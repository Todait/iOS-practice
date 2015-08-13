//
//  WeekR.swift
//  Todait
//
//  Created by CruzDiary on 2015. 8. 12..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import RealmSwift

class WeekR: Object {
    
    dynamic var id = ""
    dynamic var serverId = ""
    dynamic var archived = false
    dynamic var sun = 0
    dynamic var mon = 0
    dynamic var tue = 0
    dynamic var wed = 0
    dynamic var thu = 0
    dynamic var fri = 0
    dynamic var sat = 0
    dynamic var dirtyFlag = false
    
    dynamic var taskDateId:TaskDateR?
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
