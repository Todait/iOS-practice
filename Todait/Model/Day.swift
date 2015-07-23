//
//  Day.swift
//  Todait
//
//  Created by CruzDiary on 2015. 7. 23..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import Foundation
import CoreData

class Day: NSManagedObject {

    @NSManaged var date: NSNumber
    @NSManaged var dayOfWeek: NSNumber
    @NSManaged var doneAmount: NSNumber
    @NSManaged var doneSecond: NSNumber
    @NSManaged var expectAmount: NSNumber
    @NSManaged var score: NSNumber
    @NSManaged var localId: NSNumber
    @NSManaged var off: NSNumber
    @NSManaged var done: NSNumber
    @NSManaged var amountLogList: NSOrderedSet
    @NSManaged var diaryList: NSOrderedSet
    @NSManaged var taskDateId: TaskDate
    @NSManaged var timeHistoryList: NSOrderedSet
    @NSManaged var timeLogList: NSOrderedSet
    @NSManaged var checkLogList: NSSet
    @NSManaged var amountRangeList: NSSet
    @NSManaged var reviewDayList: ReviewDay

}
