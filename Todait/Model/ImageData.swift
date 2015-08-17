//
//  ImageData.swift
//  Todait
//
//  Created by CruzDiary on 2015. 7. 23..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import Foundation
import CoreData

class ImageData: NSManagedObject {

    @NSManaged var image: NSData
    @NSManaged var createdAt: NSDate
    @NSManaged var diaryId: Diary
    @NSManaged var taskId: Task

}
