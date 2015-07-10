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
    var buttons:[DateButton]! = []
    var width:CGFloat! = 0
    var height:CGFloat! = 0
    var dateNumber:NSNumber!
    var delegate:CalendarDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupRatio()
        setupButtons()
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupRatio(){
        let screenRect = UIScreen.mainScreen().bounds
        let screenWidth = screenRect.size.width
        ratio = screenWidth/320
        width = 320*ratio/7
        height = 48*ratio
    }
    
    func setupButtons(){
        
        for index in 0...6 {
            
            
            let i = Int(index)
            
            let originX = CGFloat(i%7)*width
            
            let button = DateButton(frame:CGRectMake(originX, 32*ratio, width, 20*ratio))
            button.setTitleColor(UIColor.todaitGray(), forState: UIControlState.Normal)
            button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Light", size: 19*ratio)
            buttons.append(button)
            addSubview(button)
        }
    }
    
    
}
