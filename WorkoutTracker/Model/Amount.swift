//
//  Amount.swift
//  WorkoutTracker
//
//  Created by ChristianBieniak on 28/12/16.
//  Copyright © 2016 Bieniapps. All rights reserved.
//

import Foundation
import CoreData

public class Amount: NSManagedObject {
    
    @NSManaged public var amountValue: Double
    @NSManaged public var session: Session
    @NSManaged public var denomination: Denomination
    
}
