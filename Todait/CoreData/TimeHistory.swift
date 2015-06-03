//
//  TimeHistory.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 3..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import Foundation
import CoreData

class TimeHistory: NSManagedObject {

    @NSManaged var archived: NSNumber
    @NSManaged var created_at: NSNumber
    @NSManaged var dirty_flag: NSNumber
    @NSManaged var done_millis: NSNumber
    @NSManaged var ended_at: NSNumber
    @NSManaged var server_day_id: NSNumber
    @NSManaged var server_id: NSNumber
    @NSManaged var started_at: NSDate
    @NSManaged var updated_at: NSDate
    @NSManaged var day_id: NSManagedObject

}
