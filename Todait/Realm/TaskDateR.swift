//
//  TaskDateR.swift
//  Todait
//
//  Created by CruzDiary on 2015. 8. 12..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import RealmSwift

class TaskDateR: Object {
    
    dynamic var id = ""
    dynamic var serverId = 0
    dynamic var startDate = 0
    dynamic var endDate = 0
    dynamic var state = 0
    dynamic var archived = false
    dynamic var dirtyFlag = false
    dynamic var taskId:TaskR?
    dynamic var week:WeekR?
    
    let days = List<DayR>()
    
    override static func primaryKey()->String? {
        return "id"
    }
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
