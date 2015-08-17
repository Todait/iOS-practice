//
//  DetailTest.swift
//  Todait
//
//  Created by CruzDiary on 2015. 7. 27..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit
import XCTest

class DetailTests: XCTestCase {
    
    
    var finishHour:Int = 4
    var finishMinute:Int = 15
    
    override func setUp() {
        super.setUp()
        
        finishHour = 4
        finishMinute = 0
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func getDate(year:Int,month:Int,day:Int,hour:Int,minute:Int,second:Int)->NSDate{
        
        let dateComp = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitHour|NSCalendarUnit.CalendarUnitMinute|NSCalendarUnit.CalendarUnitSecond|NSCalendarUnit.CalendarUnitMonth|NSCalendarUnit.CalendarUnitYear|NSCalendarUnit.CalendarUnitDay, fromDate:NSDate())
        
        dateComp.month = month
        dateComp.year = year
        dateComp.day = day
        dateComp.hour = hour
        dateComp.minute = minute
        dateComp.second = second
        
        
        return NSCalendar.currentCalendar().dateFromComponents(dateComp)!
        
    }
    
    
    func getDateNumberFromDate(date:NSDate)->NSNumber{
        
        let dateForm = NSDateFormatter()
        dateForm.dateFormat = "yyyyMMdd"
        let dateNumber = dateForm.stringFromDate(date).toInt()
        
        let diff = checkDayLastTime(date)
        
        return dateForm.stringFromDate(date.addDay(diff)).toInt()!
        
    }
    
    
    
    func checkDayLastTime(date:NSDate)->Int{
        
        
        let comp = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitHour|NSCalendarUnit.CalendarUnitMinute, fromDate:date)
        
        
        var finishHour:Int = self.finishHour
        var finishMinute:Int = self.finishMinute
        
        
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
    
    func getWeekNumber(date:NSDate)->CGFloat{
        
        
        var time = Int(date.timeIntervalSinceDate(getFirstSundayDateOfMonth(date)) / (7*24*60*60))
        
        return CGFloat(time + 1)
        
    }
    
