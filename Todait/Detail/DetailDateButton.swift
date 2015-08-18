//
//  dateButton.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 28..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit



enum DateStatus:Int{
    case Progressing
    case Completed
    case Complete
    case UnCompleted
    case UnStart
    case None
}

class DetailDateButton: UIButton {
    
    
    
    
    
    var dateNumber:NSNumber!
    var backgroundChart:UIView!
    var frontChart:UIView!
    var ratio:CGFloat! = 0
    var width:CGFloat! = 0
    var height:CGFloat! = 0
    var delegate:CalendarDelegate?
    var expectLabel:UILabel!
    
    var circleImageView:UIImageView!
    var status:DateStatus!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupRatio()
        setupEvent()
        addCircleImageView()
        addExpectLabel()
        
        self.backgroundColor = UIColor.redColor()
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
        
        if let delegate = delegate {
            if delegate.respondsToSelector("updateDate:from:"){
                delegate.updateDate(getDateFromDateNumber(dateNumber),from:"button")
            }
        }
    }
    
    
    func addCircleImageView(){
        
        
        circleImageView = UIImageView(frame:CGRectMake(width/2 - 7, 6*ratio, 14,14))
        circleImageView.contentMode = UIViewContentMode.ScaleAspectFill
        addSubview(circleImageView)
        
        
        setDateStatus(DateStatus.None)
    }
    
    
    func setDateStatus(status:DateStatus){
        
        self.status = status
        
        switch status {
            
        case .Progressing: circleImageView.image = UIImage(named:"bg_circle_red@3x.png")
        case .Completed: circleImageView.image = UIImage(named:"bg_circle_lightgreen@3x.png")
        case .Complete: circleImageView.image = UIImage(named:"bg_circle_green@3x.png")
        case .UnCompleted: circleImageView.image = UIImage(named:"bg_circle_lightred@3x.png")
        case .UnStart: circleImageView.image = UIImage(named:"bg_circle_gray@3x.png")
        default: circleImageView.image = nil
            
        }
        
    }
    
    
    
    func addExpectLabel(){
        
        
        
        expectLabel = UILabel(frame: CGRectMake(width/2 - 7, 6*ratio, 14, 14))
        expectLabel.adjustsFontSizeToFitWidth = true
        expectLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 10)
        expectLabel.textColor = UIColor.whiteColor()
        expectLabel.textAlignment = NSTextAlignment.Center
        expectLabel.backgroundColor = UIColor.clearColor()
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
