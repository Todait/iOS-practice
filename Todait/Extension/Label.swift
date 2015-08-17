//
//  Label.swift
//  Todait
//
//  Created by CruzDiary on 2015. 8. 7..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

extension UILabel {
    
    func setKern(kern:CGFloat){
        
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = textAlignment
        
        
        
        
        
        self.attributedText = NSMutableAttributedString(string:text!, attributes: [NSKernAttributeName:kern,NSForegroundColorAttributeName:textColor,NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle])
    
    }
    
}
