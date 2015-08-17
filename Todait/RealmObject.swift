//
//  Generic.swift
//  Todait
//
//  Created by CruzDiary on 2015. 8. 17..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import RealmSwift

protocol RealmObjectDelegate: NSObjectProtocol {
    
    func getParentsIdKey()->String
    
}

class RealmObject : Object{
    
    dynamic var id = ""
    dynamic var serverId = 0
    dynamic var dirtyFlag = false
    
    override static func primaryKey()->String? {
        return "id"
    }
    
    func addRelation(child:RealmObject){
        
    }
    
    func getParentsModel()->RealmObject.Type{
    
        return RealmObject.self
    }
    
    func getParentsServerIdKey()->String{
        return ""
    }
    
}
