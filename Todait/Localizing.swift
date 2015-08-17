//
//  Localizing.swift
//  Todait
//
//  Created by CruzDiary on 2015. 7. 15..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import Foundation

public func getDeleteString() -> String {
    
    if getLanguage() == "ko" {
        return "삭제"
    }else{
        return "Delete"
    }
}

public func getMainString() -> String {
    
    if getLanguage() == "ko" {
        return "메인"
    }else{
        return "Home"
    }
    
}

public func getTimeTableString() -> String{
    if getLanguage() == "ko" {
        return "타임로그"
    }else{
        return "TimeTable"
    }
    
}

public func getStatisticsString() -> String{
    if getLanguage() == "ko" {
        return "통계"
    }else{
        return "Statistics"
    }
}

public func getProfileString() -> String{
    if getLanguage() == "ko" {
        return "마이페이지"
    }else{
        return "Profile"
    }
}

