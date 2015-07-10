//
//  TrendChartView.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 25..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class TrendChartView: UIScrollView {

    
    var ratio:CGFloat! = 0
    var width:CGFloat! = 35

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupRatio()
        
    }
    
    func setupRatio(){
        let screenRect = UIScreen.mainScreen().bounds
        let screenWidth = screenRect.size.width
        ratio = screenWidth/320
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func updateChart(data:[[String:AnyObject]]){
        
        let dataCount = data.count
        
        let axisCount = Int(data[0]["value"]!.count)
        contentSize = CGSizeMake(CGFloat(axisCount)*width, frame.size.height)
        
        
        var maxValue = CGFloat(data[0]["max"]! as! NSNumber)
        
        
        for index in 0...dataCount {
            
            addChart(maxValue,data:data[index])
            
            if index == dataCount-1 {
                break
            }
            
            
        }
        
        addXAxisLabel(data)
    }
    
    func getMaxValue(data:[[String:AnyObject]])->CGFloat{
        
        
        
        
        return 1.0
    }
    
    func addChart(maxValue:CGFloat,data:[String:AnyObject]){
        
        var chartColor:UIColor! = data["color"] as! UIColor
        var chartData:[CGFloat] = data["value"] as! [CGFloat]
        var dataCount = chartData.count
        var dataPoints:[CGPoint] = []
        
        var path = UIBezierPath()
        path.lineCapStyle = kCGLineCapSquare
        
        for index in 0...dataCount {
            
            var nextPoint = CGPointMake(CGFloat(index) * 40*ratio+15*ratio, CGFloat(frame.size.height-30*ratio)*(1-chartData[index]/(maxValue*1.5)))
            dataPoints.append(nextPoint)
            
            
            let pointView = UIView(frame:CGRectMake(0, 0, 4*ratio, 4*ratio))
            pointView.clipsToBounds = true
            pointView.layer.cornerRadius = 2*ratio
            pointView.backgroundColor = chartColor
            pointView.center = nextPoint
            addSubview(pointView)
            
            if index == 0 {
                path.moveToPoint(nextPoint)
            }else{
                path.addLineToPoint(nextPoint)
            }
            
            
            if index == dataCount-1 {
                break
            }
        }
        
        
        var chartLayer = CAShapeLayer()
        chartLayer.strokeColor = chartColor.CGColor
        chartLayer.fillColor = UIColor.clearColor().CGColor
        chartLayer.lineWidth = 1*ratio
        chartLayer.path = path.CGPath
        chartLayer.strokeEnd = 1.0
        chartLayer.strokeStart = 0.0
        layer.addSublayer(chartLayer)
        
        
    }
    
    func addXAxisLabel(data:[[String:AnyObject]]){
    
        var dataCount = Int(data[0]["value"]!.count)
        
        for index in 0...dataCount{
            
            let xAxisLabel = UILabel(frame: CGRectMake(0, 0, 60*ratio, 20*ratio))
            xAxisLabel.text = "\(index+1)" + "일차"
            xAxisLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 10*ratio)
            xAxisLabel.textColor = UIColor.todaitGray()
            xAxisLabel.textAlignment = NSTextAlignment.Center
            addSubview(xAxisLabel)
            
            
            xAxisLabel.center = CGPointMake(CGFloat(index) * 40*ratio+15*ratio, frame.size.height - 15*ratio)
            
            if dataCount-1 == index {
                break
            }
        }
    }
    
    
    
}
