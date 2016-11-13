//
//  InterfaceController.swift
//  WorkoutTracker WatchKit Extension
//
//  Created by ChristianBieniak on 16/10/16.
//  Copyright © 2016 Bieniapps. All rights reserved.
//

import WatchKit
import Foundation
import CoreData
import WatchConnectivity



class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    var session: WCSession? {
        didSet {
            if let session = session {
                session.delegate = self
                session.activate()
            }
        }
    }
    
    var exercises: [Exercise] = [] {
        didSet {
            self.tableView.setNumberOfRows(exercises.count, withRowType: "temp")
            if exercises.count > 0 {
                for i  in 0...(exercises.count - 1) {
                    let row = self.tableView.rowController(at: i) as! ExerciseRow
                    row.titleRow.setText(exercises[i].name)
                    
                    }
            }
        
        }
    }

    @IBOutlet var tableView: WKInterfaceTable!
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        session = WCSession.default()
        
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        // 3
        
        if let container = WatchDataModel().container {
            self.exercises = WatchDataModel.allExercises(container)
        }
        
       //https://www.raywenderlich.com/117329/watchos-2-tutorial-part-4-watch-connectivity
        
        
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    
        session.sendMessage([:], replyHandler: nil, errorHandler: { (error) -> Void in
                            print(error)
                    })
    
    }

    
    func session(_ session: WCSession, didFinish fileTransfer: WCSessionFileTransfer, error: Error?) {
        
        print("error: ", error)
    }
    
    func session(_ session: WCSession, didReceive file: WCSessionFile) {

        do {
        var x = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: PersistentContainer.sharedAppGroup)
            x = x!.appendingPathComponent("numodel.sqlite")
            do {
                try FileManager.default.removeItem(at: x!)
            } catch {
                print(error)
            }
         //try   FileManager.default.createDirectory(at: x!, withIntermediateDirectories: false, attributes: nil)
            //if FileManager.default.fileExists(atPath: x!.absoluteString) {
            
//             let fileURL = try FileManager.default.replaceItemAt(x!.absoluteURL, withItemAt: file.fileURL.absoluteURL)
//            } else {
                try FileManager.default.moveItem(at: file.fileURL, to:x!)
//            }
        print("error: ", file)
        
        let dm = WatchDataModel.sharedInstance
        dm.setupContainer(with: x!, completionHandler: { (test, error) in
            print("TEST \(test.url)")
            self.exercises = WatchDataModel.allExercises(dm.container!)
            
            
            }
        )
//        } catch {
//            print("\(error)")
//        }
        } catch {
            print(error)
        }
    }
    /** Called on the delegate of the receiver. Will be called on startup if the incoming message caused the receiver to launch. */
//    @available(watchOS 2.0, *)
//    public func session(_ session: WCSession, didReceiveMessage message: [String : Any]){
//        //self.tableView.r
//    
//    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        let exercise = WatchDataModel.allExercises(WatchDataModel.sharedInstance.container!)[rowIndex]
        //get exercise
        //pass it through
        self.pushController(withName: "AddSession", context: exercise)
    }

}


class ExerciseRow: NSObject {
    
    
    @IBOutlet var titleRow: WKInterfaceLabel!
    
    
}
