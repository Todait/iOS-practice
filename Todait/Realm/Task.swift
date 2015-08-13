//
//  TaskR.swift
//  Todait
//
//  Created by CruzDiary on 2015. 8. 12..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import RealmSwift

class TaskR: Object {
    
    dynamic var id = ""
    dynamic var serverId = -1
    dynamic var name = ""
    dynamic var unit = ""
    dynamic var startPoint = 0
    dynamic var amount = 0
    dynamic var notificationMode = false
    dynamic var notificationTime = ""
    dynamic var archived = false
    dynamic var priority = 0
    dynamic var repeatCount = 1
    dynamic var reviewType = ""
    dynamic var reviewCount = 0
    dynamic var completed = false
    dynamic var taskType = ""
    dynamic var dirtyFlag = false
    
    let taskDates = List<TaskDateR>()
    
    dynamic var categoryId:CategoryR?
    
    override static func primaryKey()->String? {
        return "id"
    }
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
