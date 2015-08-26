//
//  AmountTask.swift
//  Todait
//
//  Created by CruzDiary on 2015. 8. 14..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class AmountTask: NSObject {
    
    var goal:String? = nil
    var startDate:NSDate? = nil
    var endDate:NSDate? = nil
    var unit:String? = nil
    var totalAmount:Int?
    var dayAmount:Int?
    var startAmount:Int?
    var endAmount:Int?
    
    var category:Category? = nil
    var repeatCount = 0
    var reviewCount = 0
    var isNotification = false
    var notificationDate:NSDate? = nil
    var color:UIColor? = nil
    var weekAmounts:[Int] = [Int](count:7, repeatedValue:0)
    var isTotal = false
    var isEditedMode = false
    var editedTask:Task? = nil
    
    class var sharedInstance: AmountTask {
        
        struct Amount {
            static var onceToken: dispatch_once_t = 0
            static var instance: AmountTask? = nil
            
        }
        
        dispatch_once(&Amount.onceToken) {
            Amount.instance = AmountTask()
        }
        
        return Amount.instance!
    }
    
    func setDefault(){
        
        goal = nil
        startDate = nil
        endDate = nil
        unit = nil
        isTotal = false
        totalAmount = 0
        dayAmount = 0
        category = nil
        repeatCount = 1
        reviewCount = 0
        isNotification = false
        notificationDate = nil
        color = nil
        weekAmounts = [Int](count:7, repeatedValue:0)
        isEditedMode = false
        editedTask = nil
        
    }
    
    func setTask(task:Task){
        
        goal = task.name
        unit = task.unit
        
        if task.taskType == "total_by_amount"{
            totalAmount = task.amount
        }
        isNotification = task.notificationMode
        
        if let week = task.getWeekValues(){
            weekAmounts = week
        }
    
        
    }
    
    func createTaskParams()->[String:AnyObject]{
        
        var params:[String:AnyObject] = [:]
        params["task"] = createTaskParams()
        params["today_date"] = getTodayDateNumber()
        
        return params
    }
    
    func createTaskParam()->[String:AnyObject]{
        
        
        var task:[String:AnyObject] = [:]
        task["local_id"] = NSUUID().UUIDString
        task["name"] = goal
        task["category_id"] = category?.serverId
        task["review_count"] = reviewCount
        task["repeat_count"] = repeatCount
        task["task_dates_attributes"] = createTaskDateParams()
        task["unit"] = unit
        
        if isTotal == true {
            task["task_type"] = "total_by_amount"
        }else{
            task["task_type"] = "range_by_amount"
        }
        
        if isNotification == true {
            
            var comp = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitHour|NSCalendarUnit.CalendarUnitMinute, fromDate: notificationDate!)
            task["notification_mode"] = true
            task["notification_time"] = String(format: "%02lu", arguments: [comp.hour]) + ":" + String(format: "%02lu", arguments: [comp.minute])
            
        }else{
            
            task["notification_mode"] = false
            task["notification_time"] = "00:00"
            
        }
        
        
        return task
    }
    
    func createTaskDateParams()->[String:AnyObject]{
        var taskDate:[String:AnyObject] = [:]
        taskDate["start_date"] = getDateNumberFromDate(startDate!)
        taskDate["end_date"] = getDateNumberFromDate(endDate!)
        taskDate["week_attributes"] = createWeekParams()
        
        return taskDate
        
    }
    
    func createWeekParams()->[String:AnyObject]{
        
        var week:[String:AnyObject] = [:]
        week["sun"] = weekAmounts[0]
        week["mon"] = weekAmounts[1]
        week["tue"] = weekAmounts[2]
        week["wed"] = weekAmounts[3]
        week["thu"] = weekAmounts[4]
        week["fri"] = weekAmounts[5]
        week["sat"] = weekAmounts[6]
        
        return week
    }
    
}





