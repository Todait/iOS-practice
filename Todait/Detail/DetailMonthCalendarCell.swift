//
//  WeekCalendarCell.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 24..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class DetailMonthCalendarCell: UICollectionViewCell {
    
    
    var dayLabel:UILabel!
    var ratio:CGFloat! = 0
    var buttons:[DetailDateButton]! = []
    var dayLabels:[UILabel]! = []
    
    
    var width:CGFloat! = 0
    var height:CGFloat! = 0
    var dateNumber:NSNumber!
    var delegate:CalendarDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupRatio()
        setButtons()
        setupDayLabels()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupRatio(){
        let screenRect = UIScreen.mainScreen().bounds
        let screenWidth = screenRect.size.width
        ratio = screenWidth/320
        width = 320*ratio/7
        height = 60*ratio
    }
    
    func setButtons(){
        
        for index in 0...41 {
            
            let i = Int(index)
            
            let originX = CGFloat(i%7)*width
            let originY = CGFloat(i/7)*height
            
            let button = DetailDateButton(frame: CGRectMake(originX, originY, width, height))
            button.setTitleColor(UIColor.todaitGray(), forState: UIControlState.Normal)
            button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Light", size: 19*ratio)
            buttons.append(button)
            addSubview(button)
        }
        
    }
    
    func setupDayLabels(){
        
        for index in 0...41 {
            
            
            let i = Int(index)
            
            let originX = CGFloat(i%7)*width
            let originY = CGFloat(i/7)*height
            
            let label = UILabel(frame:CGRectMake(originX, 33*ratio + originY, width, 20*ratio))
            label.backgroundColor = UIColor.clearColor()
            label.textColor = UIColor.todaitGray()
            label.font = UIFont(name: "AppleSDGothicNeo-Light", size: 19*ratio)
            label.textAlignment = NSTextAlignment.Center
            
            dayLabels.append(label)
            addSubview(label)
        }
        
    }
    
    
}
