//
//  WeekChart.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 12..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit



class WeekChart: UIView {

    
    var ratio:CGFloat = 0
    var chartBoxs:[UIView] = []
    var direction:weekChartDirection! = weekChartDirection.upDirection
    var chartWidth:CGFloat = 35
    var chartColor:UIColor!
    var padding:CGFloat = 5
    
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        
        setupRatio()
        setupDefault()
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
    
    
    func addChart(){
        
        for index in 0...6{
            let chartBox = UIView()
            
            addSubview(chartBox)
            chartBoxs.append(chartBox)
            
        }
    }
    
    func updateChart(values:[CGFloat]){
        
        let originX = padding
        
        let maxValue = maxElement(values)
        
        for index in 0...6 {
            
            let originX = (2*CGFloat(index)+1)*frame.size.width/14 - CGFloat(chartWidth/2)
            let chartBox = chartBoxs[index]
            chartBox.backgroundColor = chartColor
            chartBox.layer.cornerRadius = chartWidth/2
            chartBox.clipsToBounds = true
            
            var chartHeight:CGFloat! = 0
            
            if maxValue != 0 {
                chartHeight = (values[index]*frame.size.height)/maxValue
            }else{
                chartHeight = 5
            }
            
            
            if chartHeight == 0 {
                
                chartHeight = 5
                chartBox.backgroundColor = UIColor.todaitGray()
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
        
        touchPoint(touches, event:event)
        super.touchesBegan(touches, withEvent: event)
        
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        touchPoint(touches, event: event)
        super.touchesMoved(touches,withEvent: event)
        
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        super.touchesEnded(touches, withEvent: event)
        
    }
    
    
    func touchPoint(touches:NSSet,event:UIEvent){
        let touch: AnyObject? = touches.anyObject()
        let touchPoint:CGPoint! = touch?.locationInView(self)
        var subview:UIView! = UIView()
        
        if direction == weekChartDirection.upDirection {
            subview = hitTest(CGPointMake(touchPoint.x, frame.size.height-1), withEvent: event)
        }else if direction == weekChartDirection.downDirection {
            subview = hitTest(CGPointMake(touchPoint.x, 1), withEvent: event)
        }
        
        if subview.frame.size.width == chartWidth {
            
            UIView.animateWithDuration(0.8, animations: { () -> Void in
                subview.transform = CGAffineTransformMakeScale(1.2,1.2)
            }, completion: { (Bool) -> Void in
                UIView.animateWithDuration(1.5, animations: { () -> Void in
                    subview.transform = CGAffineTransformMakeScale(1,1)
                })
            })
        }
        
        
    }
    
    
}
