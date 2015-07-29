//
//  Category.swift
//  Todait
//
//  Created by CruzDiary on 2015. 7. 23..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import Foundation
import CoreData

class Category: NSManagedObject {

    @NSManaged var archivedAt: NSDate
    @NSManaged var color: String
    @NSManaged var createdAt: NSDate
    @NSManaged var dirtyFlag: NSNumber
    @NSManaged var name: String
    @NSManaged var serverId: NSNumber
    @NSManaged var updatedAt: NSDate
    @NSManaged var localId: NSNumber
    @NSManaged var categoryType: String
    @NSManaged var taskList: NSSet
    @NSManaged var userId: User
    @NSManaged var hidden:Bool

    
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
