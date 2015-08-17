//
//  ReviewDay.swift
//  Todait
//
//  Created by CruzDiary on 2015. 7. 23..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import Foundation
import CoreData

class ReviewDay: NSManagedObject {

    @NSManaged var date: NSNumber
    @NSManaged var done: NSNumber
    @NSManaged var localId: String
    @NSManaged var dayId: NSSet
    @NSManaged var timeLogList: TimeLog
    @NSManaged var checkLogList: CheckLog

}
