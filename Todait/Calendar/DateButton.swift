//
//  dateButton.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 28..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class DateButton: UIButton {

    
    var dateNumber:NSNumber!
    var backgroundChart:UIView!
    var frontChart:UIView!
    var ratio:CGFloat! = 0
    var width:CGFloat! = 0
    var height:CGFloat! = 0
    var delegate:CalendarDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupRatio()
        addChartView()
        setupEvent()
    }
    
    
    func setupRatio(){
        let screenRect = UIScreen.mainScreen().bounds
        let screenWidth = screenRect.size.width
        ratio = screenWidth/320
        width = 320*ratio/7
        height = 48*ratio
    }
    
    func addChartView(){
        
        backgroundChart = UIView(frame: CGRectMake(2*ratio, 33*ratio,width - 4*ratio, 3*ratio))
        backgroundChart.backgroundColor = UIColor.todaitBackgroundGray()
        addSubview(backgroundChart)
        
        
        frontChart = UIView(frame: CGRectMake(0, 0, 15*ratio, 3*ratio))
        frontChart.backgroundColor = UIColor.todaitRed()
        backgroundChart.addSubview(frontChart)
        
        backgroundChart.hidden = true
    }
    
    func updateChart(value:CGFloat){
        if value == 0 {
            backgroundChart.hidden = true
        }else{
            backgroundChart.hidden = false
            frontChart.frame = CGRectMake(0, 0, backgroundChart.frame.size.width * value, 3*ratio)
            
            if value < 0.33 {
                frontChart.backgroundColor = UIColor.todaitRed()
            }else if value < 0.66 {
                frontChart.backgroundColor = UIColor.todaitYellow()
            }else {
                frontChart.backgroundColor = UIColor.todaitGreen()
            }
        }
    }
    
    func setupEvent(){
        
        addTarget(self, action: Selector("dateUpdate"), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    
    
    func dateUpdate(){
        
        
        self.backgroundColor = UIColor.todaitWhiteGray()
        if self.delegate.respondsToSelector("updateDate:from:"){
            self.delegate.updateDate(getDateFromDateNumber(dateNumber),from:"button")
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
