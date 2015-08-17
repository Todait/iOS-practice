//
//  ExitViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 8. 6..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

//
//  ResetViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 29..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

protocol ExitDelegate:NSObjectProtocol{
    func saveAndExitTimeLog()
    func resetAndExitTimeLog()
}


class ExitViewController: BasicViewController {
    
    var filterView:UIImageView!
    var resetView:UIView!
    var resetButton:UIButton!
    var saveButton:UIButton!
    var closeButton:UIButton!
    var delegate:ExitDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addFilterView()
        addResetView()
        addInfoView()
        addButtons()
        
        
    }
    
    func addFilterView(){
        
        filterView = UIImageView(frame: view.frame)
        filterView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        view.addSubview(filterView)
        
    }
    
    func addResetView(){
        
        resetView = UIView(frame: CGRectMake(13.5*ratio, height, 294*ratio,160*ratio))
        resetView.backgroundColor = UIColor.clearColor()
        view.addSubview(resetView)
        
        
    }
    
    func addInfoView(){
        
        let grayView = UIView(frame: CGRectMake(0, 0, 294*ratio,33*ratio))
        grayView.backgroundColor = UIColor.colorWithHexString("#949494")
        resetView.addSubview(grayView)
        
        let infoLabel = UILabel(frame: CGRectMake(13*ratio, 0, 200*ratio, 33*ratio))
        infoLabel.textAlignment = NSTextAlignment.Left
        infoLabel.textColor = UIColor.whiteColor()
        infoLabel.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 12.5*ratio)
        infoLabel.text = "나가기"
        resetView.addSubview(infoLabel)
        
        
        let whiteView = UIView(frame: CGRectMake(0, 33*ratio, 294*ratio, 75*ratio))
        whiteView.backgroundColor = UIColor.whiteColor()
        resetView.addSubview(whiteView)
        
        
        let messageLabel = UILabel(frame: CGRectMake(0, 33*ratio, 294*ratio, 75*ratio))
        messageLabel.textAlignment = NSTextAlignment.Center
        messageLabel.textColor = UIColor.todaitGray()
        messageLabel.text = "방금 공부하신 시간을 저장하시겠습니까?"
        messageLabel.font = UIFont(name: "AppleSDGothicNeo-Light", size: 13*ratio)
        resetView.addSubview(messageLabel)
        
    }
    
    func addButtons(){
        
        addCloseButton()
        addResetButton()
        addSaveButton()
        
        
    }
    
    func addCloseButton(){
        closeButton = UIButton(frame: CGRectMake(252*ratio, 9*ratio, 30*ratio, 17.5*ratio))
        closeButton.setTitle("닫기", forState: UIControlState.Normal)
        closeButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        closeButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Light", size: 10*ratio)
        closeButton.layer.cornerRadius = 8.75*ratio
        closeButton.clipsToBounds = true
        closeButton.layer.borderWidth = 0.5*ratio
        closeButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        closeButton.addTarget(self, action: Selector("closeButtonClk"), forControlEvents: UIControlEvents.TouchDown)
        
        //resetView.addSubview(closeButton)
    }
    
    func closeButtonClk(){
        
        
        UIView.animateWithDuration(0.4, delay: 0, options: .CurveEaseInOut , animations: { () -> Void in
            self.resetView.transform = CGAffineTransformMakeTranslation(0, 0*self.ratio)
            
            }) { (Bool) -> Void in
                
                self.dismissViewControllerAnimated(false, completion: { () -> Void in
                    
                })
        }
        
        
        
        
    }
    
    func addResetButton(){
        
        resetButton = UIButton(frame: CGRectMake(0, 117*ratio, 147*ratio, 43*ratio))
        resetButton.setTitle("저장안함(초기화)", forState: UIControlState.Normal)
        resetButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        resetButton.setBackgroundImage(UIImage.colorImage(UIColor.todaitRed(), frame: CGRectMake(0, 0, 147*ratio, 43*ratio)), forState: UIControlState.Normal)
        resetButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo", size: 15*ratio)
        resetButton.addTarget(self, action: Selector("resetButtonClk"), forControlEvents: UIControlEvents.TouchUpInside)
        
        resetView.addSubview(resetButton)
    }
    
    func resetButtonClk(){
        
        
        dismissViewControllerAnimated(false, completion: { () -> Void in
            
            if self.delegate.respondsToSelector("resetAndExitTimeLog"){
                self.delegate.resetAndExitTimeLog()
            }
            
        })
    }
    
    func addSaveButton(){
        saveButton = UIButton(frame: CGRectMake(147*ratio, 117*ratio, 147*ratio, 43*ratio))
        saveButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        saveButton.setTitle("저장", forState: UIControlState.Normal)
        saveButton.setBackgroundImage(UIImage.colorImage(UIColor.todaitGreen(), frame: CGRectMake(0, 0, 147*ratio, 43*ratio)), forState: UIControlState.Normal)
        saveButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo", size: 15*ratio)
        saveButton.addTarget(self, action: Selector("saveButtonClk"), forControlEvents: UIControlEvents.TouchUpInside)
        resetView.addSubview(saveButton)
    }
    
    
    func saveButtonClk(){
        
        
        dismissViewControllerAnimated(false, completion: { () -> Void in
            
            if self.delegate.respondsToSelector("saveAndExitTimeLog"){
                self.delegate.saveAndExitTimeLog()
            }
        })
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        let touch: AnyObject? = (touches as NSSet).anyObject()
        let touchPoint:CGPoint! = touch?.locationInView(view)
        
        if touchPoint.y < height - 160*ratio {
            closeButtonClk()
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        todaitNavBar.hidden = true
        
        UIView.animateWithDuration(0.4, delay: 0, options: .CurveEaseInOut , animations: { () -> Void in
            self.resetView.transform = CGAffineTransformMakeTranslation(0, -160*self.ratio)
            
            }) { (Bool) -> Void in
                
        }
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
}
