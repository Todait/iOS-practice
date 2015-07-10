//
//  MainTabbarButton.swift
//  Todait
//
//  Created by CruzDiary on 2015. 7. 6..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class MainTabbarButton: UIButton {

    var iconImageView:UIImageView!
    var buttonLabel:UILabel!
    var ratio:CGFloat!
    
    
    var normalImage:UIImage!
    var highlightImage:UIImage!
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        setupRatio()
        addIconImageView()
        addButtonLabel()
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setupRatio(){
        let screenRect = UIScreen.mainScreen().bounds
        let screenWidth = screenRect.size.width
        ratio = screenWidth/320
    }
    
    func addIconImageView(){
        iconImageView = UIImageView(frame: CGRectMake((320*ratio/5 - 27*ratio)/2, 9.5*ratio, 27*ratio, 23*ratio))
        iconImageView.contentMode = UIViewContentMode.ScaleAspectFill
        addSubview(iconImageView)
    }
    
    func addButtonLabel(){
        buttonLabel = UILabel(frame: CGRectMake(0,35*ratio,320*ratio/5,10*ratio))
        buttonLabel.font = UIFont(name: "AppleSDGothicNeo-Light", size: 8*ratio)
        buttonLabel.textColor = UIColor.todaitDarkGray()
        buttonLabel.textAlignment = NSTextAlignment.Center
        addSubview(buttonLabel)
    }
    
    func setupSelected(selected:Bool){
        
        if selected == true {
            backgroundColor = UIColor.colorWithHexString("#95CCC4")
            buttonLabel.textColor = UIColor.whiteColor()
            iconImageView.image = highlightImage
            
        }else{
            backgroundColor = UIColor.whiteColor()
            buttonLabel.textColor = UIColor.todaitDarkGray()
            iconImageView.image = normalImage
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
