//
//  ReviewDayR.swift
//  Todait
//
//  Created by CruzDiary on 2015. 8. 12..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import RealmSwift

class ReviewDayR: Object {
    
    dynamic var id = ""
    dynamic var serverId = 0
    dynamic var date = 0
    dynamic var done = false
    dynamic var archived = false
    dynamic var dirtyFlag = false
    dynamic var dayId:DayR?
    
    override static func primaryKey()->String? {
        return "id"
    }
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
