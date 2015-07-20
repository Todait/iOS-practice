//
//  Image.swift
//  Todait
//
//  Created by CruzDiary on 2015. 7. 17..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import Foundation
import CoreData

class Image: NSManagedObject {

    @NSManaged var image: NSData
    @NSManaged var diary_id: Diary

}
