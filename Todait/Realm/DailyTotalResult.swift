//
//  DailyTotalResultR.swift
//  Todait
//
//  Created by CruzDiary on 2015. 8. 12..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import RealmSwift

class DailyTotalResultR: Object {
    
    dynamic var id = ""
    dynamic var serverId = 0
    dynamic var achievementRate = 0
    dynamic var doneSecond = 0
    dynamic var date = 0
    dynamic var archived = false
    dynamic var dirtyFlag = false
    dynamic var userId:UserR?
    
    override static func primaryKey()->String? {
        return "id"
    }
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
