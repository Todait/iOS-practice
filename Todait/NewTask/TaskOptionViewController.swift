//
//  NewGoalStep4ViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 8. 5..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class TaskOptionViewController: BasicViewController,TodaitNavigationDelegate{
   
    
    var optionView:UIView!
    var options:[Int] = [1,2,4]
    
    var option:Int = 0
    var eventOption = 0
    
    var titleString:String!
    var completeButton:UIButton!

    
    var alarmOption:OptionButton!
    var repeatOption:OptionButton!
    var reviewOption:OptionButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = UIColor.todaitBackgroundGray()
        addOptionView()
        
    }
    
    
    func addOptionView(){
        
        
        optionView = UIView(frame: CGRectMake(2*ratio, 64 + 2*ratio, 316*ratio, 118*ratio))
        optionView.backgroundColor = UIColor.whiteColor()
        view.addSubview(optionView )
        
        addAlarmOptionView()
        addReviewOptionView()
        addRepeatOptionView()
        
        
    }
    
    func addAlarmOptionView(){
        
        
        alarmOption = OptionButton(frame:CGRectMake(2*ratio,59*ratio,157*ratio,47*ratio))
        alarmOption.backgroundColor = UIColor.clearColor()
        alarmOption.onImage = UIImage(named: "icon_alarm_wt@3x.png")
        alarmOption.offImage = UIImage(named: "icon_alarm@3x.png")
        alarmOption.onColor = UIColor.todaitGreen()
        alarmOption.offColor = UIColor.todaitGray()
        alarmOption.setText("알람없음")
        alarmOption.setButtonOn(false)
        optionView.addSubview(alarmOption)
        
        
    }
    
    
    func addReviewOptionView(){
        
        
        
        
        reviewOption = OptionButton(frame:CGRectMake(2*ratio,12*ratio,157*ratio,47*ratio))

        reviewOption.backgroundColor = UIColor.clearColor()
        reviewOption.onImage = UIImage(named: "icon_review_wt@3x.png")
        reviewOption.offImage = UIImage(named: "icon_review@3x.png")
        reviewOption.onColor = UIColor.todaitGreen()
        reviewOption.offColor = UIColor.todaitGray()
        reviewOption.setText("복습 0회")
        reviewOption.setButtonOn(false)
        optionView.addSubview(reviewOption)
        
    }
    
    
    func addRepeatOptionView(){
        
        repeatOption = OptionButton(frame:CGRectMake(162*ratio,12*ratio,157*ratio,47*ratio))
        repeatOption.backgroundColor = UIColor.clearColor()
        repeatOption.addTarget(self, action: Selector("repeatOptionClk"), forControlEvents: UIControlEvents.TouchDown)
        repeatOption.onImage = UIImage(named: "icon_reread_wt@3x.png")
        repeatOption.offImage = UIImage(named: "icon_reread@3x.png")
        repeatOption.onColor = UIColor.todaitGreen()
        repeatOption.offColor = UIColor.todaitGray()
        repeatOption.setText("회독 0회")
        repeatOption.setButtonOn(false)
        optionView.addSubview(repeatOption)
        
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        titleLabel.text = titleString
        
        todaitNavBar.todaitDelegate = self
        todaitNavBar.backButton.hidden = false
        
        addCompleteButton()
    }
    
    func addCompleteButton(){
        
        if completeButton != nil {
            return
        }
        
        completeButton = UIButton(frame: CGRectMake(260*ratio, 32, 50*ratio, 24))
        completeButton.setTitle("Done", forState: UIControlState.Normal)
        completeButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 18)
        completeButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        completeButton.addTarget(self, action: Selector("completeButtonClk"), forControlEvents: UIControlEvents.TouchUpInside)
        completeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        view.addSubview(completeButton)
        
    }
    
    func completeButtonClk(){
        
        
    }
    
    
    func backButtonClk(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
