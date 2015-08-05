//
//  NewGoalStep4ViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 8. 5..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class NewGoalStep4ViewController: BasicViewController,TodaitNavigationDelegate,CountDelegate{
   
    
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
        
        addAlarmOptionView()
        addReviewOptionView()
        addReReadOptionView()
        
        
    }
    
    func addAlarmOptionView(){
        
        
        var alarmOption = OptionButton(frame:CGRectMake(2*ratio,59*ratio,157*ratio,47*ratio))
        alarmOption.backgroundColor = UIColor.clearColor()
        alarmOption.addTarget(self, action: Selector("alarmOptionClk"), forControlEvents: UIControlEvents.TouchDown)
        alarmOption.onImage = UIImage(named: "icon_alarm_wt@3x.png")
        alarmOption.offImage = UIImage(named: "icon_alarm@3x.png")
        alarmOption.onColor = UIColor.todaitGreen()
        alarmOption.offColor = UIColor.todaitGray()
        alarmOption.setText("알람없음")
        alarmOption.setButtonOn(false)
        optionView.addSubview(alarmOption)
        
        
    }
    
    func alarmOptionClk(){
        
        option = OptionStatus.Alarm.rawValue
        
        
        
    }
    
    func addReviewOptionView(){
        
        
        
        
        var reviewOption = OptionButton(frame:CGRectMake(2*ratio,12*ratio,157*ratio,47*ratio))

        reviewOption.backgroundColor = UIColor.clearColor()
        reviewOption.addTarget(self, action: Selector("reviewOptionClk"), forControlEvents: UIControlEvents.TouchDown)
        reviewOption.onImage = UIImage(named: "icon_review_wt@3x.png")
        reviewOption.offImage = UIImage(named: "icon_review@3x.png")
        reviewOption.onColor = UIColor.todaitGreen()
        reviewOption.offColor = UIColor.todaitGray()
        reviewOption.setText("복습 0회")
        reviewOption.setButtonOn(false)
        optionView.addSubview(reviewOption)
        
    }
    
    func reviewOptionClk(){
        
        
        var reviewOptionVC = ReviewViewController()
        reviewOptionVC.delegate = self
        reviewOptionVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        
        self.navigationController?.presentViewController(reviewOptionVC, animated: false, completion: { () -> Void in
            
        })
        
        
        
    }
    
    func addReReadOptionView(){
        
        var reReadOption = OptionButton(frame:CGRectMake(162*ratio,12*ratio,157*ratio,47*ratio))
        reReadOption.backgroundColor = UIColor.clearColor()
        reReadOption.addTarget(self, action: Selector("reReadOptionClk"), forControlEvents: UIControlEvents.TouchDown)
        reReadOption.onImage = UIImage(named: "icon_reread_wt@3x.png")
        reReadOption.offImage = UIImage(named: "icon_reread@3x.png")
        reReadOption.onColor = UIColor.todaitGreen()
        reReadOption.offColor = UIColor.todaitGray()
        reReadOption.setText("회독 0회")
        reReadOption.setButtonOn(false)
        optionView.addSubview(reReadOption)
        
        
    }
    
    func reReadOptionClk(){
        
        //option = OptionStatus.Reread
        
        var readOptionVC = RereadViewController()
        readOptionVC.delegate = self
        readOptionVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        
        self.navigationController?.presentViewController(readOptionVC, animated: false, completion: { () -> Void in
            
        })
        
        
        
    }
    
    func count(count:Int){
        
        
        
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
        
        completeButton = UIButton(frame: CGRectMake(255*ratio, 32, 50*ratio, 20))
        completeButton.setTitle("완료", forState: UIControlState.Normal)
        completeButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 18*ratio)
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
