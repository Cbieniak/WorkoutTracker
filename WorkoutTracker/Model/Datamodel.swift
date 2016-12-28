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
            try results = nuContext.fetch(Exercise.fetchRequest()).filter { $0.name != nil }.sorted(by: { $0.name!.lowercased() < $1.name!.lowercased()  })
            
            return results
        } catch {
            print("Error with request: \(error)")
        }
        return []
    }
    
    static func allSessions(_ container: NSPersistentContainer = Datamodel.sharedInstance.container) -> [Session] {
        let nuContext = container.viewContext
        
        var results: [Session]
        do {
            
            try results = nuContext.fetch(Session.fetchRequest())
            
            return results
        } catch {
            print("Error with request: \(error)")
        }
        return []
    }
    
    static func allDenominations(_ container: NSPersistentContainer = Datamodel.sharedInstance.container) -> [Denomination] {
        let nuContext = container.viewContext
        
        var results: [Denomination]
        do {
            
            try results = nuContext.fetch(Denomination.fetchRequest())
            
            return results
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
