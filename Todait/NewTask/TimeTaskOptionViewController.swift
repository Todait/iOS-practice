//
//  NewGoalStep4TimeViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 8. 14..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit
import Alamofire

class TimeTaskOptionViewController: TaskOptionViewController ,AlarmDelegate ,CountDelegate{
   
    
    var timeTask = TimeTask.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = UIColor.todaitBackgroundGray()
        addOptionView()
        
        
        updateAlarmStatus(timeTask.isNotification)
        eventOption = 1
        count(timeTask.reviewCount)
        eventOption = 2
        count(timeTask.repeatCount)
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
        reviewOption.setText("복습 \(timeTask.reviewCount)회")

    }
    
    func reviewOptionClk(){
        
        eventOption = 1
        
        var reviewOptionVC = ReviewViewController()
        reviewOptionVC.delegate = self
        reviewOptionVC.count = timeTask.repeatCount
        reviewOptionVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        
        self.navigationController?.presentViewController(reviewOptionVC, animated: false, completion: { () -> Void in
            
        })
        
        
        
    }
    
    override func addRepeatOptionView(){
        super.addRepeatOptionView()
        
        
        
        repeatOption.addTarget(self, action: Selector("repeatOptionClk"), forControlEvents: UIControlEvents.TouchDown)
        repeatOption.setText("회독 \(timeTask.repeatCount)회")

    }
    
    func repeatOptionClk(){
        
        
        eventOption = 2
        //option = OptionStatus.repeat
        
        var repeatOptionVC = RepeatViewController()
        repeatOptionVC.delegate = self
        repeatOptionVC.count = timeTask.repeatCount
        repeatOptionVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        
        self.navigationController?.presentViewController(repeatOptionVC, animated: false, completion: { () -> Void in
            
        })
        
        
        
    }
    
    func getAlarmStatus()->Bool{
        
        return timeTask.isNotification
    }
    
    func getAlarmTime() -> NSDate? {
        
        return timeTask.notificationDate
        
    }
    
    func updateAlarmTime(date: NSDate) {
        timeTask.notificationDate = date
    }
    
    func updateAlarmStatus(status: Bool) {
        
        
        timeTask.isNotification = status
        
        
        if timeTask.isNotification == true {
            
            if let notificationDate = timeTask.notificationDate {
                var comp = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitHour|NSCalendarUnit.CalendarUnitMinute, fromDate: timeTask.notificationDate!)
                
                alarmOption.setText("\(comp.hour):\(comp.minute)")
            }
            
        }else{
            alarmOption.setText("알람없음")
        }
        
        alarmOption.setButtonOn(timeTask.isNotification)
    }
    
    
    
    func count(count:Int){
        
        
        switch eventOption {
        case 1: reviewOption.setText("복습 \(count)회") ; reviewOption.setButtonOn(count != 0); timeTask.reviewCount = count
        case 2: repeatOption.setText("회독 \(count)회") ; repeatOption.setButtonOn(count != 0); timeTask.repeatCount = count
        default: eventOption = 0
        }
        
        eventOption = 0
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        titleLabel.text = timeTask.goal
        todaitNavBar.todaitDelegate = self
        todaitNavBar.backButton.hidden = false
        
        addCompleteButton()
    }
    
    override func completeButtonClk(){
        
        requestTimeTask()
        
    }
    
    func requestTimeTask(){
        
        
        ProgressManager.show()
        
        if let param = timeTask.createTimeTaskParams() {
            
            
            var manager = Alamofire.Manager.sharedInstance
            manager.session.configuration.HTTPAdditionalHeaders = ["Content-Type":"application/json","Accept" : "application/vnd.todait.v1+json"]
            
            var params = makeBatchParams(CREATE_TASK, param)
            setUserHeader()
            
            Alamofire.request(.POST, SERVER_URL + BATCH, parameters: params).responseJSON(options: nil) { (request, response, object, error) -> Void in
                
                
                let jsons = JSON(object!)
                
                let syncData = encodeData(jsons["results"][0]["body"])
                self.realmManager.synchronize(syncData)
                
                
                
                
                let taskData = encodeData(jsons["results"][1]["body"])
                
                
                let task:JSON? = taskData["task"]
                if let task = task {
                    
                    self.defaults.setObject(task["sync_at"].stringValue, forKey: "sync_at")
                    self.realmManager.synchronizeTask(task)
                }
                
                
                let day:JSON? = taskData["future_days"]
                if let day = day {
                    self.defaults.setObject(day["sync_at"].stringValue, forKey: "sync_at")
                    self.realmManager.synchronizeDays(day)
                }
                
                let deleteDays:JSON? = taskData["deleted_days"]
                if let deleteDays = deleteDays {
                    self.defaults.setObject(deleteDays["sync_at"].stringValue, forKey: "sync_at")
                    self.realmManager.deleteDays(deleteDays)
                }
                
                ProgressManager.hide()
                
                self.navigationController?.dismissViewControllerAnimated(true, completion: { () -> Void in
                    
                })
                
            }
            
        }
        
    }
    
}
