//
//  ColorButton.swift
//  Todait
//
//  Created by CruzDiary on 2015. 8. 3..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class ColorButton: BasicButton {
    
    
    
    
    
    
    var normalTitleColor:UIColor! = UIColor.whiteColor()
    var normalBackgroundColor:UIColor! = UIColor.clearColor()
    
    var highlightedTitleColor:UIColor! = UIColor.whiteColor()
    var highlightedBackgroundColor:UIColor! = UIColor.clearColor()
    
    var buttonOn:Bool! = false
    
    
    func setButtonOn(on:Bool){
        
        if on == true {
            
            buttonOn = true
            setTitleColor(highlightedTitleColor, forState: UIControlState.Normal)
            setTitleColor(normalTitleColor, forState: UIControlState.Highlighted)
            setBackgroundImage(UIImage.colorImage(highlightedBackgroundColor, frame: CGRectMake(0, 0, frame.size.width, frame.size.height)), forState: UIControlState.Normal)
            setBackgroundImage(UIImage.colorImage(normalBackgroundColor, frame: CGRectMake(0, 0, frame.size.width, frame.size.height)), forState: UIControlState.Highlighted)
            
            
        }else{
            
            buttonOn = false
            setTitleColor(normalTitleColor, forState: UIControlState.Normal)
            setTitleColor(highlightedTitleColor, forState: UIControlState.Highlighted)
            setBackgroundImage(UIImage.colorImage(normalBackgroundColor, frame: CGRectMake(0, 0, frame.size.width, frame.size.height)), forState: UIControlState.Normal)
            setBackgroundImage(UIImage.colorImage(highlightedBackgroundColor, frame: CGRectMake(0, 0, frame.size.width, frame.size.height)), forState: UIControlState.Highlighted)
            
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
