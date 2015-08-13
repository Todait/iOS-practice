//
//  TimerViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 2..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit
import CoreData

class TimerViewController: BasicViewController,TodaitNavigationDelegate,ResetDelegate,TimeLogDelegate,AmountLogDelegate,ExitDelegate{
    
    var amountLabel: UILabel!
    var subAmountLabel: UILabel!
    
    
    var backgroundImageView: UIImageView!
    var filterView:UIImageView!
    
    
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
    
    //let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    
    var day:Day!
    var task:Task!
    
    var completeButton:UIButton!
    
    var timerView:TimerView!
    
    var isSaved:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        
        totalTime = NSTimeInterval(day.doneSecond)
        
        addBackgroundImageView()
        
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
    
    func addBackgroundImageView(){
        
        backgroundImageView = UIImageView(frame:view.frame)
        backgroundImageView.image = UIImage(named: "timerBack2@3x.png")
        backgroundImageView.contentMode = UIViewContentMode.ScaleAspectFill
        backgroundImageView.clipsToBounds = true
        view.addSubview(backgroundImageView)
        
        filterView = UIImageView(frame:view.frame)
        filterView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        backgroundImageView.addSubview(filterView)
    }
    
    func addAmountTextView(){
        
        amountTextView = AmountTextView(frame: CGRectMake(95*ratio,105*ratio, 130*ratio, 44*ratio))
        amountTextView.userInteractionEnabled = false
        amountTextView.amountFont = UIFont(name: "AppleSDGothicNeo-Light", size: 34*ratio)
        amountTextView.unitFont = UIFont(name: "AppleSDGothicNeo-Light", size: 34*ratio)
        amountTextView.amountColor = UIColor.whiteColor()
        amountTextView.unitColor = UIColor.whiteColor()
        
        
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.Center
        amountTextView.paragraphStyle = paragraphStyle
        
        view.addSubview(amountTextView)
        
        if let day = day {
            amountTextView.setupText(day.doneAmount, total: day.expectAmount, unit: task.unit)
        }
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
        resetButton = UIButton(frame: CGRectMake(0, height, 80*ratio, 55*ratio))
        resetButton.setImage(UIImage(named: "bt_initialization@3x.png"), forState: UIControlState.Normal)
        resetButton.setBackgroundImage(UIImage.colorImage(UIColor(red: 0, green: 0, blue: 0, alpha: 0.3), frame: CGRectMake(0,0,80*ratio,55*ratio)), forState: UIControlState.Highlighted)
        resetButton.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
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
        
        
        /*
        let entityDescription = NSEntityDescription.entityForName("TimeLog", inManagedObjectContext:managedObjectContext!)
        let timeLog = TimeLog(entity: entityDescription!, insertIntoManagedObjectContext:managedObjectContext)
        
        timeLog.dayId = day
        timeLog.timestamp = NSDate().timeIntervalSince1970
        timeLog.createdAt = NSDate()
        timeLog.beforeSecond = day.doneSecond
        day.doneSecond = Int(day.doneSecond) + Int(currentTime)
        currentTime = 0
        timeLog.afterSecond = day.doneSecond
        timeLog.createdAt = NSDate()
        timeLog.updatedAt = NSDate()
        
        
        var error: NSError?
        managedObjectContext?.save(&error)
        */
        
        let timeLog = TimeLog()
        timeLog.id = NSUUID().UUIDString
        timeLog.day = day
        timeLog.timestamp = Int(NSDate().timeIntervalSince1970)
        timeLog.beforeSecond = day.doneSecond
        timeLog.afterSecond = Int(day.doneSecond) + Int(currentTime)
        
        realm.write{
            self.realm.add(timeLog)
            self.day.timeLogs.append(timeLog)
            self.day.doneSecond = Int(self.day.doneSecond) + Int(self.currentTime)
            self.realm.add(self.day, update: true)
        }
        
        
        
        currentTime = 0
        updateTimeLabel()
        amountTextView.setupText(day.doneAmount, total: day.expectAmount, unit: task.unit)
    }
    
