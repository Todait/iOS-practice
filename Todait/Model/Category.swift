//
//  Category.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 9..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import Foundation
import CoreData

class Category: NSManagedObject {

    @NSManaged var archived_at: NSDate
    @NSManaged var color: String
    @NSManaged var created_at: NSDate
    @NSManaged var dirty_flag: NSNumber
    @NSManaged var name: String
    @NSManaged var server_id: NSNumber
    @NSManaged var updated_at: NSDate
    @NSManaged var user_id: User
    @NSManaged var taskList: NSSet
    
    
    func getAveragePercent()->NSNumber {
        
        var percent = 0
        
        for task in taskList {
            
            let taskItem:Task = task as! Task
            
            percent = percent + Int(taskItem.getPercentOfDoneAmount())
        
        }
        
        if taskList.count == 0 {
            return 0
        }
        
        
        
        
        return percent / taskList.count
    }
    
    func getTotalTime()->NSNumber {
        
        var totalTime = 0
        
        for task in taskList {
            
            let taskItem:Task = task as! Task
            
            totalTime = totalTime + Int(taskItem.getTotalDoneTime())
        }
        
        return totalTime
    }
    
    func getWeekTime()->NSNumber {
        
        var totalTime:Int = 0
        let date = getDateFromDateNumber(getDateNumberFromDate(NSDate()))
        
        for task in taskList {
            
            let taskItem:Task = task as! Task
            
            
            totalTime = totalTime + Int(taskItem.getWeekDayDoneTime(date))
            
        }
        
        return totalTime
        
    }
    
}
