//
//  Denomination.swift
//  WorkoutTracker
//
//  Created by ChristianBieniak on 28/12/16.
//  Copyright © 2016 Bieniapps. All rights reserved.
//

import Foundation
import CoreData

struct TransferrableDenomination: Equatable {
    
    public var ascending: Bool
    public var incrementWholeNumber: Bool
    public var name: String
    public var suffix: String?
    
    func toDictionary() -> [String: Any] {
        return ["name" : name,
                "suffix" : suffix,
                "incrementWholeNumber" : incrementWholeNumber,
                "ascending" : ascending]
    }
    
    public static func ==(lhs: TransferrableDenomination, rhs: TransferrableDenomination) -> Bool {
        return lhs.name == rhs.name
    }
}

public class Denomination: NSManagedObject, Dictionariable {
    
    static var serializableAttributes: [String] = ["ascending",
                                                   "incrementWholeNumber",
                                                   "name",
                                                   "suffix"]
    
    
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
