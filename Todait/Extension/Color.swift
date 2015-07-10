//
//  Color.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 10..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

public extension UIColor {
    
    
    class func todaitBlue()->UIColor! {
        return colorWithHexString("#77c4f0")
    }
    
    class func todaitOrange()->UIColor! {
        return colorWithHexString("#FF9381")
    }
    
    class func todaitRed()->UIColor! {
        return colorWithHexString("#FD8878")
    }
    
    class func todaitPurple()->UIColor! {
        return colorWithHexString("#AB99DE")
    }
    
    class func todaitGreen()->UIColor! {
        return colorWithHexString("#00D2B1")
    }
    
    class func todaitGray()->UIColor! {
        return colorWithHexString("#C9C9C9")
    }
    
    class func todaitNewGray()->UIColor! {
        return colorWithHexString("#929292")
    }
    
    class func todaitLightGray()->UIColor! {
        return colorWithHexString("#F6F6F6")
    }
    
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