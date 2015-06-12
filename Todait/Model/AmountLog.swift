//
//  AmountLog.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 9..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import Foundation
import CoreData



class AmountLog: NSManagedObject {

    @NSManaged var after_done_amount: NSNumber
    @NSManaged var archived: NSNumber
    @NSManaged var before_done_amount: NSNumber
    @NSManaged var created_at: NSDate
    @NSManaged var dirty_flag: NSNumber
    @NSManaged var server_day_id: NSNumber
    @NSManaged var server_id: NSNumber
    @NSManaged var timestamp: NSNumber
    @NSManaged var updated_at: NSDate
    @NSManaged var day_id: Day

}
