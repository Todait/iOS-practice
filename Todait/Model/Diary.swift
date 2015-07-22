//
//  Diary.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 9..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import Foundation
import CoreData

class Diary: NSManagedObject {

    @NSManaged var archived: NSNumber
    @NSManaged var body: String
    @NSManaged var created_at: NSDate
    @NSManaged var diry_flag: NSNumber
    @NSManaged var image_names: String
    @NSManaged var score: NSNumber
    @NSManaged var server_day_id: NSNumber
    @NSManaged var server_id: NSNumber
    @NSManaged var timestamp: String
    @NSManaged var updated_at: NSDate
    @NSManaged var day_id: Day
    @NSManaged var imageList: NSOrderedSet
}
