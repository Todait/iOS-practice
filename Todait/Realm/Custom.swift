//
//  Custom.swift
//  Todait
//
//  Created by CruzDiary on 2015. 8. 17..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import RealmSwift

class Custom: RealmObject {
    
    dynamic var name = ""
    
    
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
