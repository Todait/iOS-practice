//
//  Off_Day.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 3..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import Foundation
import CoreData

class Off_Day: NSManagedObject {

    @NSManaged var archived: NSNumber
    @NSManaged var created_at: NSDate
    @NSManaged var date: NSNumber
    @NSManaged var dirty_flag: NSNumber
    @NSManaged var server_id: NSNumber
    @NSManaged var server_task_id: NSNumber
    @NSManaged var update_at: NSDate
    @NSManaged var task_id: Task

}
