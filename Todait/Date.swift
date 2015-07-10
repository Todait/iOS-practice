//
//  Date.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 10..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import Foundation

public extension NSDate {
    func addDay(day:Int)->NSDate{
        
        return self.dateByAddingTimeInterval(24*60*60*NSTimeInterval(day))
        
    }
    
    func addMonth(month:Int)->NSDate{
        
        
        var dateComp = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitYear|NSCalendarUnit.CalendarUnitMonth|NSCalendarUnit.CalendarUnitDay|NSCalendarUnit.CalendarUnitWeekday|NSCalendarUnit.CalendarUnitHour, fromDate: self)
        
        dateComp.month = dateComp.month + month
        
        return NSCalendar.currentCalendar().dateFromComponents(dateComp)!
        
    }
    
    func addWeek(week:Int)->NSDate{
        
        
        var dateComp = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitYear|NSCalendarUnit.CalendarUnitMonth|NSCalendarUnit.CalendarUnitDay|NSCalendarUnit.CalendarUnitWeekday|NSCalendarUnit.CalendarUnitHour|NSCalendarUnit.CalendarUnitWeekOfMonth, fromDate: self)
        
        dateComp.day = dateComp.day + 7*week
        
        return NSCalendar.currentCalendar().dateFromComponents(dateComp)!
        
    }
}
