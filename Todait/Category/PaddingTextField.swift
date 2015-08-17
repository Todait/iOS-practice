//
//  PaddingTextField.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 8..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class PaddingTextField: UITextField {
    
    var padding:CGFloat! = 0
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        
        var paddingFrame = bounds
        paddingFrame.origin.x = paddingFrame.origin.x + self.padding
        
        return paddingFrame
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        var paddingFrame = bounds
        paddingFrame.origin.x = paddingFrame.origin.x + self.padding
        
        return paddingFrame
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
