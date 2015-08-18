//
//  OptionButton.swift
//  Todait
//
//  Created by CruzDiary on 2015. 8. 5..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

enum OptionStatus:Int {
    
    case None = 0
    case Review = 1
    case Reread = 2
    case Alarm = 4
    
}


class OptionButton: BasicButton {

    
    var optionColor:UIColor!
    var optionText:String!
    var optionFont:UIFont!
    
    var onColor:UIColor! = UIColor.orangeColor()
    var offColor:UIColor! = UIColor.grayColor()
    var onImage:UIImage!
    var offImage:UIImage!
    
    var buttonOn:Bool!
    
    var iconImageView:UIImageView!
    var textLabel:UILabel!
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        addIconImageView()
        addTextLabel()
        
        
        /*
        if option & OptionStatus.Review.rawValue > 0 {
            iconImageView.image = UIImage(named: "icon_review_wt@3x.png")
            titleLabel.textColor = UIColor.todaitGreen()
        }else{
            iconImageView.image = UIImage(named: "icon_review@3x.png")
            titleLabel.textColor = UIColor.todaitGray()
        }
        
        */
        
    }

    func setText(text:String){
        optionText = text
    }
    
    func textUpdate(){
        
         textLabel.attributedText = NSMutableAttributedString(string:optionText, attributes: [NSKernAttributeName:3.5,NSForegroundColorAttributeName:optionColor!,NSFontAttributeName:optionFont!])
    }
    
    func setButtonOn(on:Bool){
        
        if on == true {
            
            buttonOn = true
            iconImageView.image = onImage
            optionColor = onColor
            
            textUpdate()
        }else{
            
            buttonOn = false
            iconImageView.image = offImage
            optionColor = offColor
            
            textUpdate()
        }
        
    }

    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addIconImageView(){
        iconImageView = UIImageView(frame: CGRectMake(30*ratio, 6*ratio, 30*ratio, 30*ratio))
        iconImageView.center = CGPointMake(37*ratio, 23.5*ratio)
        addSubview(iconImageView)
    }
    
    
    func addTextLabel(){
        
        optionFont = UIFont(name: "AppleSDGothicNeo-Ultralight", size: 12.5*ratio)
        
        textLabel = UILabel(frame: CGRectMake(63*ratio, 12*ratio, 92*ratio, 22.5*ratio))
        textLabel.font = optionFont
        textLabel.textAlignment = NSTextAlignment.Left
        textLabel.textColor = offColor
        addSubview(textLabel)
        
    }
    

    

}
