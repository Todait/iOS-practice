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
        return colorWithHexString("#FF4FA0FE")
    }
    
    class func todaitLightBlue()->UIColor! {
        return colorWithHexString("#664FA0FE")
    }
    
    class func todaitOrange()->UIColor! {
        return colorWithHexString("#FFFF9381")
    }
    
    class func todaitYellow()->UIColor! {
        return colorWithHexString("#FFFFD094")
    }
    
    
    class func todaitLightRed()->UIColor! {
        return colorWithHexString("#66FF9999")
    }
    
    class func todaitRed()->UIColor! {
        return colorWithHexString("#FFFF7E7E")
    }
    
    class func todaitDarkRed()->UIColor! {
        return colorWithHexString("#FFF26666")
    }
    
    class func todaitPurple()->UIColor! {
        return colorWithHexString("#FFAB99DE")
    }
    
    class func todaitGreen()->UIColor! {
        return colorWithHexString("#FF00D2B1")
    }
    
    class func todaitDarkGreen()->UIColor! {
        return colorWithHexString("#FF00AB8E")
    }
    
    class func todaitDarkGray()->UIColor! {
        return colorWithHexString("#FF666666")
    }
    
    class func todaitGray()->UIColor! {
        return colorWithHexString("#FF949494")
    }
    
    class func todaitLightGray()->UIColor! {
        return colorWithHexString("#FFCCCCCC")
    }
    
    class func todaitBackgroundGray()->UIColor! {
        return colorWithHexString("#FFEEEEEE")
    }
    
    class func todaitWhiteGray()->UIColor! {
        return colorWithHexString("#FFF2F2F2")
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