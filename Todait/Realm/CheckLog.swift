//
//  CheckLogR.swift
//  Todait
//
//  Created by CruzDiary on 2015. 8. 12..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import RealmSwift

class CheckLog: RealmObject {
    
    
    
    dynamic var beforeChecked = 0
    dynamic var afterChecked = 0
    dynamic var timestamp = 0
    dynamic var day:Day?
    dynamic var archived = false
    
    
    func setupJSON(json:JSON){
        
        if let serverId = json["id"].int{
            self.serverId = serverId
        }else{
            serverId = -1
        }
        
        
        beforeChecked = json["befre_checked"].intValue
        afterChecked = json["after_checked"].intValue
        timestamp = json["timestamp"].intValue
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
