//
//  AmountRangeR.swift
//  Todait
//
//  Created by CruzDiary on 2015. 8. 12..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import RealmSwift

class AmountRange: RealmObject {
    
    dynamic var startPoint = 0
    dynamic var endPoint = 0
    dynamic var doneAmount = 0
    dynamic var archived = false
    dynamic var day:Day?
    
    func setupJSON(json:JSON){
        
        if let serverId = json["id"].int{
            self.serverId = serverId
        }else{
            serverId = -1
        }
        
        
        doneAmount = json["done_amount"].intValue
        startPoint = json["start_point"].intValue
        endPoint = json["end_point"].intValue
        archived = json["archived"].boolValue
        
    }
    
    
    override func getParentsModel()->RealmObject.Type{
        return Day.self
    }
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
