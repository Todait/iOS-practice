//
//  WeekR.swift
//  Todait
//
//  Created by CruzDiary on 2015. 8. 12..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import RealmSwift
import SwiftyJSON

class Week: RealmObject {
    
    dynamic var archived = false
    dynamic var sun = 0
    dynamic var mon = 0
    dynamic var tue = 0
    dynamic var wed = 0
    dynamic var thu = 0
    dynamic var fri = 0
    dynamic var sat = 0
    dynamic var userId = -1
    dynamic var taskDate:TaskDate?
    
    
    func setupJSON(json:JSON){
        
        
        sun = json["sun"].intValue
        mon = json["mon"].intValue
        tue = json["tue"].intValue
        wed = json["wed"].intValue
        thu = json["thu"].intValue
        fri = json["fri"].intValue
        sat = json["sat"].intValue
        archived = json["archived"].boolValue
        userId = json["user_id"].intValue
        serverId = json["id"].intValue
        
        
    }
    
    override func getParentsServerIdKey()->String{
        return "task_date_id"
    }
    
    
    override func getParentsModel()->RealmObject.Type{
        return TaskDate.self
    }
    
    func getExpectedAmount()->[Int]{
        
        var expectedAmount:[Int] = [sun,mon,tue,wed,thu,fri,sat]
        
        return expectedAmount
    }
    
    
    func getExpectedTime()->[Int]{
        
        var expectedTime:[Int] = [sun,mon,tue,wed,thu,fri,sat]
        
        return expectedTime
    }
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
