//
//  WeekCalendarCell.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 24..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit


class DetailWeekCalendarCell: UICollectionViewCell {
    
    var ratio:CGFloat! = 0
    var buttons:[DetailDateButton]! = []
    var dayLabels:[UILabel]! = []
    
    
    var width:CGFloat! = 0
    var height:CGFloat! = 0
    var dateNumber:NSNumber!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupRatio()
        setupButtons()
        setupDayLabels()
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupRatio(){
        let screenRect = UIScreen.mainScreen().bounds
        let screenWidth = screenRect.size.width
        ratio = screenWidth/320
        width = 310*ratio/7
        height = 49*ratio
    }
    
    func setupButtons(){
        
        for index in 0...6 {
            
            
            let i = Int(index)
            
            let originX = CGFloat(i%7)*width + 5*ratio
            
            let button = DetailDateButton(frame:CGRectMake(originX, 0, width, 49*ratio))
            button.backgroundColor = UIColor.clearColor()
            button.setTitleColor(UIColor.todaitGray(), forState: UIControlState.Normal)
            button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Ultralight", size: 19*ratio)
            buttons.append(button)
            addSubview(button)
        }
    }
    
    func setupDayLabels(){
        
        for index in 0...6 {
            
            
            let i = Int(index)
            
            let originX = CGFloat(i%7)*width + 5*ratio
            
            let label = UILabel(frame:CGRectMake(originX, 23*ratio, width, 20*ratio))
            label.backgroundColor = UIColor.clearColor()
            label.textColor = UIColor.todaitGray()
            label.font = UIFont(name: "AppleSDGothicNeo-Ultralight", size: 19*ratio)
            label.textAlignment = NSTextAlignment.Center
            
            dayLabels.append(label)
            addSubview(label)
        }
        
    }
    
}
