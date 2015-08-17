//
//  UserR.swift
//  Todait
//
//  Created by CruzDiary on 2015. 8. 12..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import RealmSwift

class UserR: Object {
    
    dynamic var id = ""
    dynamic var email = ""
    dynamic var name = ""
    dynamic var authenticationToken = ""
    dynamic var imageNames = ""
    
    let tasks = List<TaskR>()
    let categorys = List<CategoryR>()
    let dailyTotalResults = List<DailyTotalResultR>()
    let preferences = List<PreferenceR>()
    
    override static func primaryKey()->String? {
        return "id"
    }
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
