//
//  UserR.swift
//  Todait
//
//  Created by CruzDiary on 2015. 8. 12..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import RealmSwift

class User: RealmObject {
    
    dynamic var email = ""
    dynamic var name = ""
    dynamic var authenticationToken = ""
    dynamic var imageNames = ""
    
    let tasks = List<Task>()
    let categorys = List<Category>()
    let dailyTotalResults = List<DailyTotalResult>()
    let preferences = List<Preference>()
    
    
    func setupJSON(json:JSON){
        
        if let serverId = json["id"].int{
            self.serverId = serverId
        }else{
            serverId = -1
        }
        
        email = json["email"].stringValue
        name = json["name"].stringValue
        authenticationToken = json["authentication_token"].stringValue
        
    
    }

   
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
