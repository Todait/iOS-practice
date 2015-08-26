//
//  TimeTask.swift
//  Todait
//
//  Created by CruzDiary on 2015. 8. 14..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class TimeTask: NSObject {
   
    var goal:String? = nil
    var startDate:NSDate? = nil
    var endDate:NSDate? = nil
    var unit:String? = nil
    var isTotal = false
    var totalAmount:Int?
    var startAmount:Int?
    var endAmount:Int?
    var category:Category? = nil
    var repeatCount = 1
    var reviewCount = 0
    var isNotification = false
    
    var notificationDate:NSDate? = nil
    var color:UIColor? = nil
    var weekTimes:[Int] = [Int](count:7, repeatedValue:0)
    
    var isEditedMode = false
    var editedTask:Task?
    
    
    func setDefault(){
        
        goal = nil
        startDate = nil
        endDate = nil
        unit = nil
        isTotal = false
        totalAmount = 0
        startAmount = 0
        endAmount = 0
        category = nil
        repeatCount = 1
        reviewCount = 0
        isNotification = false
        notificationDate = nil
        color = nil
        weekTimes = [Int](count:7, repeatedValue:0)
        isEditedMode = false
        editedTask = nil
    }
    
    func getParams()->[String:AnyObject]?{
        
        //params["user"] = ["email":email,"name":name,"password":password,"password_confirmation":confirm,"grade":job,"image_names":fileName]
        var param:[String:AnyObject] = [:]
        
        param["body"] = goal
        param["color"] = color
        param["review_count"] = reviewCount
        param["category_id"] = category?.serverId
        
        
        
        if isTotal == true {
            param["amount"] = totalAmount
            param["start_point"] = 0
        }else{
            param["amount"] = endAmount! - startAmount!
            param["start_point"] = startAmount
        }
        
        return param
        
    }
    
    class var sharedInstance: TimeTask {
        
        struct Time {
            static var onceToken: dispatch_once_t = 0
            static var instance: TimeTask? = nil
            
        }
        
        dispatch_once(&Time.onceToken) {
            Time.instance = TimeTask()
        }
        
        return Time.instance!
    }
    
    func getAmount()->Int{
        
        if isTotal == true {
            
            if let totalAmount = totalAmount {
                return totalAmount
            }
            
        }else{
            
            if let startAmount = startAmount {
                
                if let endAmount = endAmount {
                    return endAmount - startAmount
                }
            }
        }
        
        return 0
    }
    
    
    
    
    func createEditedTaskParams()->[String:AnyObject]?{

        var params:[String:AnyObject] = [:]
        params["task"] = createEditedTaskParams()
        params["today_date"] = getTodayDateNumber()
        return params
        
    }
    
    
    func createEditedTaskParam()->[String:AnyObject]{
        
        
        var task:[String:AnyObject] = [:]
        
        task["name"] = goal
        task["category_id"] = category?.serverId
        task["review_count"] = reviewCount
        task["repeat_count"] = repeatCount
        task["task_dates_attributes"] = createEditedTaskDateParams(editedTask!)
        task["unit"] = unit
        
        
        
        if isTotal == true {
            task["task_type"] = "total_by_time"
            task["amount"] = totalAmount ?? 0
        }else{
            task["task_type"] = "range_by_time"
            task["start_point"] = startAmount!
            task["amount"] = endAmount! - startAmount!
        }
        
        if isNotification == true && notificationDate != nil {
            
            var comp = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitHour|NSCalendarUnit.CalendarUnitMinute, fromDate: notificationDate!)
            task["notification_mode"] = true
            task["notification_time"] = String(format: "%02lu", arguments: [comp.hour]) + ":" + String(format: "%02lu", arguments: [comp.minute])
            
        }else{
            
            task["notification_mode"] = false
            task["notification_time"] = "00:00"
            
        }
        
        
        return task
    }
    
    
    func createEditedTaskDateParams(task:Task)->[[String:AnyObject]]{
        
        
        var params:[[String:AnyObject]] = []
        
        for taskDate in task.taskDates {
            
            
            var param:[String:AnyObject] = [:]
            param["start_date"] = getDateNumberFromDate(startDate!)
            param["end_date"] = getDateNumberFromDate(endDate!)
            param["week_attributes"] = createEditedWeekParams(taskDate)
            param["id"] = taskDate.serverId
            
            
            params.append(param)
        }
        
        
        return params
        
    }
    
    func createEditedWeekParams(taskDate:TaskDate)->[String:AnyObject]{
        
        var week:[String:AnyObject] = [:]
        week["sun"] = weekTimes[0]
        week["mon"] = weekTimes[1]
        week["tue"] = weekTimes[2]
        week["wed"] = weekTimes[3]
        week["thu"] = weekTimes[4]
        week["fri"] = weekTimes[5]
        week["sat"] = weekTimes[6]
        week["id"] = taskDate.week?.serverId
        
        
        return week
    }

    
    
    
    
    
    
    
    
    
    
    func createTaskParams()->[String:AnyObject]?{
        
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
            task["task_type"] = "total_by_time"
            task["amount"] = totalAmount ?? 0
        }else{
            task["task_type"] = "range_by_time"
            task["start_point"] = startAmount!
            task["amount"] = endAmount! - startAmount!
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
    
    func setTask(task:Task){
        
        editedTask = task
        isEditedMode = true
        
        goal = task.name
        unit = task.unit
        startDate = getDateFromDateNumber(task.taskDates.last!.startDate)
        endDate = getDateFromDateNumber(task.taskDates.last!.endDate)
        
        
        if task.taskType == "total_by_time"{
            totalAmount = task.amount
            isTotal = true
        }else{
            startAmount = task.startPoint
            endAmount = task.amount - task.startPoint
            isTotal = false
        }
        isNotification = task.notificationMode
        
        if let week = task.getWeekValues(){
            weekTimes = week
        }
        
        
    }
    
    func createTaskDateParams()->[[String:AnyObject]]{
        var taskDate:[String:AnyObject] = [:]
        taskDate["start_date"] = getDateNumberFromDate(startDate!)
        taskDate["end_date"] = getDateNumberFromDate(endDate!)
        taskDate["week_attributes"] = createWeekParams()
        
        return [taskDate]
        
    }
    
    func createWeekParams()->[String:AnyObject]{
        
        var week:[String:AnyObject] = [:]
        week["sun"] = weekTimes[0]
        week["mon"] = weekTimes[1]
        week["tue"] = weekTimes[2]
        week["wed"] = weekTimes[3]
        week["thu"] = weekTimes[4]
        week["fri"] = weekTimes[5]
        week["sat"] = weekTimes[6]
        
        
        
        return week
    }
    
}
