//
//  TimeTileView.swift
//  Todait
//
//  Created by CruzDiary on 2015. 7. 16..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class TimeTileView: UIView {

    var colorBox:UIView!
    var colorBackground:UIView!
    
    var startTimeLabel:UILabel!
    var endTimeLabel:UILabel!
    var titleLabel:UILabel!
    var timeLabel:UILabel!
    
    var mainColor:UIColor!
    var ratio:CGFloat! = 0
    var width:CGFloat! = 0
    var height:CGFloat! = 0
    
    var startLocation:CGPoint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupRatio()
        
        addColorBackground()
        addColorBox()
        addStartTimeLabel()
        addEndTimeLabel()
        addTitleLabel()
        addTimeLabel()
        addLongGesture()
    }
    
    func setupRatio(){
        let screenRect = UIScreen.mainScreen().bounds
        let screenWidth = screenRect.size.width
        ratio = screenWidth/320
        width = frame.size.width
        height = frame.size.height
    }
    
    func addColorBackground(){
        
        colorBackground = UIView(frame: CGRectMake(0, 0, width-60*ratio, height))
        colorBackground.backgroundColor = UIColor.clearColor()
        
        addSubview(colorBackground)
        
    }

    func addColorBox(){
        
        colorBox = UIView(frame: CGRectMake(0, 0, 6*ratio, height))
        
        colorBackground.addSubview(colorBox)
    }
    
    func addStartTimeLabel(){
        startTimeLabel = UILabel(frame: CGRectMake(width - 55*ratio, 0, 60*ratio, 20*ratio))
        startTimeLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 7.5*ratio)
        startTimeLabel.text = "4:50"
        startTimeLabel.textAlignment = NSTextAlignment.Left
        startTimeLabel.textColor = UIColor.todaitGray()
        addSubview(startTimeLabel)
    }
    
    func addEndTimeLabel(){
        endTimeLabel = UILabel(frame: CGRectMake(width - 55*ratio, height - 20*ratio, 60*ratio, 20*ratio))
        endTimeLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 7.5*ratio)
        endTimeLabel.text = "7:50"
        endTimeLabel.textAlignment = NSTextAlignment.Left
        endTimeLabel.textColor = UIColor.todaitGray()
        addSubview(endTimeLabel)
    }
    
    func addTitleLabel(){
        
        titleLabel = UILabel(frame: CGRectMake(width - 130*ratio, height - 46*ratio, 60*ratio, 20*ratio))
        titleLabel.text = "운동"
        titleLabel.textColor = UIColor.todaitDarkGray()
        titleLabel.textAlignment = NSTextAlignment.Right
        titleLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 12*ratio)
        addSubview(titleLabel)
        
    }
    
    func addTimeLabel(){
        
        timeLabel = UILabel(frame: CGRectMake(width - 130*ratio, height - 30*ratio, 60*ratio, 20*ratio))
        timeLabel.text = "3시간 00분"
        timeLabel.textColor = UIColor.todaitDarkGray()
        timeLabel.textAlignment = NSTextAlignment.Right
        timeLabel.font = UIFont(name: "AppleSDGothicNeo-UltraLight", size: 10*ratio)
        addSubview(timeLabel)
        
    }
    
    func addLongGesture(){
        
        var longGesture = UILongPressGestureRecognizer()
        longGesture.addTarget(self, action: Selector("longGesture:"))
        addGestureRecognizer(longGesture)
        
    }
    
    func longGesture(gesture:UILongPressGestureRecognizer){
        
        
        if gesture.state == UIGestureRecognizerState.Began {
            
            startLocation = gesture.locationInView(self)
            self.superview?.bringSubviewToFront(self)
            
        }else if gesture.state == UIGestureRecognizerState.Changed {
            
            var pt = gesture.locationInView(self)
            var newCenter = CGPointMake(self.center.x, self.center.y + pt.y - startLocation.y)
            
            self.center = newCenter
            
        }
        
        
        
        
    }
    
    func setupColor(color:UIColor){
        
        colorBackground.backgroundColor = color.colorWithAlphaComponent(0.05)
        colorBox.backgroundColor = color
        
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
