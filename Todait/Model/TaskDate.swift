//
//  TaskDate.swift
//  Todait
//
//  Created by CruzDiary on 2015. 7. 23..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import Foundation
import CoreData

class TaskDate: NSManagedObject {

    @NSManaged var localId: String
    @NSManaged var startDate: NSNumber
    @NSManaged var endDate: NSNumber
    @NSManaged var state: NSNumber
    @NSManaged var taskId: Task
    @NSManaged var dayList: NSSet
    @NSManaged var week: Week

    
    
    
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    let defaults:NSUserDefaults! = NSUserDefaults.standardUserDefaults()
    
    
    
    func getColor()->UIColor{
        return taskId.getColor()
    }
    
    
    
    
}
