//
//  Week.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 9..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import Foundation
import CoreData

class Week: NSManagedObject {

    @NSManaged var archived_at: NSDate
    @NSManaged var created_at: NSDate
    @NSManaged var dirty_flag: NSNumber
    @NSManaged var fri_minute: NSNumber
    @NSManaged var mon_minute: NSNumber
    @NSManaged var sat_minute: NSNumber
    @NSManaged var server_id: NSNumber
    @NSManaged var server_task_id: NSNumber
    @NSManaged var sun_minute: NSNumber
    @NSManaged var thu_minute: NSNumber
    @NSManaged var tue_minute: NSNumber
    @NSManaged var updated_at: NSDate
    @NSManaged var wed_minute: NSNumber
    @NSManaged var task_id: Task
    
    func getExpectedAmount()->[NSNumber]{
        
        var expectedAmount:[NSNumber] = [sun_minute,mon_minute,tue_minute,wed_minute,thu_minute,fri_minute,sat_minute]
        
        return expectedAmount
    }

}
