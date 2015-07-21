//
//  MonthCalendarTests.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 28..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit
import XCTest

class MonthCalendarTests: XCTestCase {

    
    func updateMonth(date:NSDate)->String{
        
        let dateForm = NSDateFormatter()
        dateForm.dateFormat = "yyyy.MM"
        return dateForm.stringFromDate(date)
    }
    
    func getCurrentDate(indexPath:NSIndexPath,date:NSDate)->NSDate{
        
        var adjustDate = getAdjustDate(date)
        
        return adjustDate.addMonth(Int(indexPath.section - 500))
    }
    
    func getAdjustDate(date:NSDate)->NSDate{
        
        return getDateFromDateNumber(getDateNumberFromDate(date))
    }
    
    
    func getFirstDateOfMonth(date:NSDate)->NSDate{
        
        let firstDayOfMonthComp = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitYear|NSCalendarUnit.CalendarUnitMonth|NSCalendarUnit.CalendarUnitDay|NSCalendarUnit.CalendarUnitWeekday|NSCalendarUnit.CalendarUnitHour, fromDate:date)
        firstDayOfMonthComp.day = 1
        firstDayOfMonthComp.hour = 5
        
        var firstDate:NSDate = NSCalendar.currentCalendar().dateFromComponents(firstDayOfMonthComp)!
        
