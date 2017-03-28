//
//  Amount.swift
//  WorkoutTracker
//
//  Created by ChristianBieniak on 28/12/16.
//  Copyright © 2016 Bieniapps. All rights reserved.
//

import Foundation
import CoreData

public struct TransferrableAmount: Equatable {
    var amount: Double
    var denominationName: String
    
    func toDictionary() -> [String: Any] {
        return ["amount" : NSNumber(value: amount),
                "denominationName" : denominationName]
    }
    
    public static func ==(lhs: TransferrableAmount, rhs: TransferrableAmount) -> Bool {
        return lhs.denominationName == rhs.denominationName
    }
}


public class Amount: NSManagedObject, Dictionariable {
    
    static var serializableAttributes: [String] = ["amountValue"]
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Amount> {
        return NSFetchRequest<Amount>(entityName: "Amount");
    }
    
    @NSManaged public var amountValue: Double
    @NSManaged public var session: Session
    @NSManaged public var denomination: Denomination
    
    
    
}

