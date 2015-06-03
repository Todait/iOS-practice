//
//  Day.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 3..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import Foundation
import CoreData

class Day: NSManagedObject {

    @NSManaged var archived_at: NSNumber
    @NSManaged var created_at: NSDate
    @NSManaged var date: NSNumber
    @NSManaged var day_of_week: NSNumber
    @NSManaged var dirty_flag: NSNumber
    @NSManaged var done_amount: NSNumber
    @NSManaged var done_second: NSNumber
    @NSManaged var expect_amount: NSNumber
    @NSManaged var server_id: NSNumber
    @NSManaged var server_task_id: NSNumber
    @NSManaged var updated_at: NSDate
    @NSManaged var task_id: NSManagedObject

}
