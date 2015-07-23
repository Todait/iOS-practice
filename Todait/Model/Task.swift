//
//  Task.swift
//  Todait
//
//  Created by CruzDiary on 2015. 7. 23..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import Foundation
import CoreData

class Task: NSManagedObject {

    @NSManaged var amount: NSNumber
    @NSManaged var taskType: String
    @NSManaged var dirtyFlag: NSNumber
    @NSManaged var endDate: NSNumber
    @NSManaged var imageNames: String
    @NSManaged var lastUpdateDate: NSNumber
    @NSManaged var name: String
    @NSManaged var notificationMode: NSNumber
    @NSManaged var notificationTime: String
    @NSManaged var serverCategoryId: NSNumber
    @NSManaged var serverId: NSNumber
    @NSManaged var startDate: NSNumber
    @NSManaged var startPoint: NSNumber
    @NSManaged var unit: String
    @NSManaged var localId: String
    @NSManaged var reviewType: String
    @NSManaged var reviewCount: NSNumber
    @NSManaged var completed: NSNumber
    @NSManaged var repeatCount: NSNumber
    @NSManaged var priority: NSNumber
    @NSManaged var categoryId: Category
    @NSManaged var taskDateList: NSOrderedSet
    @NSManaged var imageDataList: NSSet

}