    func resetTimeLog() {
        totalTime = totalTime - currentTime
        currentTime = 0
        
        updateTimeLabel()
        isSaved = true
    }
    
    
    func showButtons(show:Bool){
        
        var transform = 55*ratio
        
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
        timeLogButton = UIButton(frame: CGRectMake(80*ratio, height, 80*ratio, 55*ratio))
        timeLogButton.setImage(UIImage(named: "bt_stopwatch@3x.png"), forState: UIControlState.Normal)
        timeLogButton.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        timeLogButton.addTarget(self, action: Selector("timeButtonClk"), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        timeLogButton.setBackgroundImage(UIImage.colorImage(UIColor(red: 0, green: 0, blue: 0, alpha: 0.3), frame: CGRectMake(0,0,80*ratio,55*ratio)), forState: UIControlState.Highlighted)
        
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
    
    func recordTimeLog(time: NSTimeInterval) {
        
        
        currentTime = currentTime + time
        totalTime = totalTime + time
        updateTimeLabel()
        /*
        let entityDescription = NSEntityDescription.entityForName("TimeLog", inManagedObjectContext:managedObjectContext!)
        let timeLog = TimeLog(entity: entityDescription!, insertIntoManagedObjectContext:managedObjectContext)
        
        timeLog.dayId = day
        timeLog.timestamp = NSDate().timeIntervalSince1970
        timeLog.createdAt = NSDate()
        timeLog.beforeSecond = day.doneSecond
        day.doneSecond = Int(day.doneSecond.integerValue) + Int(time)
        timeLog.afterSecond = day.doneSecond.integerValue
        timeLog.createdAt = NSDate()
        timeLog.updatedAt = NSDate()
        
        //timeLog.day_id.doneSecond = timeLog.day_id.doneSecond.integerValue + Int(time)
        
        var error: NSError?
        managedObjectContext?.save(&error)
        
        totalTime = totalTime + time
        
        updateTimeLabel()
        amountTextView.setupText(day.doneAmount.integerValue, total: day.expectAmount.integerValue, unit: task.unit)
        */
    }
    
    func addAmountButton(){
        amountLogButton = UIButton(frame: CGRectMake(160*ratio, height, 80*ratio, 55*ratio))
        amountLogButton.setImage(UIImage(named: "bt_amount@3x.png"), forState: UIControlState.Normal)
        amountLogButton.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        
        amountLogButton.setBackgroundImage(UIImage.colorImage(UIColor(red: 0, green: 0, blue: 0, alpha: 0.3), frame: CGRectMake(0,0,80*ratio,55*ratio)), forState: UIControlState.Highlighted)
        
        amountLogButton.addTarget(self, action: Selector("amountButtonClk"), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(amountLogButton)
    }
    
    func amountButtonClk(){
        
        var amountVC = AmountViewController()
        //amountVC.delegate = self
        amountVC.taskType = task.taskType
        amountVC.unit = task.unit
        amountVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        amountVC.delegate = self
        self.navigationController?.presentViewController(amountVC, animated: false, completion: { () -> Void in
            
        })
    }
    
    func saveAmountLog(amount:Int){
        
        /*
        let entityDescription = NSEntityDescription.entityForName("AmountLog", inManagedObjectContext:managedObjectContext!)
        
        let amountLog = AmountLog(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
        
        amountLog.dayId = day
        amountLog.beforeDoneAmount = day.doneAmount
        amountLog.updatedAt = NSDate()
        amountLog.dirtyFlag = 0
        day.doneAmount = Int(day.doneAmount) + Int(amount)
        amountLog.afterDoneAmount = day.doneAmount
        amountLog.createdAt = NSDate()
        amountLog.timestamp = NSDate().timeIntervalSince1970
        amountLog.serverId = 0
        amountLog.serverDayId = 0
        amountLog.archived = 0
    
        
        var error: NSError?
        managedObjectContext?.save(&error)
        
        if let err = error {
            //에러처리
        }else{
            NSLog("AmountLog 저장 및 업데이트성공",1)
        }
        */
        
        let amountLog = AmountLog()
        amountLog.id = NSUUID().UUIDString
        amountLog.day = day
        amountLog.beforeAmount = day.doneAmount
        amountLog.dirtyFlag = false

        amountLog.afterAmount = day.doneAmount
        amountLog.timestamp = Int(NSDate().timeIntervalSince1970)
        amountLog.serverId = 0
        amountLog.archived = false
        
        realm.write{
            self.realm.add(amountLog)
            self.day.amountLogs.append(amountLog)
            self.day.doneAmount = Int(self.day.doneAmount) + Int(amount)
            self.realm.add(self.day,update:true)
        }
        
        amountTextView.setupText(day.doneAmount, total: day.expectAmount, unit: task.unit)
    }
    
    
    
    func addDoneButton(){
        doneButton = UIButton(frame: CGRectMake(240*ratio, height-55*ratio, 80*ratio, 55*ratio))
        doneButton.setBackgroundImage(UIImage(named: "bt_check@3x.png"), forState: UIControlState.Normal)
        doneButton.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        doneButton.addTarget(self, action: Selector("doneButtonClk"), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(doneButton)
    }
    
    func doneButtonClk(){
        
        
        updateTimeLabel()
        saveTimeLog()
        
        if timer.valid == true {
            timerButtonClk()
        }
        
        isSaved = true
        
        
        //backButtonClk()
        
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
        subTimerLabel.text = "누적 공부 시간 " + getTimeStringFromSeconds(totalTime)
        subTimerLabel.textColor = UIColor.whiteColor()
        subTimerLabel.textAlignment = NSTextAlignment.Center
        view.addSubview(subTimerLabel)
        
    }

    
    func addTimerButton(){
        
        timerButton = UIButton(frame: CGRectMake(113*ratio, 209*ratio, 94*ratio, 122*ratio))
        timerButton.setBackgroundImage(UIImage(named: "02_stopwatch_stop@3x.png"), forState: UIControlState.Normal)
        timerButton.setBackgroundImage(UIImage.maskColor("02_stopwatch_stop@3x.png", color:UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)), forState: UIControlState.Highlighted)
        timerButton.addTarget(self, action: Selector("timerButtonClk"), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(timerButton)
        
    }
    
    
    
    func timerButtonClk(){
        
        if timer.valid {
            
            showButtons(true)
            
            timerButton.setBackgroundImage(UIImage(named: "02_stopwatch_play@3x.png"), forState: UIControlState.Normal)
            timerButton.setBackgroundImage(UIImage.maskColor("02_stopwatch_play@3x.png", color:UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)), forState: UIControlState.Highlighted)
            
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
            timerButton.setBackgroundImage(UIImage.maskColor("02_stopwatch_stop@3x.png", color:UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)), forState: UIControlState.Highlighted)
            
        }

    }
    
    
    func recordTime(){
        
        endDate = NSDate()
        stopTimer()
        
        saveTimeLog()
        saveTimeHistory()
        
        day.doneSecond = Int(totalTime)
        
        //var error:NSError?
        //managedObjectContext?.save(&error)
        
    }
    
    
    func saveTimeHistory(){
        
        let timeHistory = TimeHistory()
        timeHistory.id = NSUUID().UUIDString
        timeHistory.day = day
        timeHistory.startedAt = Int(startDate.timeIntervalSince1970)
        timeHistory.endedAt = Int(endDate.timeIntervalSince1970)
        timeHistory.doneMillis = Int(endDate.timeIntervalSinceDate(startDate))
        
        day.timeHistorys.append(timeHistory)
        
        realm.write{
            self.realm.add(timeHistory)
            self.realm.add(self.day,update:true)
        }
        
        
        /*
        let entityDescription = NSEntityDescription.entityForName("TimeHistory", inManagedObjectContext:managedObjectContext!)
        let timeHistory = TimeHistory(entity: entityDescription!, insertIntoManagedObjectContext:managedObjectContext)
        timeHistory.dayId = day
        timeHistory.startedAt = startDate
        timeHistory.endedAt = endDate
        timeHistory.doneMillis = endDate.timeIntervalSinceDate(startDate)
        
        var error: NSError?
        managedObjectContext?.save(&error)
        */
    }
    
    func setupTimer(){
        currentTime = 0
        totalTime = NSTimeInterval(day.doneSecond)
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
        completeButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 18*ratio)
        completeButton.addTarget(self, action: Selector("recordTime"), forControlEvents: UIControlEvents.TouchUpInside)
        //view.addSubview(completeButton)
        
        
        //self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    func countDown(){
        
        currentTime = currentTime + 1
        totalTime = totalTime + 1
        
        isSaved = false
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
        
        self.titleLabel.text = task.category!.name + " - " + task.name
        
        todaitNavBar.setBackgroundImage(UIImage.colorImage(UIColor.clearColor(),frame:todaitNavBar.frame), forBarMetrics: UIBarMetrics.Default)
        todaitNavBar.shadowImage = UIImage()
        
        
        self.screenName = "Stopwatch Activity"
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func addAmountCount(point:Int){
        amountCount = amountCount + point
    }
    
    
    func backButtonClk() {
        
        if isSaved == true {
            self.navigationController?.popViewControllerAnimated(true)
        }else{
            
            
            if timer.valid == true {
                timerButtonClk()
            }
            
            var exitVC = ExitViewController()
            exitVC.delegate = self
            exitVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
            //exitVC.delegate = self
            self.navigationController?.presentViewController(exitVC, animated: false, completion: { () -> Void in
                
            })
            
        }
    }
    
    func saveAndExitTimeLog() {
        doneButtonClk()
        isSaved = true
        backButtonClk()
    }
    
    func resetAndExitTimeLog() {
        
        
        isSaved = true
        backButtonClk()
        
    }
    
}
