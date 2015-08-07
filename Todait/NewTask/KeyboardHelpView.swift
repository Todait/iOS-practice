//
//  KeyboardHelpView.swift
//  Todait
//
//  Created by CruzDiary on 2015. 8. 7..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit


protocol KeyboardHelpDelegate: NSObjectProtocol {
    
    func confirmButtonClk()
    func leftButtonClk()
    func rightButtonClk()
    
}

enum KeyboardHelpStatus {
    case Start
    case Center
    case End
}


class KeyboardHelpView: BasicView {

    var leftButton:UIButton!
    var rightButton:UIButton!
    var confirmButton:UIButton!
    
    var isStartPoint:Bool! = false
    var isEndPoint:Bool! = false
    
    
    var leftImageName:String!
    var rightImageName:String!
    
    weak var delegate:KeyboardHelpDelegate?
    
    var status:KeyboardHelpStatus! = KeyboardHelpStatus.Center
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        leftButton = UIButton(frame: CGRectMake(7*ratio, 0, 38*ratio, 38*ratio))
        leftButton.addTarget(self, action: Selector("leftButtonClk"), forControlEvents: UIControlEvents.TouchDown)
        addSubview(leftButton)
        
        rightButton = UIButton(frame: CGRectMake(50*ratio, 0, 38*ratio, 38*ratio))
        rightButton.addTarget(self, action: Selector("rightButtonClk"), forControlEvents: UIControlEvents.TouchDown)
        addSubview(rightButton)
        
        
        confirmButton = UIButton(frame: CGRectMake(246*ratio, 0 , 74*ratio, 38*ratio))
        confirmButton.setBackgroundImage(UIImage.colorImage(UIColor.todaitGreen(), frame: CGRectMake(0, 0, 74*ratio, 38*ratio)), forState: UIControlState.Normal)
        confirmButton.setBackgroundImage(UIImage.colorImage(UIColor.todaitDarkGreen(), frame: CGRectMake(0, 0, 74*ratio, 38*ratio)), forState: UIControlState.Highlighted)
        confirmButton.setTitle("확인", forState: UIControlState.Normal)
        confirmButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        confirmButton.addTarget(self, action: Selector("confirmButtonClk"), forControlEvents: UIControlEvents.TouchUpInside)
        confirmButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 15*ratio)
        addSubview(confirmButton)
        
    }
    
    func leftButtonClk(){
        
        
        if status == KeyboardHelpStatus.Start {
            confirmButtonClk()
            return
        }
        
        
        if let delegate = delegate {
            if delegate.respondsToSelector("leftButtonClk"){
                delegate.leftButtonClk()
            }
        }
    }
    
    func rightButtonClk(){
        
        if status == KeyboardHelpStatus.End {
            confirmButtonClk()
            return
        }
        
        if let delegate = delegate {
            if delegate.respondsToSelector("rightButtonClk"){
                delegate.rightButtonClk()
            }
        }
    }
    
    func confirmButtonClk(){
        
        if let delegate = delegate {
            if delegate.respondsToSelector("confirmButtonClk"){
                delegate.confirmButtonClk()
            }
        }
        
    }
    
    func setStatus(status:KeyboardHelpStatus){
        
        
        self.status = status
        
        switch status {
        case .Start: setStartStatus()
        case .Center: setCenterStatus()
        case .End: setEndStatus()
        default: return
        }
        
    }
    
    private func setStartStatus(){
        
        leftButton.setImage(UIImage.maskColor(leftImageName, color: UIColor.todaitLightGray()), forState: UIControlState.Normal)
        rightButton.setImage(UIImage(named: rightImageName), forState: UIControlState.Normal)
        
    }

    private func setCenterStatus(){
        
        leftButton.setImage(UIImage(named: leftImageName), forState: UIControlState.Normal)
        rightButton.setImage(UIImage(named: rightImageName), forState: UIControlState.Normal)
    }
    
    private func setEndStatus(){
        
        leftButton.setImage(UIImage(named: leftImageName), forState: UIControlState.Normal)
        rightButton.setImage(UIImage.maskColor(rightImageName, color: UIColor.todaitLightGray()), forState: UIControlState.Normal)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
   
    
}
