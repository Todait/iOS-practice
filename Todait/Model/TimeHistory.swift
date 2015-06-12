//
//  TimeHistory.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 9..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class TimeHistory: NSManagedObject {

    @NSManaged var archived: NSNumber
    @NSManaged var created_at: NSDate
    @NSManaged var dirty_flag: NSNumber
    @NSManaged var done_millis: NSNumber
    @NSManaged var ended_at: NSDate
    @NSManaged var server_day_id: NSNumber
    @NSManaged var server_id: NSNumber
    @NSManaged var started_at: NSDate
    @NSManaged var updated_at: NSDate
    @NSManaged var day_id: Day

    
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    let defaults:NSUserDefaults! = NSUserDefaults.standardUserDefaults()
    
    func getColor()->UIColor{
        return day_id.getColor()
    }
    
    func getHistoryTime()->NSTimeInterval{
        return ended_at.timeIntervalSinceDate(started_at)
    }
    
    
}
