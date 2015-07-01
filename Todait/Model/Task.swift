//
//  Task.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 9..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Task: NSManagedObject {

    @NSManaged var amount: NSNumber
    @NSManaged var amount_type: NSNumber
    @NSManaged var archived_at: NSDate
    @NSManaged var created_at: NSDate
    @NSManaged var dirty_flag: NSNumber
    @NSManaged var end_date: NSNumber
    @NSManaged var image_names: String
    @NSManaged var last_update_date: NSNumber
    @NSManaged var name: String
    @NSManaged var notification_mode: String
    @NSManaged var notification_time: String
    @NSManaged var server_category_id: NSNumber
    @NSManaged var server_id: NSNumber
    @NSManaged var start_date: NSNumber
    @NSManaged var start_point: NSNumber
    @NSManaged var unit: String
    @NSManaged var updated_at: NSDate
    @NSManaged var category_id: Category
    @NSManaged var dayList: NSOrderedSet
    @NSManaged var week:Week

    
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    let defaults:NSUserDefaults! = NSUserDefaults.standardUserDefaults()
    
    
    func getWeekTimeProgressData(date:NSDate)->[[String:NSNumber]]{
        
        var datas:[[String:NSNumber]] = []
        var adjustDate:NSDate! = getAdjustDate(date)
        
        
        var expectedTimes = week.getExpectedTime()
        
        for dayOfWeek in 0...6 {
            
            let dayOfWeekComp = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitWeekday|NSCalendarUnit.CalendarUnitYear|NSCalendarUnit.CalendarUnitDay|NSCalendarUnit.CalendarUnitMonth, fromDate: adjustDate)
            dayOfWeekComp.day = dayOfWeekComp.day - 6 + dayOfWeek
            let dayOfWeekDate:NSDate! = NSCalendar.currentCalendar().dateFromComponents(dayOfWeekComp)
            
            let day:Day? = getDay(getDateNumberFromDate(dayOfWeekDate))
            
            
            if let check = day {
                var data:[String:NSNumber] = [:]
                data["expect"] = Int(expectedTimes[dayOfWeek])
                data["done"] = Int(day!.done_second)
                
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
    
    
    func getWeekAmountProgressData(date:NSDate)->[[String:NSNumber]]{
        var datas:[[String:NSNumber]] = []
        var adjustDate:NSDate! = getAdjustDate(date)
        
        for dayOfWeek in 0...6 {
            
            let dayOfWeekComp = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitWeekday|NSCalendarUnit.CalendarUnitYear|NSCalendarUnit.CalendarUnitDay|NSCalendarUnit.CalendarUnitMonth, fromDate: adjustDate)
            dayOfWeekComp.day = dayOfWeekComp.day - 6 + dayOfWeek
            let dayOfWeekDate:NSDate! = NSCalendar.currentCalendar().dateFromComponents(dayOfWeekComp)
            
            let day:Day? = getDay(getDateNumberFromDate(dayOfWeekDate))
            
            if let check = day {
                var data:[String:NSNumber] = [:]
                data["expect"] = CGFloat(day!.expect_amount.floatValue)
                data["done"] = CGFloat(day!.done_amount.floatValue)
                
                datas.append(data)
            }else{
                var data:[String:NSNumber] = [:]
                data["expect"] = 0
                data["done"] = 0
                
                datas.append(data)
            }
        }
        
        return datas
    }
    
    
    func getAverageFocusScore()->NSNumber{
        
        var day:Day?
        var score:CGFloat = 0
        
        for dayItem in dayList {
            
            let item:Day! = dayItem as! Day
            
            score = score + CGFloat(item.score.floatValue)
            
            
        }
        
        if dayList.count == 0 {
            return  0
        }
        
        
        return score/CGFloat(dayList.count)
        
    }
    
    
    func getProgressPercentAtDateNumber(dateNumber:NSNumber)->NSNumber{
        
        let day = getDay(dateNumber)
        
        if day != nil {
            return day!.getProgressPercent()
        }
        
        return 0
        
    }
    
    
    
    func updateDay(){
        
        var startDate = start_date
        let todayDate = getTodayDateNumber()
        var endDate = end_date
        
        var dayArray = dayList
        
        while startDate.integerValue < todayDate.integerValue {
            
            getDay(startDate)!
            
            let nextDate = getDateFromDateNumber(startDate).addDay(1)
            startDate = getDateNumberFromDate2(nextDate)
        }
        
        dayList = dayArray
        
    }
    
    func getDateNumberFromDate2(date:NSDate)->NSNumber{
        
        let dateForm = NSDateFormatter()
        dateForm.dateFormat = "yyyyMMdd"
        let dateNumber = dateForm.stringFromDate(date).toInt()
        
        return dateForm.stringFromDate(date).toInt()!
        
    }
    
    
    func getColor()->UIColor{
        return UIColor.colorWithHexString(category_id.color)
    }
    
    func getWeekDayDoneTime(date:NSDate)->NSNumber{
        
        let dateNumberList:[NSNumber] = getWeekDateNumberList(date)
        var totalTime = 0
        
        for dateNumber in dateNumberList {
            let doneSecond = getDayDoneSecond(dateNumber)
            totalTime = totalTime + Int(doneSecond)
        }
        
        return totalTime
    }
    
    func getWeekDayDoneAmount(date:NSDate)->[NSNumber]{
        
        let dateNumberList:[NSNumber] = getWeekDateNumberList(date)
        var doneAmountList:[NSNumber] = []
        
        for dateNumber in dateNumberList {
            let doneAmount = getDayDoneAmount(dateNumber)
            doneAmountList.append(doneAmount)
        }
        
        return doneAmountList
    }
    
    func getWeekDateNumberList(date:NSDate)->[NSNumber]{
        
        var dateNumberList:[NSNumber] = []
        
        for dayOfWeek in 0...6 {
            
            let dayOfWeekComp = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitWeekday|NSCalendarUnit.CalendarUnitYear|NSCalendarUnit.CalendarUnitDay|NSCalendarUnit.CalendarUnitMonth, fromDate: date)
            dayOfWeekComp.day = dayOfWeekComp.day - 6 + dayOfWeek
            let dayOfWeekDate = NSCalendar.currentCalendar().dateFromComponents(dayOfWeekComp)
            let dateNumber = getDateNumberFromDate(dayOfWeekDate!)
            
            dateNumberList.append(dateNumber)
        }
        
        return dateNumberList
    }
    
    
    
    
    func getWeekDateNumberString(date:NSDate)->[String]{
        
        
        
        var adjustDate:NSDate! = getAdjustDate(date)
        var dateStringList:[String] = []
        
        
        for dayOfWeek in 0...6 {
            
            let dayOfWeekComp = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitWeekday|NSCalendarUnit.CalendarUnitYear|NSCalendarUnit.CalendarUnitDay|NSCalendarUnit.CalendarUnitMonth, fromDate: adjustDate)
            dayOfWeekComp.day = dayOfWeekComp.day - 6 + dayOfWeek
            let dayOfWeekDate = NSCalendar.currentCalendar().dateFromComponents(dayOfWeekComp)
            
            let dateForm = NSDateFormatter()
            dateForm.dateFormat = "MMM d일"
            
            let dateString = dateForm.stringFromDate(dayOfWeekDate!)
            dateStringList.append(dateString)
        }
        
        return dateStringList
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
    
    func getDayDoneAmount(dateNumber:NSNumber)->NSNumber{
    
        var day:Day?
        
        for dayItem in dayList {
            
            let item:Day! = dayItem as! Day
            if item.date.integerValue == dateNumber.integerValue {
                day = item
                break
            }
        }
        
        if let isValid = day{
            return isValid.done_amount
        }
        
        return 0
    }
    
    
    func getDayDoneSecond(dateNumber:NSNumber)->NSNumber{
        var day:Day!
        
        for dayItem in dayList {
            
            let item:Day! = dayItem as! Day
            
            if item.date.integerValue == dateNumber.integerValue {
                day = item
                break
            }
        }
        
        return day.done_second
    }
    
    
    func getDay(dateNumber:NSNumber)->Day?{
        
        var day:Day?
        
        for dayItem in dayList {
            
            let item:Day! = dayItem as! Day
            if item.date.integerValue == dateNumber.integerValue {
                day = item
            }
        }
        
        if let isValid = day{
            return isValid
        }
        
        
        if((dateNumber.integerValue >= start_date.integerValue) && (end_date.integerValue >= dateNumber.integerValue)){
            let day = makeDay(dateNumber)
            return day
        }
        
        return day
    }
    
    func makeDay(dateNumber:NSNumber)->Day!{
        
        
        let entityDescription = NSEntityDescription.entityForName("Day", inManagedObjectContext:context!)
        let day = Day(entity: entityDescription!, insertIntoManagedObjectContext: context)
        
        day.updated_at = NSDate()
        day.created_at = NSDate()
        day.task_id = self
        day.done_amount = 0
        day.done_second = 0
        day.date = dateNumber
        day.day_of_week = getDayOfWeekFromDateNumber(dateNumber)
        day.expect_amount = Int(calculateExpectedAmount(day))
        
        
        var error: NSError?
        context?.save(&error)
        
        
        return day
    }

    
    func calculateExpectedAmount(day:Day) -> NSNumber{
        
        let totalAmount = amount
        let doneAmount = getTotalDoneAmount()
        
        let leftAmount = getLeftTotalAmount(Int(totalAmount),doneAmount:Int(doneAmount))
        let percent = getDayPercent(day)
        
        
        return CGFloat(leftAmount)*CGFloat(percent) + 1
    }
    
    func getDayPercent(day:Day)->NSNumber{
        
        
        
        let week = self.week
        let expectedAmount = week.getExpectedAmount()
        let todayAmount = expectedAmount[Int(day.day_of_week)]
        
        
        var totalAmount:NSNumber = 0
        
        let todayDateNumber = getTodayDateNumber()
        let progressDay:Int = getProgressDayFromDateNumber(todayDateNumber, endDateNumber:end_date).integerValue
        
        for index in 0...progressDay {
            
            let expectIndex = Int((Int(day.day_of_week) + Int(index))%7)
            totalAmount = totalAmount.integerValue + Int(expectedAmount[expectIndex])
            
        }
        
        if totalAmount == 0 {
            return 0
        }
        
        
        return todayAmount.floatValue / totalAmount.floatValue
    }
    
    
    
    
    
    //유틸
    func getDayOfWeekFromDateNumber(dateNumber:NSNumber)->Int{
        
        let date = getDateFromDateNumber(dateNumber)
        let dayOfWeek = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitWeekday, fromDate:date)
        
        
        return dayOfWeek.weekday - 1
    }
    
    
    //유틸
    func getDateFromDateNumber(dateNumber:NSNumber)->NSDate{
        let dateForm = NSDateFormatter()
        dateForm.dateFormat = "yyyyMMdd"
        let date:NSDate = dateForm.dateFromString("\(dateNumber)")!
        return date
    }
    
    func getLeftTotalAmount(totalAmount:Int,doneAmount:Int)->NSNumber{
        return max(totalAmount-doneAmount,0)
    }
    
    func getPercentOfPeriodProgress()->NSNumber{
        
        let todayDateNumber = getTodayDateNumber()
        
        if todayDateNumber.integerValue > end_date.integerValue {
            return 100
            
        }else if todayDateNumber.integerValue >= start_date.integerValue && todayDateNumber.integerValue <= end_date.integerValue {
            
            let progressDay = getProgressDayFromDateNumber(start_date, endDateNumber: todayDateNumber)
            let totalDay = getProgressDayFromDateNumber(start_date, endDateNumber: end_date)
            
            return progressDay.floatValue * 100 / totalDay.floatValue
        }
        
        return 0
    }
    
    func getStringOfPeriodProgress()->String{
        
        let todayDateNumber = getTodayDateNumber()
        
        if todayDateNumber.integerValue > end_date.integerValue {
            return "마감 날짜가 지났습니다"
        }else if todayDateNumber.integerValue >= start_date.integerValue && todayDateNumber.integerValue <= end_date.integerValue {
            
            let progressDay = getProgressDayFromDateNumber(start_date, endDateNumber: todayDateNumber)
            let totalDay = getProgressDayFromDateNumber(start_date, endDateNumber: end_date)
            
            return "\(progressDay)일째 | \(totalDay)일 남음"
        }
        
        
        return "ㅋㅋ"
    }
    
    func getTodayDateNumber()->NSNumber{
        let dateForm = NSDateFormatter()
        dateForm.dateFormat = "yyyyMMdd"
        let todayDateNumber = dateForm.stringFromDate(NSDate()).toInt()
        
        if checkTodayLastTime() == true {
            
            
            return dateForm.stringFromDate(NSDate().dateByAddingTimeInterval(24*60*60)).toInt()!
            
        }
        
        
        return todayDateNumber!
    }
    
    
    func getProgressDayFromDateNumber(startDateNumber:NSNumber,endDateNumber:NSNumber)->NSNumber{
        
        
        if startDateNumber.integerValue == endDateNumber.integerValue {
            return 1
        }
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let startDate:NSDate! = dateFormatter.dateFromString("\(startDateNumber)")
        
        let startComp = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitYear|NSCalendarUnit.CalendarUnitMonth|NSCalendarUnit.CalendarUnitDay|NSCalendarUnit.CalendarUnitHour|NSCalendarUnit.CalendarUnitDay, fromDate: startDate)
        startComp.hour = self.defaults.integerForKey("finishHourOfDay")
        startComp.minute = self.defaults.integerForKey("finishMinuteOfDay") + 1
        
        
        
        let endDate:NSDate! = dateFormatter.dateFromString("\(endDateNumber)")
        
        let endComp = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitYear|NSCalendarUnit.CalendarUnitMonth|NSCalendarUnit.CalendarUnitDay|NSCalendarUnit.CalendarUnitHour|NSCalendarUnit.CalendarUnitDay, fromDate: endDate)
        endComp.hour = self.defaults.integerForKey("finishHourOfDay")
        endComp.minute = self.defaults.integerForKey("finishMinuteOfDay") - 1
        
        
        return getProgressDay(startDate, endDate:endDate)
        
    }
    
    func getProgressDay(startDate:NSDate,endDate:NSDate)->NSNumber{
        
        
        var dayNumber = Int(endDate.timeIntervalSinceDate(startDate)/(24*60*60))
        var dayRemainder = endDate.timeIntervalSinceDate(startDate)%(24*60*60)
        
        if dayRemainder != 0 {
            dayNumber = dayNumber + 1
        }
        
        
        return dayNumber
        
    }
    
    
    func checkTodayLastTime()->Bool{
        
        let nowTime = NSDate()
        let nowComp = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitHour|NSCalendarUnit.CalendarUnitMinute, fromDate:nowTime)
        
        
        var finishHour:Int = defaults.integerForKey("finishHourOfDay")
        let finishMinute:Int = defaults.integerForKey("finishMinuteOfDay")
        
        if finishHour < 12 {
            finishHour = finishHour + 24
        }
        
        let nowTotalMinute = 60*nowComp.hour + nowComp.minute
        let finishTimeOfDayTotalMinute = 60*finishHour + finishMinute
        
        if nowTotalMinute > finishTimeOfDayTotalMinute {
            return true
        }
        
        return false
    }
    
    
    
    func getDoneTimeString()->String{
        let totalSeconds = getTotalDoneTime()
        return totalSeconds.toTimeString()
    }
    
    
    func getTotalDoneTime()->NSNumber{
        
        var doneTime:Int = 0
        
        for dayItem in dayList{
            let day:Day! = dayItem as! Day
            doneTime = doneTime + day.done_second.integerValue
        }
        
        return doneTime
    }
    
    func getPercentOfDoneAmount()->NSNumber{
        
        let doneAmount = getTotalDoneAmount()
        let totalAmount = amount
        
        return doneAmount.floatValue * 100 / totalAmount.floatValue
    }
    
    func getDoneAmountString()->String{
        
        let doneAmount = getTotalDoneAmount()
        let totalAmount = amount
        let remainder = totalAmount.integerValue - doneAmount.integerValue
        
        if remainder <= 0 {
            return "\(doneAmount)/\(totalAmount) \(unit)"
        }else{
            return "\(doneAmount)/\(totalAmount) \(unit) (\(remainder)\(unit) 남음)"
        }
    }
    
    func getTotalDoneAmount()->NSNumber{
        
        var doneAmount:Int = 0
        
        for dayItem in dayList{
            let day:Day! = dayItem as! Day
            doneAmount = doneAmount + day.done_amount.integerValue
        }
        
        return doneAmount
    }
    
    func isComplete()-> Bool {
        
        if amount.integerValue <= getTotalDoneAmount().integerValue {
            return true
        }
        
        return false
    }
    
    func isProgress()-> Bool {
        let nowDateNumber = getTodayDateNumber()
        
        if nowDateNumber.integerValue <= end_date.integerValue {
            return true
        }
        
        return false
    }
    
}
