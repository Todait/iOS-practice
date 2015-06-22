

import UIKit
import XCTest



class StatisticsTests: XCTestCase {
    
    
    
    func getDayString(numbers:[NSNumber])->[String]{
        
        var strings:[String] = []
        
        for number in numbers {
            
            
            let date = getDateFromDateNumber(number)
            let dateComp = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitDay, fromDate: date)
            
            strings.append("\(dateComp.day)")
            
        }
        
        return strings
    }
    
    
    
    override func setUp() {
        super.setUp()
        
        
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
    
    func getDateNumberFromDate(date:NSDate)->NSNumber{
        
        let dateForm = NSDateFormatter()
        dateForm.dateFormat = "yyyyMMdd"
        let dateNumber = dateForm.stringFromDate(date).toInt()
        
        let diff = checkDayLastTime(date)
        
        return dateForm.stringFromDate(date.addDay(diff)).toInt()!
        
    }
    
    
    
    func checkDayLastTime(date:NSDate)->Int{
        
        
        let comp = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitHour|NSCalendarUnit.CalendarUnitMinute, fromDate:date)
        
        
        var finishHour:Int = 4
        var finishMinute:Int = 0
        
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
    
    func testGetDayString(){
        
        XCTAssertEqual(getDayString([20150621,20150622,20150623,20150624]),["21","22","23","24"],"날짜체크")
        
        
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



