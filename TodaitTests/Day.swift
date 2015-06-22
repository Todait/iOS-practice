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

class Day:NSObject {
    
      var archived_at: NSDate!
      var created_at: NSDate!
      var date: NSNumber!
      var day_of_week: NSNumber!
      var dirty_flag: NSNumber!
      var done_amount: NSNumber!
      var done_second: NSNumber!
      var expect_amount: NSNumber!
      var server_id: NSNumber!
      var server_task_id: NSNumber!
      var updated_at: NSDate!
      var task_id: Task!
      var diaryList: NSOrderedSet = []
      var timeHistoryList: NSOrderedSet = []
      var timeLogList: NSOrderedSet = []
      var amountLogList: NSOrderedSet = []
    
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
            let date:NSDate! = amountLog.created_at
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
