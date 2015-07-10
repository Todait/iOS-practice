//
//  WeekCalendarCell.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 24..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class MonthCalendarCell: UICollectionViewCell {
    
    
    var dayLabel:UILabel!
    var ratio:CGFloat! = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupRatio()
        addDayLabels()
        
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupRatio(){
        let screenRect = UIScreen.mainScreen().bounds
        let screenWidth = screenRect.size.width
        ratio = screenWidth/320
    }
    
    func addDayLabels(){
        
        dayLabel = UILabel(frame:CGRectMake(0, 0, 320*ratio/7, 48*ratio))
        dayLabel.textAlignment = NSTextAlignment.Center
        dayLabel.textColor = UIColor.todaitGray()
        dayLabel.font = UIFont(name: "AppleSDGothicNeo-Light", size: 19*ratio)
        addSubview(dayLabel)
        
    }
    
    
}
