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
    //var contentsLabel : UILabel!
    
    var contentsTextView : AmountTextView!
    
    
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
    let DEFAULT_LINE_WIDTH : CGFloat = 3
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        setupRatio()
        addTitleLabel()
        //addContentsLabel()
        addContentsTextView()
        addTimerButton()
        addPercentLabel()
        addColorBoxView()
    }
    
    func setupRatio(){
        let screenRect = UIScreen.mainScreen().bounds
        let screenWidth = screenRect.size.width
        ratio = screenWidth/320
    }
    
    func addTitleLabel(){
        titleLabel = UILabel(frame: CGRectMake(75*ratio, 11*ratio, 250*ratio, 14*ratio))
        titleLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 10*ratio)
        titleLabel.textColor = UIColor.todaitGray()
        titleLabel.textAlignment = NSTextAlignment.Left
        self.addSubview(titleLabel)
    }

    /*
    func addContentsLabel(){
        contentsLabel = UILabel(frame: CGRectMake(60*ratio, 26*ratio, 250*ratio, 22*ratio))
        contentsLabel.font = UIFont(name: "AvenirNext-Regular", size: 16*ratio)
        contentsLabel.textColor = UIColor.todaitDarkGray()
        contentsLabel.textAlignment = NSTextAlignment.Left
        self.addSubview(contentsLabel)
    }
    */
    
    func addContentsTextView(){
        
        contentsTextView = AmountTextView(frame: CGRectMake(72*ratio, 20*ratio, 250*ratio, 32*ratio))
        contentsTextView.unitColor = UIColor.todaitGray()
        contentsTextView.unitFont = UIFont(name: "AppleSDGothicNeo-Regular", size: 20*ratio)
        contentsTextView.amountFont = UIFont(name: "AppleSDGothicNeo-Regular", size: 20*ratio)
        contentsTextView.amountColor = UIColor.todaitDarkGray()
        contentsTextView.baseLine = 0
        
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.Left
        
        contentsTextView.paragraphStyle = paragraphStyle
        
        self.addSubview(contentsTextView)
    }

    func addTimerButton(){
        timerButton = UIButton(frame: CGRectMake(23*ratio, 11*ratio, 36*ratio, 36*ratio))
        
        timerButton.clipsToBounds = true
        timerButton.layer.cornerRadius = 17*ratio
        timerButton.layer.borderWidth = 1.0*ratio
        timerButton.layer.borderColor = UIColor.todaitLightGray().CGColor
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
        percentBezierPath = UIBezierPath(arcCenter: timerButton.center, radius:timerButtonRect.size.width/2 - DEFAULT_LINE_WIDTH*ratio/2, startAngle: degreeToRadians(DEFAULT_START_ANGLE), endAngle: degreeToRadians(DEFAULT_END_ANGLE), clockwise: true) as UIBezierPath!
        
    }
    
    func degreeToRadians(angle: CGFloat) -> CGFloat{
        return (angle)/180.0 * CGFloat(M_PI)
    }
    
    func addPercentLayer(){
        percentLayer = CAShapeLayer()
        percentLayer.path = percentBezierPath.CGPath
        percentLayer.fillColor = UIColor.clearColor().CGColor
        percentLayer.strokeColor = UIColor.colorWithHexString("#FFFB887E").CGColor
        percentLayer.strokeStart = 0.0
        percentLayer.strokeEnd = 0.5
        percentLayer.lineWidth = DEFAULT_LINE_WIDTH*ratio
        percentLayer.lineCap = kCALineCapButt
        percentLayer.frame = CGRectMake(0, 0, 36*ratio,36*ratio)
        self.layer .addSublayer(percentLayer)
    }
    
    func addPercentLabel(){
        percentLabel = UILabel(frame: CGRectMake(23*ratio, 11*ratio, 36*ratio, 36*ratio))
        percentLabel.font = UIFont(name: "AvenirNext-Regular", size: 10*ratio)
        percentLabel.text = "%"
        percentLabel.textAlignment = NSTextAlignment.Center
        percentLabel.textColor = UIColor.todaitLightGray()
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
