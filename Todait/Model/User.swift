//
//  User.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 9..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import Foundation
import CoreData

class User: NSManagedObject {

    @NSManaged var authenication_token: String
    @NSManaged var created_at: NSDate
    @NSManaged var dirty_flag: NSNumber
    @NSManaged var email: String
    @NSManaged var image_names: String
    @NSManaged var name: String
    @NSManaged var server_id: NSNumber
    @NSManaged var updated_at: NSDate

}
