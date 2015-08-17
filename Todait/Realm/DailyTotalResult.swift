//
//  DailyTotalResultR.swift
//  Todait
//
//  Created by CruzDiary on 2015. 8. 12..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import RealmSwift

class DailyTotalResult: RealmObject {
    
    dynamic var achievementRate = 0
    dynamic var doneSecond = 0
    dynamic var date = 0
    dynamic var archived = false
    dynamic var userId:User?
    
    func setupJSON(json:JSON){
        
        serverId = json["id"].intValue
        doneSecond = json["done_second"].intValue
        date = json["date"].intValue
        archived = json["archived"].boolValue
        achievementRate = json["achievment_rate"].intValue
        
    }
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
