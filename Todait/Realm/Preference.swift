//
//  PreferenceR.swift
//  Todait
//
//  Created by CruzDiary on 2015. 8. 12..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import RealmSwift

class Preference: RealmObject {
    
    dynamic var stopwatchScreenDim = false
    dynamic var comboCount = 0
    dynamic var maxComboCount = 0
    dynamic var notificationMode = false
    dynamic var notificationTime = ""
    dynamic var finishTime = ""
    dynamic var customStopwatchBackground = false
    dynamic var stopwatchBackgroundImageName = ""
    dynamic var userId:User?
    
    
    func setupJSON(json:JSON){
        
        stopwatchScreenDim = json["stopwatch_screen_dim"].boolValue
        comboCount = json["combo_count"].intValue
        maxComboCount = json["max_combo_count"].intValue
        notificationMode = json["notificaiton_mode"].boolValue
        notificationTime = json["notification_time"].stringValue
        finishTime = json["finish_time"].stringValue
        customStopwatchBackground = json["custom_stopwatch_background"].boolValue
        stopwatchBackgroundImageName = json["stopwatch_background_imagename"].stringValue
        serverId = json["id"].intValue
        
    }
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
