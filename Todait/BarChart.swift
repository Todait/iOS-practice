//
//  BarChart.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 4..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit


enum BarChartStyle : Int {
    case HolizontalRound
    case HolizontalSquare
    case VerticalRound
    case VerticalSquare
}


class BarChart: UIView {

    var backgroundLayer: CAShapeLayer!
    var percentLayer: CAShapeLayer!
    var percentBezierPath: UIBezierPath!
    var ratio: CGFloat!
    
    var style: BarChartStyle = BarChartStyle.VerticalRound

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupRatio()
        
        
    }
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setStyle(style:BarChartStyle){
        
    }
    

    func setupRatio(){
        let screenRect = UIScreen.mainScreen().bounds
        let screenWidth = screenRect.size.width
        ratio = screenWidth/320
    }
    
    func setPercentBezierPath(){
        let timerButtonRect = frame
        percentBezierPath = UIBezierPath(rect:frame)
        
    }
    
    func addBackgroundLayer(){
        backgroundLayer = CAShapeLayer()
        backgroundLayer.path = percentBezierPath.CGPath
        backgroundLayer.fillColor = UIColor.clearColor().CGColor
        backgroundLayer.strokeColor = UIColor.lightGrayColor().CGColor
        backgroundLayer.strokeStart = 0.0
        backgroundLayer.strokeEnd = 1.0
        backgroundLayer.lineWidth = frame.size.height
        backgroundLayer.lineCap = kCALineCapRound
        backgroundLayer.frame = CGRectMake(0, 0, frame.size.width,frame.size.height)
        self.layer .addSublayer(backgroundLayer)
    }
    
    func addPercentLayer(){
        percentLayer = CAShapeLayer()
        percentLayer.path = percentBezierPath.CGPath
        percentLayer.fillColor = UIColor.clearColor().CGColor
        percentLayer.strokeColor = UIColor.colorWithHexString("#00D2B1").CGColor
        percentLayer.strokeStart = 0.0
        percentLayer.strokeEnd = 0.5
        percentLayer.lineWidth = frame.size.height
        percentLayer.lineCap = kCALineCapRound
        percentLayer.frame = CGRectMake(0, 0, frame.size.width,frame.size.height)
        self.layer .addSublayer(percentLayer)
        
    }
    
 
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
