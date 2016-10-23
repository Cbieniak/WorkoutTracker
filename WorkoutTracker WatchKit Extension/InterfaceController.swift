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
            for i  in 0...(exercises.count - 1) {
                let row = self.tableView.rowController(at: i) as! ExerciseRow
                row.titleRow.setText(exercises[i].name)
                
            }
            
               //self.tableView.setRowTypes(exercises.flatMap { $0.name })
            
        }
    }

    @IBOutlet var tableView: WKInterfaceTable!
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        session = WCSession.default()
        session!.activate()
        
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        
        // 3
        self.tableView.setNumberOfRows(3, withRowType: "temp")
        
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
    
//        session.sendMessage(["reference": "exercises"], replyHandler: { (response) -> Void in
//            // 4
//            
//            print("\(response)")
//            self.tableView.setRowTypes(["temp"])
//            //self.tableView.setNumberOfRows().count, withRowType: "temp")
//            
//            let results:NSArray = response["exercises"] as! NSArray
//            
//            
//            
////            self.tableView.setRowTypes(results.flatMap { exercise in
////                
//////                let unarchivedDictionary = NSKeyedUnarchiver.unarchiveObject(with:exercise as! Data) as! NSDictionary
//////                
////                let exercise = Exercise(context: Datamodel.sharedInstance.container.viewContext)
////                exercise.informedFromDictionary(unarchivedDictionary)
////                
////                return exercise.name
////
////            })
////                return Exercise(dictionary:unarchivedDictionary )
//                
//            }, errorHandler: { (error) -> Void in
//                // 6
//                print(error)
//        })
    
    }

    
    func session(_ session: WCSession, didFinish fileTransfer: WCSessionFileTransfer, error: Error?) {
        print("error: ", error)
    }
    
    func session(_ session: WCSession, didReceive file: WCSessionFile) {
        print("error: ", file)
//        do {
//        try? _ = Datamodel.sharedInstance.container.persistentStoreCoordinator.addPersistentStore(ofType: NSBinaryStoreType, configurationName: nil, at: file.fileURL, options: nil)
//        }
//        
//        Datamodel.sharedInstance.container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error {
//                fatalError("Unresolved error \(error)")
//            }
//            print("test")
//            
//            
//        })
        
        let dm = WatchDataModel()
        dm.setupContainer(with: file.fileURL.absoluteURL, completionHandler: { (test, error) in
                self.exercises = WatchDataModel.allExercises(dm.container!)
            
            
            }
        )
        
       
       
        
        
        
    }
    /** Called on the delegate of the receiver. Will be called on startup if the incoming message caused the receiver to launch. */
//    @available(watchOS 2.0, *)
//    public func session(_ session: WCSession, didReceiveMessage message: [String : Any]){
//        //self.tableView.r
//    
//    }

}


class ExerciseRow: NSObject {
    
    
    @IBOutlet var titleRow: WKInterfaceLabel!
    
    
}
