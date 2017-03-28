//
//  Denomination.swift
//  WorkoutTracker
//
//  Created by ChristianBieniak on 28/12/16.
//  Copyright © 2016 Bieniapps. All rights reserved.
//

import Foundation
import CoreData

public class Denomination: NSManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Denomination> {
        return NSFetchRequest<Denomination>(entityName: "Denomination");
    }
    
    @NSManaged public var ascending: Bool
    @NSManaged public var incrementWholeNumber: Bool
    @NSManaged public var name: String
    @NSManaged public var suffix: String?
    
    @NSManaged public var amounts: Set<Amount>
    @NSManaged public var exercises: Set<Exercise>
    
}
