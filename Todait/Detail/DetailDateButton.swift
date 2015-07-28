//
//  dateButton.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 28..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class DetailDateButton: UIButton {
    
    
    var dateNumber:NSNumber!
    var backgroundChart:UIView!
    var frontChart:UIView!
    var ratio:CGFloat! = 0
    var width:CGFloat! = 0
    var height:CGFloat! = 0
    var delegate:CalendarDelegate!
    var expectLabel:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupRatio()
        setupEvent()
        
        addExpectLabel()
    }
    
    
    func setupRatio(){
        let screenRect = UIScreen.mainScreen().bounds
        let screenWidth = screenRect.size.width
        ratio = screenWidth/320
        width = 310*ratio/7
        height = 49*ratio
    }
    
    func setupEvent(){
        
        addTarget(self, action: Selector("dateUpdate"), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    
    
    func dateUpdate(){
        
        
        if self.delegate.respondsToSelector("updateDate:from:"){
            self.delegate.updateDate(getDateFromDateNumber(dateNumber),from:"button")
        }
    }
    
    func addExpectLabel(){
        
        
        
        expectLabel = UILabel(frame: CGRectMake(width/2 - 7, 6*ratio, 14, 14))
        
        expectLabel.adjustsFontSizeToFitWidth = true
        expectLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 10)
        expectLabel.textColor = UIColor.whiteColor()
        expectLabel.textAlignment = NSTextAlignment.Center
        expectLabel.backgroundColor = UIColor.clearColor()
        expectLabel.clipsToBounds = true
        expectLabel.layer.cornerRadius = 7
        addSubview(expectLabel)
        
        
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
