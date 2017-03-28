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

class InterfaceController: WKInterfaceController, WCSessionDelegate, NSKeyedUnarchiverDelegate {
    
    var session: WCSession? {
        didSet {
            if let session = session {
                session.delegate = self
                session.activate()
            }
        }
    }
    
    var exercises: [TransferrableExercise] = [] {
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
    @IBOutlet var syncButton: WKInterfaceButton!
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        session = WCSession.default()
    }
    
    @IBAction func syncTouchedUpInside() {
        self.session!.sendMessage(["exercises" : "all"], replyHandler: { result in
            if let dictionaries = result["exercises"] as? [[String: Any]] {
//               self.exercises = dictionaries.flatMap({ NSKeyedUnarchiver.unarchiveObject(with: $0)}).flatMap { Exercise.init(from: $0 as! [String: Any])  }
                
                
                self.exercises = dictionaries.flatMap({ return TransferrableExercise(name: $0["name"] as! String, primaryKey: $0["primaryKey"] as! String) })
            }
            
            
            
            
        }) { (error) in
            print(error)
        }
        
    }
    
    func decodeThisShit(data: Data) -> Exercise? {
        //let exe = Exercise(context: Datamodel.sharedInstance.container.viewContext)
        do {
            
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            unarchiver.setClass(Exercise.self, forClassName: "WorkoutTracker.Exercise")
            unarchiver.delegate = self
            let decode = try unarchiver.decodeTopLevelObject(forKey: "root") as! Exercise
            return decode
            // OR `unarchiver.decodeTopLevelObject()` depends on how you archived.
        }
        catch let (err) {
            print(err)
            return nil
        }

    }
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        
//        self.session!.sendMessage(["exercises" : "all"], replyHandler: { result in
//            if let dictionaries = result["exercises"] as? [Data] {
//                self.exercises = dictionaries.flatMap({ NSKeyedUnarchiver.unarchiveObject(with: $0)}).flatMap { Exercise.init(from: $0 as! [String: Any])  }
//            }
//            
//            
//            
//            
//        }) { (error) in
//            print(error)
//        }
    
        
       //https://www.raywenderlich.com/117329/watchos-2-tutorial-part-4-watch-connectivity
        
        
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        session.sendMessage([:], replyHandler: nil, errorHandler: { print($0) })
    }

    
    func session(_ session: WCSession, didFinish fileTransfer: WCSessionFileTransfer, error: Error?) {
        
        print("error: \(error)")
    }
    
    func session(_ session: WCSession, didReceive file: WCSessionFile) {

    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        let exercise = self.exercises[rowIndex]
        //get exercise
        //pass it through
        self.pushController(withName: "AddSession", context: exercise)
    }
    

}


class ExerciseRow: NSObject {
    
    
    @IBOutlet var titleRow: WKInterfaceLabel!
    
    
}
