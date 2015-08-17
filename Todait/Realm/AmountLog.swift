//
//  AmountLogR.swift
//  Todait
//
//  Created by CruzDiary on 2015. 8. 12..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import RealmSwift

class AmountLog: RealmObject {
    
    dynamic var timestamp = 0
    dynamic var archived = false
    dynamic var beforeAmount = 0
    dynamic var afterAmount = 0
    dynamic var day:Day?
    
    override func getParentsModel()->RealmObject.Type{
        return Day.self
    }
    
    
    func setupJSON(json:JSON){
        
        if let serverId = json["id"].int{
            self.serverId = serverId
        }else{
            serverId = -1
        }
        
        timestamp = json["timestamp"].intValue
        archived = json["archived"].boolValue
        beforeAmount = json["before_amount"].intValue
        afterAmount = json["after_amount"].intValue
        
    }
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
