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
    var repeatCount = 0
    var reviewCount = 0
    var isNotification = false
    var notificationDate:NSDate? = nil
    var color:UIColor? = nil
    var weekTimes:[Int] = [Int](count:7, repeatedValue:0)
    
    
    func getParams()->[String:AnyObject]?{
        
        //params["user"] = ["email":email,"name":name,"password":password,"password_confirmation":confirm,"grade":job,"image_names":fileName]
        
        var params:[String:AnyObject] = [:]
        
        var param:[String:AnyObject] = [:]
        param["body"] = goal
        param["color"] = color
        param["review_count"] = reviewCount
        param["category_id"] = category?.serverId
        
        
        
        if isTotal == true {
            param["amount"] = totalAmount
            param["start_point"] = nil
        }else{
            param["amount"] = endAmount! - startAmount!
            param["start_point"] = startAmount
        }
        
        return params
        
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
    
    func createTimeTaskParams()->[String:AnyObject]{
        
        var params:[String:AnyObject] = [:]
        params["task"] = createTaskParams()
        
        return params
    }
    
    func createTaskParams()->[String:AnyObject]{
        
        
        var task:[String:AnyObject] = [:]
        task["local_id"] = NSUUID().UUIDString
        task["name"] = goal
        task["start_date"] = startDate
        task["category_id"] = category?.serverId
        task["review_count"] = reviewCount
        task["repeat_count"] = repeatCount
        task["task_date"] = createTaskDateParams()
        task["unit"] = unit
        
        if isTotal == true {
            task["task_type"] = "total_by_amount"
        }else{
            task["task_type"] = "range_by_amount"
        }
        
        if isNotification == true {
            
        }else{
            
        }
        
        
        return task
    }
    
    func createTaskDateParams()->[String:AnyObject]{
        var taskDate:[String:AnyObject] = [:]
        taskDate["start_date"] = getDateNumberFromDate(startDate!)
        taskDate["week"] = createWeekParams()
        
        return taskDate
        
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
