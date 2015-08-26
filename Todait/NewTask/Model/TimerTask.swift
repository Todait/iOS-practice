//
//  TimerTask.swift
//  Todait
//
//  Created by CruzDiary on 2015. 8. 14..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class TimerTask: NSObject {
    
    var goal:String? = nil
    var category:Category? = nil
    var startDate: NSDate?
    var isNotification = false
    var notificationDate:NSDate? = nil
    var color:UIColor? = nil
    var isEditedMode = false
    var editedTask:Task?
    var priority = 0
    
    
    func setDefault(){
        
        goal = nil
        category = nil
        startDate = nil
        isNotification = false
        notificationDate = nil
        color = nil
        isEditedMode = false
        editedTask = nil
        priority = 0
        
    }
    
    class var sharedInstance: TimerTask {
        
        struct Timer {
            static var onceToken: dispatch_once_t = 0
            static var instance: TimerTask? = nil
            
        }
        
        dispatch_once(&Timer.onceToken) {
            Timer.instance = TimerTask()
        }
        
        return Timer.instance!
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
        task["priority"] = priority
        
        if let category = category {
            task["category_id"] = category.serverId
        }
        
        task["task_dates_attributes"] = createTaskDateParams()
        
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
            param["id"] = taskDate.serverId
            param["state"] = taskDate.state
            
            params.append(param)
        }
        
        
        return params
        
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
        task["task_dates_attributes"] = createTaskDateParams()
        task["priority"] = priority
        
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
        
        
        priority = task.priority
        editedTask = task
        isEditedMode = true
        goal = task.name
        isNotification = task.notificationMode
        
        if let notificationDate = getNotificationDate(task.notificationTime){
            self.notificationDate = notificationDate
        }
        
    }
    
    func getNotificationDate(notificationTime:String)->NSDate?{
        
        let dateForm = NSDateFormatter()
        dateForm.dateFormat = "HH:mm"
        
        if let notificationDate = dateForm.dateFromString(notificationTime) {
            
            let dateComp = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitHour|NSCalendarUnit.CalendarUnitMinute, fromDate: notificationDate)
            
            let todayDate = getDateFromDateNumber(getTodayDateNumber())
            
            let todayComp = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitHour|NSCalendarUnit.CalendarUnitMinute, fromDate: todayDate)
            todayComp.hour = dateComp.hour
            todayComp.minute = dateComp.minute
            
            return NSCalendar.currentCalendar().dateFromComponents(todayComp)
        }
        
        return nil
    }
    
    
    func createTaskDateParams()->[[String:AnyObject]]{
        
        var taskDate:[String:AnyObject] = [:]
        taskDate["start_date"] = getDateNumberFromDate(startDate!)
        taskDate["state"] = 0
        
        return [taskDate]
        
    }
    
    
}
