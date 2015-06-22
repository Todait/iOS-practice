//
//  Day.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 9..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Day: NSManagedObject {

    @NSManaged var archived_at: NSDate
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
    @NSManaged var task_id: Task
    @NSManaged var diaryList: NSOrderedSet
    @NSManaged var timeHistoryList: NSOrderedSet
    @NSManaged var timeLogList: NSOrderedSet
    @NSManaged var amountLogList: NSOrderedSet
    
    let defaults:NSUserDefaults! = NSUserDefaults.standardUserDefaults()
    
    func getColor()->UIColor{
        return task_id.getColor()
    }
    
    
    func getProgressPercent()->NSNumber{
        return done_amount.floatValue/expect_amount.floatValue
    }
    
    func getProgressString()->String{
        return "\(done_amount) / \(expect_amount) \(task_id.unit)"
    }
        
    func getAmountLogValuePerTime()->[NSNumber]{
        
        var amounts:[NSNumber] = []
        
        for index in 0...47{
            amounts.append(0)
        }
        
        
        
        let startComp = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitYear|NSCalendarUnit.CalendarUnitMonth|NSCalendarUnit.CalendarUnitDay|NSCalendarUnit.CalendarUnitHour|NSCalendarUnit.CalendarUnitDay, fromDate: created_at)
        startComp.hour = self.defaults.integerForKey("finishHourOfDay")
        startComp.minute = self.defaults.integerForKey("finishMinuteOfDay") + 5
        
        let dayStartDate:NSDate! = NSCalendar.currentCalendar().dateFromComponents(startComp)
        
        for log in amountLogList {
            
            
            let amountLog:AmountLog = log as! AmountLog
            let date:NSDate! = log.created_at
            let diff = date.timeIntervalSinceDate(dayStartDate)
            var index = Int(diff / (30*60))
            
            if index > 47 {
                index = 47
            }
            
            if (index < 0){
                index = 0
            }
            NSLog("%lu",index)
            amounts[index] = amounts[index].integerValue + amountLog.getDoneAmount().integerValue
        }
        
        
        return amounts
    }
    
}
