//
//  Category.swift
//  Todait
//
//  Created by CruzDiary on 2015. 7. 23..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import Foundation
import CoreData

class Category: NSManagedObject {

    @NSManaged var archivedAt: NSDate
    @NSManaged var color: String
    @NSManaged var createdAt: NSDate
    @NSManaged var dirtyFlag: NSNumber
    @NSManaged var name: String
    @NSManaged var serverId: NSNumber
    @NSManaged var updatedAt: NSDate
    @NSManaged var localId: NSNumber
    @NSManaged var categoryType: String
    @NSManaged var taskList: NSSet
    @NSManaged var userId: User

}
