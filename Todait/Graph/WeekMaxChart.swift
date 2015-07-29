//
//  WeekChart.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 12..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit


enum weekChartDirection:Int{
    case upDirection
    case downDirection
}


class WeekMaxChart: UIView {
    
    
    var ratio:CGFloat = 0
    
    var frontCharts:[UIView] = []
    var backCharts:[UIView] = []
    var valueLabels:[UILabel] = []
    
    var direction:weekChartDirection! = weekChartDirection.upDirection
    var chartWidth:CGFloat = 35
    
    var frontColor:UIColor!
    var backColor:UIColor!
    
    var chartFont:UIFont!
    
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
        frontColor = UIColor.todaitRed()
        backColor = UIColor.todaitLightGray()
        chartFont = UIFont(name: "AppleSDGothicNeo-Regular", size: 10*ratio)
    }
    
    
    func addChart(){
        
        for index in 0...6{
            let frontChart = UIView()
            let backChart = UIView()
            let valueLabel = UILabel()
            
            valueLabel.adjustsFontSizeToFitWidth = true
            valueLabel.textAlignment = NSTextAlignment.Center
            
            addSubview(backChart)
            addSubview(frontChart)
            addSubview(valueLabel)
            
            frontCharts.append(frontChart)
            backCharts.append(backChart)
            valueLabels.append(valueLabel)
            
        }
    }
    
    func updateTimeChart(values:[[String:NSNumber]]){
        
        let originX = padding
        
        let maxValue = getMaxElement(values)
        let maxHeight = frame.size.height-14*ratio
        
        
        
        for index in 0...6 {
            
            let originX = (2*CGFloat(index)+1)*frame.size.width/14 - CGFloat(chartWidth/2)
            
            let frontChart = frontCharts[index]
            frontChart.layer.cornerRadius = chartWidth/2
            frontChart.clipsToBounds = true
            
            let backChart = backCharts[index]
            backChart.layer.cornerRadius = chartWidth/2
            backChart.clipsToBounds = true
            
            let valueLabel = valueLabels[index]
            
            
            var doneAmount:CGFloat! = CGFloat(values[index]["done"]!)
            var expectAmount:CGFloat! = CGFloat(values[index]["expect"]!)
            
            frontChart.backgroundColor = frontColor
            backChart.backgroundColor = backColor
            valueLabel.textColor = frontColor
            valueLabel.font = chartFont
            valueLabel.text = getTimeStringOfTwoArgumentsFromSeconds(NSTimeInterval(doneAmount))
            
            var doneHeight:CGFloat! = 0
            var expectHeight:CGFloat! = 0
            
            if maxValue != 0 {
                expectHeight = (expectAmount*maxHeight)/maxValue
                doneHeight = (doneAmount/expectAmount) * expectHeight
                
            }else{
                
                expectHeight = chartWidth
                doneHeight = 0
            }
            
            
            if expectHeight == 0 {
                expectHeight = chartWidth
                doneHeight = 0
            }
            
            
            if expectHeight < doneHeight {
                expectHeight = doneHeight
            }
            
            
            
            if direction == weekChartDirection.upDirection {
                
                
                valueLabel.frame = CGRectMake(originX-3*ratio, self.frame.size.height - 20*ratio, chartWidth+6*ratio, 10*ratio)
                frontChart.frame = CGRectMake(originX, self.frame.size.height, chartWidth,0)
                backChart.frame = CGRectMake(originX, frame.size.height, chartWidth ,-1*expectHeight)
                
                
                UIView.animateWithDuration(1.5, animations: { () -> Void in
                    
                    valueLabel.frame = CGRectMake(originX-3*self.ratio, backChart.frame.origin.y - 15*self.ratio, self.chartWidth+6*self.ratio, 10*self.ratio)
                    frontChart.frame = CGRectMake(originX, self.frame.size.height, self.chartWidth,-1*doneHeight)
                    
                })
            }else if direction == weekChartDirection.downDirection {
                
                /*
                chartBox.frame = CGRectMake(originX, 0, chartWidth,0)
                
                UIView.animateWithDuration(1.5, animations: { () -> Void in
                chartBox.frame = CGRectMake(originX, 0, self.chartWidth,chartHeight)
                })
                */
            }
            
        }
        
    }

    
    func updateChart(values:[[String:NSNumber]]){
        
        let originX = padding
        
        let maxValue = getMaxElement(values)
        let maxHeight = frame.size.height-14*ratio
        
        
        
        for index in 0...6 {
            
            let originX = (2*CGFloat(index)+1)*frame.size.width/14 - CGFloat(chartWidth/2)
            
            let frontChart = frontCharts[index]
            frontChart.layer.cornerRadius = chartWidth/2
            frontChart.clipsToBounds = true
            
            let backChart = backCharts[index]
            backChart.layer.cornerRadius = chartWidth/2
            backChart.clipsToBounds = true
            
            let valueLabel = valueLabels[index]
            
            
            var doneAmount:CGFloat! = CGFloat(values[index]["done"]!)
            var expectAmount:CGFloat! = CGFloat(values[index]["expect"]!)
            
            frontChart.backgroundColor = frontColor
            backChart.backgroundColor = backColor
            valueLabel.textColor = frontColor
            valueLabel.font = chartFont
            valueLabel.text = String(format: "%.0f", doneAmount)
            
            var doneHeight:CGFloat! = 0
            var expectHeight:CGFloat! = 0
            
            if maxValue != 0 {
                expectHeight = (expectAmount*maxHeight)/maxValue
                doneHeight = (doneAmount/expectAmount) * expectHeight
            
            }else{
                
                expectHeight = chartWidth
                doneHeight = 0
            }
            
            
            if expectHeight == 0 {
                doneHeight = 0
                expectHeight = chartWidth
            }
            
            
            if expectHeight < doneHeight {
                expectHeight = doneHeight
            }
            
            
            
            if direction == weekChartDirection.upDirection {
                
                
                valueLabel.frame = CGRectMake(originX-3*ratio, self.frame.size.height, chartWidth+6*ratio, 10*ratio)
                frontChart.frame = CGRectMake(originX, self.frame.size.height, chartWidth,0)
                backChart.frame = CGRectMake(originX, frame.size.height, chartWidth ,-1*expectHeight)
                
                
                UIView.animateWithDuration(1.5, animations: { () -> Void in
                    
                    valueLabel.frame = CGRectMake(originX-3*self.ratio, backChart.frame.origin.y - 15*self.ratio, self.chartWidth+6*self.ratio, 10*self.ratio)
                    frontChart.frame = CGRectMake(originX, self.frame.size.height, self.chartWidth,-1*doneHeight)
                    
                })
            }else if direction == weekChartDirection.downDirection {
                
                /*
                chartBox.frame = CGRectMake(originX, 0, chartWidth,0)
                
                UIView.animateWithDuration(1.5, animations: { () -> Void in
                    chartBox.frame = CGRectMake(originX, 0, self.chartWidth,chartHeight)
                })
                */
            }
            
        }
        
    }
    
    
    func getMaxElement(data:[[String:NSNumber]])->CGFloat {
        
        var maxValue:CGFloat = 0
        
        for index in 0...6 {
         
            if maxValue < CGFloat(data[index]["done"]!) {
                maxValue = CGFloat(data[index]["done"]!)
            }
            
            if maxValue < CGFloat(data[index]["expect"]!){
                maxValue = CGFloat(data[index]["expect"]!)
            }
            
        }
        
        return maxValue
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
