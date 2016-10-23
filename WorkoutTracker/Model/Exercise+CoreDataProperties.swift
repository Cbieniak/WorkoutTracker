//
//  Exercise+CoreDataProperties.swift
//  
//
//  Created by ChristianBieniak on 16/10/16.
//
//

import Foundation
import CoreData


extension Exercise {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Exercise> {
        return NSFetchRequest<Exercise>(entityName: "Exercise");
    }

    @NSManaged public var name: String?
    @NSManaged public var sessions: NSSet
    
}
