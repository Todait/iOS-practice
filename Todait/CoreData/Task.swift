//
//  Task.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 3..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import Foundation
import CoreData

class Task: NSManagedObject {

    @NSManaged var amount_type: NSNumber
    @NSManaged var archived_at: NSNumber
    @NSManaged var created_at: NSDate
    @NSManaged var updated_at: NSDate
    @NSManaged var dirty_flag: NSNumber
    @NSManaged var end_date: NSDate
    @NSManaged var image_names: String
    @NSManaged var last_update_date: NSNumber
    @NSManaged var name: String
    @NSManaged var notification_mode: String
    @NSManaged var notification_time: String
    @NSManaged var server_category_id: NSNumber
    @NSManaged var server_id: NSNumber
    @NSManaged var start_date: NSDate
    @NSManaged var unit: String
    @NSManaged var category_id: Category

}
