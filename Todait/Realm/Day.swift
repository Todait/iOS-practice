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
        
        
        serverId = json["id"].int ?? -1
        expectAmount = json["expect_amount"].int ?? 0
        doneAmount = json["done_amount"].int ?? 0
        doneSecond = json["done_second"].int ?? 0
        done = json["done"].bool ?? false
        date = json["date"].int ?? 0
        off = json["off"].bool ?? false
        archived = json["archived"].bool ?? false
        userId = json["user_id"].int ?? -1
        score = json["score"].double ?? 0.0
        
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
