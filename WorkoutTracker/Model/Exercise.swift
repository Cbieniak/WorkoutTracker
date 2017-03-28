//
//  Exercise+CoreDataClass.swift
//  
//
//  Created by ChristianBieniak on 16/10/16.
//
//

import Foundation
import CoreData

public class Exercise: NSManagedObject {

}


extension Exercise {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Exercise> {
        return NSFetchRequest<Exercise>(entityName: "Exercise");
    }
    
    @NSManaged public var name: String?
    @NSManaged public var primaryKey: String!
    @NSManaged public var sessions: NSSet
    @NSManaged public var denominations: NSOrderedSet
    @NSManaged public var trackedAttributes: NSArray
    
}
