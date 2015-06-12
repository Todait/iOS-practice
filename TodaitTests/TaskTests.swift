//
//  TaskTests.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 12..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit
import XCTest
import CoreData
import Foundation



class Day: NSObject {
    
    var date:NSNumber!
    var done_amount:NSNumber!
    
}

class TaskTests: XCTestCase {
    
    
    var dayList:[Day] = []
    
    override func setUp() {
        super.setUp()
        
        
        
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
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
    
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
}
