//
//  Review_Task.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 3..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import Foundation
import CoreData

class Review_Task: NSManagedObject {

    @NSManaged var archived: NSNumber
    @NSManaged var created_at: NSDate
    @NSManaged var dirty_flag: NSNumber
    @NSManaged var end_date: NSNumber
    @NSManaged var server_id: NSNumber
    @NSManaged var server_task_id: NSNumber
    @NSManaged var start_date: NSNumber
    @NSManaged var updated_at: NSDate
    @NSManaged var task_id: Task

}
