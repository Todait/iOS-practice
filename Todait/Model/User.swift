//
//  User.swift
//  Todait
//
//  Created by CruzDiary on 2015. 7. 23..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import Foundation
import CoreData

class User: NSManagedObject {

    @NSManaged var authenicationToken: String
    @NSManaged var email: String
    @NSManaged var imageNames: String
    @NSManaged var name: String

}
