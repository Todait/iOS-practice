//
//  Week.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 3..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import Foundation
import CoreData

class Week: NSManagedObject {

    @NSManaged var archived_at: NSNumber
    @NSManaged var created_at: NSNumber
    @NSManaged var dirty_flag: NSNumber
    @NSManaged var fri_minute: NSNumber
    @NSManaged var mon_minute: NSNumber
    @NSManaged var sat_minute: NSNumber
    @NSManaged var server_id: NSNumber
    @NSManaged var server_task_id: NSNumber
    @NSManaged var sun_minute: NSNumber
    @NSManaged var thu_minute: NSNumber
    @NSManaged var tue_minute: NSNumber
    @NSManaged var updated_at: NSNumber
    @NSManaged var wed_minute: NSNumber
    @NSManaged var task_id: NSManagedObject

}
