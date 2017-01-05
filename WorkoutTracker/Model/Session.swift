//
//  Session+CoreDataClass.swift
//  
//
//  Created by ChristianBieniak on 23/10/16.
//
//

import Foundation
import CoreData


public class Session: NSManagedObject {
    
    static func trackedAttributeSuffix(attr: String) -> String {
        if attr == "reps" { return "reps" }
        if attr == "time" { return "seconds" }
        if attr == "weight" { return "kg" }
        if attr == "speed" { return "kmph" }
        if attr == "distance" { return "km" }
        return ""
    }
    
    func descriptiveString() -> String {
        
        let formatter = DateFormatter()
        formatter.locale = NSLocale.current
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        //get order from exercise
        let dateStr = formatter.string(from: self.date as! Date)
        let currentAmounts = self.amounts!.allObjects as! [Amount]
        let currentAmountString = currentAmounts.map { ($0.denomination.incrementWholeNumber ? String(describing: Int($0.amountValue)) : String(describing: Int($0.amountValue))) + " " + ($0.denomination.suffix ?? $0.denomination.name) + "\n" }
        let sessionInfo:String = currentAmountString.reduce(""){ $0 + $1 }

        return sessionInfo + dateStr
        
    }
}

extension Session {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Session> {
        return NSFetchRequest<Session>(entityName: "Session");
    }
    
    @NSManaged public var date: NSDate?
    @NSManaged public var reps: Double
    @NSManaged public var time: Double
    @NSManaged public var distance: Double
    @NSManaged public var weight: Double
    @NSManaged public var speed: Double
    @NSManaged public var exercise: Exercise?
    
    @NSManaged public var amounts: NSSet?
    
    static let attributes: [String] = ["reps", "distance", "weight", "time", "speed"]
    
}
