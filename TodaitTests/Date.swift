import Foundation

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
    
    func addMonth(month:Int)->NSDate{
        
        
        var dateComp = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitYear|NSCalendarUnit.CalendarUnitMonth|NSCalendarUnit.CalendarUnitDay|NSCalendarUnit.CalendarUnitWeekday|NSCalendarUnit.CalendarUnitHour, fromDate: self)
        
        dateComp.month = dateComp.month + month
        
        return NSCalendar.currentCalendar().dateFromComponents(dateComp)!
        
    }
}