//
//  CircleChart.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 4..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class CircleChart: UIView {

    var percentLabel:UILabel!
    var backgroundLayer: CAShapeLayer!
    var percentLayer: CAShapeLayer!
    var maskLayer: CALayer!
    
    var percentBezierPath: UIBezierPath!
    var ratio : CGFloat!
    
    let DEFAULT_START_ANGLE : CGFloat = -89.0
    let DEFAULT_END_ANGLE : CGFloat = -89.00001
    let DEFAULT_LINE_WIDTH : CGFloat = 2.5
    
    var circleColor:UIColor!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupRatio()
        setPercentBezierPath()
        addBackgroundLayer()
        setupCircleColor()
        addPercentLayer()
        addMaskLayer()
        addPercentLabel()
    }
    
    func setupRatio(){
        let screenRect = UIScreen.mainScreen().bounds
        let screenWidth = screenRect.size.width
        ratio = screenWidth/320
    }
    
    
    func setPercentBezierPath(){
        percentBezierPath = UIBezierPath(arcCenter:getCenter(), radius:self.frame.size.width/2 - DEFAULT_LINE_WIDTH/2, startAngle: degreeToRadians(DEFAULT_START_ANGLE), endAngle: degreeToRadians(DEFAULT_END_ANGLE), clockwise: true) as UIBezierPath!
        
    }
    
    func degreeToRadians(angle: CGFloat) -> CGFloat{
        return (angle)/180.0 * CGFloat(M_PI)
    }
    
    func addBackgroundLayer(){
        
        
        backgroundLayer = CAShapeLayer()
        backgroundLayer.path = percentBezierPath.CGPath
        backgroundLayer.fillColor = UIColor.clearColor().CGColor
        backgroundLayer.strokeColor = UIColor.todaitLightGray().CGColor
        backgroundLayer.strokeStart = 0.0
        backgroundLayer.strokeEnd = 1.0
        backgroundLayer.lineWidth = DEFAULT_LINE_WIDTH
        backgroundLayer.lineCap = kCALineCapRound
        backgroundLayer.frame = CGRectMake(0, 0, frame.size.width,frame.size.height)
        self.layer .addSublayer(backgroundLayer)
    }
    
    func setupCircleColor(){
        
        circleColor = UIColor.todaitGreen()
    }
    
    func addPercentLayer(){
        percentLayer = CAShapeLayer()
        percentLayer.path = percentBezierPath.CGPath
        percentLayer.fillColor = UIColor.clearColor().CGColor
        percentLayer.strokeColor = circleColor.CGColor
        percentLayer.strokeStart = 0.0
        percentLayer.strokeEnd = 0.5
        percentLayer.lineWidth = DEFAULT_LINE_WIDTH
        percentLayer.lineCap = kCALineCapRound
        percentLayer.frame = CGRectMake(0, 0, frame.size.width,frame.size.height)
        self.layer .addSublayer(percentLayer)
        
    }
    
    
    func addMaskLayer(){
        
        var background:UIImage = UIImage(named: "graph_bg.png")!
        
        maskLayer = CALayer()
        maskLayer.contents = background
        maskLayer.frame = frame
        //maskLayer.mask = percentLayer
       // maskLayer.
        
        //layer.addSublayer(maskLayer)
        
        
    }
    
    func updatePercent(percent:NSNumber){
        percentLayer.strokeEnd = CGFloat(percent)
        percentLabel.text = "\(Int(percent.floatValue*100))%"
        percentLabel.textColor = circleColor
        percentLayer.strokeColor = circleColor.CGColor
        percentLayer.strokeEnd = CGFloat(percent)
    }
    
    func addPercentLabel(){
        let centerX = frame.size.width/2
        let centerY = frame.size.height/2
        percentLabel = UILabel(frame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))
        percentLabel.backgroundColor = UIColor.clearColor()
        percentLabel.font = UIFont(name: "AvenirNext-Medium", size: 12*ratio)
        percentLabel.text = "55%"
        percentLabel.textAlignment = NSTextAlignment.Center
        percentLabel.textColor = UIColor.todaitOrange()
        percentLabel.center = CGPointMake(centerX, centerY)
        percentLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(percentLabel)
    }

    
    func setLineWidth(width:CGFloat){
        percentBezierPath = UIBezierPath(arcCenter: getCenter(), radius:self.frame.size.width/2 - width/2, startAngle: degreeToRadians(DEFAULT_START_ANGLE), endAngle: degreeToRadians(DEFAULT_END_ANGLE), clockwise: true) as UIBezierPath!
        
        updateBezierPath()
    }
    
    func getCenter()->CGPoint{
        let centerX = frame.size.width/2
        let centerY = frame.size.height/2
        return CGPointMake(centerX, centerY)
    }
    
    func updateBezierPath(){
        backgroundLayer.path = percentBezierPath.CGPath
        percentLayer.path = percentBezierPath.CGPath
        
    }
    

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
