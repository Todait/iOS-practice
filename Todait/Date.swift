//
//  Date.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 10..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import Foundation

public extension NSDate {
    func addDay(day:Int)->NSDate{
        
        return self.dateByAddingTimeInterval(24*60*60*NSTimeInterval(day))
        
    }
}
