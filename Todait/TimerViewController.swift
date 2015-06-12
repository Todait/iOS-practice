//
//  TimerViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 2..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit
import CoreData

class TimerViewController: BasicViewController,TodaitNavigationDelegate {
    
    
    var timer : NSTimer!
    var backgroundImageView : UIImageView!
    var backgroundImage : UIImage!
    
    @IBOutlet weak var mainTimerLabel: UILabel!
    var subTimerLabel : UILabel!
    var contentsLabel : UILabel!
    var timerButton : UIButton!
    
    var currentTime : NSTimeInterval! = 0
    var totalTime : NSTimeInterval! = 0
    
    
    var startDate: NSDate!
    var endDate: NSDate!
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var day:Day!
    var task:Task!
    
    var completeButton:UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        
        
        
        addSubTimerLabel()
        addTimerButton()
        setupTimer()
        startTimer()
        
        addCompleteButton()
    }
    
    func setupBackgroundImage(){
        backgroundImage = UIImage(named:"track.jpg")
    }
    
    func addBackgroundImageView(){
        backgroundImageView = UIImageView(frame: view.frame)
        backgroundImageView.image = backgroundImage
        view.addSubview(backgroundImageView)
        
        addFilterImageView(backgroundImageView, alpha: 0.5)
    }
    
    func addFilterImageView(imageView:UIImageView,alpha:CGFloat){
        
        let filterView : UIImageView = UIImageView(frame: CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height))
        filterView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        imageView.addSubview(filterView)
    }
    
    func addMainTimerLabel(){
        mainTimerLabel = UILabel(frame:CGRectMake(0, 0,260*ratio, 100*ratio))
        mainTimerLabel.font = UIFont(name: "AvenirNext-Regular", size: 50*ratio)
        mainTimerLabel.text = "00:00:00"
        mainTimerLabel.textColor = UIColor.whiteColor()
        mainTimerLabel.textAlignment = NSTextAlignment.Center
        mainTimerLabel.sizeToFit()
        mainTimerLabel.center = view.center
        view.addSubview(mainTimerLabel)
        
    }
    
    func addSubTimerLabel(){
        subTimerLabel = UILabel(frame: CGRectMake(0,0,200*ratio, 30*ratio))
        subTimerLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        subTimerLabel.font = UIFont(name: "AvenirNext-Regular", size: 20*ratio)
        subTimerLabel.text = "00:00:00"
        subTimerLabel.textColor = UIColor.whiteColor()
        subTimerLabel.textAlignment = NSTextAlignment.Right
        view.addSubview(subTimerLabel)
        
        
        var subTopConstraint = NSLayoutConstraint(item: subTimerLabel, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: mainTimerLabel, attribute: NSLayoutAttribute.Top, multiplier: ratio, constant: -5)
        view.addConstraint(subTopConstraint)
        
        
        var subRightConstraint = NSLayoutConstraint(item: subTimerLabel, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: mainTimerLabel, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0)
        view.addConstraint(subRightConstraint)
        
    }
    
    func addTimerButton(){
        timerButton = UIButton(frame: CGRectMake(0, 0, 100*ratio, 100*ratio))
        timerButton.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.25)
        timerButton.clipsToBounds = true
        timerButton.layer.cornerRadius = 10*ratio
        timerButton.addTarget(self, action: Selector("timerButtonClk"), forControlEvents: UIControlEvents.TouchUpInside)
        timerButton.center = view.center
        view.addSubview(timerButton)
    }
    
    func timerButtonClk(){
        if timer.valid {
            
            endDate = NSDate()
            stopTimer()
            
            recordTime()
            
            
            
        }else{
            startTimer()
            
        }
    }
    
    
    func recordTime(){
        
        
        saveTimeLog()
        saveTimeHistory()
        
        day.done_second = NSNumber(integer:day.done_second.integerValue+Int(totalTime))
        var error:NSError?
        managedObjectContext?.save(&error)
        
        NSLog("시간이 저장되었습니다",0)
        
    }
    
    
    func saveTimeLog(){
        
        let entityDescription = NSEntityDescription.entityForName("TimeLog", inManagedObjectContext:managedObjectContext!)
        let timeLog = TimeLog(entity: entityDescription!, insertIntoManagedObjectContext:managedObjectContext)
        timeLog.dirty_flag = 0
        timeLog.day_id = day
        timeLog.timestamp = NSDate().timeIntervalSince1970
        timeLog.created_at = NSDate()
        timeLog.server_id = 0
        timeLog.before_second = day.done_second
        timeLog.after_second = day.done_second.integerValue + Int(totalTime)
        timeLog.done_second = Int(totalTime)
        timeLog.created_at = NSDate()
        timeLog.updated_at = NSDate()
        
        var error: NSError?
        managedObjectContext?.save(&error)
    }
    
    func saveTimeHistory(){
        
        let entityDescription = NSEntityDescription.entityForName("TimeHistory", inManagedObjectContext:managedObjectContext!)
        let timeHistory = TimeHistory(entity: entityDescription!, insertIntoManagedObjectContext:managedObjectContext)
        timeHistory.dirty_flag = 0
        timeHistory.day_id = day
        timeHistory.created_at = NSDate()
        timeHistory.updated_at = NSDate()
        timeHistory.server_id = 0
        timeHistory.server_day_id = 0
        timeHistory.started_at = startDate
        timeHistory.ended_at = endDate
        timeHistory.done_millis = endDate.timeIntervalSinceDate(startDate)
        
        var error: NSError?
        managedObjectContext?.save(&error)
    }
    
    func setupTimer(){
        currentTime = 0
        totalTime = 0
        startDate = NSDate()
    }
    
    func startTimer(){
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("countDown"), userInfo: nil, repeats: true)
        countDown()
    }
    
    
    func addCompleteButton(){
        
        completeButton = UIButton(frame:CGRectMake(50*ratio, 400*ratio, 220*ratio, 45*ratio))
        completeButton.layer.borderWidth = 2*ratio
        completeButton.layer.borderColor = UIColor.todaitGreen().CGColor
        completeButton.setBackgroundImage(UIImage.colorImage(UIColor.clearColor(), frame: CGRectMake(0,0,260*ratio,45*ratio)), forState:UIControlState.Normal)
        completeButton.setBackgroundImage(UIImage.colorImage(UIColor.todaitGreen(), frame: CGRectMake(0, 0, 260*ratio, 45*ratio)), forState: UIControlState.Highlighted)
        completeButton.setTitle("Complete", forState: UIControlState.Normal)
        completeButton.setTitleColor(UIColor.todaitGreen(), forState: UIControlState.Normal)
        completeButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        completeButton.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 18*ratio)
        
        view.addSubview(completeButton)
    }
    
    func countDown(){
        
        currentTime = currentTime + 1
        totalTime = totalTime + 1
        
        updateTimeLabel()
        
    }
    
    func stopTimer(){
        timer.invalidate()
    }
    
    func updateTimeLabel(){
        
        mainTimerLabel.text = getTimeStringFromSeconds(currentTime)
        subTimerLabel.text = getTimeStringFromSeconds(totalTime)
    }
    
    func getTimeStringFromSeconds(seconds : NSTimeInterval ) -> String {
        
        let hour : Int = Int(seconds / 3600)
        let minute : Int = Int((seconds % 3600 ) / 60)
        let second : Int = Int((seconds % 3600 ) % 60)
        
        return String(format:  "%02lu:%02lu:%02lu", arguments: [hour,minute,second])
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        todaitNavBar.todaitDelegate = self
        todaitNavBar.backButton.hidden = false
        
        self.titleLabel.text = task.name
        
        todaitNavBar.setBackgroundImage(UIImage.colorImage(UIColor.clearColor(),frame:todaitNavBar.frame), forBarMetrics: UIBarMetrics.Default)
        todaitNavBar.shadowImage = UIImage()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func backButtonClk() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
