//
//  TimerView.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 15..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class TimerView: UIView {
    
    
    var ratio:CGFloat! = 0
    var timerLabel:UILabel!
    
    var timerBezierPath:UIBezierPath!
    
    var timerBackLayer:CAShapeLayer!
    var timerFrontLayer:CAShapeLayer!
    
    var timerFrontOrigin:CGFloat! = 0
    var timerFrontDestination:CGFloat! = 1
    
    
    var timer:NSTimer!
    
    var timerCount:Int! = 0
    
    let DEFAULT_START_ANGLE : CGFloat = -89.0
    let DEFAULT_END_ANGLE : CGFloat = -89.00001
    let DEFAULT_LINE_WIDTH : CGFloat = 20.0
    
    
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        setupRatio()
        settimerBezierPath()
        
        
        addBackLayer()
        addFrontLayer()
        addTimerLabel()
    }

    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupRatio(){
        let screenRect = UIScreen.mainScreen().bounds
        let screenWidth = screenRect.size.width
        ratio = screenWidth/320
    }
    
    
    func settimerBezierPath(){
        timerBezierPath = UIBezierPath(arcCenter:getCenter(), radius:self.frame.size.width/2 - DEFAULT_LINE_WIDTH/2, startAngle: degreeToRadians(DEFAULT_START_ANGLE), endAngle: degreeToRadians(DEFAULT_END_ANGLE), clockwise: true) as UIBezierPath!
        
    }
    
    
    func degreeToRadians(angle: CGFloat) -> CGFloat{
        return (angle)/180.0 * CGFloat(M_PI)
    }
    
    
    func addBackLayer(){
        
        
        timerBackLayer = CAShapeLayer()
        timerBackLayer.path = timerBezierPath.CGPath
        timerBackLayer.fillColor = UIColor.clearColor().CGColor
        timerBackLayer.strokeColor = UIColor.todaitLightGray().CGColor
        timerBackLayer.strokeStart = 0.0
        timerBackLayer.strokeEnd = 1.0
        timerBackLayer.lineWidth = DEFAULT_LINE_WIDTH
        timerBackLayer.lineCap = kCALineCapRound
        timerBackLayer.frame = CGRectMake(0, 0, frame.size.width,frame.size.height)
        self.layer .addSublayer(timerBackLayer)
    }
    
    
    func addFrontLayer(){
        timerFrontLayer = CAShapeLayer()
        timerFrontLayer.path = timerBezierPath.CGPath
        timerFrontLayer.fillColor = UIColor.clearColor().CGColor
        //timerFrontLayer.strokeColor = timerColor.CGColor
        timerFrontLayer.strokeStart = 0.0
        timerFrontLayer.strokeEnd = 0.0
        timerFrontLayer.lineWidth = DEFAULT_LINE_WIDTH
        timerFrontLayer.lineCap = kCALineCapButt
        timerFrontLayer.frame = CGRectMake(0, 0, frame.size.width,frame.size.height)
        self.layer .addSublayer(timerFrontLayer)
        
    }
    
    func addTimerLabel(){
        let centerX = frame.size.width/2
        let centerY = frame.size.height/2
        timerLabel = UILabel(frame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))
        timerLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 70*ratio)
        timerLabel.text = "55%"
        timerLabel.textAlignment = NSTextAlignment.Center
        timerLabel.center = CGPointMake(centerX, centerY)
        self.addSubview(timerLabel)
    }
    
    
    func setLineWidth(width:CGFloat){
        timerBezierPath = UIBezierPath(arcCenter: getCenter(), radius:self.frame.size.width/2 - width/2, startAngle: degreeToRadians(DEFAULT_START_ANGLE), endAngle: degreeToRadians(DEFAULT_END_ANGLE), clockwise: true) as UIBezierPath!
        
        updateBezierPath()
    }
    
    func getCenter()->CGPoint{
        let centerX = frame.size.width/2
        let centerY = frame.size.height/2
        return CGPointMake(centerX, centerY)
    }
    
    func updateBezierPath(){
        timerBackLayer.path = timerBezierPath.CGPath
        timerFrontLayer.path = timerBezierPath.CGPath
    }
    
    
    func setTimerColor(color:UIColor){
        
        timerFrontLayer.strokeColor = color.CGColor
        timerBackLayer.strokeColor = color.colorWithAlphaComponent(0.4).CGColor
        timerLabel.textColor = color
        
    }
    
    func startAnimation(){
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.fromValue = timerFrontOrigin
        animation.toValue = timerFrontDestination
        animation.duration = 120
        
        timerFrontLayer.addAnimation(animation, forKey: "timerAnimation")
        
        
        startTimer()
    }
    
    func startTimer(){
        
        timer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(1/60), target: self, selector: Selector("timerCountDown"), userInfo: nil, repeats: true)
        timerCount = 0
    }
    
    func timerCountDown(){
        timerCount = timerCount + 1
        timerLabel.text = "\(timerCount/60):\(timerCount%60)"
        
        if timerCount == 120*60 {
            timer.invalidate()
        }
        
        timerFrontLayer.strokeEnd =  CGFloat(timerCount/(120*60))
    }
    
    func endAnimation(){
        timerFrontLayer.strokeEnd = CGFloat(timerCount/(120*60))
        timerFrontLayer.removeAllAnimations()
        timer.invalidate()
    }
}
