//
//  Week.swift
//  Todait
//
//  Created by CruzDiary on 2015. 7. 23..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import Foundation
import CoreData

class Week: NSManagedObject {

    @NSManaged var fri: NSNumber
    @NSManaged var mon: NSNumber
    @NSManaged var sat: NSNumber
    @NSManaged var sun: NSNumber
    @NSManaged var thu: NSNumber
    @NSManaged var tue: NSNumber
    @NSManaged var wed: NSNumber
    @NSManaged var taskDateId: TaskDate

}
