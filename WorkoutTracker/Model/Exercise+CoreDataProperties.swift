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
    @NSManaged public var weight: NSNumber?
    @NSManaged public var distance: NSNumber?
    @NSManaged public var reps: NSNumber?
    @NSManaged public var time: NSNumber?
    
    func informedFromDictionary(_ dictionary: NSDictionary) {
        self.name = dictionary["name"] as! String?
        self.weight = dictionary["weight"] as! NSNumber
        self.distance = dictionary["distance"] as! NSNumber
        self.reps = dictionary["reps"] as! NSNumber
        self.time = dictionary["time"] as! NSNumber
        
    }
    
    
    func toData() -> NSData {
        let dict:NSMutableDictionary = NSMutableDictionary()
        
        if let safeName = name {
            dict.setValue(safeName, forKey: "iname")
        }
        
        if let safeWeight = weight {
            dict.setValue(safeWeight, forKey: "weight")
        }
        
        if let safeDistance = distance {
            dict.setValue(safeDistance, forKey: "distance")
        }
        
        if let safeReps = reps {
            dict.setValue(safeReps, forKey: "reps")
        }
        
        if let safeTime = time {
            dict.setValue(safeTime, forKey: "time")
            
            
        }
        
        /* NSDictionary to NSData */
        return NSKeyedArchiver.archivedData(withRootObject:self) as NSData
        
    }

}
