//
//  TaskR.swift
//  Todait
//
//  Created by CruzDiary on 2015. 8. 12..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import RealmSwift
import SwiftyJSON

class Task: RealmObject{
    
    dynamic var name = ""
    dynamic var unit = ""
    dynamic var startPoint:Int = 0
    dynamic var amount = 0
    dynamic var notificationMode = false
    dynamic var notificationTime = ""
    dynamic var archived = false
    dynamic var priority = 0
    dynamic var repeatCount = 1
    dynamic var userId = -1
    dynamic var reviewType:String = ""
    dynamic var reviewCount:Int = 0
    dynamic var completed = false
    dynamic var taskType = ""
    dynamic var hidden = false
    
    let taskDates = List<TaskDate>()
    
    dynamic var category:Category?
    
    override func addRelation(child:RealmObject){
        
        if child.className == "TaskDate" {
            (child as! TaskDate).task = self
            taskDates.append(child as! TaskDate)
        }
    }
    
    override func getParentsModel()->RealmObject.Type{
        return Category.self
    }
    
    override func getParentsServerIdKey()->String{
        return "category_id"
    }
    
    func setupJSON(json:JSON){
        
        
        serverId = json["id"].intValue
        name = json["name"].stringValue
        unit = json["unit"].stringValue
        startPoint = json["start_point"].intValue
        amount = json["amount"].intValue
        notificationMode = json["notification_mode"].boolValue
        notificationTime = json["notification_time"].stringValue
        archived = json["archived"].boolValue
        priority = json["priority"].intValue
        repeatCount = json["repeat_count"].intValue
        userId = json["user_id"].intValue
        taskType = json["task_type"].stringValue
        completed = json["completed"].boolValue
    }
    
    
    func getTrendData()->[[String:AnyObject]]{
        
        var datas:[[String:AnyObject]] = []
        
        var timeData:[String:AnyObject] = [:]
        var amountData:[String:AnyObject] = [:]
        
        var timeValue:[NSNumber] = []
        var amountValue:[NSNumber] = []
        
        var maxPercent:CGFloat = 0
        
        
        for taskDate in taskDates {
            
            var expectedTimes = taskDate.week!.getExpectedTime()
            
            for day in taskDate.days {
                
                var expectAmount = CGFloat(day.expectAmount)
                var doneAmount = CGFloat(day.doneAmount)
                
                var amountPercent:CGFloat = 0
                
                if expectAmount != 0 {
                    amountPercent = CGFloat(doneAmount)/CGFloat(expectAmount)
                }
                amountValue.append(amountPercent)
                
                
                
                
                var expectTime = CGFloat(expectedTimes[Int(day.dayOfWeek())])
                var doneTime = CGFloat(day.doneSecond)
                var timePercent:CGFloat = 0
                
                if expectTime != 0{
                    timePercent = CGFloat(doneTime)/CGFloat(expectTime)
                }
                timeValue.append(timePercent)
                
                
                if maxPercent < amountPercent {
                    maxPercent = amountPercent
                }
                
                if maxPercent < timePercent {
                    maxPercent = timePercent
                }
                
            }
        }
        
        
        timeData["color"] = UIColor.todaitBlue()
        timeData["value"] = timeValue
        timeData["max"] = maxPercent
        
        amountData["color"] = UIColor.todaitRed()
        amountData["value"] = amountValue
        amountData["max"] = maxPercent
        
        datas.append(timeData)
        datas.append(amountData)
        
        
        
        
        return datas
        
    }
    
    
    func isProgress()-> Bool {
        /*
        let nowDateNumber = getTodayDateNumber()
        
        if nowDateNumber <= endDate {
            return true
        }
        */
        return false
    }
    
    
    func getDay(dateNumber:Int)->Day?{
        
        
        for taskDate in taskDates {
            
            if let day = taskDate.getDay(dateNumber) {
                return day
            }
            
        }
        return nil
    }
    
    
    func getTodayDay()->Day?{
        
        if taskDates.count > 0 {
            
            return taskDates.last?.getTodayDay()
        }
        
        return nil
    }
    
