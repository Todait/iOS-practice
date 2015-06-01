//
//  TodaitNavigationBar.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 1..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

@objc protocol TodaitNavigationDelegate : NSObjectProtocol {
    func backButtonClk()
}

class TodaitNavigationBar: UINavigationBar {
    
    var ratio : CGFloat!
    var backButton : UIButton!
    var todaitDelegate: TodaitNavigationDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.tintColor = UIColor.whiteColor()
        setupRatio()
        self.setBackgroundImage(UIImage.colorImage(UIColor.colorWithHexString("#27DB9F"),frame:frame), forBarMetrics: UIBarMetrics.Default)
        addBackButton()
        
    }
    
    func setupRatio(){
        var screenRect = UIScreen.mainScreen().bounds
        var screenWidth : CGFloat = screenRect.size.width
        ratio = screenWidth/320
    }
    
    func addBackButton(){
        backButton = UIButton(frame: CGRectMake(0,0, 80*ratio, 64))
        backButton.setImage(UIImage(named: "back@3x.png"), forState:UIControlState.Normal)
        backButton.addTarget(self, action: Selector("backButtonClk"), forControlEvents: UIControlEvents.TouchUpInside)
        backButton.hidden = true
        backButton.contentEdgeInsets = UIEdgeInsetsMake(20*ratio, -50*ratio,0, 0)
        self.addSubview(backButton)
    }
    
    func backButtonClk(){
        if(todaitDelegate.respondsToSelector(Selector("backButtonClk"))){
            todaitDelegate.backButtonClk()
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
