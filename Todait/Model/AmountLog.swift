//
//  AmountLog.swift
//  Todait
//
//  Created by CruzDiary on 2015. 7. 23..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import Foundation
import CoreData

class AmountLog: NSManagedObject {

    @NSManaged var afterDoneAmount: NSNumber
    @NSManaged var archived: NSNumber
    @NSManaged var beforeDoneAmount: NSNumber
    @NSManaged var createdAt: NSDate
    @NSManaged var dirtyFlag: NSNumber
    @NSManaged var serverDayId: NSNumber
    @NSManaged var serverId: NSNumber
    @NSManaged var timestamp: NSNumber
    @NSManaged var updatedAt: NSDate
    @NSManaged var dayId: Day

}
