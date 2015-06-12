//
//  UIImageExtension.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 1..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

public extension UIImage {
    
    class func colorImage(color:UIColor, frame:CGRect) -> UIImage{
        UIGraphicsBeginImageContext(frame.size)
        let context:CGContextRef = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, frame)
        
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    class func maskColor(imageName:String,color:UIColor) -> UIImage{
        let image:UIImage = UIImage(named:imageName)!
        let rect = CGRectMake(0, 0, image.size.width, image.size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, image.scale)
        let contextRef: CGContextRef = UIGraphicsGetCurrentContext()
        image.drawInRect(rect)
        CGContextSetFillColorWithColor(contextRef, color.CGColor)
        CGContextSetBlendMode(contextRef,kCGBlendModeSourceAtop)
        CGContextFillRect(contextRef, rect)
        
        let result:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    
}