//
//  AmountLog.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 9..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import Foundation
import CoreData



class AmountLog:NSObject{
    
       var after_done_amount: NSNumber!
       var archived: NSNumber!
       var before_done_amount: NSNumber!
       var created_at: NSDate!
       var dirty_flag: NSNumber!
       var server_day_id: NSNumber!
       var server_id: NSNumber!
       var timestamp: NSNumber!
       var updated_at: NSDate!
       var day_id: Day!
    
    
    func getDoneAmount()->NSNumber{
        return after_done_amount.integerValue - before_done_amount.integerValue
    }
}
