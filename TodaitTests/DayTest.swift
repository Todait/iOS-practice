//
//  DayTests.swift
//  FocusTimer
//
//  Created by CruzDiary on 2015. 6. 14..
//  Copyright (c) 2015년 RealNumWorks. All rights reserved.
//

import UIKit
import XCTest


public extension NSDate {
    
    func getDayString()->String{
        let dateForm = NSDateFormatter()
        dateForm.dateFormat = "MMM dd, EEE"
        return dateForm.stringFromDate(self)
    }
    
    func getHourString()->String{
        let hourForm = NSDateFormatter()
        hourForm.dateFormat = "a h:mm"
        return hourForm.stringFromDate(self)
    }
    
    func addDay(day:Int)->NSDate{
        
        return self.dateByAddingTimeInterval(24*60*60*NSTimeInterval(day))
        
    }
}


public extension String {
    
    static func colorString(index:Int)->String{
        
        switch index{
        case 0: return "#80ED63"
        case 1: return "#FCDB73"
        case 2: return "#FF854A"
        case 3: return "#FF5C61"
        case 4: return "#8554F5"
        case 5: return "#3D6BF0"
        case 6: return "#265494"
        default : return "#80ED63"
            
        }
    }
    
    
    func getYearMonthStringFromDate(date:NSDate)->String{
        
        var realDate:NSDate! = date
        
        if checkDayLastTime(date) {
            realDate = date.dateByAddingTimeInterval(24*60*60)
        }
        
        
        let dateForm = NSDateFormatter()
        
        if (getLanguage() == "ko") {
            // 2015년 3월 2주차 형태로 표기
            dateForm.dateFormat =  "YYYY년 MMMM ";
            
            return dateForm.stringFromDate(realDate)
        }else{
            // 1st Week, Jan, 2015의 형태로 표기
            dateForm.dateFormat = "MMM, yyyy"
            
            return dateForm.stringFromDate(realDate)
        }
    }
    
    
    
    
    
    func getDayNumberFromDate(date:NSDate)->NSNumber{
        
        let dateForm = NSDateFormatter()
        dateForm.dateFormat = "yyyyMMdd"
        let dateNumber = dateForm.stringFromDate(date).toInt()
        
        if checkDayLastTime(date) == true {
            
            return dateForm.stringFromDate(date.dateByAddingTimeInterval(24*60*60)).toInt()!
        }
        
        return dateNumber!
    }
    
    
    
    func checkDayLastTime(date:NSDate)->Bool{
        
        
        let comp = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitHour|NSCalendarUnit.CalendarUnitMinute, fromDate:date)
        
        
        var finishHour:Int = 4
        var finishMinute:Int = 0
        
        
        if comp.hour < 12 && finishHour < 12 {
            let nowTotalMinute = 60*comp.hour + comp.minute
            let finishTimeOfDayTotalMinute = 60*finishHour + finishMinute
            
            if nowTotalMinute > finishTimeOfDayTotalMinute {
                return true
            }
            
        }else if comp.hour > 12 && finishHour < 12 {
            return false
        }else if comp.hour < 12 && finishHour > 12 {
            return true
        }else if comp.hour > 12 && finishHour > 12 {
            let nowTotalMinute = 60*comp.hour + comp.minute
            let finishTimeOfDayTotalMinute = 60*finishHour + finishMinute
            
            
            if nowTotalMinute > finishTimeOfDayTotalMinute {
                return true
            }
        }
        
        
        return false
    }
    
    
    
    
    func getWeekStringFromTier(tier:Int)->String{
        
        
        let weekForm = NSDateFormatter()
        
        if (getLanguage() == "ko") {
            // 2015년 3월 2주차 형태로 표기
            weekForm.dateFormat = "W";
            
            return "\(tier)주차"
        }else{
            // 1st Week, Jan, 2015의 형태로 표기
            let dateStrings = ["st Week","nd Week","rd Week","th Week","th Week","th Week"];
            
            weekForm.dateFormat = "W"
            
            return "\(tier)" + dateStrings[tier]
        }
        
        
        
    }
    
    func getLanguage()->String{
        return NSLocale.preferredLanguages()[0] as! String
    }
}




