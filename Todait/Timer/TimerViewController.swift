//
//  TimerViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 2..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit
import CoreData

class TimerViewController: BasicViewController,TodaitNavigationDelegate,ResetDelegate,TimeLogDelegate,AmountLogDelegate{
    
    var amountLabel: UILabel!
    var subAmountLabel: UILabel!
    var backgroundImageView: UIImageView!
    
    
    
    var mainTimerLabel:UILabel!
    var subTimerLabel:UILabel!
    
    var amountTextView:AmountTextView!
    var totalTimeLabel:UILabel!
    
    var resetButton: UIButton!
    var timeLogButton: UIButton!
    var amountLogButton: UIButton!
    var doneButton: UIButton!
    
    
    var timer : NSTimer!
    
    var backgroundImage : UIImage!
    
    
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
        
        addAmountTextView()
        
        
        addTotalTimeLabel()
        
        addResetButton()
        addTimeButton()
        addAmountButton()
        addDoneButton()
        
        //addAmountChartView()
        //addTimerView()
        addCompleteButton()
        setMainTimerLabel()
        setSubTimerLabel()
        addTimerButton()
        
        
        
        
        startTimer()
        
    }
    
    func addAmountTextView(){
        
        amountTextView = AmountTextView(frame: CGRectMake(95*ratio,105*ratio, 130*ratio, 44*ratio))
        amountTextView.setupText(day.done_amount.integerValue, total: day.expect_amount.integerValue, unit: task.unit)
        amountTextView.userInteractionEnabled = false
        amountTextView.amountFont = UIFont(name: "AppleSDGothicNeo-Light", size: 34*ratio)
        amountTextView.unitFont = UIFont(name: "AppleSDGothicNeo-Light", size: 34*ratio)
        amountTextView.amountColor = UIColor.whiteColor()
        amountTextView.unitColor = UIColor.whiteColor()
        
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.Center
        amountTextView.paragraphStyle = paragraphStyle
        
        view.addSubview(amountTextView)
        
        amountTextView.setupText(day.done_amount.integerValue, total: day.expect_amount.integerValue, unit: task.unit)
    }
    
    
    
    func addTotalTimeLabel(){
        
        totalTimeLabel = UILabel(frame: CGRectMake(95*ratio, height - 120*ratio, 130*ratio, 25*ratio))
        totalTimeLabel.text = ""
        totalTimeLabel.textAlignment = NSTextAlignment.Center
        totalTimeLabel.textColor = UIColor.whiteColor()
        totalTimeLabel.font = UIFont(name: "AppleSDGothicNeo", size: 12*ratio)
        
        
        view.addSubview(totalTimeLabel)
        
    }
    
    func addResetButton(){
        resetButton = UIButton(frame: CGRectMake(0, height, 80*ratio, 48*ratio))
        resetButton.setImage(UIImage(named: "stopwatch_bottom_02@3x.png"), forState: UIControlState.Normal)
        resetButton.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        resetButton.addTarget(self, action: Selector("resetButtonClk"), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(resetButton)
    }
    
    func resetButtonClk(){
        
        var resetVC = ResetViewController()
        resetVC.delegate = self
        resetVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        
        self.navigationController?.presentViewController(resetVC, animated: false, completion: { () -> Void in
            
        })
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
        day.done_second = Int(day.done_second) + Int(totalTime)
        timeLog.after_second = day.done_second.integerValue
        timeLog.done_second = Int(totalTime)
        timeLog.created_at = NSDate()
        timeLog.updated_at = NSDate()
        
        
        var error: NSError?
        managedObjectContext?.save(&error)
        
        
        
        updateTimeLabel()
        amountTextView.setupText(day.done_amount.integerValue, total: day.expect_amount.integerValue, unit: task.unit)
    }
    
    func resetTimeLog() {
        totalTime = totalTime - currentTime
        currentTime = 0
        
        updateTimeLabel()
    }
    
    
    func showButtons(show:Bool){
        
        var transform = 48*ratio
        
        if show {
            transform = transform * -1
        }
        
        UIView.animateWithDuration(0.4, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            self.timeLogButton.transform = CGAffineTransformMakeTranslation(0, transform)
            self.resetButton.transform = CGAffineTransformMakeTranslation(0, transform)
            self.amountLogButton.transform = CGAffineTransformMakeTranslation(0, transform)
            }, completion: { (Bool) -> Void in
                
        })
        
        
    }
    
    
    
    func addTimeButton(){
        timeLogButton = UIButton(frame: CGRectMake(80*ratio, height, 80*ratio, 48*ratio))
        timeLogButton.setBackgroundImage(UIImage(named: "stopwatch_bottom_03@3x.png"), forState: UIControlState.Normal)
        timeLogButton.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        timeLogButton.addTarget(self, action: Selector("timeButtonClk"), forControlEvents: UIControlEvents.TouchUpInside)
        timeLogButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        view.addSubview(timeLogButton)
    }
    
    func timeButtonClk(){
        
        var timeLogVC = TimeLogViewController()
        timeLogVC.delegate = self
        timeLogVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        
        self.navigationController?.presentViewController(timeLogVC, animated: false, completion: { () -> Void in
            
        })
        
    }
    
    func saveTimeLog(time: NSTimeInterval) {
        
        let entityDescription = NSEntityDescription.entityForName("TimeLog", inManagedObjectContext:managedObjectContext!)
        let timeLog = TimeLog(entity: entityDescription!, insertIntoManagedObjectContext:managedObjectContext)
        timeLog.dirty_flag = 0
        timeLog.day_id = day
        timeLog.timestamp = NSDate().timeIntervalSince1970
        timeLog.created_at = NSDate()
        timeLog.server_id = 0
        timeLog.before_second = day.done_second
        day.done_second = Int(day.done_second.integerValue) + Int(time)
        timeLog.after_second = day.done_second.integerValue
        timeLog.done_second = Int(time)
        timeLog.created_at = NSDate()
        timeLog.updated_at = NSDate()
        
        //timeLog.day_id.done_second = timeLog.day_id.done_second.integerValue + Int(time)
        
        var error: NSError?
        managedObjectContext?.save(&error)
        
        totalTime = totalTime + time
        
        updateTimeLabel()
        amountTextView.setupText(day.done_amount.integerValue, total: day.expect_amount.integerValue, unit: task.unit)

    }
    
    func addAmountButton(){
        amountLogButton = UIButton(frame: CGRectMake(160*ratio, height, 80*ratio, 48*ratio))
        amountLogButton.setImage(UIImage(named: "stopwatch_bottom_04@3x.png"), forState: UIControlState.Normal)
        amountLogButton.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        amountLogButton.addTarget(self, action: Selector("amountButtonClk"), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(amountLogButton)
    }
    
    func amountButtonClk(){
        
        var amountVC = AmountViewController()
        //amountVC.delegate = self
        amountVC.amount_type = task.amount_type
        amountVC.unit = task.unit
        amountVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        amountVC.delegate = self
        self.navigationController?.presentViewController(amountVC, animated: false, completion: { () -> Void in
            
        })
    }
    
    func saveAmountLog(amount:Int){
        
        let entityDescription = NSEntityDescription.entityForName("AmountLog", inManagedObjectContext:managedObjectContext!)
        
        let amountLog = AmountLog(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
        
        amountLog.day_id = day
        amountLog.before_done_amount = day.done_amount
        amountLog.updated_at = NSDate()
        amountLog.dirty_flag = 0
        day.done_amount = Int(day.done_amount) + Int(amount)
        amountLog.after_done_amount = day.done_amount
        amountLog.created_at = NSDate()
        amountLog.timestamp = NSDate().timeIntervalSince1970
        amountLog.server_id = 0
        amountLog.server_day_id = 0
        amountLog.archived = 0
    
        
        var error: NSError?
        managedObjectContext?.save(&error)
        
        if let err = error {
            //에러처리
        }else{
            NSLog("AmountLog 저장 및 업데이트성공",1)
        }
        
        amountTextView.setupText(day.done_amount.integerValue, total: day.expect_amount.integerValue, unit: task.unit)
    }
    
    
    
    func addDoneButton(){
        doneButton = UIButton(frame: CGRectMake(240*ratio, height-48*ratio, 80*ratio, 48*ratio))
        doneButton.setBackgroundImage(UIImage(named: "stopwatch_bottom_05@3x.png"), forState: UIControlState.Normal)
        doneButton.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        doneButton.addTarget(self, action: Selector("doneButtonClk"), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(doneButton)
    }
    
    func doneButtonClk(){
        
        backButtonClk()
        
        
    }
    
    
    func updateButtons(){
        
        
        resetButton.setBackgroundImage(UIImage(named: "stopwatch_bottom_02@3x.png"), forState: UIControlState.Normal)
        timeLogButton.setBackgroundImage(UIImage(named: "stopwatch_bottom_03@3x.png"), forState: UIControlState.Normal)
        amountLogButton.setBackgroundImage(UIImage(named: "stopwatch_bottom_04@3x.png"), forState: UIControlState.Normal)
        doneButton.setBackgroundImage(UIImage(named: "stopwatch_bottom_05@3x.png"), forState: UIControlState.Normal)

        
        
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
    
    func setMainTimerLabel(){
        
        mainTimerLabel = UILabel(frame: CGRectMake(15*ratio, 380*ratio, 290*ratio, 50*ratio))
        mainTimerLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 38*ratio)
        mainTimerLabel.text = "00:00:00"
        mainTimerLabel.textColor = UIColor.whiteColor()
        mainTimerLabel.textAlignment = NSTextAlignment.Center
        view.addSubview(mainTimerLabel)
        
    }
    
    
    func setSubTimerLabel(){
        subTimerLabel = UILabel(frame: CGRectMake(15*ratio, 425*ratio,290*ratio, 24*ratio))
        subTimerLabel.font = UIFont(name: "AppleSDGothicNeo-Light", size: 14*ratio)
        subTimerLabel.text = "누적 공부 시간 00:00:00"
        subTimerLabel.textColor = UIColor.whiteColor()
        subTimerLabel.textAlignment = NSTextAlignment.Center
        view.addSubview(subTimerLabel)
        
    }

    
    func addTimerButton(){
        
        timerButton = UIButton(frame: CGRectMake(113*ratio, 209*ratio, 94*ratio, 122*ratio))
        timerButton.setBackgroundImage(UIImage(named: "02_stopwatch_stop@3x.png"), forState: UIControlState.Normal)
        timerButton.setBackgroundImage(UIImage(named: "02_stopwatch_play@3x.png"), forState: UIControlState.Highlighted)
        timerButton.addTarget(self, action: Selector("timerButtonClk"), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(timerButton)
        
    }
    
    
    
    func timerButtonClk(){
        
        if timer.valid {
            
            showButtons(true)
            
            timerButton.setBackgroundImage(UIImage(named: "02_stopwatch_play@3x.png"), forState: UIControlState.Normal)
            timerButton.setBackgroundImage(UIImage(named: "02_stopwatch_stop@3x.png"), forState: UIControlState.Highlighted)
            
            timer.invalidate()
            
            /*
            endDate = NSDate()
            stopTimer()
            
            recordTime()
            */
        }else{
            //startTimer()
            
            showButtons(false)
            startTimer()
            
            timerButton.setBackgroundImage(UIImage(named: "02_stopwatch_stop@3x.png"), forState: UIControlState.Normal)
            timerButton.setBackgroundImage(UIImage(named: "02_stopwatch_play@3x.png"), forState: UIControlState.Highlighted)
            
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
        //view.addSubview(completeButton)
        
        
        //self.navigationController?.popViewControllerAnimated(true)
        
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
        subTimerLabel.text = "누적 공부 시간 " + getTimeStringFromSeconds(totalTime)
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
        
        self.titleLabel.text = task.category_id.name + " - " + task.name
        
        todaitNavBar.setBackgroundImage(UIImage.colorImage(UIColor.clearColor(),frame:todaitNavBar.frame), forBarMetrics: UIBarMetrics.Default)
        todaitNavBar.shadowImage = UIImage()
        
        
        self.screenName = "Stopwatch Activity"
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    /*
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
    */
    func addAmountCount(point:Int){
        amountCount = amountCount + point
    }
    
    
    func backButtonClk() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
