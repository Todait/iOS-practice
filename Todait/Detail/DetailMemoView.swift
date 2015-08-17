//
//  DetailMemoView.swift
//  Todait
//
//  Created by CruzDiary on 2015. 7. 13..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit




protocol DetailMemoViewDelegate : NSObjectProtocol {
    func diaryButtonClk()
    func focusButtonClk()
    func amountButtonClk()
    func timeLogButtonClk()
    func timerButtonClk()
}


class DetailMemoView: UIView {
    
    
    var headerLabel:UILabel!
    var diaryButton:UIButton!
    var infoLabel:UILabel!
    var focusButton:UIButton!
    var timerButton:UIButton!
    var timerAimLabel:UILabel!
    var timerLabel:UILabel!
    var timeLogButton:UIButton!
    var circleChart:CircleChart!
    var amountTextView:AmountTextView!
    var amountButton:UIButton!
    
    var upperLine:UIView!
    var middleLine:UIView!
    
    var ratio:CGFloat! = 0
    var width:CGFloat! = 0
    var height:CGFloat! = 0
    
    var delegate:DetailMemoViewDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupRatio()
        addHeaderLabel()
        addDiaryButton()
        addInfoLabel()
        
        addFocusButton()
        addLine()
        addTimerButton()
        addTimeLogButton()
        addTimerLabel()
        addTimerAimLabel()
        
