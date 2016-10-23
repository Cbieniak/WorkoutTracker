//
//  Datamodel.swift
//  WorkoutTracker
//
//  Created by ChristianBieniak on 18/10/16.
//  Copyright © 2016 Bieniapps. All rights reserved.
//

import Foundation
import CoreData

public class Datamodel {

    
    public class var sharedInstance : Datamodel {
        struct Static {
            static let instance : Datamodel = Datamodel()
        }
        return Static.instance
    }
    
    let binaryUrl: URL = PersistentContainer.defaultDirectoryURL().appendingPathComponent("binary")
    
//    lazy var binaryContainer: NSPersistentContainer = {
//        let container = PersistentContainer(name: "Datamodel")
////        do {
////            
//////            try _ = container.persistentStoreCoordinator.addPersistentStore(ofType: NSBinaryStoreType, configurationName: nil, at: self.binaryUrl, options: nil)
////            
////        } catch {
////            print("\(error)")
////        }
//        
////        
//        
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error {
//                fatalError("Unresolved error \(error)")
//            }
//        })
//        
//        return container
//        
//    }()
    
    
    lazy var container: PersistentContainer = {
        let container = PersistentContainer(name: "Datamodel")
    
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        })
        
        return container

    }()

    static func allExercises(_ container: NSPersistentContainer = Datamodel.sharedInstance.container) -> [Exercise] {
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

final class PersistentContainer: NSPersistentContainer {
    
    static let sharedAppGroup:String = "group.bieniapps.WorkoutTracker"
    internal override class func defaultDirectoryURL() -> URL {
        var url = super.defaultDirectoryURL()
        if let newURL =
            FileManager.default.containerURL(
                forSecurityApplicationGroupIdentifier: PersistentContainer.sharedAppGroup) {
            url = newURL
        }
        return url
    }
}
