
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
    var valueLabel:UILabel!
    var delegate:touchDelegate!
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        
        setupRatio()
        setupDefault()
        setupLineView()
        
        addChart()
        
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
        
        lineView = UIView(frame: CGRectMake(0, 0, 30*ratio, frame.size.height-30*ratio))
        lineView.backgroundColor = UIColor.clearColor()
        lineView.hidden = true
        lineView.layer.cornerRadius = 15*ratio
        
        let line = UIView(frame: CGRectMake(14.75*ratio, 30*ratio, 0.5*ratio,frame.size.height+5*ratio))
        line.backgroundColor = UIColor.todaitPurple()
        line.alpha = 0.9
        lineView.addSubview(line)
        
        
        valueLabel = UILabel(frame: CGRectMake(0, 0, 30*ratio, 30*ratio))
        valueLabel.text = "10"
        valueLabel.textColor = UIColor.whiteColor()
        valueLabel.font = UIFont(name: "AvenirNext-Regular", size: 12*ratio)
        valueLabel.layer.cornerRadius = 15*ratio
        valueLabel.clipsToBounds = true
        valueLabel.backgroundColor = UIColor.todaitPurple()
        valueLabel.textAlignment = NSTextAlignment.Center
        lineView.addSubview(valueLabel)
        
        
        
        addSubview(lineView)
        
    }
    
    func addChart(){
        
        for index in 0...41{
            let chartBox = UIView()
            
            addSubview(chartBox)
            chartBoxs.append(chartBox)
            
        }
    }
    
    func updateChart(values:[CGFloat]){
        
        let originX = padding
        
        let maxValue = maxElement(values)
        
        
        
        for index in 0...values.count-1 {
            
            let originX = (2*CGFloat(index)+1)*frame.size.width/(2*CGFloat(values.count)) - CGFloat(chartWidth/2)
            let chartBox = chartBoxs[index]
            chartBox.backgroundColor = chartColor
            
            var chartHeight:CGFloat! = 0
            
            if maxValue != 0 {
                chartHeight = (values[index]*frame.size.height)/maxValue
            }
            
            chartBox.tag = Int(values[index])
            
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
        
        self.delegate.touchBegin()
        touchPoint(touches, event:event)
        super.touchesBegan(touches, withEvent: event)
        
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        touchPoint(touches, event: event)
        super.touchesMoved(touches,withEvent: event)
        
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        self.delegate.touchEnd()
        lineView.hidden = true
        super.touchesEnded(touches, withEvent: event)
        
    }
    
    
    func touchPoint(touches:NSSet,event:UIEvent){
        let touch: AnyObject? = touches.anyObject()
        let touchPoint:CGPoint! = touch?.locationInView(self)
        let subview:UIView! = hitTest(CGPointMake(touchPoint.x, frame.size.height-1), withEvent: event)
        
        NSLog("%f %f",touchPoint.x,touchPoint.y)
        
        if (touchPoint.x >= 0 && touchPoint.x <= frame.size.width) {
            lineView.hidden = false
            lineView.center = CGPointMake(touchPoint.x, -10*ratio)
            
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
