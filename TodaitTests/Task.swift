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

class Task:NSObject {
    
     var amount: NSNumber!
     var amount_type: NSNumber!
     var archived_at: NSDate!
     var created_at: NSDate!
     var dirty_flag: NSNumber!
     var end_date: NSNumber!
     var image_names: String!
     var last_update_date: NSNumber!
     var name: String!
     var notification_mode: String!
     var notification_time: String!
     var server_category_id: NSNumber!
     var server_id: NSNumber!
     var start_date: NSNumber!
     var start_point: NSNumber!
     var unit: String!
     var updated_at: NSDate!
     var category_id: Category!
     var dayList: [Day] = []
    
     var week:Week!
    
    
    func updateDay(){
     
        var startDate = start_date
        let todayDate = getTodayDateNumber()
        var endDate = end_date
        
        var dayArray = dayList
        
        while startDate.integerValue < todayDate.integerValue {
            
            
            dayArray.append(getDay(startDate)!)
            
            let nextDate = getDateFromDateNumber(startDate).addDay(1)
            startDate = getDateNumberFromDate(nextDate)
        }
        
        dayList = dayArray
        
    }
    
    func getColor()->UIColor{
        
        return UIColor.redColor()
        //return UIColor.colorWithHexString(category_id.color)
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
    
    
    //date와 오늘마감시간에 따라 에러발생가능성 있음
    
    func getDateNumberFromDate(date:NSDate)->NSNumber{
        
        let dateForm = NSDateFormatter()
        dateForm.dateFormat = "yyyyMMdd"
        
        let dateNumber:NSNumber! = dateForm.stringFromDate(date).toInt()
        
        return dateNumber
    }
    
    func getWeekDateNumberString(date:NSDate)->[String]{
        var dateStringList:[String] = []
        
        for dayOfWeek in 0...6 {
            
            let dayOfWeekComp = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitWeekday|NSCalendarUnit.CalendarUnitYear|NSCalendarUnit.CalendarUnitDay|NSCalendarUnit.CalendarUnitMonth, fromDate: date)
            dayOfWeekComp.day = dayOfWeekComp.day - 6 + dayOfWeek
            let dayOfWeekDate = NSCalendar.currentCalendar().dateFromComponents(dayOfWeekComp)
            
            let dateForm = NSDateFormatter()
            dateForm.dateFormat = "MMM d일"
            
            let dateString = dateForm.stringFromDate(dayOfWeekDate!)
            dateStringList.append(dateString)
        }
        
        return dateStringList
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
        
        let day = Day()
        
        
        day.updated_at = NSDate()
        day.created_at = NSDate()
        day.task_id = self
        day.done_amount = 0
        day.done_second = 0
        day.date = dateNumber
        day.day_of_week = getDayOfWeekFromDateNumber(dateNumber)
        day.expect_amount = Int(calculateExpectedAmount(day))
        
        
        return day
    }

    
    func calculateExpectedAmount(day:Day) -> NSNumber{
        
        let totalAmount = amount
        let doneAmount = getTotalDoneAmount()
        
        let leftAmount = getLeftTotalAmount(Int(totalAmount),doneAmount:Int(doneAmount))
        let percent = 0.1
        
        
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
        
        return dayOfWeek.weekday
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
        return getDateNumberFromDate(NSDate())
    }
    
    
    func getProgressDayFromDateNumber(startDateNumber:NSNumber,endDateNumber:NSNumber)->NSNumber{
        
        
        if startDateNumber.integerValue == endDateNumber.integerValue {
            return 1
        }
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let startDate:NSDate! = dateFormatter.dateFromString("\(startDateNumber)")
        
        let startComp = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitYear|NSCalendarUnit.CalendarUnitMonth|NSCalendarUnit.CalendarUnitDay|NSCalendarUnit.CalendarUnitHour|NSCalendarUnit.CalendarUnitDay, fromDate: startDate)
        startComp.hour = 4
        startComp.minute = 0
        
        
        let endDate:NSDate! = dateFormatter.dateFromString("\(endDateNumber)")
        
        let endComp = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitYear|NSCalendarUnit.CalendarUnitMonth|NSCalendarUnit.CalendarUnitDay|NSCalendarUnit.CalendarUnitHour|NSCalendarUnit.CalendarUnitDay, fromDate: endDate)
        endComp.hour = 4
        endComp.minute = -1
        
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
        
        
        var finishHour:Int = 4
        let finishMinute:Int = 0
        
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
