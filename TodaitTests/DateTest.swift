//
//  TodaitTests.swift
//  TodaitTests
//
//  Created by CruzDiary on 2015. 6. 1..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit
import XCTest

class DateTest: XCTestCase {
    
    let defaults:NSUserDefaults! = NSUserDefaults.standardUserDefaults()
    
    var cruz:Int = 0
    
    override func setUp() {
        super.setUp()
        
        cruz = 0
        
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testAdd(){
        cruz = 1
        
        XCTAssertTrue(cruz == 1, "Cruz must 0")
        
    }
    
    
    func getTodayDateNumber()->NSNumber{
        let dateForm = NSDateFormatter()
        dateForm.dateFormat = "yyyyMMdd"
        let todayDateNumber = dateForm.stringFromDate(NSDate()).toInt()
        
        if checkTodayLastTime() == true {
            return todayDateNumber! + 1
        }
        
        
        return todayDateNumber!
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
