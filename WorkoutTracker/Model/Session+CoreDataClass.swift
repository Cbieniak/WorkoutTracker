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
        
        let dateStr = formatter.string(from: self.date as! Date)
        let sessionInfo: String =  self.exercise!.trackedAttributes.reduce("", { $0 + " " + String(describing: (self.value(forKey: $1 as! String)) ?? "") + " " + Session.trackedAttributeSuffix(attr: $1 as! String) + "\n" })
        return sessionInfo + dateStr
        
    }
}
