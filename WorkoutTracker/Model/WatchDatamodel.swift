//
//  WatchDatamodel.swift
//  WorkoutTracker
//
//  Created by ChristianBieniak on 21/10/16.
//  Copyright © 2016 Bieniapps. All rights reserved.
//

import Foundation
import CoreData

public class WatchDataModel {
    
    public class var sharedInstance : WatchDataModel {
        struct Static {
            static let instance : WatchDataModel = WatchDataModel()
        }
        return Static.instance
    }
    
    let binaryUrl: URL = NSPersistentContainer.defaultDirectoryURL().appendingPathComponent("binary")
    
    var container: NSPersistentContainer?
    
    func setupContainer(with path: URL, completionHandler: @escaping ((NSPersistentStoreDescription, Error?) -> Void)) {
        self.container = NSPersistentContainer(name: "Datamodel")
        do {
           //try self.container!.persistentStoreCoordinator.
            try self.container!.persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: path, options: nil)
            self.container!.loadPersistentStores(completionHandler: completionHandler)
        } catch {
            print("error")
        }
        
        
        
    }
    
    static func allExercises(_ container: NSPersistentContainer) -> [Exercise] {
        let nuContext = container.viewContext
        
        var results: [Exercise]
        do {
            
            try results = nuContext.fetch(Exercise.fetchRequest())
            
            return results
            //             print("\(searchResults)")
            ////            return searchResults.map { exercise in
            ////                return exercise as! Exercise
            ////                //return Exercise(dictionary: exercise as! [String: AnyObject])
            ////            }
            // return searchResults as! [Exercise]
        } catch {
            print("Error with request: \(error)")
        }
        return []
    }
    
    
}