    func getColor()->UIColor{
        
        if let category = category {
            return UIColor.colorWithHexString(category.color)
        }
        
        return UIColor.clearColor()
    }
    
    
    func getStringOfPeriodProgress()->String{
        
        if let lastTaskDate = taskDates.last {
            return lastTaskDate.getStringOfPeriodProgress()
        }
        
        return ""
    }
    
    
    func isComplete()-> Bool {
        
        if amount <= getTotalDoneAmount() {
            return true
        }
        
        return false
    }
    
    
    func getDoneTimeString()->String{
        let totalSeconds = getTotalDoneTime()
        return "\(totalSeconds)"
    }
    
    
    func getTotalDoneTime()->Int{
        
        var doneTime:Int = 0
        
        
        for taskDate in taskDates {
            
            for day in taskDate.days {
                doneTime = doneTime + day.doneSecond
            }
        }
        
        return doneTime
    }
    
    func getPercentOfPeriodProgress()->Float{
        
        var totalDay = 0
        var progressDay = 0
        
        let todayDateNumber = getTodayDateNumber()
        
        
        
        for taskDate in taskDates {
            
            if todayDateNumber > taskDate.endDate {
                
                progressDay = progressDay +  taskDate.getTotalProgressDay()
                totalDay = totalDay +  taskDate.getTotalProgressDay()
                
            }else if todayDateNumber >= taskDate.startDate && todayDateNumber <= taskDate.endDate {
                
                progressDay = progressDay + taskDate.getProgressDay()
                totalDay = totalDay +  taskDate.getTotalProgressDay()
                
            }
            
        }
        
        
        return Float(progressDay) * 100 / Float(totalDay)
    }
    
    
    func getPercentOfDoneAmount()->Float{
        
        
        let doneAmount = getTotalDoneAmount()
        let totalAmount = amount
        
        if totalAmount == 0 {
            return 0
        }
        
        return Float(doneAmount) * 100 / Float(totalAmount)
    }
    
    func getAverageFocusScore()->Float{
        
        var day:Day?
        var score:Float = 0
        var count = 0
        
        for taskDate in taskDates {
            
            for day in taskDate.days {
                score = score + Float(day.score)
                count = count + 1
            }
        }
        
        
        if count == 0 {
            return  0
        }
        
        
        return score/Float(count)
        
    }
    
    
    func getWeekAmountProgressData(date:NSDate)->[[String:Int]]{
        
        
        var datas:[[String:Int]] = []
        var adjustDate:NSDate! = getAdjustDate(date)
        
        for dayOfWeek in 0...6 {
            
            let dayOfWeekComp = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitWeekday|NSCalendarUnit.CalendarUnitYear|NSCalendarUnit.CalendarUnitDay|NSCalendarUnit.CalendarUnitMonth, fromDate: adjustDate)
            dayOfWeekComp.day = dayOfWeekComp.day - 6 + dayOfWeek
            let dayOfWeekDate:NSDate! = NSCalendar.currentCalendar().dateFromComponents(dayOfWeekComp)
            
            let day:Day? = getDay(getDateNumberFromDate(dayOfWeekDate))
            
            if let check = day {
                var data:[String:Int] = [:]
                data["expect"] = day!.expectAmount
                data["done"] = day!.doneAmount
                
                datas.append(data)
            }else{
                var data:[String:Int] = [:]
                data["expect"] = 0
                data["done"] = 0
                
                datas.append(data)
            }
        }
        