    func getFirstSundayDateOfMonth(date:NSDate)->NSDate{
        
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
    
    
    func testGetWeekNumber(){
        
        
        var date = getDate(2015, month: 7, day: 22,hour: 3,minute: 55,second: 10)
        XCTAssertEqual(getWeekNumber(date),4.0,"4주차")
        date = getDate(2015, month: 7, day: 23,hour: 3,minute: 55,second: 10)
        XCTAssertEqual(getWeekNumber(date),4.0,"4주차")
        date = getDate(2015, month: 7, day: 24,hour: 3,minute: 55,second: 10)
        XCTAssertEqual(getWeekNumber(date),4.0,"4주차")
        date = getDate(2015, month: 7, day: 25,hour: 3,minute: 55,second: 10)
        XCTAssertEqual(getWeekNumber(date),4.0,"4주차")
        date = getDate(2015, month: 7, day: 26,hour: 8,minute: 55,second: 10)
        XCTAssertEqual(getWeekNumber(date),5.0,"5주차")
        date = getDate(2015, month: 7, day: 27,hour: 3,minute: 55,second: 10)
        XCTAssertEqual(getWeekNumber(date),5.0,"5주차")
        date = getDate(2015, month: 7, day: 28,hour: 3,minute: 55,second: 10)
        XCTAssertEqual(getWeekNumber(date),5.0,"5주차")
        date = getDate(2015, month: 7, day: 29,hour: 3,minute: 55,second: 10)
        XCTAssertEqual(getWeekNumber(date),5.0,"5주차")
        date = getDate(2015, month: 7, day: 30,hour: 3,minute: 55,second: 10)
        XCTAssertEqual(getWeekNumber(date),5.0,"5주차")
        date = getDate(2015, month: 7, day: 31,hour: 3,minute: 55,second: 10)
        XCTAssertEqual(getWeekNumber(date),5.0,"5주차")
        date = getDate(2015, month: 8, day: 1,hour: 3,minute: 55,second: 10)
        XCTAssertEqual(getWeekNumber(date),1.0,"5주차")
        date = getDate(2015, month: 8, day: 2,hour: 3,minute: 55,second: 10)
        XCTAssertEqual(getWeekNumber(date),2.0,"2주차")
        date = getDate(2015, month: 8, day: 3,hour: 3,minute: 55,second: 10)
        XCTAssertEqual(getWeekNumber(date),2.0,"2주차")
        date = getDate(2015, month: 8, day: 4,hour: 3,minute: 55,second: 10)
        XCTAssertEqual(getWeekNumber(date),2.0,"2주차")
        date = getDate(2015, month: 8, day: 5,hour: 3,minute: 55,second: 10)
        XCTAssertEqual(getWeekNumber(date),2.0,"2주차")
        date = getDate(2015, month: 8, day: 6,hour: 3,minute: 55,second: 10)
        XCTAssertEqual(getWeekNumber(date),2.0,"2주차")
        date = getDate(2015, month: 8, day: 7,hour: 3,minute: 55,second: 10)
        XCTAssertEqual(getWeekNumber(date),2.0,"2주차")
        date = getDate(2015, month: 8, day: 8,hour: 3,minute: 55,second: 10)
        XCTAssertEqual(getWeekNumber(date),2.0,"2주차")
        date = getDate(2015, month: 8, day: 9,hour: 3,minute: 55,second: 10)
        XCTAssertEqual(getWeekNumber(date),3.0,"3주차")
        date = getDate(2015, month: 8, day: 10,hour: 3,minute: 55,second: 10)
        XCTAssertEqual(getWeekNumber(date),3.0,"3주차")
        date = getDate(2015, month: 8, day: 11,hour: 3,minute: 55,second: 10)
        XCTAssertEqual(getWeekNumber(date),3.0,"3주차")
        date = getDate(2015, month: 8, day: 12,hour: 3,minute: 55,second: 10)
        XCTAssertEqual(getWeekNumber(date),3.0,"3주차")
        date = getDate(2015, month: 8, day: 13,hour: 3,minute: 55,second: 10)
        XCTAssertEqual(getWeekNumber(date),3.0,"3주차")
        date = getDate(2015, month: 8, day: 14,hour: 3,minute: 55,second: 10)
        XCTAssertEqual(getWeekNumber(date),3.0,"3주차")
        date = getDate(2015, month: 8, day: 15,hour: 3,minute: 55,second: 10)
        XCTAssertEqual(getWeekNumber(date),3.0,"3주차")
        date = getDate(2015, month: 8, day: 16,hour: 3,minute: 55,second: 10)
        XCTAssertEqual(getWeekNumber(date),4.0,"4주차")
        date = getDate(2015, month: 8, day: 17,hour: 3,minute: 55,second: 10)
        XCTAssertEqual(getWeekNumber(date),4.0,"4주차")
        date = getDate(2015, month: 8, day: 18,hour: 3,minute: 55,second: 10)
        XCTAssertEqual(getWeekNumber(date),4.0,"4주차")
        date = getDate(2015, month: 8, day: 19,hour: 3,minute: 55,second: 10)
        XCTAssertEqual(getWeekNumber(date),4.0,"4주차")
        date = getDate(2015, month: 8, day: 20,hour: 3,minute: 55,second: 10)
        XCTAssertEqual(getWeekNumber(date),4.0,"4주차")
        date = getDate(2015, month: 8, day: 21,hour: 3,minute: 55,second: 10)
        XCTAssertEqual(getWeekNumber(date),4.0,"4주차")
        date = getDate(2015, month: 8, day: 22,hour: 3,minute: 55,second: 10)
        XCTAssertEqual(getWeekNumber(date),4.0,"4주차")
        date = getDate(2015, month: 8, day: 23,hour: 3,minute: 55,second: 10)
        XCTAssertEqual(getWeekNumber(date),5.0,"5주차")
        
        
        date = getDate(2015, month: 8, day: 24,hour: 3,minute: 55,second: 10)
        XCTAssertEqual(getWeekNumber(date),5.0,"5주차")
        date = getDate(2015, month: 8, day: 25,hour: 3,minute: 55,second: 10)
        XCTAssertEqual(getWeekNumber(date),5.0,"5주차")
        date = getDate(2015, month: 8, day: 26,hour: 3,minute: 55,second: 10)
        XCTAssertEqual(getWeekNumber(date),5.0,"5주차")
        date = getDate(2015, month: 8, day: 27,hour: 3,minute: 55,second: 10)
        XCTAssertEqual(getWeekNumber(date),5.0,"5주차")
        date = getDate(2015, month: 8, day: 28,hour: 3,minute: 55,second: 10)
        XCTAssertEqual(getWeekNumber(date),5.0,"5주차")
        date = getDate(2015, month: 8, day: 29,hour: 3,minute: 55,second: 10)
        XCTAssertEqual(getWeekNumber(date),5.0,"5주차")
        date = getDate(2015, month: 8, day: 30,hour: 3,minute: 55,second: 10)
        XCTAssertEqual(getWeekNumber(date),6.0,"6주차")
        date = getDate(2015, month: 8, day: 31,hour: 3,minute: 55,second: 10)
        XCTAssertEqual(getWeekNumber(date),6.0,"6주차")
        date = getDate(2015, month: 9, day: 1,hour: 3,minute: 55,second: 10)
        XCTAssertEqual(getWeekNumber(date),1.0,"1주차")
        date = getDate(2015, month: 9, day: 2,hour: 3,minute: 55,second: 10)
        XCTAssertEqual(getWeekNumber(date),1.0,"1주차")
        date = getDate(2015, month: 9, day: 33,hour: 3,minute: 55,second: 10)
        XCTAssertEqual(getWeekNumber(date),1.0,"1주차")
    }
    
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}