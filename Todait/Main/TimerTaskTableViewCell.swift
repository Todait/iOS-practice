//
//  TimerTaskViewCell.swift
//  Todait
//
//  Created by CruzDiary on 2015. 7. 27..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class TimerTaskTableViewCell: BasicTableViewCell {
    
    var titleLabel : UILabel!
    //var contentsLabel : UILabel!
    
    var contentsTextView : TimerTextView!
    
    
    var timerButton : UIButton!
    var percentLabel : UILabel!
    var colorBoxView : UIView!
    var percentLayer : CAShapeLayer!
    var percentBezierPath : UIBezierPath!
    var indexPath : NSIndexPath!
    
    var delegate : TaskTableViewCellDelegate?
    
    let DEFAULT_START_ANGLE : CGFloat = -89.0
    let DEFAULT_END_ANGLE : CGFloat = -89.00001
    let DEFAULT_LINE_WIDTH : CGFloat = 2
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        addTitleLabel()
        addContentsTextView()
        
        addTimerButton()
        addPercentLabel()
        addColorBoxView()
    }
    
    
    func addTitleLabel(){
        titleLabel = UILabel(frame: CGRectMake(70, 11, 250, 14))
        titleLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 11)
        titleLabel.textColor = UIColor.todaitGray()
        titleLabel.textAlignment = NSTextAlignment.Left
        self.addSubview(titleLabel)
    }
    
    
    func addContentsTextView(){
        
        contentsTextView = TimerTextView(frame: CGRectMake(70, 20, 250, 32))
        contentsTextView.stringColor = UIColor.todaitGray()
        contentsTextView.stringFont = UIFont(name: "AppleSDGothicNeo-Medium", size: 16)
        contentsTextView.numberFont = UIFont(name: "AppleSDGothicNeo-Medium", size: 16)
        contentsTextView.numberColor = UIColor.todaitDarkGray()
        contentsTextView.baseLine = 0
        contentsTextView.textContainer.lineFragmentPadding = 0
        
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.Left
        paragraphStyle.headIndent = 0
        paragraphStyle.firstLineHeadIndent = 0
        
        contentsTextView.paragraphStyle = paragraphStyle
        
        self.addSubview(contentsTextView)
    }
    
    func addTimerButton(){
        timerButton = UIButton(frame: CGRectMake(0, 0, 68, 58))
        
        timerButton.clipsToBounds = true
        timerButton.layer.cornerRadius = 18
        
        timerButton.addTarget(self, action: Selector("timerButtonTouchUpOutside"), forControlEvents:UIControlEvents.TouchUpOutside)
        timerButton.addTarget(self, action: Selector("timerButtonTouchDown"), forControlEvents:UIControlEvents.TouchDown)
        timerButton.addTarget(self, action: Selector("timerButtonClk"), forControlEvents: UIControlEvents.TouchUpInside)
        
        timerButton.setImage(UIImage(named: "bt_play_wt_a@3x.png"), forState: UIControlState.Normal)
        
        timerButton.setImage(UIImage(named: "bt_play_gray_a@3x.png"), forState: UIControlState.Highlighted)
        
        //timerButton.setBackgroundImage(UIImage.colorImage(UIColor.clearColor(), frame:CGRectMake(0,0,36,36)), forState: UIControlState.Normal)
        //timerButton.setBackgroundImage(UIImage.colorImage(UIColor.colorWithHexString("#95CCC4").colorWithAlphaComponent(0.5), frame:CGRectMake(0,0,36,36)), forState: UIControlState.Highlighted)
        timerButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        
        self.addSubview(timerButton)
        
        setPercentBezierPath()
        addPercentLayer()
    }
    
    
    func timerButtonTouchDown(){
        
        print("touchdown")
        percentLabel.hidden = true
        
    }
    
    func timerButtonTouchUpOutside(){
        
        print("touchUpOutSide")
        percentLabel.hidden = false
    }
    
    func timerButtonClk(){
        
        if let delegate = delegate {
            if delegate.respondsToSelector(Selector("timerButtonClk:")){
                delegate.timerButtonClk(indexPath)
            }
        }
    }
    
    func setPercentBezierPath(){
        let timerButtonRect = timerButton.frame
        percentBezierPath = UIBezierPath(arcCenter:CGPointMake(38,29), radius:18 - DEFAULT_LINE_WIDTH/2, startAngle: degreeToRadians(DEFAULT_START_ANGLE), endAngle: degreeToRadians(DEFAULT_END_ANGLE), clockwise: true) as UIBezierPath!
        
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
        percentLayer.lineWidth = DEFAULT_LINE_WIDTH
        percentLayer.lineCap = kCALineCapButt
        percentLayer.frame = CGRectMake(0, 0, 36,36)
        self.layer .addSublayer(percentLayer)
    }
    
    func addPercentLabel(){
        percentLabel = UILabel(frame: CGRectMake(21.5, 12, 36, 36))
        percentLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 10)
        percentLabel.text = "%"
        percentLabel.textAlignment = NSTextAlignment.Center
        percentLabel.textColor = UIColor.todaitLightGray()
        self.addSubview(percentLabel)
    }
    
    func addColorBoxView(){
        colorBoxView = UIView(frame: CGRectMake(0, 0, 4, 58))
        colorBoxView.backgroundColor = UIColor.clearColor()
        self.addSubview(colorBoxView)
    }
    
    
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        
        if highlighted == true {
            backgroundColor = UIColor.todaitBackgroundGray()
        }else{
            backgroundColor = UIColor.whiteColor()
        }
        
    }
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
