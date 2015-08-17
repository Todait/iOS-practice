//
//  TaskDateR.swift
//  Todait
//
//  Created by CruzDiary on 2015. 8. 12..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import RealmSwift
import SwiftyJSON

class TaskDate: RealmObject {
    
    dynamic var startDate = 0
    dynamic var endDate = 0
    dynamic var state = 0
    dynamic var archived = false
    dynamic var task:Task?
    dynamic var week:Week?
    dynamic var userId = 0
    
    let days = List<Day>()
    let defaults = NSUserDefaults.standardUserDefaults()
    let ONE_DAY = 1
    
    
    func setupJSON(json:JSON){
        
        
        serverId = json["id"].intValue
        startDate = json["start_date"].intValue
        endDate = json["end_date"].intValue
        state = json["state"].intValue
        userId = json["user_id"].intValue
        archived = json["archived"].boolValue
    
    }
    
    override func getParentsModel()->RealmObject.Type{
        return Task.self
    }
   
    override func getParentsServerIdKey()->String{
        return "task_id"
    }
    
    
    override func addRelation(child:RealmObject){
        
        if child.className == "Day" {
            
            (child as! Day).taskDate = self
            days.append(child as! Day)
            
        }else if(child.className == "Week") {
            
            (child as! Week).taskDate = self
            week = (child as! Week)
        }
    }
    
    
    func getColor()->UIColor?{
        
        if let task = task {
            return task.getColor()
        }
        
        return nil
    }
    
    
    func getWeekTimeProgressData(date:NSDate)->[[String:NSNumber]]{
        
        var datas:[[String:NSNumber]] = []
        var adjustDate:NSDate! = getAdjustDate(date)
        var expectedTimes = week!.getExpectedTime()
        
        for dayOfWeek in 0...6 {
            
            let dayOfWeekComp = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitWeekday|NSCalendarUnit.CalendarUnitYear|NSCalendarUnit.CalendarUnitDay|NSCalendarUnit.CalendarUnitMonth, fromDate: adjustDate)
            dayOfWeekComp.day = dayOfWeekComp.day - 6 + dayOfWeek
            let dayOfWeekDate:NSDate! = NSCalendar.currentCalendar().dateFromComponents(dayOfWeekComp)
            
            let day:Day? = getDay(getDateNumberFromDate(dayOfWeekDate))
            
            
            if let day = day {
                
                var dayOfWeekIndex:Int = Int(day.dayOfWeek())
                
                var data:[String:NSNumber] = [:]
                data["expect"] = Int(expectedTimes[dayOfWeekIndex])
                data["done"] = Int(day.doneSecond)
                
                datas.append(data)
            }else{
                var data:[String:NSNumber] = [:]
                data["expect"] = Int(expectedTimes[dayOfWeek])
                data["done"] = 0
                
                datas.append(data)
            }
        }
        
