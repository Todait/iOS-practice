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
    var unit:String? = nil
    var totalAmount:Int?
    var dayAmount:Int?
    var category:Category? = nil
    var repeatCount = 0
    var reviewCount = 0
    var isNotification = false
    var notificationDate:NSDate? = nil
    var color:UIColor? = nil
    var weekAmounts:[Int] = [Int](count:7, repeatedValue:0)
    var isTotal = false
    
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
    
    func createAmountTaskParams()->[String:AnyObject]{
        
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





