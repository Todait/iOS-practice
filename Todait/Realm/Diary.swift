//
//  DiaryR.swift
//  Todait
//
//  Created by CruzDiary on 2015. 8. 12..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import RealmSwift

class Diary: RealmObject {
    
    dynamic var body = ""
    dynamic var timestamp = 0
    dynamic var archived = false
    dynamic var day:Day?
    
    let images = List<Image>()
    
    func setupJSON(json:JSON){
        
        if let serverId = json["id"].int{
            self.serverId = serverId
        }else{
            serverId = -1
        }
        
        
        
        body = json["body"].stringValue
        timestamp = json["timestamp"].intValue
        archived = json["archived"].boolValue

        
    }
    
    override func getParentsServerIdKey()->String{
        return "day_id"
    }
    
    override func getParentsModel()->RealmObject.Type{
        return Day.self
    }
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
