//
//  Utill.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 15..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit
import Foundation


public let CREDENTIAL_ACCESS_KEY:String = "AKIAJS3V26L2Z3N64B6A"
public let CREDENTIAL_SECRET_KEY:String = "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"
public let AWSS3_BUCKET_NAME:String = "todait-images"


extension Array {
    
    func find(includedElement: T -> Bool) -> Int? {
        for (idx, element) in enumerate(self) {
            if includedElement(element) {
                return idx
            }
        }
        return nil
    }
    
    func indexOfObject(object : AnyObject) -> NSInteger
    {
        return (self as! NSArray).indexOfObject(object)
    }
    
}


extension UIView {
    class func fromNib<T : UIView>(nibNameOrNil: String? = nil) -> T {
        let v: T? = fromNib(nibNameOrNil: nibNameOrNil)
        return v!
    }
    
    class func fromNib<T : UIView>(nibNameOrNil: String? = nil) -> T? {
        var view: T?
        let name: String
        if let nibName = nibNameOrNil {
            name = nibName
        } else {
            // Most nibs are demangled by practice, if not, just declare string explicitly
            name = "\(T.self)".componentsSeparatedByString(".").last!
        }
        let nibViews = NSBundle.mainBundle().loadNibNamed(name, owner: nil, options: nil)
        for v in nibViews {
            if let tog = v as? T {
                view = tog
            }
        }
        return view
    }
}


public func getIndexFromCategoryColorString(color:String)->Int{
    
    switch color{
    case "#FFF2F2F2": return 0
    case "#FFFFD094": return 1
    case "#FFFDE039": return 2
    case "#FFFFB95A": return 3
    case "#FFE8716E": return 4
    case "#FFFF9EC7": return 5
    case "#FFFA5B85": return 6
    case "#FFC552A6": return 7
    case "#FFCC9DF2": return 8
    case "#FF957AC6": return 9
    case "#FFA3E5E4": return 10
    case "#FF8CC5FF": return 11
    case "#FF4FA0FE": return 12
    case "#FF23C4CE": return 13
    case "#FF286883": return 14
    case "#FF75EC75": return 15
    case "#FFB0DE8F": return 16
    case "#FF70C79E": return 17
    case "#FFD2D392": return 18
    case "#FFCEA37A": return 19
    default: return 0
        
    }
    
}

public func getTimeString(time:Int)->String{
    
    let hour = time.toHour()
    let minute = time.toMinute()
    
    if hour == 0 {
        return "\(minute)분"
    }else{
        if minute == 0 {
            return "\(hour)시간"
        }else{
            return "\(hour)시간 \(minute)분"
        }
    }
}


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

public func getFirstDateOfMonth(date:NSDate)->NSDate{
    
    let firstDayOfMonthComp = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitYear|NSCalendarUnit.CalendarUnitMonth|NSCalendarUnit.CalendarUnitDay|NSCalendarUnit.CalendarUnitWeekday|NSCalendarUnit.CalendarUnitHour, fromDate:date)
    firstDayOfMonthComp.day = 1
    firstDayOfMonthComp.hour = 11
    firstDayOfMonthComp.minute = 59
    
    var firstDate:NSDate = NSCalendar.currentCalendar().dateFromComponents(firstDayOfMonthComp)!
    
    let weekDayComp = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitWeekday, fromDate: firstDate)
    let firstOfWeek = weekDayComp.weekday
    
    if (firstOfWeek > 4) {
        firstDate = firstDate.addDay(8-firstOfWeek)
    }else{
        firstDate = firstDate.addDay(1-firstOfWeek)
    }
    
    return firstDate
}


public func getNewUUIDString()->String {
    
    var uuid = NSUUID().UUIDString.lowercaseString
    
    return "\(Int(NSDate().timeIntervalSince1970))-" + uuid
}

public func getNewUUIDFileNameString()->String {
    
    var uuid = NSUUID().UUIDString.lowercaseString
    
    return "\(Int(NSDate().timeIntervalSince1970))-" + uuid + ".jpg"
}

public func getTimeStringFromSeconds(seconds : NSTimeInterval ) -> String {
    
    
    let remainder : Int = Int(seconds % 3600 )
    let hour : Int = Int(seconds / 3600)
    let minute : Int = Int(remainder / 60)
    let second : Int = Int(remainder % 60)
    
    
    return String(format:  "%02lu:%02lu:%02lu", arguments: [hour,minute,second])
}


public func getTimeStringOfTwoArgumentsFromSeconds(seconds : NSTimeInterval ) -> String {
    
    
    let remainder : Int = Int(seconds % 3600 )
    let hour : Int = Int(seconds / 3600)
    let minute : Int = Int(remainder / 60)
    let second : Int = Int(remainder % 60)
    
    
    
    if hour > 0 {
        return String(format:  "%02lu:%02lu", arguments: [hour,minute])
    }
    
    
    return String(format:  "%02lu:%02lu", arguments: [minute,second])
}


public func getTimeStringOfHourMinuteFromSeconds(seconds : NSTimeInterval ) -> String {
    
    
    let remainder : Int = Int(seconds % 3600 )
    let hour : Int = Int(seconds / 3600)
    let minute : Int = Int(remainder / 60)
    let second : Int = Int(remainder % 60)
    
    return String(format:  "%02lu:%02lu", arguments: [hour,minute])
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

public func getDateNumberFromDate(date:NSDate)->NSNumber{
    
    let dateForm = NSDateFormatter()
    dateForm.dateFormat = "yyyyMMdd"
    let dateNumber = dateForm.stringFromDate(date).toInt()
    
    let diff = checkDayLastTime(date)
    
    return dateForm.stringFromDate(date.addDay(diff)).toInt()!
    
}


public func getFirstSundayDateOfMonth(date:NSDate)->NSDate{
    
    let firstDayOfMonthComp = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitYear|NSCalendarUnit.CalendarUnitMonth|NSCalendarUnit.CalendarUnitDay|NSCalendarUnit.CalendarUnitWeekday|NSCalendarUnit.CalendarUnitHour, fromDate:date)
    firstDayOfMonthComp.day = 1
    firstDayOfMonthComp.hour = 11
    firstDayOfMonthComp.minute = 59
    
    var firstDate:NSDate = NSCalendar.currentCalendar().dateFromComponents(firstDayOfMonthComp)!
    
    let weekDayComp = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitWeekday, fromDate: firstDate)
    let firstOfWeek = weekDayComp.weekday
    
    
    firstDate = firstDate.addDay(-firstOfWeek)
    
    return firstDate
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

public func getLanguage()->String{
    return NSLocale.preferredLanguages()[0] as! String
}

public func getCancelString()->String{
    if getLanguage() == "ko" {
        return "취소"
    }else{
        return "Cancel"
    }
}



