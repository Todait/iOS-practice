//
//  PreferenceR.swift
//  Todait
//
//  Created by CruzDiary on 2015. 8. 12..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import RealmSwift

class PreferenceR: Object {
    
    dynamic var id = ""
    dynamic var serverId = 0
    dynamic var stopwatchScreenDim = false
    dynamic var comboCount = 0
    dynamic var maxComboCount = 0
    dynamic var notificationMode = false
    dynamic var notificationTime = ""
    dynamic var finishTime = ""
    dynamic var customStopwatchBackground = false
    dynamic var stopwatchBackgroundImageName = ""
    dynamic var dirtyFlag = false
    dynamic var userId:UserR?
    
    override static func primaryKey()->String? {
        return "id"
    }
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
