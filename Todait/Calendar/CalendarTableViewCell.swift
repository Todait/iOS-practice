//
//  CalendarTableViewCell.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 3..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class CalendarTableViewCell: UITableViewCell,CalendarDayViewDelegate{
    
    
    
    var dayViews: [CalendarDayView] = []
    var ratio: CGFloat!
    
    var monthDateLabel:UILabel!
    var calendarDate: NSDate!
    var calendar: NSCalendar!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupRatio()
        setupCalendar()
        
        let mainDate = NSDate()
        let cellWidth:CGFloat = 320*ratio / 7
        let cellHeight:CGFloat = 50*ratio
        
        
        addMonthDateLabel()
        
        
        for index in 0...41 {
            
            let i:CGFloat = CGFloat(index)
            let originX:CGFloat = (i%7) * cellWidth
            let originY:CGFloat = CGFloat(Int(i/7)) * cellHeight + 30*ratio
            var dayView = CalendarDayView(frame: CGRectMake(originX,originY,cellWidth, cellHeight))
            dayView.delegate = self
            addSubview(dayView)
            dayViews.append(dayView)
        }
    }
    
    
    
    func dayViewClk(date:NSDate){
        NSLog("%@",date)
    }
    
    func setupRatio(){
        var screenRect = UIScreen.mainScreen().bounds
        var screenWidth : CGFloat = screenRect.size.width
        ratio = screenWidth/320
    }
    
    func setupCalendar(){
        calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
    }
    
    
    func addMonthDateLabel(){
        monthDateLabel = UILabel(frame: CGRectMake(0, 5*ratio, 320*ratio, 25*ratio))
        monthDateLabel.textAlignment = NSTextAlignment.Center
        monthDateLabel.textColor = UIColor.colorWithHexString("#969696")
        monthDateLabel.font = UIFont(name: "AvenirNext-Regular", size: 20*ratio)
        monthDateLabel.text = "6월"
        addSubview(monthDateLabel)
    }
    
    func setupDate(date:NSDate){
        calendarDate = date
        

        
        
        
        let firstDate = getFirstDate(calendarDate)
        let lastDate = getLastDate(calendarDate)
        
        let startDayIndexOfDateButton = getStartIndexFromDate(firstDate)
        let lastDayIndexOfDateButton = startDayIndexOfDateButton + getLastDateDay(lastDate)
        
        
        let comp = calendar.components(NSCalendarUnit.CalendarUnitYear|NSCalendarUnit.CalendarUnitMonth|NSCalendarUnit.CalendarUnitDay, fromDate:date)
        
        
        
        for index in 0...41 {
            let dayView = dayViews[index]
            dayView.dayLabel.text = ""
            
            if index%7 == 0 || index%7 == 6 {
                dayView.dayLabel.textColor = UIColor.colorWithHexString("#FFFB887E")
            }
            
            
            if index >= startDayIndexOfDateButton && index < lastDayIndexOfDateButton {
                
                comp.day = index
                
                let dayView = dayViews[index]
                dayView.dayLabel.text = String(index-startDayIndexOfDateButton+1)
                dayView.date = calendar.dateFromComponents(comp)
                
                
                if index % 8 == 0 {
                    dayView.dayLabel.backgroundColor = UIColor.todaitPurple()
                    dayView.dayLabel.textColor = UIColor.whiteColor()
                    dayView.selected = 1
                }else if index % 5 == 0 {
                    dayView.dayLabel.backgroundColor = UIColor.todaitRed()
                    dayView.dayLabel.textColor = UIColor.whiteColor()
                    dayView.selected = 1
                }else{
                    //dayView.dayLabel.backgroundColor = UIColor.whiteColor()
                    //dayView.dayLabel.textColor = UIColor.colorWithHexString("#969696")
                    //dayView.selected = 0
                }
                
            }
            
            
        }
        
        
        
        
        
        
    }
    
    func getFirstDate(date:NSDate)->NSDate{
        
        let firstDayOfMonthComp = calendar.components(NSCalendarUnit.CalendarUnitYear|NSCalendarUnit.CalendarUnitMonth|NSCalendarUnit.CalendarUnitDay|NSCalendarUnit.CalendarUnitWeekday, fromDate:date)
        firstDayOfMonthComp.day = 1
        let firstDate:NSDate = calendar.dateFromComponents(firstDayOfMonthComp)!
        
        return firstDate
    }
    
    func getLastDate(date:NSDate)->NSDate{
        let lastDayOfMonthComp = calendar.components(NSCalendarUnit.CalendarUnitYear|NSCalendarUnit.CalendarUnitMonth|NSCalendarUnit.CalendarUnitDay, fromDate:date)
        lastDayOfMonthComp.month = lastDayOfMonthComp.month+1
        lastDayOfMonthComp.day = 0
        
        let lastDate:NSDate = calendar.dateFromComponents(lastDayOfMonthComp)!
        
        return lastDate
    }
    
    func getStartIndexFromDate(firstDate:NSDate)->Int{
        
        let firstDayOfWeek = getDayOfWeek(firstDate)
        
        return firstDayOfWeek%7
    }
    
    func getDayOfWeek(date:NSDate)->Int{
        
        let dayOfWeek = calendar.components(NSCalendarUnit.CalendarUnitWeekday, fromDate:date)
        
        return dayOfWeek.weekday
    }
    
    
    func getLastDateDay(lastDate:NSDate)->Int{
        
        let dayComp = calendar.components(NSCalendarUnit.CalendarUnitDay, fromDate:lastDate)
        
        return dayComp.day
        
    }
    

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
