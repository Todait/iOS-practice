//
//  Image.swift
//  Todait
//
//  Created by CruzDiary on 2015. 8. 13..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import RealmSwift

class Image: Object {
    
    dynamic var id = ""
    dynamic var fileName = ""
    dynamic var archived = false
    dynamic var diary:Diary?
    
    override static func primaryKey()->String? {
        return "id"
    }
    
    // Specify properties to ignore (Realm won't persist these)
    
    //  override static func ignoredProperties() -> [String] {
    //    return []
    //  }
}
