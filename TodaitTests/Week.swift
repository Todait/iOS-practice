//
//  Week.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 9..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import Foundation
import CoreData

class Week:NSObject {
    
     var archived_at: NSDate!
     var created_at: NSDate!
     var dirty_flag: NSNumber!
     var fri_minute: NSNumber!
     var mon_minute: NSNumber!
     var sat_minute: NSNumber!
     var server_id: NSNumber!
     var server_task_id: NSNumber!
     var sun_minute: NSNumber!
     var thu_minute: NSNumber!
     var tue_minute: NSNumber!
     var updated_at: NSDate!
     var wed_minute: NSNumber!
     var task_id: Task!
    
    func getExpectedAmount()->[NSNumber]{
        
        var expectedAmount:[NSNumber] = [sun_minute,mon_minute,tue_minute,wed_minute,thu_minute,fri_minute,sat_minute]
        
        return expectedAmount
    }
    
}
