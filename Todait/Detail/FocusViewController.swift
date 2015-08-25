//
//  TimeLogViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 29..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

protocol FocusDelegate : NSObjectProtocol {
    func saveFocus(focus:CGFloat)
}

class FocusViewController: BasicViewController{
    
    
    
    var day:Day!
    var focus:CGFloat! = 0
    
    var filterView:UIImageView!
    
    var resetView:UIView!
    var resetButton:UIButton!
    
    var cancelButton:UIButton!
    var confirmButton:UIButton!
    
    var delegate:FocusDelegate?
    
    
    var task_type:String! = ""
    var unit:String! = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addFilterView()
        addResetView()
        addInfoView()
        
        addCancelButton()
        addConfirmButton()
        addFocusView()
        
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
        infoLabel.text = "집중도 등록"
        resetView.addSubview(infoLabel)
        
        
        let whiteView = UIView(frame: CGRectMake(0, 33*ratio, 294*ratio, 72*ratio))
        whiteView.backgroundColor = UIColor.whiteColor()
        resetView.addSubview(whiteView)
        
        
        let panGesture = UIPanGestureRecognizer(target: self, action: Selector("gesture:"))
        whiteView.addGestureRecognizer(panGesture)
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector("gesture:"))
        whiteView.addGestureRecognizer(tapGesture)
    }
    
    
    func gesture(gesture:UIGestureRecognizer){
        
        //리팩토링 필요
        
        let touchPoint = gesture.locationInView(resetView)
        
        let base:CGFloat = 70*ratio
        let startWidth = 24*ratio
        
        for var index = 0 ; index < 6 ; index++ {
            
            if touchPoint.x < base + startWidth/2 + CGFloat(index)*34*ratio {
                setFocusScore(CGFloat(index))
                return
            }else if touchPoint.x < base + startWidth + CGFloat(index)*34*ratio {
                setFocusScore(CGFloat(index) + 0.5)
                return
            }
        }
        
    }
    
    func addFocusView(){
        
        //리팩토링 필요
        
        if let day = day {
            focus = CGFloat(day.score)
        }
        
        
        
        for index in 0...4 {
            
            var imageView = UIImageView(frame: CGRectMake(70*ratio + 34*ratio * CGFloat(index), 59*ratio, 24*ratio, 24*ratio))
            imageView.image = UIImage(named: "detail_basic_30@3x.png")
            
            resetView.addSubview(imageView)
            
            
            if index > Int(focus) {
                
            }else if index == Int(focus){
                
                
                var percent = focus - CGFloat(index)
                
                var path = UIBezierPath()
                path.moveToPoint(CGPointMake(0*ratio,12*ratio))
                path.addLineToPoint(CGPointMake(24*ratio,12*ratio))
                
                
                var colorLayer = CAShapeLayer()
                colorLayer.path = path.CGPath
                colorLayer.fillColor = UIColor.todaitGreen().CGColor
                colorLayer.strokeColor = UIColor.todaitRed().CGColor
                colorLayer.strokeStart = 0
                colorLayer.strokeEnd = percent
                colorLayer.lineWidth = 24*ratio
                
                
                var maskLayer = CALayer()
                maskLayer.contents = UIImage(named: "detail_diary_input_star@3x.png")!.CGImage
                maskLayer.frame = CGRectMake(70*ratio + 34*ratio * CGFloat(index), 59*ratio, 24*ratio, 24*ratio)
                maskLayer.mask = colorLayer
                
                resetView.layer.addSublayer(maskLayer)
                
            }else{
                
                var imageView = UIImageView(frame: CGRectMake(70*ratio + 34*ratio * CGFloat(index), 59*ratio, 24*ratio, 24*ratio))
                imageView.image = UIImage(named: "detail_diary_input_star@3x.png")
                resetView.addSubview(imageView)
            }
            
            
            let tapGesture = UITapGestureRecognizer(target: self, action: Selector("tapGesture:"))
            
            imageView.tag = index + 1
            imageView.addGestureRecognizer(tapGesture)
            
        }
        
    }
    
    func tapGesture(imageView:UIImageView){
        
        setFocusScore(CGFloat(imageView.tag))
        
    }
    
    func setFocusScore(score:CGFloat){
        NSLog("%f", score)
        
        focus = score
        
        
        for index in 0...4 {
            
            var imageView = UIImageView(frame: CGRectMake(70*ratio + 34*ratio * CGFloat(index), 59*ratio, 24*ratio, 24*ratio))
            imageView.image = UIImage(named: "detail_basic_30@3x.png")
            
            resetView.addSubview(imageView)
            
            
            if index > Int(focus) {
                
            }else if index == Int(focus){
                
                
                var percent = focus - CGFloat(index)
                
                var path = UIBezierPath()
                path.moveToPoint(CGPointMake(0*ratio,12*ratio))
                path.addLineToPoint(CGPointMake(24*ratio,12*ratio))
                
                
                var colorLayer = CAShapeLayer()
                colorLayer.path = path.CGPath
                colorLayer.fillColor = UIColor.todaitGreen().CGColor
                colorLayer.strokeColor = UIColor.todaitRed().CGColor
                colorLayer.strokeStart = 0
                colorLayer.strokeEnd = percent
                colorLayer.lineWidth = 24*ratio
                
                
                var maskLayer = CALayer()
                maskLayer.contents = UIImage(named: "detail_diary_input_star@3x.png")!.CGImage
                maskLayer.frame = CGRectMake(70*ratio + 34*ratio * CGFloat(index), 59*ratio, 24*ratio, 24*ratio)
                maskLayer.mask = colorLayer
                
                resetView.layer.addSublayer(maskLayer)
                
            }else{
                
                var imageView = UIImageView(frame: CGRectMake(70*ratio + 34*ratio * CGFloat(index), 59*ratio, 24*ratio, 24*ratio))
                imageView.image = UIImage(named: "detail_diary_input_star@3x.png")
                resetView.addSubview(imageView)
            }
            
            
            let tapGesture = UITapGestureRecognizer(target: self, action: Selector("tapGesture:"))
            
            imageView.tag = index + 1
            imageView.addGestureRecognizer(tapGesture)
            
        }

        
    }
    
    func closeButtonClk(){
        
        UIView.animateWithDuration(0.4, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            self.resetView.transform = CGAffineTransformMakeTranslation(0, 0)
            }, completion: { (Bool) -> Void in
                
                self.dismissViewControllerAnimated(false, completion: { () -> Void in
                    
                })
        })
    }
    
    
    func resetButtonClk(){
        
    }
    
    func getTimeLog()->NSTimeInterval{
        
        //var hour = hourPicker.selectedRowInComponent(0) * 3600
        //var minute = minutePicker.selectedRowInComponent(0) * 60
        //var second = secondPicker.selectedRowInComponent(0)
        
        return NSTimeInterval(1) //hour + minute + second)
    }
    
    
    func addCancelButton(){
        cancelButton = UIButton(frame: CGRectMake(0, 118*ratio, 147*ratio, 43*ratio))
        cancelButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        cancelButton.setTitle("취소", forState: UIControlState.Normal)
        cancelButton.setBackgroundImage(UIImage.colorImage(UIColor.todaitLightGray(), frame: CGRectMake(0, 0, 294*ratio, 43*ratio)), forState: UIControlState.Normal)
        cancelButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo", size: 15*ratio)
        cancelButton.addTarget(self, action: Selector("confirmButtonClk"), forControlEvents: UIControlEvents.TouchUpInside)
        resetView.addSubview(cancelButton)
    }
    
    
    
    func addConfirmButton(){
        
        confirmButton = UIButton(frame: CGRectMake(147*ratio, 118*ratio, 147*ratio, 43*ratio))
        confirmButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        confirmButton.setTitle("저장", forState: UIControlState.Normal)
        confirmButton.setBackgroundImage(UIImage.colorImage(UIColor.todaitGreen(), frame: CGRectMake(0, 0, 294*ratio, 43*ratio)), forState: UIControlState.Normal)
        confirmButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo", size: 15*ratio)
        confirmButton.addTarget(self, action: Selector("confirmButtonClk"), forControlEvents: UIControlEvents.TouchUpInside)
        resetView.addSubview(confirmButton)
    }
    
    func cancelButtonClk(){
         closeButtonClk()
    }
    
    
    func confirmButtonClk(){
        
        
        if let delegate = delegate{
            
            if delegate.respondsToSelector("saveFocus:"){
                delegate.saveFocus(focus)
                closeButtonClk()
            }
        }
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
        
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut , animations: { () -> Void in
            self.resetView.transform = CGAffineTransformMakeTranslation(0, -160*self.ratio)
            
            }) { (Bool) -> Void in
                
        }
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
}