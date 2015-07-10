//
//  Utill.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 15..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit





public func getTodayDateNumber()->NSNumber{
    
    return getDateNumberFromDate(NSDate())
}


public func getWeekDateNumberList(date:NSDate)->[NSNumber]{
    
    let adjustDate = getDateFromDateNumber(getDateNumberFromDate(date))
    
    var dateNumberList:[NSNumber] = []
    
    for dayOfWeek in 0...6 {
        
        let dayOfWeekComp = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitWeekday|NSCalendarUnit.CalendarUnitYear|NSCalendarUnit.CalendarUnitDay|NSCalendarUnit.CalendarUnitMonth, fromDate: adjustDate)
        dayOfWeekComp.day = dayOfWeekComp.day - 6 + dayOfWeek
        let dayOfWeekDate = NSCalendar.currentCalendar().dateFromComponents(dayOfWeekComp)
        let dateNumber = getDateNumberFromDate(dayOfWeekDate!)
        
        dateNumberList.append(dateNumber)
    }
    
    return dateNumberList
}


public func getDateFromDateNumber(dateNumber:NSNumber)->NSDate{
    
    let dateForm = NSDateFormatter()
    dateForm.dateFormat = "yyyyMMdd"
    let mainDate = dateForm.dateFromString("\(dateNumber)")
    
    let adjustComp = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitYear|NSCalendarUnit.CalendarUnitMonth|NSCalendarUnit.CalendarUnitDay|NSCalendarUnit.CalendarUnitMinute|NSCalendarUnit.CalendarUnitHour, fromDate: mainDate!)
    adjustComp.hour = 5
    adjustComp.minute = 0
    
    return NSCalendar.currentCalendar().dateFromComponents(adjustComp)!
    
}


public func getDateNumberFromDate(date:NSDate)->NSNumber{
    
    let dateForm = NSDateFormatter()
    dateForm.dateFormat = "yyyyMMdd"
    let dateNumber = dateForm.stringFromDate(date).toInt()
    
    let diff = checkDayLastTime(date)
    
    return dateForm.stringFromDate(date.addDay(diff)).toInt()!
    
}




public func getDate(year:Int,month:Int,day:Int,hour:Int,minute:Int,second:Int)->NSDate{
    
    let dateComp = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitHour|NSCalendarUnit.CalendarUnitMinute|NSCalendarUnit.CalendarUnitSecond|NSCalendarUnit.CalendarUnitMonth|NSCalendarUnit.CalendarUnitYear|NSCalendarUnit.CalendarUnitDay, fromDate:NSDate())
    
    dateComp.month = month
    dateComp.year = year
    dateComp.day = day
    dateComp.hour = hour
    dateComp.minute = minute
    dateComp.second = second
    
    
    return NSCalendar.currentCalendar().dateFromComponents(dateComp)!
    
}

public func checkDayLastTime(date:NSDate)->Int{
    
    
    let comp = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitHour|NSCalendarUnit.CalendarUnitMinute, fromDate:date)
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    var finishHour:Int = defaults.integerForKey("finishHourOfDay")
    var finishMinute:Int = defaults.integerForKey("finishMinuteOfDay")
    
    
    if comp.hour < 12 && finishHour < 12 {
        let nowTotalMinute = 60*comp.hour + comp.minute
        let finishTimeOfDayTotalMinute = 60*finishHour + finishMinute
        
        if nowTotalMinute >= finishTimeOfDayTotalMinute {
            return 0
        }else{
            return -1
        }
        
    }else if comp.hour > 12 && finishHour < 12 {
        return 0
    }else if comp.hour < 12 && finishHour > 12 {
        return 1
    }else if comp.hour > 12 && finishHour > 12 {
        
        let nowTotalMinute = 60*comp.hour + comp.minute
        let finishTimeOfDayTotalMinute = 60*finishHour + finishMinute
        
        
        if nowTotalMinute >= finishTimeOfDayTotalMinute {
            return 1
        }
    }
    
    
    return 0
}
