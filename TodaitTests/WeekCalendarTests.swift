//
//  WeekCalendarTests.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 29..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit
import XCTest

class WeekCalendarTests: XCTestCase {

    
    
    func getNumberOfWeekViewScrollCount(from:NSDate,to:NSDate)->NSNumber{
        
        var firstDateOfFrom = getFirstDateOfWeek(from)
        var firstDateOfTo = getFirstDateOfWeek(to)
        
        return Int(firstDateOfTo.timeIntervalSinceDate(firstDateOfFrom) / (7*24*60*60))
    }
    
    func getFirstDateOfWeek(date:NSDate)->NSDate{
        
        var adjustDate = getDateFromDateNumber(getDateNumberFromDate(date))
        
        let firstDayOfMonthComp = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitYear|NSCalendarUnit.CalendarUnitMonth|NSCalendarUnit.CalendarUnitDay|NSCalendarUnit.CalendarUnitWeekday|NSCalendarUnit.CalendarUnitHour|NSCalendarUnit.CalendarUnitWeekOfMonth, fromDate:date)
        
        var firstDate:NSDate = NSCalendar.currentCalendar().dateFromComponents(firstDayOfMonthComp)!
        
        
        let weekDayComp = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitWeekday, fromDate: firstDate)
        let firstOfWeek = weekDayComp.weekday
        
        
        firstDate = firstDate.addDay(1-firstOfWeek)
        
        return firstDate
    }
    
    
    func testWeekCalendarMove(){
        
        var fromDate = getDate(2015, 6, 28, 10, 0, 0)
        var toDate = getDate(2015, 5, 1, 10, 0, 0)
        XCTAssertEqual(getNumberOfWeekViewScrollCount(fromDate, to: toDate),-9,"Week 왼쪽 스와이프")

        fromDate = getDate(2015, 6, 30, 10, 0, 0)
        toDate = getDate(2015, 4, 26, 10, 10, 0)
        XCTAssertEqual(getNumberOfWeekViewScrollCount(fromDate, to: toDate),-9,"Week 오른쪽 스와이프")
        
        fromDate = getDate(2015, 6, 30, 10, 0, 0)
        toDate = getDate(2015, 4, 30, 10, 10, 0)
        XCTAssertEqual(getNumberOfWeekViewScrollCount(fromDate, to: toDate),-9,"Week 오른쪽 스와이프")
        
        
        fromDate = getDate(2015, 6, 30, 10, 0, 0)
        toDate = getDate(2015, 5, 7, 10, 10, 0)
        XCTAssertEqual(getNumberOfWeekViewScrollCount(fromDate, to: toDate),-8,"Week 오른쪽 스와이프")
        
        fromDate = getDate(2015, 6, 30, 10, 0, 0)
        toDate = getDate(2015, 5, 15, 10, 10, 0)
        XCTAssertEqual(getNumberOfWeekViewScrollCount(fromDate, to: toDate),-7,"Week 오른쪽 스와이프")
        
        fromDate = getDate(2015, 6, 30, 10, 0, 0)
        toDate = getDate(2015, 5, 23, 10, 10, 0)
        XCTAssertEqual(getNumberOfWeekViewScrollCount(fromDate, to: toDate),-6,"Week 오른쪽 스와이프")
        
        fromDate = getDate(2015, 6, 30, 10, 0, 0)
        toDate = getDate(2015, 5, 29, 10, 10, 0)
        XCTAssertEqual(getNumberOfWeekViewScrollCount(fromDate, to: toDate),-5,"Week 오른쪽 스와이프")
        
        fromDate = getDate(2015, 6, 30, 10, 0, 0)
        toDate = getDate(2015, 5, 31, 10, 10, 0)
        XCTAssertEqual(getNumberOfWeekViewScrollCount(fromDate, to: toDate),-4,"Week 오른쪽 스와이프")
        
        fromDate = getDate(2015, 6, 30, 10, 0, 0)
        toDate = getDate(2015, 6, 4, 10, 10, 0)
        XCTAssertEqual(getNumberOfWeekViewScrollCount(fromDate, to: toDate),-4,"Week 오른쪽 스와이프")
        
        
        fromDate = getDate(2015, 6, 30, 10, 0, 0)
        toDate = getDate(2015, 6, 11, 10, 10, 0)
        XCTAssertEqual(getNumberOfWeekViewScrollCount(fromDate, to: toDate),-3,"Week 오른쪽 스와이프")
        
        fromDate = getDate(2015, 6, 30, 10, 0, 0)
        toDate = getDate(2015, 6, 18, 10, 10, 0)
        XCTAssertEqual(getNumberOfWeekViewScrollCount(fromDate, to: toDate),-2,"Week 오른쪽 스와이프")
        
        fromDate = getDate(2015, 6, 30, 10, 0, 0)
        toDate = getDate(2015, 6, 25, 10, 10, 0)
        XCTAssertEqual(getNumberOfWeekViewScrollCount(fromDate, to: toDate),-1,"Week 오른쪽 스와이프")
        
        
        fromDate = getDate(2015, 6, 30, 10, 0, 0)
        toDate = getDate(2015, 6, 28, 10, 10, 0)
        XCTAssertEqual(getNumberOfWeekViewScrollCount(fromDate, to: toDate),0,"Week 오른쪽 스와이프")
        
        fromDate = getDate(2015, 6, 30, 10, 0, 0)
        toDate = getDate(2015, 7, 7, 10, 10, 0)
        XCTAssertEqual(getNumberOfWeekViewScrollCount(fromDate, to: toDate),1,"Week 오른쪽 스와이프")

        fromDate = getDate(2015, 6, 30, 10, 0, 0)
        toDate = getDate(2015, 7, 14, 10, 10, 0)
        XCTAssertEqual(getNumberOfWeekViewScrollCount(fromDate, to: toDate),2,"Week 오른쪽 스와이프")

        fromDate = getDate(2015, 6, 30, 10, 0, 0)
        toDate = getDate(2015, 7, 21, 10, 10, 0)
        XCTAssertEqual(getNumberOfWeekViewScrollCount(fromDate, to: toDate),3,"Week 오른쪽 스와이프")

        fromDate = getDate(2015, 6, 30, 10, 0, 0)
        toDate = getDate(2015, 7, 26, 10, 10, 0)
        XCTAssertEqual(getNumberOfWeekViewScrollCount(fromDate, to: toDate),4,"Week 오른쪽 스와이프")

        fromDate = getDate(2015, 6, 30, 10, 0, 0)
        toDate = getDate(2015, 8, 2, 10, 10, 0)
        XCTAssertEqual(getNumberOfWeekViewScrollCount(fromDate, to: toDate),5,"Week 오른쪽 스와이프")
        
        
    }
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
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
