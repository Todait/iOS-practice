//
//  AmountRange.swift
//  Todait
//
//  Created by CruzDiary on 2015. 7. 23..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import Foundation
import CoreData

class AmountRange: NSManagedObject {

    @NSManaged var startPoint: NSNumber
    @NSManaged var endPoint: NSNumber
    @NSManaged var doneAmount: NSNumber
    @NSManaged var dayId: Day

}