        return datas
        
    }
    
    func getAdjustDate(date:NSDate)->NSDate{
        
        return getDateFromDateNumber(getDateNumberFromDate(date))
    }
    
    
    func getDay(dateNumber:Int)->Day?{
        
        if days.count > 0 {
            if let day = days.last {
                if day.date == dateNumber {
                    return day
                }
            }
        }
        
        return nil
    }
    
    func getTodayDay()->Day?{
        
        if days.count > 0 {
            if let day = days.last {
                if day.date == getTodayDateNumber() {
                    return day
                }
            }
        }
        
        return nil
    }
    
    func getUnit()->NSString{
        
        if let task = task {
            return task.unit
        }
        
        return ""
    }
    
    func getDayPercent(day:Day)->Float{
        
        if let week = self.week {
            
            let expectedAmount = week.getExpectedAmount()
            let todayAmount = expectedAmount[Int(day.dayOfWeek())]
            
            
            var totalAmount:Int = 0
            
            let todayDateNumber = getTodayDateNumber()
            let progressDay:Int = getProgressDayFromDateNumber(todayDateNumber, endDateNumber:endDate)
            
            
            if progressDay < 0 {
                return 0
            }
            
            for index in 0...progressDay {
                
                let expectIndex = Int((Int(day.dayOfWeek()) + Int(index))%7)
                totalAmount = totalAmount + Int(expectedAmount[expectIndex])
                
            }
            
            if totalAmount == 0 {
                return 0
            }
            
            
            return Float(todayAmount) / Float(totalAmount)
            
        }
        
        
        return 0
    }
    
    
    
    func getLeftTotalAmount(totalAmount:Int,doneAmount:Int)->Int{
        return max(totalAmount-doneAmount,0)
    }
    
    
    func getPercentOfPeriodProgress() -> Float {
        
        let todayDateNumber = getTodayDateNumber()
        
        if todayDateNumber > endDate {
            return 100
            
        }else if todayDateNumber >= startDate && todayDateNumber <= endDate {
            
            let progressDay = getProgressDayFromDateNumber(startDate, endDateNumber: todayDateNumber)
            let totalDay = getProgressDayFromDateNumber(startDate, endDateNumber: endDate)
            
            return Float(progressDay) * 100 / Float(totalDay)
        }
        
        return 0
    }
    
    
    func getStringOfPeriodProgress()->String{
        
        let todayDateNumber = getTodayDateNumber()
        
        if todayDateNumber > endDate {
            return "마감 날짜가 지났습니다"
        }else if todayDateNumber >= startDate && todayDateNumber <= endDate {
            
            let progressDay = getProgressDayFromDateNumber(startDate, endDateNumber: todayDateNumber)
            let totalDay = getProgressDayFromDateNumber(startDate, endDateNumber: endDate)
            
            return "\(progressDay)일째 | \(totalDay)일 남음"
        }
        
        return ""
    }
    
    
    func getTotalProgressDay()->Int{
        return getProgressDayFromDateNumber(startDate, endDateNumber: endDate)
    }
    
    func getProgressDay()->Int{
        
        return getProgressDayFromDateNumber(startDate, endDateNumber: getTodayDateNumber())
    }
    
    func getProgressDayFromDateNumber(startDateNumber:Int,endDateNumber:Int)->Int{
        
        
        if startDateNumber == endDateNumber {
            return ONE_DAY
        }
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        
        
        if let startDate = dateFormatter.dateFromString("\(startDateNumber)") {
            
            let startComp = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitYear|NSCalendarUnit.CalendarUnitMonth|NSCalendarUnit.CalendarUnitDay|NSCalendarUnit.CalendarUnitHour|NSCalendarUnit.CalendarUnitDay, fromDate: startDate)
            startComp.hour = self.defaults.integerForKey("finishHourOfDay")
            startComp.minute = self.defaults.integerForKey("finishMinuteOfDay") + 1
            
            
            if let endDate = dateFormatter.dateFromString("\(endDateNumber)") {
                
                let endComp = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitYear|NSCalendarUnit.CalendarUnitMonth|NSCalendarUnit.CalendarUnitDay|NSCalendarUnit.CalendarUnitHour|NSCalendarUnit.CalendarUnitDay, fromDate: endDate)
                
                endComp.hour = self.defaults.integerForKey("finishHourOfDay")
                endComp.minute = self.defaults.integerForKey("finishMinuteOfDay") - 1
                
                
                return getProgressDay(startDate, endDate:endDate)
                
            }
        }
        
        return 0
        
    }
    
    func getProgressDay(startDate:NSDate,endDate:NSDate)->Int{
        
        
        var dayNumber = Int(endDate.timeIntervalSinceDate(startDate)/(24*60*60))
        var dayRemainder = endDate.timeIntervalSinceDate(startDate)%(24*60*60)
        
        if dayRemainder != 0 {
            dayNumber = dayNumber + 1
        }
        
        
        return dayNumber
        
    }

    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
