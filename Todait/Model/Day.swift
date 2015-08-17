//
//  Day.swift
//  Todait
//
//  Created by CruzDiary on 2015. 7. 23..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import Foundation
import CoreData

class Day: NSManagedObject {

    @NSManaged var date: NSNumber
    @NSManaged var dayOfWeek: NSNumber
    @NSManaged var doneAmount: NSNumber
    @NSManaged var doneSecond: NSNumber
    @NSManaged var expectAmount: NSNumber
    @NSManaged var score: NSNumber
    @NSManaged var localId: NSNumber
    @NSManaged var off: NSNumber
    @NSManaged var done: NSNumber
    @NSManaged var createdAt: NSDate
    @NSManaged var amountLogList: NSOrderedSet
    @NSManaged var diaryList: NSOrderedSet
    @NSManaged var taskId: Task
    @NSManaged var timeHistoryList: NSOrderedSet
    @NSManaged var timeLogList: NSOrderedSet
    @NSManaged var checkLogList: NSSet
    @NSManaged var amountRangeList: NSSet
    @NSManaged var reviewDayList: ReviewDay

    
    let defaults:NSUserDefaults! = NSUserDefaults.standardUserDefaults()
    
    func getColor()->UIColor{
        return taskId.getColor()
    }
    
    
    func getProgressPercent()->NSNumber{
        return doneAmount.floatValue/expectAmount.floatValue
    }
    
    func getProgressString()->String{
        return "\(doneAmount) / \(expectAmount) \(taskId.unit)"
    }
    
    func getAmountLogValuePerTime()->[NSNumber]{
        
        var amounts:[NSNumber] = []
        
        for index in 0...47{
            amounts.append(0)
        }
        
        
        
        let startComp = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitYear|NSCalendarUnit.CalendarUnitMonth|NSCalendarUnit.CalendarUnitDay|NSCalendarUnit.CalendarUnitHour|NSCalendarUnit.CalendarUnitDay, fromDate: createdAt)
        startComp.hour = self.defaults.integerForKey("finishHourOfDay")
        startComp.minute = self.defaults.integerForKey("finishMinuteOfDay") + 5
        
        let dayStartDate:NSDate! = NSCalendar.currentCalendar().dateFromComponents(startComp)
        
        for log in amountLogList {
            
            
            let amountLog:AmountLog = log as! AmountLog
            let date:NSDate! = log.createdAt
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