class Time {
    
    
    var date:NSNumber!
    var createAt:NSDate!
    
    
    func getWeekString()->String{
        
        
        
        var adjustDate = getDateFromDateNumber(date)
        
        var firstDate = getFirstDateOfMonth(adjustDate)
        var lastDate = getLastDateOfMonth(adjustDate)
        
        
        if (createAt.timeIntervalSinceDate(lastDate) > 0){
            firstDate = getFirstDateOfMonth(createAt.addDay(7))
            lastDate = getLastDateOfMonth(createAt.addDay(7))
        }else if(firstDate.timeIntervalSinceDate(createAt)>0){
            firstDate = getFirstDateOfMonth(createAt.addDay(-7))
        }
        
        let tier = Int(createAt.timeIntervalSinceDate(firstDate) / (7*24*60*60)) + 1
        
        
        
        return String().getYearMonthStringFromDate(getCenterDate(firstDate, endDate: lastDate)) + String().getWeekStringFromTier(tier)
        
    }
    
    func getDateFromDateNumber(dateNumber:NSNumber)->NSDate{
        
        let dateForm = NSDateFormatter()
        dateForm.dateFormat = "yyyyMMdd"
        let mainDate = dateForm.dateFromString("\(dateNumber)")
        
        let adjustComp = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitYear|NSCalendarUnit.CalendarUnitMonth|NSCalendarUnit.CalendarUnitDay|NSCalendarUnit.CalendarUnitMinute|NSCalendarUnit.CalendarUnitHour, fromDate: mainDate!)
        adjustComp.hour = 5
        adjustComp.minute = 0
        
        return NSCalendar.currentCalendar().dateFromComponents(adjustComp)!
        
    }
    
    
    func getCenterDate(startDate:NSDate,endDate:NSDate)->NSDate{
        
        
        return startDate.dateByAddingTimeInterval(endDate.timeIntervalSinceDate(startDate)/2)
        
    }
    
    
    
    
    
    func getFirstDateOfMonth(date:NSDate)->NSDate{
        
        let firstDayOfMonthComp = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitYear|NSCalendarUnit.CalendarUnitMonth|NSCalendarUnit.CalendarUnitDay|NSCalendarUnit.CalendarUnitWeekday|NSCalendarUnit.CalendarUnitHour, fromDate:date)
        firstDayOfMonthComp.day = 1
        firstDayOfMonthComp.hour = 5
        
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
    
    
    
    func getLastDateOfMonth(date:NSDate)->NSDate{
        
        let lastDayOfMonthComp = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitYear|NSCalendarUnit.CalendarUnitMonth|NSCalendarUnit.CalendarUnitDay|NSCalendarUnit.CalendarUnitHour, fromDate:date)
        lastDayOfMonthComp.month = lastDayOfMonthComp.month+1
        lastDayOfMonthComp.day = 0
        lastDayOfMonthComp.hour = 23
        var lastDate:NSDate = NSCalendar.currentCalendar().dateFromComponents(lastDayOfMonthComp)!
        
        
        let weekDayComp = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitWeekday, fromDate: lastDate)
        let lastOfWeek = weekDayComp.weekday
        
        if (lastOfWeek < 4 && lastOfWeek > 0) {
            lastDate = lastDate.addDay(-lastOfWeek)
        }else{
            lastDate = lastDate.addDay(7-lastOfWeek)
        }
        
        return lastDate
    }
    
    
}






class DayTests: XCTestCase {
    
    
    var finishHour:Int! = 4
    var finishMinute:Int! = 0
    
