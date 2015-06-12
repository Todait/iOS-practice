//
//  WeekChartView.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 4..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class WeekChartView: UIView {
    
    
    var barLabels: [UILabel]! = []
    var barCharts: [UIView]! = []
    var chartNames: [String]!
    
    let weekName:[String] = ["일","월","화","수","목","금","토"]
    
    var ratio:CGFloat = 0
    
    let DEFAULT_LABEL_WIDTH: CGFloat = 50.0
    let DEFAULT_LABEL_HEIGHT: CGFloat = 30.0
    let DEFAULT_CHART_WIDTH: CGFloat = 35.0
    let DEFAULT_CHART_INTERVAL: CGFloat = 9.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupRatio()
        setupChart()
        
        
    }
    
    func setupRatio(){
        let screenRect = UIScreen.mainScreen().bounds
        let screenWidth = screenRect.size.width
        ratio = screenWidth/320
    }
    
    func setupChart(){
        
        let padding = (frame.size.width - 7*DEFAULT_CHART_WIDTH - 6*DEFAULT_CHART_INTERVAL) / 2
        let paddingLabel = (frame.size.width - 6*DEFAULT_CHART_WIDTH - 6*DEFAULT_CHART_INTERVAL - DEFAULT_LABEL_WIDTH) / 2
        
        let interval = DEFAULT_CHART_WIDTH + DEFAULT_CHART_INTERVAL
        let originY = frame.size.height - DEFAULT_LABEL_HEIGHT
        
        for index in 0...6 {
            let chart = UIView(frame: CGRectMake(padding + interval * CGFloat(index),originY, DEFAULT_CHART_WIDTH, 0))
            
            chart.backgroundColor = UIColor.colorWithHexString("#00D2B1")
            addSubview(chart)
            
            
        
            
            let label = UILabel(frame: CGRectMake(paddingLabel + interval * CGFloat(index),originY,DEFAULT_LABEL_WIDTH,DEFAULT_LABEL_HEIGHT))
            label.text = weekName[index]
            label.textColor = UIColor.colorWithHexString("#C9C9C9")
            label.textAlignment = NSTextAlignment.Center
            label.font = UIFont(name: "AvenirNext-Regular", size: 10)
            addSubview(label)
            
            
            
            barCharts.append(chart)
            barLabels.append(label)
            
            
            
        }
        
    }
    
    func updateChart(data:[NSNumber]){
        
        let padding = (frame.size.width - 7*DEFAULT_CHART_WIDTH - 6*DEFAULT_CHART_INTERVAL) / 2
        let interval = DEFAULT_CHART_WIDTH + DEFAULT_CHART_INTERVAL
        let originY = frame.size.height - DEFAULT_LABEL_HEIGHT
        
        for index in 0...6 {
            
            let chart = barCharts[index]
            
            UIView.animateWithDuration(1.0, animations: { () -> Void in
                chart.frame = CGRectMake(padding + interval * CGFloat(index),originY, self.DEFAULT_CHART_WIDTH, -CGFloat(data[index]))
            })
        }
        
    }
    
    
    func updateLabels(title:[String]){
        
        for index in 0...6 {
            let label = barLabels[index]
            label.text = title[index]
        }
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
