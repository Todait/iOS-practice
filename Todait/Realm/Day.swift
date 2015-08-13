//
//  DayR.swift
//  Todait
//
//  Created by CruzDiary on 2015. 8. 12..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import RealmSwift

class DayR: Object {
    
    
    dynamic var id = ""
    dynamic var serverId = 0
    dynamic var expectAmount = 0
    dynamic var doneAmount = 0
    dynamic var date = 0
    dynamic var doneSecond = 0
    dynamic var archived = false
    dynamic var off = false
    dynamic var done = false
    dynamic var score = 0.0
    dynamic var dirtyFlag = false
    
    dynamic var taskDateId:TaskDateR?
    
    let diarys = List<DiaryR>()
    let amountRanges = List<AmountRangeR>()
    let timeHistorys = List<TimeHistoryR>()
    let amountLogs = List<AmountLogR>()
    let timeLogs = List<TimeLogR>()
    let checkLogs = List<CheckLogR>()
    let reviewDays = List<ReviewDay>()
    
    override static func primaryKey()->String? {
        return "id"
    }
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
