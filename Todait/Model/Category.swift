//
//  Category.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 9..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import Foundation
import CoreData

class Category: NSManagedObject {

    @NSManaged var archived_at: NSDate
    @NSManaged var color: String
    @NSManaged var created_at: NSDate
    @NSManaged var dirty_flag: NSNumber
    @NSManaged var name: String
    @NSManaged var server_id: NSNumber
    @NSManaged var updated_at: NSDate
    @NSManaged var user_id: User
    @NSManaged var taskList: NSSet

}
