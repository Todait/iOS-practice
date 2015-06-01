//
//  UIColorExtension.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 1..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

extension UIColor {
    
    class func colorWithHexString(hexString:NSString)->UIColor! {
        let colorString : NSString = hexString.stringByReplacingOccurrencesOfString("#", withString: "").uppercaseString
        var red,green,blue,alpha : CGFloat!
        switch (colorString.length) {
        case 3: // #RGB
            alpha = 1.0
            red   = colorComponentFrom(colorString, start: 0,length: 1)
            green = colorComponentFrom(colorString, start: 1,length: 1)
            blue  = colorComponentFrom(colorString, start: 2,length: 1)
            break;
        case 4: // #ARGB
            alpha = colorComponentFrom(colorString, start: 0,length: 1)
            red   = colorComponentFrom(colorString, start: 1,length: 1)
            green = colorComponentFrom(colorString, start: 2,length: 1)
            blue  = colorComponentFrom(colorString, start: 3,length: 1)
            break;
        case 6: // #RRGGBB
            alpha = 1.0
            red   = colorComponentFrom(colorString, start: 0,length: 2)
            green = colorComponentFrom(colorString, start: 2,length: 2)
            blue  = colorComponentFrom(colorString, start: 4,length: 2)
            break;
        case 8: // #AARRGGBB
            alpha = colorComponentFrom(colorString, start: 0,length: 2)
            red   = colorComponentFrom(colorString, start: 2,length: 2)
            green = colorComponentFrom(colorString, start: 4,length: 2)
            blue  = colorComponentFrom(colorString, start: 6,length: 2)
            break;
        default:
            return nil
        }
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    class func colorComponentFrom(colorString:NSString,start:NSInteger ,length: NSInteger) -> CGFloat{
        
        var subString : String = colorString.substringWithRange(NSMakeRange(start, length))
        var fullHex = length == 2 ? subString : String(format: "%@%@", subString,subString)
        var hexComponent:CUnsignedInt = 0
        
        let scanner = NSScanner(string: fullHex)
        scanner.scanHexInt(&hexComponent)
        return CGFloat(hexComponent)/255.0
        
    }
}

