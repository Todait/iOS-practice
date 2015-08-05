//
//  NewGoalStep4ViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 8. 5..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class NewGoalStep4ViewController: BasicViewController,TodaitNavigationDelegate{
   
    
    var optionView:UIView!
    var options:[Int] = [1,2,4,8]
    
    var option:Int = 0
    
    var titleString:String!
    var completeButton:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.todaitBackgroundGray()
        addOptionView()
        
    }
    
    
    func addOptionView(){
        
        
        optionView = UIView(frame: CGRectMake(2*ratio, 64 + 2*ratio, 316*ratio, 118*ratio))
        optionView.backgroundColor = UIColor.whiteColor()
        view.addSubview(optionView )
        
        
        let nib = NSBundle.mainBundle().loadNibNamed("OptionButton", owner: self, options: nil)
        
        var optionButton:OptionButton = nib[0] as! OptionButton
        
        optionView.addSubview(optionButton)
        
        /*
        addDayOptionView()
        addAlarmOptionView()
        addReviewOptionView()
        addReReadOptionView()
        */
        
    }
    
    func addDayOptionView(){
        
    }
    
    
    func addAlarmOptionView(){
        
        
        var alarmOption = UIButton(frame:CGRectMake(2*ratio,64*ratio,157*ratio,52*ratio))
        alarmOption.backgroundColor = UIColor.clearColor()
        alarmOption.addTarget(self, action: Selector("alarmOptionClk"), forControlEvents: UIControlEvents.TouchDown)
        optionView.addSubview(alarmOption)
        
        
        var iconImageView = UIImageView(frame: CGRectMake(10*ratio, 6*ratio, 40*ratio, 40*ratio))
        alarmOption.addSubview(iconImageView)
        
        
        var titleLabel = UILabel(frame: CGRectMake(63*ratio, 15*ratio, 92*ratio, 22.5*ratio))
        titleLabel.text = "알람 없음"
        titleLabel.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 12.5*ratio)
        alarmOption.addSubview(titleLabel)
        
        
        
        if option & OptionStatus.Alarm.rawValue > 0 {
            iconImageView.image = UIImage(named: "icon_alarm_wt@3x.png")
            titleLabel.textColor = UIColor.todaitGreen()
        }else{
            iconImageView.image = UIImage(named: "icon_alarm@3x.png")
            titleLabel.textColor = UIColor.todaitGray()
        }
    }
    
    func alarmOptionClk(){
        
        option = OptionStatus.Alarm.rawValue
        
    }
    
    func addReviewOptionView(){
        
        
        
        
        var reviewOption = UIButton(frame:CGRectMake(2*ratio,12*ratio,157*ratio,52*ratio))

        reviewOption.backgroundColor = UIColor.clearColor()
        reviewOption.addTarget(self, action: Selector("reviewOptionClk"), forControlEvents: UIControlEvents.TouchDown)
        optionView.addSubview(reviewOption)
        
        
        var iconImageView = UIImageView(frame: CGRectMake(10*ratio, 6*ratio, 40*ratio, 40*ratio))
        reviewOption.addSubview(iconImageView)
        
        
        var titleLabel = UILabel(frame: CGRectMake(63*ratio, 15*ratio, 92*ratio, 22.5*ratio))
        titleLabel.text = "복습 없음"
        titleLabel.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 12.5*ratio)
        reviewOption.addSubview(titleLabel)
        
        
        if option & OptionStatus.Review.rawValue > 0 {
            iconImageView.image = UIImage(named: "icon_review_wt@3x.png")
            titleLabel.textColor = UIColor.todaitGreen()
        }else{
            iconImageView.image = UIImage(named: "icon_review@3x.png")
            titleLabel.textColor = UIColor.todaitGray()
        }
    }
    
    func reviewOptionClk(){
        
        option = option | OptionStatus.Review.rawValue
        
    }
    
    func addReReadOptionView(){
        
        var reReadOption = UIButton(frame:CGRectMake(162*ratio,12*ratio,157*ratio,52*ratio))
        reReadOption.backgroundColor = UIColor.clearColor()
        reReadOption.addTarget(self, action: Selector("reReadOptionClk"), forControlEvents: UIControlEvents.TouchDown)
        optionView.addSubview(reReadOption)
        
        
        var iconImageView = UIImageView(frame: CGRectMake(10*ratio, 6*ratio, 40*ratio, 40*ratio))
        reReadOption.addSubview(iconImageView)
        
        
        var titleLabel = UILabel(frame: CGRectMake(63*ratio, 15*ratio, 92*ratio, 22.5*ratio))
        titleLabel.text = "회독 없음"
        titleLabel.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 12.5*ratio)
        reReadOption.addSubview(titleLabel)
        
        
        if option & OptionStatus.Reread.rawValue > 0 {
            iconImageView.image = UIImage(named: "icon_reread_wt@3x.png")
            titleLabel.textColor = UIColor.todaitGreen()
        }else{
            iconImageView.image = UIImage(named: "icon_reread@3x.png")
            titleLabel.textColor = UIColor.todaitGray()
        }
        
    }
    
    func reReadOptionClk(){
        
        //option = OptionStatus.Reread
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        titleLabel.text = titleString
        
        todaitNavBar.todaitDelegate = self
        todaitNavBar.backButton.hidden = false
        
        addCompleteButton()
    }
    
    func addCompleteButton(){
        
    }
    
    func backButtonClk(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
