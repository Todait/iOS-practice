//
//  InvestViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 3..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

protocol InvestDelegate: NSObjectProtocol {
    func updateInvestData(data:[Int])
}

class InvestViewController: BasicViewController,InvestUpdateDelegate{
    
    var mainColor:UIColor!
    var blurEffectView: UIVisualEffectView!
    var completeButton: UIButton!
    let nameData:[String] = ["일","월","화","수","목","금","토"]
    var timeData:[Int] = [0,0,0,0,0,0,0]
    
    var totalTimeLabel:UILabel!
    
    var nameLabels:[UILabel]! = []
    var timeLabels:[UILabel]! = []
    var investViews:[InvestView]! = []
    var delegate:InvestDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBlurBackground()
        
        addInfoTitleView()
        addInfoContentsView()
        addCompleteButton()
        addInvestView()
        
        addTimeYAxis()
        
    }
    
    
    func addInvestView(){
        
        for index in 0...6{
            
            let originX = CGFloat(index)*(width/7)
            let investWidth = (width/7)
            
            let investView = InvestView(frame:CGRectMake(originX,height-139*ratio,investWidth,24*ratio))
            investView.mainColor = mainColor
            investView.update()
            investView.index = Int(index)
            investView.delegate = self
            
            view.addSubview(investView)
            investViews.append(investView)
        }
        
    }
    
    
    func setupBlurBackground(){
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.frame
        blurEffectView.alpha = 0.9
        view.addSubview(blurEffectView)
    }
    
    func addInfoTitleView(){
        
        addInvestTitleInfoLabel()
        addInvestTotalTimeLabel()
    }
    
    
    func addInvestTitleInfoLabel(){
        let investTitleInfoLabel = UILabel(frame: CGRectMake(15*ratio,90*ratio, 290*ratio, 40*ratio))
        investTitleInfoLabel.text = "목표 투자시간"
        investTitleInfoLabel.textAlignment = NSTextAlignment.Center
        investTitleInfoLabel.textColor = mainColor
        investTitleInfoLabel.font = UIFont(name: "AvenirNext-Regular", size: 30*ratio)
        view.addSubview(investTitleInfoLabel)
    }
    
    func addInvestTotalTimeLabel(){
        totalTimeLabel = UILabel(frame: CGRectMake(15*ratio, 140*ratio, 290*ratio, 30*ratio))
        totalTimeLabel.textAlignment = NSTextAlignment.Center
        totalTimeLabel.text = "일주일 총 14시간 00분"
        totalTimeLabel.textColor = mainColor
        totalTimeLabel.font = UIFont(name: "AvenirNext-Regular", size: 20*ratio)
        
        view.addSubview(totalTimeLabel)
    }
    
    
    
    func addInfoContentsView(){
        
        addInvestWeekView()
        addInvestContentsInfoLabel()
    }
    
    func addInvestWeekView(){
        
        let dayWidth: CGFloat! = width / 7
        
        
        for index in 0...6 {
            
            
            let originX = CGFloat(index) * dayWidth
            
            let nameLabel = UILabel(frame:CGRectMake(originX, height-85*ratio, dayWidth, 20*ratio))
            
            nameLabel.textAlignment = NSTextAlignment.Center
            nameLabel.textColor = mainColor.colorWithAlphaComponent(0.1)
            nameLabel.font = UIFont(name: "AvenirNext-Regular", size: 16*ratio)
            view.addSubview(nameLabel)
            nameLabels.append(nameLabel)
            
            
            
            let timeLabel = UILabel(frame: CGRectMake(originX, height-140*ratio, dayWidth, 20*ratio))
            timeLabel.textAlignment = NSTextAlignment.Center
            timeLabel.textColor = mainColor.colorWithAlphaComponent(0.1)
            timeLabel.font = UIFont(name: "AvenirNext-Regular",size: 12*ratio)
            timeLabel.adjustsFontSizeToFitWidth = true
            view.addSubview(timeLabel)
            
            timeLabels.append(timeLabel)
            
            if index != 7 {
                nameLabel.text = nameData[index]
                timeLabel.text = getTimeString(timeData[index])
            }
            
        }
        
    }
    
    func addInvestContentsInfoLabel(){
        let investContentsInfoLabel = UILabel(frame: CGRectMake(15*ratio, 180*ratio, 290*ratio, 25*ratio))
        investContentsInfoLabel.text = "요일별 투자시간의 비율에 따라 적정 분량을 나눠줍니다"
        investContentsInfoLabel.font = UIFont(name: "AvenirNext-Regular", size: 10*ratio)
        investContentsInfoLabel.textColor = mainColor
        investContentsInfoLabel.textAlignment = NSTextAlignment.Center
        view.addSubview(investContentsInfoLabel)
    }
    
    func addCompleteButton(){
        completeButton = UIButton(frame: CGRectMake(0, height-50*ratio, width, 50*ratio))
        completeButton.backgroundColor = mainColor
        completeButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        completeButton.setTitle("확인", forState: UIControlState.Normal)
        completeButton.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 20*ratio)
        completeButton.addTarget(self, action: Selector("completeButtonClk"), forControlEvents:UIControlEvents.TouchUpInside)
        view.addSubview(completeButton)
    }
    
    func completeButtonClk(){
        
        
        if self.delegate.respondsToSelector("updateInvestData:"){
            self.delegate.updateInvestData(timeData)
        }
        
        
        dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }

    
    func addTimeYAxis(){
        
        for index in 0...23 {
            
            let originY = height - 351*ratio + 12*CGFloat(index)
            var width:CGFloat = 5
            
            if Int(index+1)%4 == 0 {
                width = 12
            }
            
            let timeBar = UIView(frame:CGRectMake(0,originY-1,width,2))
            
            timeBar.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.1)
            view.addSubview(timeBar)
        }
    }
    
    func updateIndex(index:Int,select:Bool){
        
        var color = mainColor
        
        if select == false {
            color = mainColor.colorWithAlphaComponent(0.1)
        }
        
        let nameLabel = nameLabels[index]
        let timeLabel = timeLabels[index]
        
        nameLabel.textColor = color
        timeLabel.textColor = color
        
        
        
        let totalTime = getTotalTime()
        totalTimeLabel.text = "일주일 총 "+" "+getTimeString(totalTime)
        
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        todaitNavBar.hidden = true
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)
        touchPoint(touches,event: event)
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)
        touchPoint(touches,event: event)
    }
    
    
    
    func touchPoint(touches:NSSet,event:UIEvent){
        let touch: AnyObject? = touches.anyObject()
        let touchPoint:CGPoint! = touch?.locationInView(view)
        
        let touchIndex = Int(touchPoint.x/(width/7))
        
        
        let investView = investViews[touchIndex]
        investView.investViewSelect()
        var investHeight = height-85*ratio-touchPoint.y
        
        if investHeight > 266*ratio {
            investHeight = 266*ratio
        }
        
        if investHeight < 0 {
            investHeight = 0
        }
        
        let timeIndex = Int(investHeight/4*ratio)
        
        
        investView.frame = CGRectMake(CGFloat(touchIndex)*(width/7),height-110*ratio,investView.frame.size.width,-1*CGFloat(timeIndex)*3*ratio)
        
        
        
        let timeLabel = timeLabels[touchIndex]
        timeLabel.text = getTimeString(15*timeIndex*60)
        timeLabel.frame = CGRectMake(CGFloat(touchIndex)*(width/7),height-133*ratio-1*CGFloat(timeIndex)*3*ratio,timeLabel.frame.size.width,20*ratio)
        
        
        
        timeData[touchIndex] = 15*timeIndex*60
        
        
        
        
        let totalTime = getTotalTime()
        totalTimeLabel.text = "일주일 총 "+" "+getTimeString(totalTime)
        
    }
    
    func getTotalTime()->Int{
        
        var time = 0
        
        for index in 0...6{
            
            let investView = investViews[index]
            
            if investView.selected == true {
                time = time + timeData[index]
            }
        }
        
        return time
        
    }
    
    
    
    func getTimeString(time:Int)->String{
        
        let hour = time.toHour()
        let minute = time.toMinute()
        
        if hour == 0{
            return "\(time.toMinute())분"
        }else{
            
            if minute == 0 {
                return "\(hour)시간"
            }
            
            return "\(hour)시간 \(minute)분"
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
