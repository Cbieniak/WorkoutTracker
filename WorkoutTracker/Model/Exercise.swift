//
//  Exercise+CoreDataClass.swift
//  
//
//  Created by ChristianBieniak on 16/10/16.
//
//

import Foundation
import CoreData

protocol Dictionariable {
    static var serializableAttributes: [String] { get }
    
    func toDictionary() -> [String : Any]
    init?(from dictionary: [String: Any])
}

extension Dictionariable where Self: NSManagedObject {
    func toDictionary() -> [String : Any] {
        var dict: [String: Any] = [:]
        Self.serializableAttributes.forEach {
            dict[$0] = self.value(forKey: $0) as? String
        }
        return dict
    }
    
    init?(from dictionary: [String : Any]) {
        self = Self(context: Datamodel.sharedInstance.container.viewContext)
        for (key, val) in dictionary {
            self.setValue(val, forKey: key)
        }
    }
}

public class Exercise: NSManagedObject {}

struct TransferrableExercise {
    
    var name: String
    var primaryKey: String

    func toDictionary() -> [String: Any] {
        return ["name" : name,
                "primaryKey" : primaryKey]
    }
}


extension Exercise: Dictionariable {
    
    @nonobjc static var serializableAttributes: [String] = ["name",
                                                   "primaryKey"]
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Exercise> {
        
        return NSFetchRequest<Exercise>(entityName: "Exercise");
    }
    
    @NSManaged public var name: String?
    @NSManaged public var primaryKey: String!
    @NSManaged public var sessions: NSSet
    @NSManaged public var denominations: NSOrderedSet
    @NSManaged public var trackedAttributes: NSArray
    
    func convert() -> TransferrableExercise {
        return TransferrableExercise(name: name!, primaryKey: primaryKey)
    }
}
