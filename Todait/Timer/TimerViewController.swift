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
    
    
    
    var amountChartFrontView:UIView!
    var amountChartBackView:UIView!
    var amountCount:Int! = 0
    
    
    var startDate: NSDate!
    var endDate: NSDate!
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var day:Day!
    var task:Task!
    
    var completeButton:UIButton!
    
    var timerView:TimerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        
        addAmountChartView()
        addTimerView()
        addCompleteButton()
        
        addTimeSettingView()
        //startTimer()
    }
    
    
    func addAmountChartView(){
        
        amountChartBackView = UIView(frame: CGRectMake(30*ratio, 60*ratio, 260*ratio, 24*ratio))
        amountChartBackView.layer.cornerRadius = 12*ratio
        amountChartBackView.backgroundColor = UIColor.todaitLightGray()
        amountChartBackView.clipsToBounds = true
        view.addSubview(amountChartBackView)
        
        
        
        amountChartFrontView = UIView(frame: CGRectMake(0, 0, 0*ratio, 24*ratio))
        amountChartFrontView.backgroundColor = task.getColor()
        amountChartFrontView.layer.cornerRadius = 12*ratio
        amountChartFrontView.clipsToBounds = true
        amountChartBackView.addSubview(amountChartFrontView)
        
        
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
        //filterView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
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
        
        
        var subTopConstraint = NSLayoutConstraint(item: subTimerLabel, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: mainTimerLabel, attribute: NSLayoutAttribute.Top, multiplier: ratio, constant: -25*ratio)
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
        
        endDate = NSDate()
        stopTimer()
        
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
    
    
    func addTimerView(){
        
        timerView = TimerView(frame:CGRectMake(0,0,240*ratio,240*ratio))
        timerView.center = view.center
        timerView.setTimerColor(task.getColor())
        timerView.startAnimation()
        
        view.addSubview(timerView)
        
    }
    
    
    
    
    func addCompleteButton(){
        
        completeButton = UIButton(frame:CGRectMake(50*ratio, 470*ratio, 220*ratio, 45*ratio))
        completeButton.layer.borderWidth = 2*ratio
        completeButton.layer.borderColor = task.getColor().CGColor
        completeButton.setBackgroundImage(UIImage.colorImage(UIColor.clearColor(), frame: CGRectMake(0,0,260*ratio,45*ratio)), forState:UIControlState.Normal)
        completeButton.setBackgroundImage(UIImage.colorImage(task.getColor(), frame: CGRectMake(0, 0, 260*ratio, 45*ratio)), forState: UIControlState.Highlighted)
        completeButton.setTitle("Complete", forState: UIControlState.Normal)
        completeButton.setTitleColor(task.getColor(), forState: UIControlState.Normal)
        completeButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        completeButton.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 18*ratio)
        completeButton.addTarget(self, action: Selector("recordTime"), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(completeButton)
        
        
        self.navigationController?.popViewControllerAnimated(true)
        
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
    
    
    func addTimeSettingView(){
        
        let timeView = UIView(frame:view.frame)
        timeView.backgroundColor = task.getColor()
        //view.addSubview(timeView)
        
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        todaitNavBar.todaitDelegate = self
        todaitNavBar.backButton.hidden = false
        
        self.titleLabel.text = task.name
        
        todaitNavBar.setBackgroundImage(UIImage.colorImage(UIColor.clearColor(),frame:todaitNavBar.frame), forBarMetrics: UIBarMetrics.Default)
        todaitNavBar.shadowImage = UIImage()
        
        
        self.screenName = "Stopwatch Activity"
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        let touch: AnyObject? = (touches as NSSet).anyObject()
        let touchPoint:CGPoint! = touch?.locationInView(view)
        
        
        
        let img = UIImageView(frame:CGRectMake(0,0,20*ratio,20*ratio))
        img.image = UIImage(named:"TodaitScore.png")
        img.center = touchPoint
        view.addSubview(img)
        
        let pointLabel = UILabel(frame:CGRectMake(0*ratio,0,60*ratio,10*ratio))
        pointLabel.textColor = UIColor.todaitGreen()
        pointLabel.text = "+1"
        pointLabel.font = UIFont(name:"AvenirNext-Regular",size:8*ratio)
        pointLabel.textAlignment = NSTextAlignment.Left
        pointLabel.center = CGPointMake(touchPoint.x+25*ratio,touchPoint.y)
        view.addSubview(pointLabel)
        
        UIView.animateWithDuration(1.5, animations: { () -> Void in
            
            img.center = CGPointMake(img.center.x,img.center.y - 100*self.ratio)
            img.alpha = 0
            
            pointLabel.center = CGPointMake(pointLabel.center.x,pointLabel.center.y - 100*self.ratio)
            pointLabel.alpha = 0
            
            
            }) { (Bool) -> Void in
                
                img.removeFromSuperview()
                pointLabel.removeFromSuperview()
        }
        

    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch: AnyObject? = (touches as NSSet).anyObject()
        let touchPoint:CGPoint! = touch?.locationInView(view)
        
        
        
        let img = UIImageView(frame:CGRectMake(0,0,20*ratio,20*ratio))
        img.image = UIImage(named:"TodaitScore.png")
        img.center = touchPoint
        view.addSubview(img)
        
        let pointLabel = UILabel(frame:CGRectMake(0*ratio,0,60*ratio,10*ratio))
        pointLabel.textColor = UIColor.todaitGreen()
        pointLabel.text = "+1"
        pointLabel.font = UIFont(name:"AvenirNext-Regular",size:8*ratio)
        pointLabel.textAlignment = NSTextAlignment.Left
        pointLabel.center = CGPointMake(touchPoint.x+25*ratio,touchPoint.y)
        view.addSubview(pointLabel)
        
        
        addAmountCount(1)
        
        
        UIView.animateWithDuration(1.5, animations: { () -> Void in
            
            img.center = CGPointMake(img.center.x,img.center.y - 100*self.ratio)
            img.alpha = 0
            
            pointLabel.center = CGPointMake(pointLabel.center.x,pointLabel.center.y - 100*self.ratio)
            pointLabel.alpha = 0
            
            self.amountChartFrontView.frame = CGRectMake(0,0,CGFloat(self.amountCount*2),24*self.ratio)
            
            }) { (Bool) -> Void in
                
                img.removeFromSuperview()
                pointLabel.removeFromSuperview()
        }
    }
    
    func addAmountCount(point:Int){
        amountCount = amountCount + point
    }
    
    
    func backButtonClk() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
