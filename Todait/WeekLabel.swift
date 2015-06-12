//
//  WeekChartLabel.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 11..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import Foundation

class WeekLabel: UIView{
    let weekNames:[String] = ["일","월","화","수","목","금","토"]
    
    var weekLabels:[UILabel] = []
    var ratio:CGFloat!
    var weekFont:UIFont!
    var weekColor:UIColor!
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupRatio()
        setupDefault()
        setupLabels(frame)
    }
    
    func setupRatio(){
        let screenRect = UIScreen.mainScreen().bounds
        let screenWidth = screenRect.size.width
        ratio = screenWidth/320
    }
    
    func setupDefault(){
        weekFont = UIFont(name: "AvenirNext-Regular", size: 12*ratio)
        weekColor = UIColor.todaitLightGray()
    }
    
    func setupLabels(frame: CGRect){
        
        let labelWidth = frame.size.width/7
        let labelHeight = frame.size.height
        
        for index in 0...6{
            
            let label = UILabel(frame: CGRectMake(CGFloat(index)*labelWidth, 0, labelWidth,labelHeight))
            label.font = UIFont(name:"AvenirNext-Regular", size: 10*ratio)
            label.textColor = UIColor.todaitLightGray()
            label.textAlignment = NSTextAlignment.Center
            addSubview(label)
            
            weekLabels.append(label)
        }
    }
    
    func updateLabelText(strings:[String]){
        
        
        for index in 0...6{
            let label = weekLabels[index]
            label.text = strings[index]
            label.font = weekFont
            label.textColor = weekColor
        }
    }
      
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
}
