//
//  Step3ChartBox.swift
//  Todait
//
//  Created by CruzDiary on 2015. 8. 4..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

protocol ThumbChartDelegate : NSObjectProtocol {
    
    func thumbTouchBegan()
    func thumbTouchMoved()
    func thumbTouchEnd()
}


class ThumbChartBox: BasicView {

    
    
    var frontView:UIView!
    var backView:UIView!
    
    var frontOnColor:UIColor! = UIColor.orangeColor()
    var frontOffColor:UIColor! = UIColor.lightGrayColor()
    var maxColor:UIColor! = UIColor.yellowColor()
    
    var currentValue:CGFloat! = 0
    var maxValue:CGFloat! = 0
    
    var thumbImageView:ThumbImageView!

    var isThumbed:Bool = false
    var isMax:Bool = false
    var isAnimating:Bool = false
    var chartOn:Bool! = false
    
    var delegate:ThumbChartDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.todaitBackgroundGray()
        clipsToBounds = true
        
        
        var newFrame = frame
        newFrame.origin.x = 0
        newFrame.origin.y = frame.size.height
        newFrame.size.height = 0
        
        
        frontView = UIView(frame:newFrame)
        addSubview(frontView)
        
        thumbImageView = ThumbImageView(frame: CGRectMake(0, 0, 44*ratio, 60*ratio))
        thumbImageView.center = CGPointMake(frame.size.width/2, frame.size.height)
        
        thumbImageView.onImage = UIImage(named: "newgoal_arrowhandle_green@3x.png")
        thumbImageView.offImage = UIImage(named: "newgoal_arrowhandle_gray@3x.png")
        thumbImageView.selectedImage = UIImage(named: "newgoal_arrowhandle_lightgreen@3x.png")
        thumbImageView.zeroImage = UIImage(named: "newgoal_arrowhandle_gray_up@3x.png")
        
        thumbImageView.userInteractionEnabled = true
        addSubview(thumbImageView)
        
        
        let panGesture = UIPanGestureRecognizer(target: self, action:"moveThumb:")
        thumbImageView.addGestureRecognizer(panGesture)
        
        
    }
    
    func moveThumb(gesture:UIPanGestureRecognizer){
        
        let newPoint = gesture.locationInView(self)
        var newCenter = CGPointMake(thumbImageView.center.x, newPoint.y)
        
        
        let halfx = CGRectGetMidX(self.bounds);
        newCenter.x = max(halfx, newCenter.x)
        newCenter.x = min(self.superview!.bounds.size.width - halfx, newCenter.x);
        
        let halfy = CGRectGetMidY(self.bounds);
        newCenter.y = max(0, newCenter.y);
        newCenter.y = min(frame.size.height, newCenter.y);
        
        
        thumbImageView.center = newCenter
        
        
        gesture.setTranslation(CGPointMake(0, 0), inView: self)
        
        println(newPoint.y)
        
        frontView.frame = CGRectMake(0, frame.size.height, frontView.frame.size.width, -(frame.size.height-newCenter.y))
        
        backgroundColor = UIColor.todaitBackgroundGray().colorWithAlphaComponent(newCenter.y/frame.size.height)
        
        
        
        
        if gesture.state == UIGestureRecognizerState.Began {
            
            isThumbed = true
            
            if isMax == true {
               
                thumbImageView.setImageSelected(true)
                
            }else if chartOn == true {
                
                thumbImageView.setImageOn(true)
                
            }else{
                
                thumbImageView.setImageOn(false)
                
            }
            
            currentValue = CGFloat(maxValue) * CGFloat(1 - (newCenter.y/frame.size.height))
            thumbTouchBegan()
            
        }else if gesture.state == UIGestureRecognizerState.Changed{
            
            currentValue = CGFloat(maxValue) * CGFloat(1 - (newCenter.y/frame.size.height))
            thumbTouchMoved()
            
            
        }else if gesture.state == UIGestureRecognizerState.Ended || gesture.state == UIGestureRecognizerState.Cancelled {
            
        
            isThumbed = false
        
            if isMax == true {
                
                thumbImageView.setImageSelected(true)
                
            }else if chartOn == true {
                
                thumbImageView.setImageOn(true)
                
            }else{
                
                thumbImageView.setImageOn(false)
                
            }
            
            thumbTouchEnd()
            
        }
        
        
        if frame.size.height == newCenter.y {
            thumbImageView.setZeroImage()
        }
        
        
        print("\(Int(currentValue/60))시간 \(Int((currentValue%60)))분")
    }
    
    func thumbTouchBegan(){
        
        if let delegate = delegate {
            delegate.thumbTouchBegan()
        }
    }
    
    func thumbTouchMoved(){
        
        if let delegate = delegate {
            delegate.thumbTouchMoved()
        }
    }
    
    func thumbTouchEnd(){
        
        if let delegate = delegate {
            delegate.thumbTouchEnd()
        }
    }
    

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setChartOn(on:Bool){
        
        isMax = false
        thumbImageView.setImageOn(on)
        
        if on == true {
            
            chartOn = true
            frontView.backgroundColor = frontOnColor
        
        }else{
        
            chartOn = false
            frontView.backgroundColor = frontOffColor
            
        }
        
    }
    
    func setChartMax(){
        
        isMax = true
        
        thumbImageView.setImageSelected(true)
        frontView.backgroundColor = maxColor
        
    }
    
    func setMaxValue(maxValue:CGFloat){
        
        self.maxValue = maxValue
        
        var height:CGFloat = 0
        
        if maxValue == 0 {
            height = frame.size.height/2
        }else if currentValue > maxValue {
            height = frame.size.height
        }else{
            height =  CGFloat(currentValue)/CGFloat(maxValue) * frame.size.height
        }
        
        
        
        self.frontView.frame = CGRectMake(0, frame.size.height, frontView.frame.size.width, -height)
        self.thumbImageView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height-height)
        
        backgroundColor = UIColor.todaitBackgroundGray().colorWithAlphaComponent(self.thumbImageView.center.y/frame.size.height)
        
    }
    
    func setStroke(){
        
        setMaxValue(maxValue)
        
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
