//
//  WeekChartView.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 4..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class InvestChartView: UIView {
    
    
    var barLabels: [UILabel]! = []
    var barCharts: [UIView]! = []
    var chartNames: [String]!
    var times: [Int] = []
    
    let DEFAULT_LABEL_WIDTH: CGFloat = 50.0
    let DEFAULT_LABEL_HEIGHT: CGFloat = 30.0
    let DEFAULT_CHART_WIDTH: CGFloat = 25.0
    let DEFAULT_CHART_INTERVAL: CGFloat = 12.0
    
    let weekName:[String] = ["일","월","화","수","목","금","토"]
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        setupChart()
        
        
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
            
            var time:Int = Int(rand()%300)
            
            
            let label = UILabel(frame: CGRectMake(paddingLabel + interval * CGFloat(index),originY,DEFAULT_LABEL_WIDTH,DEFAULT_LABEL_HEIGHT))
            label.text = weekName[index]
            label.textColor = UIColor.colorWithHexString("#C9C9C9")
            label.textAlignment = NSTextAlignment.Center
            addSubview(label)
            
            
            let timeLabel = UILabel(frame: CGRectMake(paddingLabel + interval * CGFloat(index),originY,DEFAULT_LABEL_WIDTH,DEFAULT_LABEL_HEIGHT))
            timeLabel.text = "\(time/60)시간 \(time%60)분"
            timeLabel.font = UIFont(name: "AvenirNext-Regular", size: 8)
            timeLabel.textColor = UIColor.colorWithHexString("#969696")
            timeLabel.textAlignment = NSTextAlignment.Center
            addSubview(timeLabel)
            
            barCharts.append(chart)
            barLabels.append(label)
            
            times.append(time)
            
            time = time % 80
            
            UIView.animateWithDuration(1.0, animations: { () -> Void in
                chart.frame = CGRectMake(padding + interval * CGFloat(index),originY, self.DEFAULT_CHART_WIDTH, -CGFloat(time))
                
                
                timeLabel.frame = CGRectMake(paddingLabel + interval * CGFloat(index),originY-CGFloat(time)-self.DEFAULT_LABEL_HEIGHT,self.DEFAULT_LABEL_WIDTH,self.DEFAULT_LABEL_HEIGHT)
            })
            
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
