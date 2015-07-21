//
//  String.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 10..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import Foundation

public extension String {
    
    
    static func categoryColorStringAtIndex(index:Int)->String{
        
        switch index{
        case 0: return "#FFFFBEBE"
        case 1: return "#FFFFD094"
        case 2: return "#FFFDE039"
        case 3: return "#FFFFB95A"
        case 4: return "#FFE8716E"
        case 5: return "#FFFF9EC7"
        case 6: return "#FFFA5B85"
        case 7: return "#FFC552A6"
        case 8: return "#FFCC9DF2"
        case 9: return "#FF957AC6"
        case 10: return "#FFA3E5E4"
        case 11: return "#FF8CC5FF"
        case 12: return "#FF4FA0FE"
        case 13: return "#FF23C4CE"
        case 14: return "#FF286883"
        case 15: return "#FF75EC75"
        case 16: return "#FFB0DE8F"
        case 17: return "#FF70C79E"
        case 18: return "#FFD2D392"
        case 19: return "#FFCEA37A"
        
        default : return "#80ED63"
            
        }
    }
    
    
}