//
//  Session+CoreDataProperties.swift
//  
//
//  Created by ChristianBieniak on 23/10/16.
//
//

import Foundation
import CoreData


extension Session {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Session> {
        return NSFetchRequest<Session>(entityName: "Session");
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var reps: Int32
    @NSManaged public var time: Double
    @NSManaged public var distance: Double
    @NSManaged public var weight: Int32
    @NSManaged public var speed: Double
    @NSManaged public var exercise: Exercise?

}
