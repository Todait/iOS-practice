//
//  CircleChart.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 4..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class ReverseCircleChart: UIView {
    
    var backgroundLayer: CAShapeLayer!
    var percentLayer: CAShapeLayer!
    var maskLayer: CALayer!
    
    var percentBezierPath: UIBezierPath!
    var ratio : CGFloat!
    
    let DEFAULT_START_ANGLE : CGFloat = -89.00001
    let DEFAULT_END_ANGLE : CGFloat = -89.00000
    let DEFAULT_LINE_WIDTH : CGFloat = 2.5
    
    
    var chartBorderWidth:CGFloat!
    var chartColor:UIColor!
    var lineColor:UIColor!
    var strokeEnd:CGFloat!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupRatio()
        setupDefault()
       
    }
    
    func setupRatio(){
        let screenRect = UIScreen.mainScreen().bounds
        let screenWidth = screenRect.size.width
        ratio = screenWidth/320
    }
    
    func setupDefault(){
        
        chartBorderWidth = DEFAULT_LINE_WIDTH
        lineColor = UIColor.todaitLightGray()
        chartColor = UIColor.todaitGreen()
    }
    
    
    
    func setPercentBezierPath(){
        percentBezierPath = UIBezierPath(arcCenter:getCenter(), radius:self.frame.size.width/2 - chartBorderWidth/2, startAngle: degreeToRadians(DEFAULT_START_ANGLE), endAngle: degreeToRadians(DEFAULT_END_ANGLE), clockwise: false) as UIBezierPath!
        
    }
    
    func degreeToRadians(angle: CGFloat) -> CGFloat{
        return (angle)/180.0 * CGFloat(M_PI)
    }
    
    func addBackgroundLayer(){
        
        
        backgroundLayer = CAShapeLayer()
        backgroundLayer.path = percentBezierPath.CGPath
        backgroundLayer.fillColor = UIColor.clearColor().CGColor
        backgroundLayer.strokeColor = lineColor.CGColor
        backgroundLayer.strokeStart = 0.0
        backgroundLayer.strokeEnd = 1.0
        backgroundLayer.lineWidth = chartBorderWidth
        backgroundLayer.lineCap = kCALineCapSquare
        backgroundLayer.frame = CGRectMake(0, 0, frame.size.width,frame.size.height)
        self.layer .addSublayer(backgroundLayer)
    }
    
    
    
    func addPercentLayer(){
        percentLayer = CAShapeLayer()
        percentLayer.path = percentBezierPath.CGPath
        percentLayer.fillColor = UIColor.clearColor().CGColor
        percentLayer.strokeColor = chartColor.CGColor
        percentLayer.strokeStart = 0.0
        percentLayer.strokeEnd = strokeEnd
        percentLayer.lineWidth = chartBorderWidth
        percentLayer.lineCap = kCALineCapSquare
        percentLayer.frame = CGRectMake(0, 0, frame.size.width,frame.size.height)
        self.layer .addSublayer(percentLayer)
        
    }
    
    
    
    func strokeChart(){
        
        setPercentBezierPath()
        addBackgroundLayer()
        addPercentLayer()
    }
    
    func setLineWidth(width:CGFloat){
        percentBezierPath = UIBezierPath(arcCenter: getCenter(), radius:self.frame.size.width/2 - width/2, startAngle: degreeToRadians(DEFAULT_START_ANGLE), endAngle: degreeToRadians(DEFAULT_END_ANGLE), clockwise: false) as UIBezierPath!
        
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
