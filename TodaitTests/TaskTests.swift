//
//  TaskTests.swift
//  FocusTimer
//
//  Created by CruzDiary on 2015. 6. 14..
//  Copyright (c) 2015년 RealNumWorks. All rights reserved.
//

import UIKit
import XCTest
import CoreData



class TaskTests: XCTestCase {
    
    
    var finishHour:Int = 4
    var finishMinute:Int = 15
    
    var task:Task!
    var week:Week!
    
    override func setUp() {
        super.setUp()
    
        finishHour = 4
        finishMinute = 0
        
        /*
        task = Task()
        task.start_date =    getDateNumberFromDate(getDate(2015, month: 6, day: 20, hour: 6, minute: 0, second: 0))
        task.end_date =    getDateNumberFromDate(getDate(2015, month:7, day:1,hour:5,minute:0,second:0))
        task.amount = 50
        
        
        week = Week()
        week.mon_minute = 5
        week.tue_minute = 5
        week.wed_minute = 10
        week.thu_minute = 3
        week.fri_minute = 0
        week.sat_minute = 10
        week.sun_minute = 8
        week.task_id = task
        task.week = week
        
        
        let day1 = Day()
        day1.expect_amount = 5
        day1.done_amount = 3
        day1.date =    getDateNumberFromDate(getDate(2015, month: 6, day: 16, hour: 6, minute: 0, second: 0))
        day1.task_id = task
        day1.day_of_week = 1
        
        let day2 = Day()
        day2.expect_amount = 5
        day2.done_amount = 3
        day2.date =    getDateNumberFromDate(getDate(2015, month: 6, day: 17, hour: 6, minute: 0, second: 0))
        day2.task_id = task
        day2.day_of_week = 1
        
        let day3 = Day()
        day3.expect_amount = 5
        day3.done_amount = 3
        day3.date =    getDateNumberFromDate(getDate(2015, month: 6, day: 18, hour: 6, minute: 0, second: 0))
        day3.task_id = task
        day3.day_of_week = 1
        
        task.dayList = [day1,day2,day3]
        
        
        
        
        */
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
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
    
    
    //
    
    
    
    func testGetDateNumberFromDate(){
        
        
        finishHour = 23
        finishMinute = 15
        XCTAssertEqual(getDateNumberFromDate(getDate(2015, month: 2, day: 28, hour: 23, minute: 10, second: 0)),20150228, "마지막시간 전")
        XCTAssertEqual(getDateNumberFromDate(getDate(2015, month: 2, day: 28, hour: 23, minute: 55, second: 0)),20150301, "마지막시간 전")
        XCTAssertEqual(getDateNumberFromDate(getDate(2015, month: 3, day: 1, hour: 23, minute: 10, second: 0)),20150301, "마지막시간 전")
        XCTAssertEqual(getDateNumberFromDate(getDate(2015, month: 3, day: 1, hour: 23, minute: 14, second: 0)),20150301, "마지막시간 전")
        XCTAssertEqual(getDateNumberFromDate(getDate(2015, month: 3, day: 1, hour: 23, minute: 15, second: 0)),20150302, "마지막시간 같음")
        XCTAssertEqual(getDateNumberFromDate(getDate(2015, month: 3, day: 1, hour: 23, minute: 16, second: 0)),20150302, "마지막시간 후")
        
        finishHour = 4
        finishMinute = 0
        
        XCTAssertEqual(getDateNumberFromDate(getDate(2015, month: 2, day: 28, hour: 3, minute: 55, second: 0)),20150227, "마지막시간 전")
        XCTAssertEqual(getDateNumberFromDate(getDate(2015, month: 2, day: 28, hour: 4, minute: 55, second: 0)),20150228, "마지막시간 전")
        XCTAssertEqual(getDateNumberFromDate(getDate(2015, month: 6, day: 14, hour: 3, minute: 55, second: 0)),20150613, "마지막시간 전")
        XCTAssertEqual(getDateNumberFromDate(getDate(2015, month: 6, day: 14, hour: 4, minute: 55, second: 0)),20150614, "마지막시간 후")
        
        
        XCTAssertEqual(getDateNumberFromDate(getDate(2015, month: 3, day: 1, hour: 3, minute: 55, second: 0)),20150228, "마지막시간 후")
        XCTAssertEqual(getDateNumberFromDate(getDate(2014, month: 3, day: 1, hour: 3, minute: 55, second: 0)),20140228, "마지막시간 후")
        XCTAssertEqual(getDateNumberFromDate(getDate(2013, month: 3, day: 1, hour: 3, minute: 55, second: 0)),20130228, "마지막시간 후")
        XCTAssertEqual(getDateNumberFromDate(getDate(2012, month: 3, day: 1, hour: 3, minute: 55, second: 0)),20120229, "2012년 윤년")
        XCTAssertEqual(getDateNumberFromDate(getDate(2011, month: 3, day: 1, hour: 3, minute: 55, second: 0)),20110228, "마지막시간 후")
        
        finishHour = 6
        finishMinute = 0

        
        XCTAssertEqual(   getDateNumberFromDate(getDate(2015, month: 6, day: 14, hour: 6, minute: 55, second: 0)),20150614, "마지막시간 전")
        XCTAssertEqual(   getDateNumberFromDate(getDate(2015, month: 6, day: 14, hour: 6, minute: 55, second: 0)),20150614, "마지막시간 후")
    }
    
    
    
    
    func testEdit() {
        
        
        
        finishHour = 4
        finishMinute = 0
        
        /*
        task.start_date = getDateNumberFromDate(getDate(2015, month: 6, day: 14, hour: 6, minute: 0, second: 0))
        task.end_date =  getDateNumberFromDate(getDate(2015, month: 6, day: 16, hour: 6, minute: 0, second: 0))
        task.updateDay()
        
        
        let sortDescriptor:NSSortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        
        var before = task.dayList
        
        //var dayList = (before as NSArray).sortedArrayUsingDescriptors([sortDescriptor])
       
        
        var taskCount = task.dayList.count
        */
        /*
        XCTAssertEqual(taskCount,5,"시작시간을 앞당긴만큼 Day 추가 카운트체크")
        
        XCTAssertEqual(dayList[0].date,20150614,"day1은 14일")
        XCTAssertEqual(dayList[1].date,20150615,"day2는 15일")
        XCTAssertEqual(dayList[2].date,20150616,"day3은 16일")
        XCTAssertEqual(dayList[3].date,20150617,"day4은 17일")
        XCTAssertEqual(dayList[4].date,20150618,"day5은 18일")
        */
        
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
