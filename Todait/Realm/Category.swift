//
//  CategoryR.swift
//  Todait
//
//  Created by CruzDiary on 2015. 8. 12..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import RealmSwift
import SwiftyJSON

class Category: Object {
    
    dynamic var id = ""
    dynamic var serverId = -1
    dynamic var name = ""
    dynamic var color = ""
    dynamic var archived = false
    dynamic var priority = 0
    dynamic var categoryType = "study"
    dynamic var dirtyFlag = false
    dynamic var hidden = false

    let tasks = List<Task>()
    
    func setupJSON(json:JSON){
        
        serverId = json["id"].intValue
        name = json["name"].stringValue
        color = json["color"].stringValue
        archived = json["archived"].boolValue
        categoryType = json["category_type"].stringValue
        priority = json["priority"].intValue
        
    }
    
    override static func primaryKey()->String? {
        return "id"
    }
    
    
    func getAveragePercent()-> Float{
        
        var percent:Float = 0
        var count:Float = 0
        
        for task in tasks {
            for taskDate in task.taskDates {
                count = count + 1
                percent = percent + taskDate.getPercentOfPeriodProgress()
            }
        }
        
        if count ==  0 {
            return 0
        }
        
        return percent / count
    }
    
    // Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
