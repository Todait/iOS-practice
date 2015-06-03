//
//  Category.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 3..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import Foundation
import CoreData

class Category: NSManagedObject {

    @NSManaged var archived_at: NSDate
    @NSManaged var color: NSNumber
    @NSManaged var created_at: NSDate
    @NSManaged var dirty_flag: NSNumber
    @NSManaged var name: String
    @NSManaged var server_id: NSNumber
    @NSManaged var updated_at: NSNumber
    @NSManaged var user_id: NSManagedObject

}