        addMiddleLine()
        addCircleChart()
        addChartMask()
        addAmountTextView()
        addAmountButton()
        
        
    }

    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func setupRatio(){
        let screenRect = UIScreen.mainScreen().bounds
        let screenWidth = screenRect.size.width
        ratio = screenWidth/320
        width = 320*ratio/7
        height = 60*ratio
    }
    
    func addHeaderLabel(){
        
        headerLabel = UILabel(frame: CGRectMake(0, 116*ratio, 320*ratio, 24.5*ratio))
        headerLabel.backgroundColor = UIColor.colorWithHexString("#EFEFEF")
        headerLabel.textColor = UIColor.todaitGray()
        headerLabel.textAlignment = NSTextAlignment.Center
        headerLabel.text = "공부메모"
        headerLabel.font = UIFont(name: "AvenirNext-Regular", size: 10*ratio)
        addSubview(headerLabel)
        
    }
    
    
    func addDiaryButton(){
        
        let diaryImage = UIImageView(frame: CGRectMake(18*ratio,116*ratio+39*ratio,16*ratio,16*ratio))
        diaryImage.image = UIImage(named: "detail_basic_27@3x.png")
        addSubview(diaryImage)
        
        
        diaryButton = UIButton(frame:CGRectMake(5*ratio,108*ratio+39*ratio,150*ratio,32*ratio))
        diaryButton.addTarget(self, action: Selector("diaryButtonClk"), forControlEvents: UIControlEvents.TouchUpInside)
        diaryButton.setBackgroundImage(UIImage.colorImage(UIColor.clearColor(), frame: CGRectMake(0, 0, 150*ratio, 32*ratio)), forState: UIControlState.Normal)
        diaryButton.setBackgroundImage(UIImage.colorImage(UIColor.todaitLightGray(), frame: CGRectMake(0, 0, 150*ratio, 32*ratio)), forState: UIControlState.Highlighted)
        
        addSubview(diaryButton)
    }
    
   
    
    func addInfoLabel(){
        
        infoLabel = UILabel(frame: CGRectMake(37*ratio, 116*ratio+24.5*ratio, 180*ratio, 45.5*ratio))
        infoLabel.textColor = UIColor.todaitGray()
        infoLabel.textAlignment = NSTextAlignment.Left
        infoLabel.text = "메모를 추가하세요."
        infoLabel.font = UIFont(name: "AvenirNext-Regular", size: 12*ratio)
        
        addSubview(infoLabel)
    }
    
    
    func addFocusButton(){
        
        focusButton = UIButton(frame: CGRectMake(200*ratio , 115*ratio+24.5*ratio, 90*ratio, 45.5*ratio))
        focusButton.setBackgroundImage(UIImage.colorImage(UIColor.clearColor(), frame: CGRectMake(0, 0, 90*ratio, 45.5*ratio)), forState: UIControlState.Normal)
        focusButton.setBackgroundImage(UIImage.colorImage(UIColor.todaitLightGray(), frame: CGRectMake(0, 0, 90*ratio, 45.5*ratio)), forState: UIControlState.Highlighted)
        focusButton.addTarget(self, action: Selector("focusButtonClk"), forControlEvents: UIControlEvents.TouchUpInside)
        
        addSubview(focusButton)
        
    }
    
   
    
    func addLine(){
        upperLine = UIView(frame:CGRectMake(0,0*ratio,width,0.5*ratio))
        upperLine.backgroundColor = UIColor.colorWithHexString("#EFEFEF")
        addSubview(upperLine)
    }
    
    func addTimerButton(){
        
        timerButton = UIButton(frame:CGRectMake(50*ratio, 0*ratio+12.5*ratio, 58*ratio, 58*ratio))
        
        timerButton.setBackgroundImage(UIImage(named: "detail_basic_23@3x.png"), forState: UIControlState.Normal)
        timerButton.clipsToBounds = true
        timerButton.addTarget(self, action: Selector("timerButtonClk"), forControlEvents: UIControlEvents.TouchUpInside)
        
        addSubview(timerButton)
    }
    
    func addTimeLogButton(){
        
        timeLogButton = UIButton(frame: CGRectMake(15*ratio, 0*ratio+70*ratio, 130*ratio, 45*ratio))
        timeLogButton.setBackgroundImage(UIImage.colorImage(UIColor.clearColor(), frame: CGRectMake(0, 0, 130*ratio, 45*ratio)), forState: UIControlState.Normal)
        timeLogButton.setBackgroundImage(UIImage.colorImage(UIColor.todaitLightGray(), frame: CGRectMake(0, 0, 130*ratio, 45*ratio)), forState: UIControlState.Highlighted)
        timeLogButton.addTarget(self, action: Selector("timeLogButtonClk"), forControlEvents: UIControlEvents.TouchUpInside)
        
        addSubview(timeLogButton)
    }
    
    func addTimerAimLabel(){
        timerAimLabel = UILabel(frame:CGRectMake(15*ratio,0*ratio+77*ratio,130*ratio,12*ratio))
        timerAimLabel.text = "목표시간 01:30:00"
        timerAimLabel.backgroundColor = UIColor.clearColor()
        timerAimLabel.font = UIFont(name: "AppleSDGothicNeo-Light", size: 10*ratio)
        timerAimLabel.textAlignment = NSTextAlignment.Center
        timerAimLabel.textColor = UIColor.todaitGray()
        
        addSubview(timerAimLabel)
    }
    
    func addTimerLabel(){
        
        timerLabel = UILabel(frame:CGRectMake(15*ratio,0*ratio+89*ratio,130*ratio,22*ratio))
        timerLabel.text = "00:00:00"
        timerLabel.font = UIFont(name: "AppleSDGothicNeo-Light",size:20*ratio)
        timerLabel.textAlignment = NSTextAlignment.Center
        timerLabel.textColor = UIColor.todaitOrange()
        
        addSubview(timerLabel)
    }
    
    
   
    
    func addMiddleLine(){
        
        middleLine = UIView(frame:CGRectMake(159.75*ratio,0*ratio,0.5*ratio,115*ratio))
        middleLine.backgroundColor = UIColor.colorWithHexString("#EFEFEF")
        
        addSubview(middleLine)
        
    }
    
    func addCircleChart(){
        
        circleChart = CircleChart(frame: CGRectMake(210*ratio, 0*ratio+12.5*ratio, 58*ratio, 58*ratio))
        circleChart.circleColor = UIColor.todaitOrange()
        //circleChart.updatePercent(progressPercent)
        circleChart.percentLabel.frame = CGRectMake(5*ratio,5*ratio,48*ratio,48*ratio)
        circleChart.percentLabel.font = UIFont(name: "AppleSDGothicNeo-Light",size: 25*ratio)
        circleChart.percentLabel.adjustsFontSizeToFitWidth = true
        
        addSubview(circleChart)
    }
    
    func addChartMask(){
        
        var background:UIImage = UIImage(named: "graph_bg.png")!
        var maskLayer:CALayer = CALayer()
        maskLayer.contents = background.CGImage
        maskLayer.frame = CGRectMake(0,0,58*ratio,58*ratio)
        maskLayer.mask = circleChart.percentLayer
        circleChart.layer.addSublayer(maskLayer)
        
    }
    
    func addAmountTextView(){
        
        amountTextView = AmountTextView(frame: CGRectMake(175*ratio,0*ratio+74*ratio, 130*ratio, 25*ratio))
        
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.Center
        amountTextView.paragraphStyle = paragraphStyle
        
        //amountTextView.setupText(day.done_amount.integerValue, total: day.expect_amount.integerValue, unit: task.unit)
        amountTextView.userInteractionEnabled = false
        addSubview(amountTextView)
    }
    
    func addAmountButton(){
        
        amountButton = UIButton(frame:CGRectMake(160*ratio, 0*ratio, 160*ratio, 115*ratio))
        amountButton.backgroundColor = UIColor.clearColor()
        amountButton.addTarget(self, action: Selector("amountButtonClk"), forControlEvents: UIControlEvents.TouchUpInside)
        
        addSubview(amountButton)
    }
    
   
    
    func addFocusScore(score:CGFloat){
        
        
        
        for index in 0...4 {
            
            var imageView = UIImageView(frame: CGRectMake(200*ratio + 17*ratio * CGFloat(index), 116*ratio+39*ratio, 14*ratio, 14*ratio))
            imageView.image = UIImage(named: "detail_basic_30@3x.png")
            
            
            addSubview(imageView)
            
            if index > Int(score) {
                
            }else if index == Int(score){
                
                
                var percent = score - CGFloat(index)
                
                var path = UIBezierPath()
                path.moveToPoint(CGPointMake(0*ratio,7*ratio))
                path.addLineToPoint(CGPointMake(14*ratio,7*ratio))
                
                
                var colorLayer = CAShapeLayer()
                colorLayer.path = path.CGPath
                colorLayer.fillColor = UIColor.todaitGreen().CGColor
                colorLayer.strokeColor = UIColor.todaitRed().CGColor
                colorLayer.strokeStart = 0
                colorLayer.strokeEnd = percent
                colorLayer.lineWidth = 14*ratio
                
                
                var maskLayer = CALayer()
                maskLayer.contents = UIImage(named: "detail_diary_input_star@3x.png")!.CGImage
                maskLayer.frame = CGRectMake(200*ratio + 17*ratio * CGFloat(index), 116*ratio+39*ratio, 14*ratio, 14*ratio)
                maskLayer.mask = colorLayer
                
                layer.addSublayer(maskLayer)
                
            }else{
                
                var imageView = UIImageView(frame: CGRectMake(200*ratio + 17*ratio * CGFloat(index), 116*ratio+39*ratio, 14*ratio, 14*ratio))
                imageView.image = UIImage(named: "detail_diary_input_star@3x.png")
                
                addSubview(imageView)
            }
        }
        
        
    }
    
    //delegate
    
    func diaryButtonClk(){
        
        if self.delegate.respondsToSelector("diaryButtonClk"){
            self.delegate.diaryButtonClk()
        }
        
    }
    
    func focusButtonClk(){
        
        if self.delegate.respondsToSelector("focusButtonClk"){
            self.delegate.focusButtonClk()
        }
        
    }
    
    func amountButtonClk(){
        
        if self.delegate.respondsToSelector("amountButtonClk"){
            self.delegate.amountButtonClk()
        }
        
    }
    
    func timerButtonClk(){
        if self.delegate.respondsToSelector("timerButtonClk"){
            self.delegate.timerButtonClk()
        }
    }
    
    func timeLogButtonClk(){
        if self.delegate.respondsToSelector("timeLogButtonClk"){
            self.delegate.timeLogButtonClk()
        }
    }
}
