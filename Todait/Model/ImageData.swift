//
//  Image.swift
//  Todait
//
//  Created by CruzDiary on 2015. 7. 17..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import Foundation
import CoreData

class ImageData: NSManagedObject {

    @NSManaged var image: NSData
    @NSManaged var diary_id: Diary
    @NSManaged var archived_at: NSDate
    @NSManaged var created_at: NSDate
    @NSManaged var updated_at: NSDate

}
