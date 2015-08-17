//
//  ColorLabel.swift
//  Todait
//
//  Created by CruzDiary on 2015. 8. 4..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class ColorLabel: BasicLabel {

    
    var textOnColor:UIColor! = UIColor.grayColor()
    var textOffColor:UIColor! = UIColor.lightGrayColor()
    
    var labelOn:Bool! = false
    
    func setLabelOn(on:Bool){
        
        if on == true {
            labelOn = true
            textColor = textOnColor
        }else{
            labelOn = false
            textColor = textOffColor
        }
        
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
