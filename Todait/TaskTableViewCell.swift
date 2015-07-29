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



class TaskTableViewCell: BasicTableViewCell {
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
    
    let DEFAULT_START_ANGLE : CGFloat = -89.0
    let DEFAULT_END_ANGLE : CGFloat = -89.00001
    let DEFAULT_LINE_WIDTH : CGFloat = 2
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addTitleLabel()
        //addContentsLabel()
        addContentsTextView()
        addTimerButton()
        addPercentLabel()
        addColorBoxView()
    }
    
    
    func addTitleLabel(){
        titleLabel = UILabel(frame: CGRectMake(75*ratio, 11*ratio, 250*ratio, 14*ratio))
        titleLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 11*ratio)
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
        contentsTextView.unitFont = UIFont(name: "AppleSDGothicNeo-Medium", size: 16*ratio)
        contentsTextView.amountFont = UIFont(name: "AppleSDGothicNeo-Medium", size: 16*ratio)
        contentsTextView.amountColor = UIColor.todaitDarkGray()
        contentsTextView.baseLine = 0
        
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.Left
        
        contentsTextView.paragraphStyle = paragraphStyle
        
        self.addSubview(contentsTextView)
    }

    func addTimerButton(){
        timerButton = UIButton(frame: CGRectMake(0*ratio, 0*ratio, 75*ratio, 58*ratio))
        
        timerButton.clipsToBounds = true
        timerButton.layer.cornerRadius = 18*ratio
        
        timerButton.addTarget(self, action: Selector("timerButtonTouchUpOutside"), forControlEvents:UIControlEvents.TouchUpOutside)
        timerButton.addTarget(self, action: Selector("timerButtonTouchDown"), forControlEvents:UIControlEvents.TouchDown)
        timerButton.addTarget(self, action: Selector("timerButtonClk"), forControlEvents: UIControlEvents.TouchUpInside)
        
        timerButton.setImage(UIImage(named: "bt_play_wt_a@3x.png"), forState: UIControlState.Normal)
        
        timerButton.setImage(UIImage(named: "bt_play_gray_a@3x.png"), forState: UIControlState.Highlighted)
        
        //timerButton.setBackgroundImage(UIImage.colorImage(UIColor.clearColor(), frame:CGRectMake(0,0,36*ratio,36*ratio)), forState: UIControlState.Normal)
        //timerButton.setBackgroundImage(UIImage.colorImage(UIColor.colorWithHexString("#95CCC4").colorWithAlphaComponent(0.5), frame:CGRectMake(0,0,36*ratio,36*ratio)), forState: UIControlState.Highlighted)
        
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
        if delegate.respondsToSelector(Selector("timerButtonClk:")){
            delegate.timerButtonClk(indexPath)
        }
    }
    
    func setPercentBezierPath(){
        let timerButtonRect = timerButton.frame
        percentBezierPath = UIBezierPath(arcCenter:CGPointMake(41*ratio,29*ratio), radius:18*ratio - DEFAULT_LINE_WIDTH*ratio/2, startAngle: degreeToRadians(DEFAULT_START_ANGLE), endAngle: degreeToRadians(DEFAULT_END_ANGLE), clockwise: true) as UIBezierPath!
        
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
        percentLabel = UILabel(frame: CGRectMake(23*ratio, 12*ratio, 36*ratio, 36*ratio))
        percentLabel.font = UIFont(name: "AvenirNext-Regular", size: 10*ratio)
        percentLabel.text = "%"
        percentLabel.textAlignment = NSTextAlignment.Center
        percentLabel.textColor = UIColor.todaitLightGray()
        self.addSubview(percentLabel)
    }
    
    func addColorBoxView(){
        colorBoxView = UIView(frame: CGRectMake(0, 0, 4*ratio, 58*ratio))
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
