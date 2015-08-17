//
//  DateManager.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 10..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import Foundation

public extension NSNumber {
    
    func toTimeString()->String{
        let seconds = self.integerValue
        
        let hour = seconds.toHour()
        
        if hour == 0 {
            return "총 \(seconds.toMinute())분 \(seconds.toSeconds())초"
        }else{
            return "총 \(seconds.toHour())시간 \(seconds.toMinute())분 \(seconds.toSeconds())초"
        }
        
    }
}

public extension Int {
    
    func toHour()->Int{
        return self/3600
    }
    
    func toMinute()->Int{
        return (self%3600)/60
    }
    
    func toSeconds()->Int{
        return (self%3600)%60
    }
    
}