//
//  DayR.swift
//  Todait
//
//  Created by CruzDiary on 2015. 8. 12..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import RealmSwift
import SwiftyJSON

class Day: RealmObject {
    
    dynamic var expectAmount = 0
    dynamic var doneAmount = 0
    dynamic var date = 0
    dynamic var doneSecond = 0
    dynamic var archived = false
    dynamic var off = false
    dynamic var done = false
    dynamic var score = 0.0
    dynamic var userId = 0
    
    dynamic var taskDate:TaskDate?
    
    let diarys = List<Diary>()
    let amountRanges = List<AmountRange>()
    let timeHistorys = List<TimeHistory>()
    let amountLogs = List<AmountLog>()
    let timeLogs = List<TimeLog>()
    let checkLogs = List<CheckLog>()
    let reviewDays = List<ReviewDay>()
    
    
    
    override func addRelation(child:RealmObject){
        
        
        switch child.className {
            
        case "Diary":
            (child as! Diary).day = self
            diarys.append(child as! Diary)
        case "AmountRange":
            (child as! AmountRange).day = self
            amountRanges.append(child as! AmountRange)
        case "TimeHistory":
            (child as! TimeHistory).day = self
            timeHistorys.append(child as! TimeHistory)
        case "AmountLog":
            (child as! AmountLog).day = self
            amountLogs.append(child as! AmountLog)
        case "TimeLog":
            (child as! TimeLog).day = self
            timeLogs.append(child as! TimeLog)
        case "CheckLog":
            (child as! CheckLog).day = self
            checkLogs.append(child as! CheckLog)
        case "ReviewDay":
            (child as! ReviewDay).day = self
            reviewDays.append(child as! ReviewDay)
        default: return
        }
        
        
    }

    
    
    func setupJSON(json:JSON){
        
        if let serverId = json["id"].int{
            self.serverId = serverId
        }else{
            serverId = -1 
        }
        
        
        
        expectAmount = json["expect_amount"].intValue
        doneAmount = json["done_amount"].intValue
        doneSecond = json["done_second"].intValue
        done = json["done"].boolValue
        date = json["date"].intValue
        off = json["off"].boolValue
        archived = json["archived"].boolValue
        userId = json["user_id"].intValue
        score = json["score"].doubleValue
        
    }
    
    
    
    override func getParentsModel()->RealmObject.Type{
        return TaskDate.self
    }
    
    
    func dayOfWeek()->Int {
        
        let dayDate = getDateFromDateNumber(date)
        
        return getDayOfWeek(dayDate) - 1
        
    }
    
    func getDayOfWeek(date:NSDate)->Int{
        
        let dayOfWeek = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitWeekday, fromDate:date)
        
        return dayOfWeek.weekday
    }
    
    func getColor()->UIColor?{
        
        if let taskDate = taskDate {
            return taskDate.getColor()
        }
        
        return nil
    }
    
    
    func getProgressPercent()->CGFloat{
        return CGFloat(doneAmount)/CGFloat(expectAmount)
    }
    
    func getProgressString()->String{
        
        var unit = ""
        
        if let taskDate = taskDate {
            unit = taskDate.getUnit() as String
        }
        
        return "\(doneAmount) / \(expectAmount) \(unit)"
    }
    
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
