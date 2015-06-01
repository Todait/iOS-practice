//
//  UIImageExtension.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 1..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

extension UIImage {
    
    class func colorImage(color:UIColor, frame:CGRect) -> UIImage{
        UIGraphicsBeginImageContext(frame.size)
        let context:CGContextRef = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, frame)
        
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
}