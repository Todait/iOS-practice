//
//  Task.swift
//  Todait
//
//  Created by CruzDiary on 2015. 7. 23..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import Foundation
import CoreData

class Task: NSManagedObject {

    @NSManaged var amount: NSNumber
    @NSManaged var taskType: String
    @NSManaged var dirtyFlag: NSNumber
    @NSManaged var endDate: NSNumber
    @NSManaged var imageNames: String
    @NSManaged var lastUpdateDate: NSNumber
    @NSManaged var name: String
    @NSManaged var notificationMode: NSNumber
    @NSManaged var notificationTime: String
    @NSManaged var serverCategoryId: NSNumber
    @NSManaged var serverId: NSNumber
    @NSManaged var startDate: NSNumber
    @NSManaged var startPoint: NSNumber
    @NSManaged var unit: String
    @NSManaged var localId: String
    @NSManaged var reviewType: String
    @NSManaged var createdAt: NSDate
    @NSManaged var reviewCount: NSNumber
    @NSManaged var completed: NSNumber
    @NSManaged var repeatCount: NSNumber
    @NSManaged var priority: NSNumber
    @NSManaged var categoryId: Category
    //@NSManaged var taskDateList: NSOrderedSet
    @NSManaged var imageDataList: NSSet
    
    @NSManaged var week:Week
    @NSManaged var dayList: NSOrderedSet
    
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    let defaults:NSUserDefaults! = NSUserDefaults.standardUserDefaults()
    
    
    func getTrendData()->[[String:AnyObject]]{
        
        var datas:[[String:AnyObject]] = []
        
        var timeData:[String:AnyObject] = [:]
        var amountData:[String:AnyObject] = [:]
        
        var timeValue:[NSNumber] = []
        var amountValue:[NSNumber] = []
        var expectedTimes = week.getExpectedTime()
        
        var maxPercent:CGFloat = 0
        
        for dayItem in dayList {
            var day = dayItem as! Day
            
            var expectAmount = CGFloat(day.expectAmount.floatValue)
            var doneAmount = CGFloat(day.doneAmount.floatValue)
            
            var amountPercent:CGFloat = 0
            if expectAmount != 0 {
                amountPercent = CGFloat(doneAmount)/CGFloat(expectAmount)
            }
            amountValue.append(amountPercent)
            
            
            
            
            var expectTime = CGFloat(expectedTimes[Int(day.dayOfWeek)])
            var doneTime = CGFloat(day.doneSecond.floatValue)
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
                data["expect"] = CGFloat(day!.expectAmount.floatValue)
                data["done"] = CGFloat(day!.doneAmount.floatValue)
                
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
        
        var startDate = self.startDate
        let todayDate = getTodayDateNumber()
        var endDate = self.endDate
        
        var dayArray = dayList
        
        while startDate.integerValue < todayDate.integerValue {
            
            getDay(startDate)!
            
            let nextDate = getDateFromDateNumber(startDate).addDay(1)
            startDate = getDateNumberFromDate2(nextDate)
        }
        
        dayList = dayArray
        
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
        
        return day.doneSecond
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
        
        
        if((dateNumber.integerValue >= startDate.integerValue) && (endDate.integerValue >= dateNumber.integerValue)){
            let day = makeDay(dateNumber)
            return day
            
        }else if taskType == "timer"{
            let day = makeDay(dateNumber)
        }
        
        return day
    }
    
    func makeDay(dateNumber:NSNumber)->Day!{
        
        
        let entityDescription = NSEntityDescription.entityForName("Day", inManagedObjectContext:context!)
        let day = Day(entity: entityDescription!, insertIntoManagedObjectContext: context)
        
        day.createdAt = NSDate()
        day.taskId = self
        day.doneAmount = 0
        day.doneSecond = 0
        day.date = dateNumber
        day.dayOfWeek = getDayOfWeekFromDateNumber(dateNumber)
        day.expectAmount = Int(calculateExpectedAmount(day))
        
        
        var error: NSError?
        context?.save(&error)
        
        
        return day
    }
    
    func getDateNumberFromDate2(date:NSDate)->NSNumber{
        
        let dateForm = NSDateFormatter()
        dateForm.dateFormat = "yyyyMMdd"
        let dateNumber = dateForm.stringFromDate(date).toInt()
        
        return dateForm.stringFromDate(date).toInt()!
        
    }
    
    
    func getColor()->UIColor{
        return UIColor.colorWithHexString(categoryId.color)
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
            return isValid.doneAmount
        }
        
        return 0
    }
    
    
    
    func calculateExpectedAmount(day:Day) -> NSNumber{
        
        let totalAmount = amount
        let doneAmount = getTotalDoneAmount()
        
        let leftAmount = getLeftTotalAmount(Int(totalAmount),doneAmount:Int(doneAmount))
        let percent = getDayPercent(day)
        
        
        return CGFloat(leftAmount)*CGFloat(percent) + 1
    }
    
    func getDayPercent(day:Day)->NSNumber{
        
        if let week = self.week as? Week {
            
            let expectedAmount = week.getExpectedAmount()
            let todayAmount = expectedAmount[Int(day.dayOfWeek)]
            
            
            var totalAmount:NSNumber = 0
            
            let todayDateNumber = getTodayDateNumber()
            let progressDay:Int = getProgressDayFromDateNumber(todayDateNumber, endDateNumber:endDate).integerValue
            
            for index in 0...progressDay {
                
                let expectIndex = Int((Int(day.dayOfWeek) + Int(index))%7)
                totalAmount = totalAmount.integerValue + Int(expectedAmount[expectIndex])
                
            }
            
            if totalAmount == 0 {
                return 0
            }
            
            
            return todayAmount.floatValue / totalAmount.floatValue
        }
        
        
        return 0
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
        
        if todayDateNumber.integerValue > endDate.integerValue {
            return 100
            
        }else if todayDateNumber.integerValue >= startDate.integerValue && todayDateNumber.integerValue <= endDate.integerValue {
            
            let progressDay = getProgressDayFromDateNumber(startDate, endDateNumber: todayDateNumber)
            let totalDay = getProgressDayFromDateNumber(startDate, endDateNumber: endDate)
            
            return progressDay.floatValue * 100 / totalDay.floatValue
        }
        
        return 0
    }
    
    func getStringOfPeriodProgress()->String{
        
        let todayDateNumber = getTodayDateNumber()
        
        if todayDateNumber.integerValue > endDate.integerValue {
            return "마감 날짜가 지났습니다"
        }else if todayDateNumber.integerValue >= startDate.integerValue && todayDateNumber.integerValue <= endDate.integerValue {
            
            let progressDay = getProgressDayFromDateNumber(startDate, endDateNumber: todayDateNumber)
            let totalDay = getProgressDayFromDateNumber(startDate, endDateNumber: endDate)
            
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
            doneTime = doneTime + day.doneSecond.integerValue
        }
        
        return doneTime
    }
    
    func getPercentOfDoneAmount()->NSNumber{
        
        let doneAmount = getTotalDoneAmount()
        let totalAmount = amount
        
        if totalAmount == 0 {
            return 0
        }
        
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
            doneAmount = doneAmount + day.doneAmount.integerValue
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
        
        if nowDateNumber.integerValue <= endDate.integerValue {
            return true
        }
        
        return false
    }
    

}
