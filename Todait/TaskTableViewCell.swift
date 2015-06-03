//
//  AimTableViewCell.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 1..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit


protocol TaskTableViewCellDelegate :  NSObjectProtocol {
    func timerButtonClk(indexPath:NSIndexPath)
}



class TaskTableViewCell: UITableViewCell {
    var titleLabel : UILabel!
    var contentsLabel : UILabel!
    var timerButton : UIButton!
    var percentLabel : UILabel!
    var colorBoxView : UIView!
    var percentLayer : CAShapeLayer!
    var percentBezierPath : UIBezierPath!
    var indexPath : NSIndexPath!
    
    var delegate : TaskTableViewCellDelegate!
    
    var ratio : CGFloat!
    
    let DEFAULT_START_ANGLE : CGFloat = -89.0
    let DEFAULT_END_ANGLE : CGFloat = -89.00001
    let DEFAULT_LINE_WIDTH : CGFloat = 2.0
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let screenRect = UIScreen.mainScreen().bounds
        let screenWidth = screenRect.size.width
        ratio = screenWidth/320
        
        addTitleLabel()
        addContentsLabel()
        addTimerButton()
        addPercentLabel()
        addColorBoxView()
    }
    
    func addTitleLabel(){
        titleLabel = UILabel(frame: CGRectMake(60*ratio, 10*ratio, 200*ratio, 14*ratio))
        titleLabel.font = UIFont(name: "AvenirNext-Regular", size: 12*ratio)
        titleLabel.textColor = UIColor.colorWithHexString("#969696")
        titleLabel.textAlignment = NSTextAlignment.Left
        self.addSubview(titleLabel)
    }

    func addContentsLabel(){
        contentsLabel = UILabel(frame: CGRectMake(60*ratio, 25*ratio, 200*ratio, 22*ratio))
        contentsLabel.font = UIFont(name: "AvenirNext-Regular", size: 16*ratio)
        contentsLabel.textColor = UIColor.colorWithHexString("#969696")
        contentsLabel.textAlignment = NSTextAlignment.Left
        self.addSubview(contentsLabel)
    }
    
    func addTimerButton(){
        timerButton = UIButton(frame: CGRectMake(15*ratio, 9.5*ratio, 30*ratio, 30*ratio))
        
        timerButton.clipsToBounds = true
        timerButton.layer.cornerRadius = 15*ratio
        timerButton.layer.borderWidth = 2.0*ratio
        timerButton.layer.borderColor = UIColor.colorWithHexString("#C0C0C0").CGColor
        timerButton.addTarget(self, action: Selector("timerButtonClk"), forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(timerButton)
        
        setPercentBezierPath()
        addPercentLayer()
    }
    
    func timerButtonClk(){
        if delegate.respondsToSelector(Selector("timerButtonClk:")){
            delegate.timerButtonClk(indexPath)
        }
    }
    
    func setPercentBezierPath(){
        let timerButtonRect = timerButton.frame
        percentBezierPath = UIBezierPath(arcCenter: timerButton.center, radius:timerButtonRect.size.width/2 - DEFAULT_LINE_WIDTH/2, startAngle: degreeToRadians(DEFAULT_START_ANGLE), endAngle: degreeToRadians(DEFAULT_END_ANGLE), clockwise: true) as UIBezierPath!
        
    }
    
    func degreeToRadians(angle: CGFloat) -> CGFloat{
        return (angle)/180.0 * CGFloat(M_PI)
    }
    
    func addPercentLayer(){
        percentLayer = CAShapeLayer()
        percentLayer.path = percentBezierPath.CGPath
        percentLayer.fillColor = UIColor.clearColor().CGColor
        percentLayer.strokeColor = UIColor.redColor().CGColor
        percentLayer.strokeStart = 0.0
        percentLayer.strokeEnd = 0.5
        percentLayer.lineWidth = DEFAULT_LINE_WIDTH
        percentLayer.lineCap = kCALineCapButt
        percentLayer.frame = CGRectMake(0, 0, 30*ratio,30*ratio)
        self.layer .addSublayer(percentLayer)
    }
    
    func addPercentLabel(){
        percentLabel = UILabel(frame: CGRectMake(15*ratio, 9*ratio, 30*ratio, 30*ratio))
        percentLabel.font = UIFont(name: "AvenirNext-Regular", size: 8*ratio)
        percentLabel.text = "%"
        percentLabel.textAlignment = NSTextAlignment.Center
        percentLabel.textColor = UIColor.orangeColor()
        self.addSubview(percentLabel)
    }
    
    func addColorBoxView(){
        colorBoxView = UIView(frame: CGRectMake(0, 0, 2 * DEFAULT_LINE_WIDTH, 49*ratio))
        colorBoxView.backgroundColor = UIColor.clearColor()
        self.addSubview(colorBoxView)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
