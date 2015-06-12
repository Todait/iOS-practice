//
//  TaskLogic.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 9..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class TaskLogic {
    
    var task:Task!
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    func getDayOn(date:NSDate)->Day{
        
        let startDate = task.start_date
        let endDate = task.end_date
        var day:Day!
        
        for day in task.dayList {
            
        }
        
        
        return day
    }
    
}