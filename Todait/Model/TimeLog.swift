//
//  TimeLog.swift
//  Todait
//
//  Created by CruzDiary on 2015. 7. 23..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import Foundation
import CoreData

class TimeLog: NSManagedObject {

    @NSManaged var afterSecond: NSNumber
    @NSManaged var beforeSecond: NSNumber
    @NSManaged var createdAt: NSDate
    @NSManaged var timestamp: NSNumber
    @NSManaged var updatedAt: NSDate
    @NSManaged var dayId: Day
    @NSManaged var reviewDay: ReviewDay

}
