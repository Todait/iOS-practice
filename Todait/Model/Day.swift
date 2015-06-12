//
//  Day.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 9..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Day: NSManagedObject {

    @NSManaged var archived_at: NSDate
    @NSManaged var created_at: NSDate
    @NSManaged var date: NSNumber
    @NSManaged var day_of_week: NSNumber
    @NSManaged var dirty_flag: NSNumber
    @NSManaged var done_amount: NSNumber
    @NSManaged var done_second: NSNumber
    @NSManaged var expect_amount: NSNumber
    @NSManaged var server_id: NSNumber
    @NSManaged var server_task_id: NSNumber
    @NSManaged var updated_at: NSDate
    @NSManaged var task_id: Task
    @NSManaged var diary: NSOrderedSet
    @NSManaged var timeHistory: NSOrderedSet
    @NSManaged var timeLog: NSOrderedSet
    @NSManaged var amountLog: NSOrderedSet
    
    func getColor()->UIColor{
        return task_id.getColor()
    }
    
    func getProgressPercent()->NSNumber{
        return done_amount.floatValue/expect_amount.floatValue
    }
    
    func getProgressString()->String{
        return "\(done_amount) / \(expect_amount) \(task_id.unit)"
    }
    
}