        let weekDayComp = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitWeekday, fromDate: firstDate)
        let firstOfWeek = weekDayComp.weekday
        
        firstDate = firstDate.addDay(1-firstOfWeek)
        
        return firstDate
    }
    
    
    
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func getNumberOfMonthViewScrollCount(from:NSDate,to:NSDate)->NSNumber{
        var fromDateNumber = getDateNumberFromDate(from)
        var toDateNumber = getDateNumberFromDate(to)
        
        var dateForm = NSDateFormatter()
        dateForm.dateFormat = "M"
        
        var fromString = dateForm.stringFromDate(from)
        var toString = dateForm.stringFromDate(to)
        
        if fromString != toString {
            if toDateNumber.integerValue > fromDateNumber.integerValue {
                NSLog("return 1", 0)
                return 1
            } else if toDateNumber.integerValue < fromDateNumber.integerValue {
                NSLog("return -1", 0)
                return -1
            }
        }
        NSLog("return 0", 0)
        
        return 0
    }
    
    
    
    func testWeekCalendarMove(){
        
        var fromDate = getDate(2015, 6, 28, 10, 0, 0)
        var toDate = getDate(2015, 5, 1, 10, 0, 0)
        XCTAssertEqual(getNumberOfMonthViewScrollCount(fromDate, to: toDate),-1,"Month를 왼쪽 스와이프")
        
        fromDate = getDate(2015, 6, 30, 10, 0, 0)
        toDate = getDate(2015, 5, 7, 10, 10, 0)
        XCTAssertEqual(getNumberOfMonthViewScrollCount(fromDate, to: toDate),-1,"Month를 오른쪽 스와이프")
        
        fromDate = getDate(2015, 6, 30, 10, 0, 0)
        toDate = getDate(2015, 5, 15, 10, 10, 0)
        XCTAssertEqual(getNumberOfMonthViewScrollCount(fromDate, to: toDate),-1,"Month를 오른쪽 스와이프")
        
        fromDate = getDate(2015, 6, 30, 10, 0, 0)
        toDate = getDate(2015, 5, 23, 10, 10, 0)
        XCTAssertEqual(getNumberOfMonthViewScrollCount(fromDate, to: toDate),-1,"Month를 오른쪽 스와이프")
        
        fromDate = getDate(2015, 6, 30, 10, 0, 0)
        toDate = getDate(2015, 5, 29, 10, 10, 0)
        XCTAssertEqual(getNumberOfMonthViewScrollCount(fromDate, to: toDate),-1,"Month를 오른쪽 스와이프")
        
        fromDate = getDate(2015, 6, 30, 10, 0, 0)
        toDate = getDate(2015, 5, 31, 10, 10, 0)
        XCTAssertEqual(getNumberOfMonthViewScrollCount(fromDate, to: toDate),-1,"Month를 오른쪽 스와이프")
        
        fromDate = getDate(2015, 6, 30, 10, 0, 0)
        toDate = getDate(2015, 6, 4, 10, 10, 0)
        XCTAssertEqual(getNumberOfMonthViewScrollCount(fromDate, to: toDate),0,"Month를 오른쪽 스와이프")
        
        
        fromDate = getDate(2015, 6, 30, 10, 0, 0)
        toDate = getDate(2015, 6, 11, 10, 10, 0)
        XCTAssertEqual(getNumberOfMonthViewScrollCount(fromDate, to: toDate),0,"Month를 오른쪽 스와이프")
        
        fromDate = getDate(2015, 6, 30, 10, 0, 0)
        toDate = getDate(2015, 6, 18, 10, 10, 0)
        XCTAssertEqual(getNumberOfMonthViewScrollCount(fromDate, to: toDate),0,"Month를 오른쪽 스와이프")
        
        fromDate = getDate(2015, 6, 30, 10, 0, 0)
        toDate = getDate(2015, 6, 25, 10, 10, 0)
        XCTAssertEqual(getNumberOfMonthViewScrollCount(fromDate, to: toDate),0,"Month를 오른쪽 스와이프")
        
        
        fromDate = getDate(2015, 6, 30, 10, 0, 0)
        toDate = getDate(2015, 6, 28, 10, 10, 0)
        XCTAssertEqual(getNumberOfMonthViewScrollCount(fromDate, to: toDate),0,"Month를 오른쪽 스와이프")
        
        fromDate = getDate(2015, 6, 30, 10, 0, 0)
        toDate = getDate(2015, 7, 7, 10, 10, 0)
        XCTAssertEqual(getNumberOfMonthViewScrollCount(fromDate, to: toDate),1,"Month를 오른쪽 스와이프")
        
        fromDate = getDate(2015, 6, 30, 10, 0, 0)
        toDate = getDate(2015, 7, 14, 10, 10, 0)
        XCTAssertEqual(getNumberOfMonthViewScrollCount(fromDate, to: toDate),1,"Month를 오른쪽 스와이프")
        
        fromDate = getDate(2015, 6, 30, 10, 0, 0)
        toDate = getDate(2015, 7, 21, 10, 10, 0)
        XCTAssertEqual(getNumberOfMonthViewScrollCount(fromDate, to: toDate),1,"Month를 오른쪽 스와이프")
        
        fromDate = getDate(2015, 6, 30, 10, 0, 0)
        toDate = getDate(2015, 7, 26, 10, 10, 0)
        XCTAssertEqual(getNumberOfMonthViewScrollCount(fromDate, to: toDate),1,"Month를 오른쪽 스와이프")
        
        
    }
    
    func testGetFirstDateOfMonth(){
        
        XCTAssertEqual(getDateNumberFromDate(getFirstDateOfMonth(getDate(2015, 7, 1, 6, 10, 10))),20150628,"7월 첫째 주")
        
        
        
    }
    
    
    func testUpdateMonth(){
        
        var defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(4, forKey: "finishHourOfDay")
        defaults.setInteger(4, forKey: "finishMinuteOfDay")
        
        var testDate = getDate(2015, 6, 30, 2, 0, 0)
        XCTAssertEqual(updateMonth(getCurrentDate(NSIndexPath(forRow: 1, inSection: 500), date: testDate)),"2015.06","날짜 체크")
        
        testDate = getDate(2015, 6, 30, 23, 30, 0)
        XCTAssertEqual(updateMonth(getCurrentDate(NSIndexPath(forRow: 1, inSection: 500), date: testDate)),"2015.06","날짜 체크")
        
        testDate = getDate(2015, 5, 31, 23, 30, 0)
        XCTAssertEqual(updateMonth(getCurrentDate(NSIndexPath(forRow: 1, inSection: 500), date: testDate)),"2015.05","날짜 체크")
        
        testDate = getDate(2015, 5, 31, 5, 30, 0)
        XCTAssertEqual(updateMonth(getCurrentDate(NSIndexPath(forRow: 1, inSection: 500), date: testDate)),"2015.05","날짜 체크")
        
        testDate = getDate(2015, 6, 1, 3, 30, 0)
        XCTAssertEqual(updateMonth(getCurrentDate(NSIndexPath(forRow: 1, inSection: 500), date: testDate)),"2015.05","날짜 체크")
        
        
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
