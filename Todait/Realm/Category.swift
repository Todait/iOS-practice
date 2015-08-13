//
//  CategoryR.swift
//  Todait
//
//  Created by CruzDiary on 2015. 8. 12..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import RealmSwift

class CategoryR: Object {
    
    dynamic var id = ""
    dynamic var serverId = -1
    dynamic var name = ""
    dynamic var color = ""
    dynamic var archived = false
    dynamic var priority = 0
    dynamic var categoryType = "study"
    dynamic var dirty_flag = false

    let tasks = List<TaskR>()
    
    override static func primaryKey()->String? {
        return "id"
    }
    
    // Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
