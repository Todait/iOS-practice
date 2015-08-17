//
//  Diary.swift
//  Todait
//
//  Created by CruzDiary on 2015. 7. 23..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import Foundation
import CoreData

class Diary: NSManagedObject {

    @NSManaged var body: String
    @NSManaged var diryFlag: NSNumber
    @NSManaged var timestamp: NSNumber
    @NSManaged var dayId: Day
    @NSManaged var imageList: NSOrderedSet

}