    var time:Time!
    
    
    override func setUp() {
        super.setUp()
        
        time = Time()
        
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
    
    
    func testGetTodayDateNumber(){
    
        finishHour = 11
        finishMinute = 30
        XCTAssertEqual(getTodayDateNumber(),20150622,"오늘(20150622 9:28 DateNumber")
        
        
        finishHour = 13
        finishMinute = 30
        XCTAssertEqual(getTodayDateNumber(),20150623,"오늘(20150622 9:28 DateNumber")
        
        finishHour = 16
        finishMinute = 27
        XCTAssertEqual(getTodayDateNumber(),20150623,"오늘(20150622 9:28 DateNumber")
        
        
        finishHour = 22
        finishMinute = 27
        XCTAssertEqual(getTodayDateNumber(),20150622,"오늘(20150622 9:28 DateNumber")
        
        
        finishHour = 21
        finishMinute = 29
        XCTAssertEqual(getTodayDateNumber(),20150622,"오늘(20150622 9:28 DateNumber")
        
        
    }
    
    
    
    func testThemeWeekString(){
        
        finishHour = 4
        finishMinute = 0
        
        time.createAt = getDate(2015, month: 5, day: 2, hour: 18, minute: 5, second: 10)
        time.date = getDateNumberFromDate(time.createAt)
        
        //XCTAssertEqual(time.getWeekString(),"2015년 4월 5주차", "주 체크")
        
        time.createAt = getDate(2015, month: 3, day: 31, hour: 18, minute: 6, second: 10)
        time.date = getDateNumberFromDate(time.createAt)
        
        XCTAssertEqual(time.getWeekString(),"2015년 4월 1주차", "주 체크")
        
        time.createAt = getDate(2015, month: 3, day: 30, hour: 18, minute: 6, second: 10)
        time.date = getDateNumberFromDate(time.createAt)
        
        XCTAssertEqual(time.getWeekString(),"2015년 4월 1주차", "주 체크")
        
        time.createAt = getDate(2015, month: 3, day: 29, hour: 18, minute: 6, second: 10)
        time.date = getDateNumberFromDate(time.createAt)
        
        XCTAssertEqual(time.getWeekString(),"2015년 4월 1주차", "주 체크")
        
        time.createAt = getDate(2015, month: 3, day: 28, hour: 18, minute: 6, second: 10)
        time.date = getDateNumberFromDate(time.createAt)
        
        XCTAssertEqual(time.getWeekString(),"2015년 3월 4주차", "주 체크")
    }
    
    
    func getDayOfWeekFromDateNumber(dateNumber:NSNumber)->Int{
        
        let date = getDateFromDateNumber(dateNumber)
        let dayOfWeek = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitWeekday, fromDate:date)
        
        
        return dayOfWeek.weekday - 1
    }
    
    func getDateFromDateNumber(dateNumber:NSNumber)->NSDate{
        let dateForm = NSDateFormatter()
        dateForm.dateFormat = "yyyyMMdd"
        let date:NSDate = dateForm.dateFromString("\(dateNumber)")!
        return date
    }
    
    
    func getTodayDateNumber()->NSNumber{
        
        return getDateNumberFromDate(NSDate())

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
    
    
    func testWeekOfDay(){
        
        
        XCTAssertEqual(getDayOfWeekFromDateNumber(20150621),0,"위크체크")
        XCTAssertEqual(getDayOfWeekFromDateNumber(20150622),1,"위크체크")
        XCTAssertEqual(getDayOfWeekFromDateNumber(20150623),2,"위크체크")
        XCTAssertEqual(getDayOfWeekFromDateNumber(20150624),3,"위크체크")
        XCTAssertEqual(getDayOfWeekFromDateNumber(20150625),4,"위크체크")
        XCTAssertEqual(getDayOfWeekFromDateNumber(20150626),5,"위크체크")
        XCTAssertEqual(getDayOfWeekFromDateNumber(20150627),6,"위크체크")
        XCTAssertEqual(getDayOfWeekFromDateNumber(20150628),0,"위크체크")
        XCTAssertEqual(getDayOfWeekFromDateNumber(20150629),1,"위크체크")
        
        XCTAssertEqual(getDayOfWeekFromDateNumber(20150630),2,"위크체크")
        XCTAssertEqual(getDayOfWeekFromDateNumber(20150701),3,"위크체크")
        XCTAssertEqual(getDayOfWeekFromDateNumber(20150702),4,"위크체크")
        XCTAssertEqual(getDayOfWeekFromDateNumber(20150703),5,"위크체크")
        XCTAssertEqual(getDayOfWeekFromDateNumber(20150704),6,"위크체크")
        XCTAssertEqual(getDayOfWeekFromDateNumber(20150705),0,"위크체크")
        
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
