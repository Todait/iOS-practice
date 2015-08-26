//
//  NewGoalStep4AmountViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 8. 14..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit
import Alamofire

class AmountTaskOptionViewController: TaskOptionViewController ,AlarmDelegate,CountDelegate {

    var amountTask = AmountTask.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = UIColor.todaitBackgroundGray()
        addOptionView()
        
        updateAlarmStatus(amountTask.isNotification)
        
        eventOption = 1
        count(amountTask.reviewCount)
        
        eventOption = 2
        count(amountTask.repeatCount)
        
    }
    
    override func addAlarmOptionView(){
        super.addAlarmOptionView()
        
        alarmOption.addTarget(self, action: Selector("alarmOptionClk"), forControlEvents: UIControlEvents.TouchDown)
        alarmOption.setText("알람없음")
    }
    
    func alarmOptionClk(){
        
        eventOption = 0
        
        var alarmVC = AlarmViewController()
        alarmVC.delegate = self
        alarmVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        
        self.navigationController?.presentViewController(alarmVC, animated: false, completion: { () -> Void in
            
        })
        
        
        //option = OptionStatus.Alarm.rawValue
        
        
        
    }
    
    override func addReviewOptionView(){
        super.addReviewOptionView()
        
        reviewOption.addTarget(self, action: Selector("reviewOptionClk"), forControlEvents: UIControlEvents.TouchDown)
        reviewOption.setText("복습 \(amountTask.reviewCount)회")
        
    }
    
    func reviewOptionClk(){
        
        eventOption = 1
        
        var reviewOptionVC = ReviewViewController()
        reviewOptionVC.delegate = self
        reviewOptionVC.count = amountTask.repeatCount
        reviewOptionVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        
        self.navigationController?.presentViewController(reviewOptionVC, animated: false, completion: { () -> Void in
            
        })
        
        
        
    }
    
    override func addRepeatOptionView(){
        super.addRepeatOptionView()
        
        
        
        repeatOption.addTarget(self, action: Selector("repeatOptionClk"), forControlEvents: UIControlEvents.TouchDown)
        repeatOption.setText("회독 \(amountTask.repeatCount)회")
        
    }
    
    func repeatOptionClk(){
        
        
        eventOption = 2
        //option = OptionStatus.repeat
        
        var repeatOptionVC = RepeatViewController()
        repeatOptionVC.delegate = self
        repeatOptionVC.count = amountTask.repeatCount
        repeatOptionVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        
        self.navigationController?.presentViewController(repeatOptionVC, animated: false, completion: { () -> Void in
            
        })
        
        
        
    }
    
    
    func getAlarmStatus()->Bool{
        
        return amountTask.isNotification
    }
    
    func getAlarmTime() -> NSDate? {
        
        return amountTask.notificationDate
        
    }
    
    func updateAlarmTime(date: NSDate) {
        amountTask.notificationDate = date
    }
    
    func updateAlarmStatus(status: Bool) {
        
        
        amountTask.isNotification = status
        
        
        if amountTask.isNotification == true {
            
            if let notificationDate = amountTask.notificationDate {
                var comp = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitHour|NSCalendarUnit.CalendarUnitMinute, fromDate: amountTask.notificationDate!)
                
                alarmOption.setText("\(comp.hour):\(comp.minute)")
            }
            
        }else{
            alarmOption.setText("알람없음")
        }
        
        alarmOption.setButtonOn(amountTask.isNotification)
    }
    
    
    
    func count(count:Int){
        
        
        switch eventOption {
        case 1: reviewOption.setText("복습 \(count)회") ; reviewOption.setButtonOn(count != 0); amountTask.reviewCount = count
        case 2: repeatOption.setText("회독 \(count)회") ; repeatOption.setButtonOn(count != 0); amountTask.repeatCount = count
        default: eventOption = 0
        }
        
        eventOption = 0
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        titleLabel.text = amountTask.goal
        
        todaitNavBar.todaitDelegate = self
        todaitNavBar.backButton.hidden = false
        
        addCompleteButton()
    }
    
    override func completeButtonClk(){
        
        
        ProgressManager.show()
        
        if InternetManager.sharedInstance.isInternetEnable() == false {
            
            let alert = UIAlertView(title: "Invalid", message: "인터넷 연결이 필요합니다.", delegate: nil, cancelButtonTitle: "Cancel")
            alert.show()
            
            ProgressManager.hide()
            
        }else{
            
            requestAmountTask()
            
        }
        
    }
    
    func requestAmountTask(){
        
        ProgressManager.show()
        
        var params:[String:AnyObject] = makeBatchParams(CREATE_TASK,amountTask.createTaskParams())
        
        setUserHeader()
        
        Alamofire.request(.POST, SERVER_URL + BATCH , parameters: params).responseJSON(options: nil) {
            (request, response , object , error) -> Void in
            
            let jsons = JSON(object!)
            
            print(jsons)
            /*
            let jsonData:NSMutableData! = NSMutableData()
            
            
            jsonData.appendData(jsons["results"][0]["body"].stringValue.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
            let ddd = JSON(data:jsonData)
            
            
            let syncData = JSON(self.sss(jsons["results"][0]["body"].stringValue))
            self.realmManager.synchronize(syncData)
            
            
            let categoryData = JSON(jsons["results"][1]["body"].stringValue)
            let json:JSON? = jsons["category"]
            
            if let json = json {
                
                self.defaults.setObject(json.stringValue, forKey: "sync_at")
                self.realmManager.synchronizeCategory(json)
            }
            */
            ProgressManager.hide()
            
            self.navigationController?.dismissViewControllerAnimated(true, completion: { () -> Void in
                
            })
            
            //self.closeButtonClk()
            
        }
        
        
        
        amountTask.createTaskParams()
        
    }
    
}