        return datas
    }

    
    
    func getWeekTimeProgressData(date:NSDate)->[[String:Int]]{
        
        var datas:[[String:Int]] = []
        var adjustDate:NSDate! = getAdjustDate(date)
        
        
        for dayOfWeek in 0...6 {
            
            let dayOfWeekComp = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitWeekday|NSCalendarUnit.CalendarUnitYear|NSCalendarUnit.CalendarUnitDay|NSCalendarUnit.CalendarUnitMonth, fromDate: adjustDate)
            dayOfWeekComp.day = dayOfWeekComp.day - 6 + dayOfWeek
            let dayOfWeekDate:NSDate! = NSCalendar.currentCalendar().dateFromComponents(dayOfWeekComp)
            
            let day:Day? = getDay(getDateNumberFromDate(dayOfWeekDate))
            
            
            if let day = day {
                
                var dayOfWeekIndex:Int = Int(day.dayOfWeek())
                var expectedTimes = day.taskDate!.week?.getExpectedTime()
                
                var data:[String:Int] = [:]
                data["expect"] = expectedTimes![dayOfWeekIndex]
                data["done"] = Int(day.doneSecond)
                
                datas.append(data)
            }else{
                var data:[String:Int] = [:]
                data["expect"] = 0//expectedTimes[dayOfWeek]
                data["done"] = 0
                
                datas.append(data)
            }
        }
            
        
        
        
        /*
        var expectedTimes = week.getExpectedTime()
        
        for dayOfWeek in 0...6 {
            
            let dayOfWeekComp = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitWeekday|NSCalendarUnit.CalendarUnitYear|NSCalendarUnit.CalendarUnitDay|NSCalendarUnit.CalendarUnitMonth, fromDate: adjustDate)
            dayOfWeekComp.day = dayOfWeekComp.day - 6 + dayOfWeek
            let dayOfWeekDate:NSDate! = NSCalendar.currentCalendar().dateFromComponents(dayOfWeekComp)
            
            let day:Day? = getDay(getDateNumberFromDate(dayOfWeekDate))
            
            
            if let check = day {
                
                var dayOfWeekIndex:Int = Int(day!.dayOfWeek)
                
                var data:[String:NSNumber] = [:]
                data["expect"] = Int(expectedTimes[dayOfWeekIndex])
                data["done"] = Int(day!.doneSecond)
                
                datas.append(data)
            }else{
                var data:[String:NSNumber] = [:]
                data["expect"] = Int(expectedTimes[dayOfWeek])
                data["done"] = 0
                
                datas.append(data)
            }
        }
        */
        
        return datas
        
    }

    
    
    func getWeekDateNumberShortString(date:NSDate)->[String]{
        var dateStringList:[String] = []
        var adjustDate:NSDate! = getAdjustDate(date)
        
        for dayOfWeek in 0...6 {
            
            let dayOfWeekComp = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitWeekday|NSCalendarUnit.CalendarUnitYear|NSCalendarUnit.CalendarUnitDay|NSCalendarUnit.CalendarUnitMonth, fromDate: adjustDate)
            dayOfWeekComp.day = dayOfWeekComp.day - 6 + dayOfWeek
            let dayOfWeekDate = NSCalendar.currentCalendar().dateFromComponents(dayOfWeekComp)
            
            let dateForm = NSDateFormatter()
            dateForm.dateFormat = "d일"
            
            let dateString = dateForm.stringFromDate(dayOfWeekDate!)
            dateStringList.append(dateString)
        }
        
        return dateStringList
    }
    
    
    func getAdjustDate(date:NSDate)->NSDate{
        
        return getDateFromDateNumber(getDateNumberFromDate(date))
    }
    
    
    func getDoneAmountString()->String{
        
        let doneAmount = getTotalDoneAmount()
        let totalAmount = amount
        let remainder = totalAmount - doneAmount
        
        if remainder <= 0 {
            return "\(doneAmount)/\(totalAmount) \(unit)"
        }else{
            return "\(doneAmount)/\(totalAmount) \(unit) (\(remainder)\(unit) 남음)"
        }
    }
    

    func getTotalDoneAmount()->Int{
        
        var doneAmount:Int = 0
        
        for taskDate in taskDates {
            
            for day in taskDate.days {
                doneAmount = doneAmount + day.doneAmount
            }
        }
        
        return doneAmount
    }
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
