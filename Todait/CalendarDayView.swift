//
//  CalendarDayView.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 5..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit
protocol CalendarDayViewDelegate: NSObjectProtocol {
    
    func dayViewClk(date:NSDate)
    
}


class CalendarDayView: UIView {

    
    var dayLabel: UILabel!
    var ratio: CGFloat!
    var delegate: CalendarDayViewDelegate!
    var date: NSDate!
    var selected: NSInteger! = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupRatio()
        addDayLabel()
        addTapGesture()
    
    }
    
    func setupRatio(){
        var screenRect = UIScreen.mainScreen().bounds
        var screenWidth : CGFloat = screenRect.size.width
        ratio = screenWidth/320
    }
    
    func addDayLabel(){
        
        let rect = CGRectMake(0, 0, 30*ratio,30*ratio)
        let center = CGPointMake(frame.width/2, frame.height/2)
        
        dayLabel = UILabel(frame:rect)
        dayLabel.center = center
        dayLabel.text = ""
        dayLabel.font = UIFont(name: "AvenirNext-Regular", size: 14*ratio)
        dayLabel.textColor = UIColor.colorWithHexString("#969696")
        dayLabel.textAlignment = NSTextAlignment.Center
        dayLabel.layer.cornerRadius = 15*ratio
        dayLabel.clipsToBounds = true
        
        addSubview(dayLabel)
    }
    
    func addTapGesture(){
        
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector("dayViewClk"))
        addGestureRecognizer(tapGesture)
    }
    
    func dayViewClk(){
        
        if selected == 1 {
            dayLabel.textColor = UIColor.todaitGray()
            dayLabel.backgroundColor = UIColor.whiteColor()
            selected = 0
        }else{
            dayLabel.textColor = UIColor.whiteColor()
            dayLabel.backgroundColor = UIColor.colorWithHexString("#42C19E")
            selected = 1
        }
        
        
        if self.delegate.respondsToSelector("dayViewClk:"){
            self.delegate.dayViewClk(date)
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
