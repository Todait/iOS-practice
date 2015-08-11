//
//  AttributeString.swift
//  Todait
//
//  Created by CruzDiary on 2015. 7. 22..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit
import Foundation

public extension NSAttributedString {
    
    static func getAttributedString(string:String,font:UIFont,color:UIColor) -> NSAttributedString{
        
        let attributedString = NSMutableAttributedString(string: string, attributes: [NSForegroundColorAttributeName:color,NSFontAttributeName:font])
        
        return attributedString
        
    }

    
    static func getAttributedString(string:String,font:UIFont,color:UIColor,paraStyle:NSParagraphStyle) -> NSAttributedString{
        
        let attributedString = NSMutableAttributedString(string: string, attributes: [NSForegroundColorAttributeName:color,NSFontAttributeName:font,NSParagraphStyleAttributeName:paraStyle])
        
        return attributedString
        
    }
}