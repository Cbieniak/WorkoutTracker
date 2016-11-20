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
}
