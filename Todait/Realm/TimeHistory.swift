//
//  TimeHistoryR.swift
//  Todait
//
//  Created by CruzDiary on 2015. 8. 12..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import RealmSwift

class TimeHistory: RealmObject {
    
    dynamic var startedAt = 0
    dynamic var endedAt = 0
    dynamic var doneMillis = 0
    dynamic var archived = false
    dynamic var day:Day?
    
    
    func getColor()->UIColor?{
        
        if let day = day {
            return day.getColor()
        }
        
        return UIColor.clearColor()
    }
    
    
    func setupJSON(json:JSON){
        
        if let serverId = json["id"].int{
            self.serverId = serverId
        }else{
            serverId = -1
        }
        
        startedAt = json["started_at"].intValue
        archived = json["archived"].boolValue
        endedAt = json["ended_at"].intValue
        doneMillis = json["done_millis"].intValue
        
    }
    
    
    func getHistoryTime()->NSTimeInterval{
        return NSTimeInterval(endedAt - startedAt)
    }
    
    override func getParentsModel()->RealmObject.Type{
        return Day.self
    }
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
