
//
//  TimeChart.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 12..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit


protocol touchDelegate: NSObjectProtocol {
    
    
    func touchEnd()
    func touchBegin();
    
}


class TimeChart: UIView {

    
    var ratio:CGFloat = 0
    var chartBoxs:[UIView] = []
    var direction:weekChartDirection! = weekChartDirection.upDirection
    var chartWidth:CGFloat = 6
    var chartColor:UIColor!
    var padding:CGFloat = 2
    
    var lineView:UIView!
    var line:UIView!
    var valueLabel:UILabel!
    var delegate:touchDelegate?
    
    var yAxiss:[UILabel]! = []
    
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        
        setupRatio()
        setupDefault()
        addYAxis(frame)
        addChart()
        
        setupLineView()
    
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupRatio(){
        let screenRect = UIScreen.mainScreen().bounds
        let screenWidth = screenRect.size.width
        ratio = screenWidth/320
    }
    
    func setupDefault(){
        chartColor = UIColor.todaitLightGray()
    }
    
    func setupLineView(){
        
        lineView = UIView(frame: CGRectMake(0, -20*ratio, 25*ratio, 15*ratio))
        lineView.backgroundColor = UIColor.clearColor()
        lineView.hidden = true
        lineView.layer.cornerRadius = 5*ratio
        
        line = UIView(frame: CGRectMake(12.25*ratio, 15*ratio, 0.5*ratio,frame.size.height))
        line.backgroundColor = UIColor.todaitPurple()
        line.alpha = 0.9
        lineView.addSubview(line)
        
        
        valueLabel = UILabel(frame: CGRectMake(0*ratio, 0*ratio, 25*ratio, 15*ratio))
        valueLabel.text = "0"
        valueLabel.textColor = UIColor.whiteColor()
        valueLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 10*ratio)
        valueLabel.layer.cornerRadius = 10*ratio
        valueLabel.clipsToBounds = true
        valueLabel.backgroundColor = UIColor.clearColor()
        valueLabel.textAlignment = NSTextAlignment.Center
        valueLabel.adjustsFontSizeToFitWidth = true
        
        lineView.addSubview(valueLabel)
        
        
        
        addSubview(lineView)
        
    }
    
    
    
    func addYAxis(frame:CGRect){
        for index in 0...3 {
            
            let originY = CGFloat(3-index) * (frame.size.height/4)
            
            let yAxis = UILabel(frame:CGRectMake(0,originY-5*ratio,40*ratio,10*ratio))
            yAxis.textAlignment = NSTextAlignment.Left
            yAxis.font = UIFont(name:"AppleSDGothicNeo-Regular",size:7*ratio)
            yAxis.text = "1"
            yAxis.textColor = UIColor.grayColor()
            addSubview(yAxis)
            
            
            let lineWidth = frame.size.width - 40*ratio
            let yLine = UIView(frame:CGRectMake(30*ratio,originY,lineWidth,0.5*ratio))
            yLine.backgroundColor = UIColor.todaitLightGray().colorWithAlphaComponent(0.9)
            addSubview(yLine)
            
            yAxiss.append(yAxis)
        }
    }
    
    func addChart(){
        
        for index in 0...47{
            let chartBox = UIView()
            
            addSubview(chartBox)
            chartBoxs.append(chartBox)
            
        }
    }
    
    func updateChart(values:[CGFloat]){
        
        let originX = padding
        
        let maxValue = maxElement(values)
        
        
        for index in 0...3 {
            let label = yAxiss[index]
            label.text = "\(maxValue*CGFloat(index+1)/4)"
        }
        
        lineView.backgroundColor = chartColor
        
        
        for index in 0...values.count-1 {
            
            let originX = (2*CGFloat(index)+1)*frame.size.width/(2*CGFloat(values.count)) - CGFloat(chartWidth/2)
            let chartBox = chartBoxs[index]
            chartBox.backgroundColor = chartColor
            
            var chartHeight:CGFloat! = 0
            
            if maxValue != 0 {
                chartHeight = (values[index]*frame.size.height)/maxValue
            }
            
            chartBox.tag = Int(values[index])
            
            if chartHeight == 0{
                chartBox.backgroundColor = UIColor.todaitGray()
                chartHeight = 5
            }
            
            
            if direction == weekChartDirection.upDirection {
                chartBox.frame = CGRectMake(originX, frame.size.height, chartWidth,0)
                
                UIView.animateWithDuration(1.5, animations: { () -> Void in
                    chartBox.frame = CGRectMake(originX, self.frame.size.height, self.chartWidth,-1*chartHeight)
                })
            }else if direction == weekChartDirection.downDirection {
                chartBox.frame = CGRectMake(originX, 0, chartWidth,0)
                
                UIView.animateWithDuration(1.5, animations: { () -> Void in
                    chartBox.frame = CGRectMake(originX, 0, self.chartWidth,chartHeight)
                })
            }
            
        }
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        if let delegate = delegate{
            if delegate.respondsToSelector("touchBegin"){
                 delegate.touchBegin()
            }
        }
        
        touchPoint(touches, event:event)
        super.touchesBegan(touches, withEvent: event)
        
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        touchPoint(touches, event: event)
        super.touchesMoved(touches,withEvent: event)
        
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        if let delegate = delegate{
            if delegate.respondsToSelector("touchEnd"){
                delegate.touchEnd()
            }
        }
        
        lineView.hidden = true
        super.touchesEnded(touches, withEvent: event)
        
    }
    
    
    func touchPoint(touches:NSSet,event:UIEvent){
        let touch: AnyObject? = touches.anyObject()
        let touchPoint:CGPoint! = touch?.locationInView(self)
        let subview:UIView! = hitTest(CGPointMake(touchPoint.x, frame.size.height-1), withEvent: event)
        
        
        lineView.backgroundColor = chartColor
        line.backgroundColor = chartColor
        
        NSLog("%f %f",touchPoint.x,touchPoint.y)
        
        if (touchPoint.x >= 0 && touchPoint.x <= frame.size.width) {
            lineView.hidden = false
            lineView.center = CGPointMake(touchPoint.x, lineView.center.y)
            
            if subview.frame.size.width == chartWidth {
                
                if let tag = subview?.tag {
                    
                    valueLabel.text = "\(subview.tag)"
                }
                
            }

        }
        
        
        
        /*
        if ([subview isKindOfClass:[PNBar class]] && [self.delegate respondsToSelector:@selector(userClickedOnBarAtIndex:)]) {
            [self.delegate userClickedOnBarAtIndex:subview.tag];
        }
        */

    }
}
