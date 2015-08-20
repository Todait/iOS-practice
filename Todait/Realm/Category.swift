//
//  CategoryR.swift
//  Todait
//
//  Created by CruzDiary on 2015. 8. 12..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import RealmSwift
import SwiftyJSON

class Category: RealmObject {
    
    dynamic var name = ""
    dynamic var color = "FFFFFFFF"
    dynamic var archived = false
    dynamic var priority = 0
    dynamic var categoryType = "study"
    dynamic var hidden = false

    let tasks = List<Task>()
    
    
    func setupJSON(json:JSON){
        
        serverId = json["id"].intValue
        name = json["name"].stringValue
        color = json["color"].string ?? "FFFFFFFF"
        archived = json["archived"].boolValue
        categoryType = json["category_type"].stringValue
        priority = json["priority"].intValue
        
    }
    
    override func addRelation(child:RealmObject){
        
        if child.className == "Task" {
            (child as! Task).category = self
            tasks.append(child as! Task)
        }
    }
    
    func getAveragePercent()-> Float{
        
        var percent:Float = 0
        var count:Float = 0
        
        for task in tasks {
            for taskDate in task.taskDates {
                count = count + 1
                percent = percent + taskDate.getPercentOfPeriodProgress()
            }
        }
        
        if count ==  0 {
            return 0
        }
        
        return percent / count
    }
    
    
    /*
    func synchronizeModel (jsons:JSON,realm:Realm){
        
        
        for var index = 0 ; index < jsons.count ; index++ {
            
            let json = jsons[index]
            
            if let serverId = json["id"].int {
                
                
                var results = realm.objects(self).filter("serverId == %lu", serverId)
                
                if results.count > 0 {
                    
                    update(results.first!,json:json,realm:realm)
                    
                    continue
                }
            }
            
            create(json,realm:realm)
        }
        
    }
    
    
    func create(json:JSON,realm:Realm){
        
        let model = self()
        model.id = NSUUID().UUIDString
        model.setupJSON(json)
        
        realm.write{
            
            if let serverId = json[model.getParentsServerIdKey()].int {
                
                let items = realm.objects(model.getParentsModel()).filter("serverId == %lu",serverId)
                
                if items.count > 0 {
                    let item = items.first!
                    item.addRelation(model)
                    realm.add(item,update:true)
                    
                }
            }
            realm.add(model)
        }
        
    }
    
    func update(model:RealmObject,json:JSON,realm:Realm){
        
        
        realm.write{
            
            if let serverId = json[model.getParentsServerIdKey()].int {
                
                let items = realm.objects(Category).filter("serverId == %lu",serverId)
                let item = items.first!
                
                item.addRelation(model)
                realm.add(item,update:true)
                
            }
            
            self.setupJSON(json)
            realm.add(model)
        }
        
    }
    */
    
    // Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
