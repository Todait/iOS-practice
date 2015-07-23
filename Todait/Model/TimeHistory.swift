//
//  TimeHistory.swift
//  Todait
//
//  Created by CruzDiary on 2015. 7. 23..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import Foundation
import CoreData

class TimeHistory: NSManagedObject {

    @NSManaged var doneMillis: NSNumber
    @NSManaged var endedAt: NSDate
    @NSManaged var startedAt: NSDate
    @NSManaged var dayId: Day

}
