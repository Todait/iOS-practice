//
//  DetailViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 2..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit
import CoreData
import Photos

class DetailViewController: BasicViewController,TodaitNavigationDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,CategoryUpdateDelegate,CalendarDelegate,TimeLogDelegate,AmountLogDelegate,FocusDelegate{
    
    
    var detailView:DetailView!
    
    var memoHeaderView:UIView!
    var monthView:UIView!
    var memoView:UIView!
    
    var weekCalendarVC:DetailWeekCalendarViewController!
    
    var detailTableView: UITableView!
    var detailScrollView: UIScrollView!
    
    
    var task:Task!
    var day:Day!
    var dateLabel:UILabel!
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    
    var progressPercent:NSNumber!
    var progressString:String!
    var timeValue:[CGFloat]! = []
    var doneCountEnabled:Bool! = true
    
    var editButton:UIButton!
    var graphButton:UIButton!
    
    
    var selectedDateNumber:NSNumber!
    
    
    let headerMinHeight:CGFloat = 100
    let hederMaxHeight:CGFloat = 215
    var showCalendarHeight:CGFloat = 48
    var isCalendarScroll:Bool = true
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        
        selectedDateNumber = getDateNumberFromDate(NSDate())
        
        setupDay()
        addHeaderView()
        addCalendarView()
        addInfoView()
        
        
        //addDetailTable()
        addDetailScrollView()
    }
    
    func setupDay(){
        
        if let dayValid = task.getDay(getTodayDateNumber()) {
            day = dayValid
            doneCountEnabled = true
            progressPercent = day.getProgressPercent()
            progressString = day.getProgressString()
            timeValue = day.getAmountLogValuePerTime() as! [CGFloat]
        } else {
            progressPercent = 0
            progressString = "0%"
            
            doneCountEnabled = false
            
            for index in 0...47{
                timeValue.append(0)
            }
        }
    }
    
    func addHeaderView(){
        
        addDetailView()
        addMonthView()
        addMemoView()
    }
    
    func addDetailView(){
        detailView = DetailView(frame: CGRectMake(0, 0, width, 215*ratio))
        detailView.dateLabel.text = task.getStringOfPeriodProgress()
        detailView.timeLabel.text = task.getDoneTimeString()
        detailView.amountLabel.text = task.getDoneAmountString()
        detailView.categoryLabel.text = task.category_id.name
        detailView.categoryCircle.backgroundColor = task.getColor()
        detailView.mainImageView.image = UIImage(named: "track.jpg")
    }
    
    func addMonthView(){
        monthView = UIView(frame: CGRectMake(0, 0, 320*ratio, 48*6*ratio))
        monthView.backgroundColor = UIColor.yellowColor()
    }
    
    func addMemoView(){
        
        memoView = UIView(frame: CGRectMake(0, 318*ratio, 320*ratio, 186*ratio))
        //memoView.backgroundColor = UIColor.orangeColor()
        
    }
    
    
    func addCalendarView(){
        
        
        
        var headerView = UIView(frame: CGRectMake(0, 215*ratio, width, 103*ratio))
        headerView.backgroundColor = UIColor.colorWithHexString("#EFEFEF")
        
        dateLabel = UILabel(frame: CGRectMake(15*ratio, 0, 290*ratio, 23*ratio))
        dateLabel.textColor = UIColor.todaitGray()
        dateLabel.font = UIFont(name:"AppleSDGothicNeo-UltraLight", size: 10*ratio)
        dateLabel.textAlignment = NSTextAlignment.Center
        headerView.addSubview(dateLabel)
        
        updateDateLabel(getDateFromDateNumber(getTodayDateNumber()))
        
        
        let weekTitle = ["SUN","MON","TUE","WED","THU","FRI","SAT"]
        let weekWidth = 320*ratio / 7
        
        
        for index in 0...6 {
            let weekDayLabel = UILabel(frame: CGRectMake(CGFloat(index)*weekWidth, 23*ratio, weekWidth, 20*ratio))
            weekDayLabel.textAlignment = NSTextAlignment.Center
            weekDayLabel.text = weekTitle[index]
            weekDayLabel.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 7.5*ratio)
            weekDayLabel.textColor = UIColor.todaitGray()
            headerView.addSubview(weekDayLabel)
            
            if index == 0 {
                weekDayLabel.textColor = UIColor.todaitRed()
            }
            
        }
        
        let line = UIView(frame:CGRectMake(0, 65.5*ratio, width, 0.5*ratio))
        line.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)
        detailView.addSubview(line)
        
        
        
        
        weekCalendarVC = DetailWeekCalendarViewController()
        addChildViewController(weekCalendarVC)
        weekCalendarVC.view.backgroundColor = UIColor.whiteColor()
        weekCalendarVC.view.frame = CGRectMake(0,43.5*ratio,width,60*ratio)
        weekCalendarVC.dateNumber = selectedDateNumber
        weekCalendarVC.delegate = self
        headerView.addSubview(weekCalendarVC.view)
        headerView.clipsToBounds = true
        
        
        detailView.addSubview(headerView)
    }
    
    func addInfoView(){
        
        
        var memoHeaderLabel = UILabel(frame: CGRectMake(0, 116*ratio, width, 24.5*ratio))
        memoHeaderLabel.backgroundColor = UIColor.colorWithHexString("#EFEFEF")
        memoHeaderLabel.textColor = UIColor.todaitGray()
        memoHeaderLabel.textAlignment = NSTextAlignment.Center
        memoHeaderLabel.text = "공부메모"
        memoHeaderLabel.font = UIFont(name: "AvenirNext-Regular", size: 10*ratio)
        memoView.addSubview(memoHeaderLabel)
        
        
        var diaryButton = UIButton(frame:CGRectMake(18*ratio,116*ratio+39*ratio,16*ratio,16*ratio))
        diaryButton.setBackgroundImage(UIImage(named: "detail_basic_27@3x.png"), forState: UIControlState.Normal)
        diaryButton.addTarget(self, action: Selector("diaryButtonClk"), forControlEvents: UIControlEvents.TouchDown)
        
        memoView.addSubview(diaryButton)
        
        var memoInfoLabel = UILabel(frame: CGRectMake(37*ratio, 116*ratio+24.5*ratio, 180*ratio, 45.5*ratio))
        memoInfoLabel.textColor = UIColor.todaitGray()
        memoInfoLabel.textAlignment = NSTextAlignment.Left
        memoInfoLabel.text = "공부 일기를 추가하세요."
        memoInfoLabel.font = UIFont(name: "AvenirNext-Regular", size: 12*ratio)
        
        memoView.addSubview(memoInfoLabel)
        
        
        var focusScore:CGFloat = CGFloat(day.score.floatValue)
        
        
        for index in 0...4 {
            
            var imageView = UIImageView(frame: CGRectMake(200*ratio + 17*ratio * CGFloat(index), 116*ratio+39*ratio, 14*ratio, 14*ratio))
            imageView.image = UIImage(named: "detail_basic_30@3x.png")
            
            
            memoView.addSubview(imageView)
            
            if index > Int(focusScore) {
                
            }else if index == Int(focusScore){
                
                
                var percent = focusScore - CGFloat(index)
                
                var path = UIBezierPath()
                path.moveToPoint(CGPointMake(0*ratio,7*ratio))
                path.addLineToPoint(CGPointMake(14*ratio,7*ratio))
                
                
                var colorLayer = CAShapeLayer()
                colorLayer.path = path.CGPath
                colorLayer.fillColor = UIColor.todaitGreen().CGColor
                colorLayer.strokeColor = UIColor.todaitRed().CGColor
                colorLayer.strokeStart = 0
                colorLayer.strokeEnd = percent
                colorLayer.lineWidth = 14*ratio
                
                
                var maskLayer = CALayer()
                maskLayer.contents = UIImage(named: "detail_diary_input_star@3x.png")!.CGImage
                maskLayer.frame = CGRectMake(200*ratio + 17*ratio * CGFloat(index), 116*ratio+39*ratio, 14*ratio, 14*ratio)
                maskLayer.mask = colorLayer
                
                memoView.layer.addSublayer(maskLayer)
                
            }else{
                
                var imageView = UIImageView(frame: CGRectMake(200*ratio + 17*ratio * CGFloat(index), 116*ratio+39*ratio, 14*ratio, 14*ratio))
                imageView.image = UIImage(named: "detail_diary_input_star@3x.png")
                
                memoView.addSubview(imageView)
            }
        }
        
        
        let focusButton = UIButton(frame: CGRectMake(200*ratio , 70*ratio+24.5*ratio, 90*ratio, 45.5*ratio))
        focusButton.backgroundColor = UIColor.clearColor()
        focusButton.addTarget(self, action: Selector("focusButtonClk"), forControlEvents: UIControlEvents.TouchDown)
        
        memoView.addSubview(focusButton)
        
        
        
        
        //
        
        var upperLine = UIView(frame:CGRectMake(0,0*ratio,width,0.5*ratio))
        upperLine.backgroundColor = UIColor.colorWithHexString("#EFEFEF")
        memoView.addSubview(upperLine)
        
        
        var timerButton = UIButton(frame:CGRectMake(50*ratio, 0*ratio+12.5*ratio, 58*ratio, 58*ratio))
        
        timerButton.setBackgroundImage(UIImage(named: "detail_basic_23@3x.png"), forState: UIControlState.Normal)
        timerButton.clipsToBounds = true
        timerButton.addTarget(self, action: Selector("timerButtonClk"), forControlEvents: UIControlEvents.TouchUpInside)
        
        memoView.addSubview(timerButton)
        
        
        
        var timerAimLabel = UILabel(frame:CGRectMake(15*ratio,0*ratio+77*ratio,130*ratio,12*ratio))
        timerAimLabel.text = "목표시간 01:30:00"
        timerAimLabel.font = UIFont(name: "AppleSDGothicNeo-Light", size: 10*ratio)
        timerAimLabel.textAlignment = NSTextAlignment.Center
        timerAimLabel.textColor = UIColor.todaitGray()
       
        memoView.addSubview(timerAimLabel)
        
        
        var timerLabel = UILabel(frame:CGRectMake(15*ratio,0*ratio+89*ratio,130*ratio,22*ratio))
        timerLabel.text = "00:00:00"
        timerLabel.font = UIFont(name: "AppleSDGothicNeo-Light",size:20*ratio)
        timerLabel.textAlignment = NSTextAlignment.Center
        timerLabel.textColor = UIColor.todaitOrange()
       
        memoView.addSubview(timerLabel)
        
        
        var timeLogButton = UIButton(frame: CGRectMake(15*ratio, 0*ratio+70*ratio, 130*ratio, 45*ratio))
        timeLogButton.backgroundColor = UIColor.clearColor()
        timeLogButton.addTarget(self, action: Selector("timeButtonClk"), forControlEvents: UIControlEvents.TouchDown)
      
        memoView.addSubview(timeLogButton)
        
        
        var middleLine = UIView(frame:CGRectMake(159.75*ratio,0*ratio,0.5*ratio,115*ratio))
        middleLine.backgroundColor = UIColor.colorWithHexString("#EFEFEF")
        
        memoView.addSubview(middleLine)
        
        var circleChart = CircleChart(frame: CGRectMake(210*ratio, 0*ratio+12.5*ratio, 58*ratio, 58*ratio))
        circleChart.circleColor = UIColor.todaitOrange()
        circleChart.updatePercent(progressPercent)
        circleChart.percentLabel.frame = CGRectMake(5*ratio,5*ratio,48*ratio,48*ratio)
        circleChart.percentLabel.font = UIFont(name: "AppleSDGothicNeo-Light",size: 25*ratio)
        circleChart.percentLabel.adjustsFontSizeToFitWidth = true
        
        memoView.addSubview(circleChart)
        
        var background:UIImage = UIImage(named: "graph_bg.png")!
        var maskLayer:CALayer = CALayer()
        maskLayer.contents = background.CGImage
        maskLayer.frame = CGRectMake(0,0,58*ratio,58*ratio)
        maskLayer.mask = circleChart.percentLayer
        circleChart.layer.addSublayer(maskLayer)
        
        
        
        
        var amountTextView = AmountTextView(frame: CGRectMake(175*ratio,0*ratio+74*ratio, 130*ratio, 25*ratio))
        amountTextView.setupText(day.done_amount.integerValue, total: day.expect_amount.integerValue, unit: task.unit)
        amountTextView.userInteractionEnabled = false
        
         memoView.addSubview(amountTextView)
        
        
        var amountButton = UIButton(frame:CGRectMake(160*ratio, 0*ratio, 160*ratio, 115*ratio))
        amountButton.backgroundColor = UIColor.clearColor()
        amountButton.addTarget(self, action: Selector("amountButtonClk"), forControlEvents: UIControlEvents.TouchDown)
        
         memoView.addSubview(amountButton)
    }
    
    
    func addDetailTable(){
        detailTableView = UITableView(frame: CGRectMake(0,0,width,height), style: UITableViewStyle.Grouped)
        detailTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        detailTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        detailTableView.delegate = self
        detailTableView.dataSource = self
        detailTableView.contentOffset.y = 0
        detailTableView.sectionFooterHeight = 0
        detailTableView.backgroundColor = UIColor.colorWithHexString("#EFEFEF")
        detailTableView.backgroundColor = UIColor.yellowColor()
        detailTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        detailTableView.contentOffset.y = 20*ratio
        //view.addSubview(detailTableView)
    }
    
    func addDetailScrollView(){
        
        detailScrollView = UIScrollView(frame: CGRectMake(0, 0, 320*ratio, 568*ratio))
        detailScrollView.contentSize = CGSizeMake(320*ratio, 1500*ratio)
        //detailScrollView.backgroundColor = UIColor.magentaColor()
        detailScrollView.delegate = self
        
        view.addSubview(detailScrollView)
        
        
        detailScrollView.addSubview(monthView)
        detailScrollView.addSubview(detailView)
        detailScrollView.addSubview(memoView)
        
    }
    
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        NSLog("놓앗다", 1)
        
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        NSLog("SCROLL Y %f originY %f",scrollView.contentOffset.y,detailView.frame.origin.y)
        
        
        let offset = scrollView.contentOffset.y
        
        scrollView.contentOffset.x = 0
        
        
        if isCalendarScroll {
            
            //detailView.transform = CGAffineTransformMakeTranslation(0, offset)
            
            if offset > 115*ratio {
                detailView.transform = CGAffineTransformMakeTranslation(0, offset-115*ratio)
            }else if offset <= 0{
                
                //detailView.transform = CGAffineTransformMakeTranslation(0, 2*offset)
                
                
                if 2*offset < -230*ratio {
                    detailView.transform = CGAffineTransformMakeTranslation(0, -115*ratio+offset)
                }else{
                    detailView.transform = CGAffineTransformMakeTranslation(0, 2*offset)
                
                    
                }
                
                
                detailScrollView.contentSize = CGSizeMake(320*ratio, 1500*ratio + detailView.frame.size.height)
                NSLog("Height", detailView.frame.size.height + 1500*ratio)
                
            }
            
            
        }else{
            
            if offset > 115*ratio {
                detailView.transform = CGAffineTransformMakeTranslation(0, offset-115*ratio)
                memoView.transform = CGAffineTransformMakeTranslation(0, offset-115*ratio)
                monthView.transform = CGAffineTransformMakeTranslation(0, offset-115*ratio)

            }else if offset <= 0 {
                
                //detailView.frame = CGRectMake(0, -offset, 320*ratio,215*ratio)
                
                
                detailView.transform = CGAffineTransformMakeTranslation(0, offset)
                memoView.transform = CGAffineTransformMakeTranslation(0, offset)
                monthView.transform = CGAffineTransformMakeTranslation(0, offset)
                
            }
            
            //detailView.transform = CGAffineTransformMakeTranslation(0, -offset)
        }
        
        
    }
    
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
        var location = scrollView.panGestureRecognizer.locationInView(view)
        NSLog("VIEW%@",NSStringFromCGPoint(location))
        
        
        var location2 = scrollView.panGestureRecognizer.locationInView(detailScrollView)
        NSLog("Detail%@",NSStringFromCGPoint(location2))
        
        
        if location2.y > 258*ratio && location2.y < 258*ratio + showCalendarHeight {
            
            isCalendarScroll = true
            
        }else {
            isCalendarScroll = false
        }
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return 308*ratio
        }else if section == 1 {
            return 0*ratio
        }else{
            return 70*ratio
        }
        
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 58*ratio
        
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        /*
        if doneCountEnabled == true {
            addDoneAmount()
        }
        */

        return false
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 15
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var headerView = UIView()
        headerView.backgroundColor = UIColor.whiteColor()
        
        headerView.addSubview(monthView)
        headerView.addSubview(memoView)
        headerView.addSubview(detailView)
        
        return headerView
    }
    
    func diaryButtonClk(){
        
        
        
    }
    
    func focusButtonClk(){
    
        var focusVC = FocusViewController()
        focusVC.delegate = self
        focusVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        focusVC.day = day
        
        
        self.navigationController?.presentViewController(focusVC, animated: false, completion: { () -> Void in
            
        })
        
        
    }
    
    
    func saveFocus(focus:CGFloat){
        
        day.score = focus
        
        
        var error: NSError?
        managedObjectContext?.save(&error)
        
        if let err = error {
            //에러처리
        }else{
            NSLog("집중도 저장",1)
        }
        
        
        //detailTableView.reloadData()
    }
    
    
    func updateDateLabel(date:NSDate){
        let dateForm = NSDateFormatter()
        dateForm.dateFormat = "yyyy.MM"
        dateLabel.text = dateForm.stringFromDate(date)
    }

    
    
    
    func updateDate(date:NSDate,from:String){
        
        NSLog("Receive Date %@", date)
        updateDateLabel(date)
        selectedDateNumber = getDateNumberFromDate(date)
        weekCalendarVC.setSelectedDateNumber(selectedDateNumber)
        
        
        day = task.getDay(getDateNumberFromDate(date))
        //detailTableView.reloadData()
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        
        cell.backgroundColor = UIColor.whiteColor()
        
        for view in cell.contentView.subviews{
            view.removeFromSuperview()
        }
        
        
        return cell
    }
    
    func timerButtonClk(){
        
        //var timer
        
        performSegueWithIdentifier("ShowTimerView", sender: self)
        
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //let destination = segue.destinationViewController as! NewTaskViewController
        
        
        if segue.identifier == "ShowTimerView" {
            let timerVC = segue.destinationViewController as! TimerViewController
            
            let day:Day! = task.getDay(getTodayDateNumber())
            timerVC.task = task
            timerVC.day = day
            
            
        }
        
        if segue.identifier == "ShowEditTaskView" {
            
            let editTaskVC = segue.destinationViewController as! EditTaskViewController
            editTaskVC.editedTask = task
            editTaskVC.delegate = self
            editTaskVC.mainColor = task.getColor()
            editTaskVC.category = task.category_id
            
        }
    
    }
    
    
    func amountButtonClk(){
        
        var amountVC = AmountViewController()
        amountVC.delegate = self
        amountVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        amountVC.amount_type = task.amount_type
        amountVC.unit = task.unit
        
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
        
        refreshView()
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
        day.done_second = Int(day.done_second) + Int(time)
        timeLog.after_second = day.done_second.integerValue
        timeLog.done_second = Int(time)
        timeLog.created_at = NSDate()
        timeLog.updated_at = NSDate()
        
        var error: NSError?
        managedObjectContext?.save(&error)
        
        
        refreshView()
    }
    
    func refreshView(){
        
        setupDay()
        refreshHeaderText()
        //detailTableView.reloadData()
        
    }
    
    func refreshHeaderText(){
        
        detailView.dateLabel.text = task.getStringOfPeriodProgress()
        detailView.timeLabel.text = task.getDoneTimeString()
        detailView.amountLabel.text = task.getDoneAmountString()
        detailView.categoryLabel.text = task.category_id.name
        detailView.categoryCircle.backgroundColor = task.getColor()
        
    }
    
    func getWeekAmountPercentString()->String{
        
        return "\(Int(task.getPercentOfDoneAmount()))%"
    }
    
    func getWeekAmountPercentValue()->NSNumber{
        
        return task.getPercentOfDoneAmount()
    }
    
    
    func getWeekDatePercentString()->String{
        
        return "\(Int(task.getPercentOfPeriodProgress()))%"
    }
    
    func getWeekDatePercentValue()->NSNumber{
        
        return task.getPercentOfPeriodProgress()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        todaitNavBar.todaitDelegate = self
        todaitNavBar.backButton.hidden = false
        
        self.titleLabel.text = task.name
        self.screenName = "Detail Activity"
        
        todaitNavBar.shadowImage = UIImage()
        todaitNavBar.setBackgroundImage(UIImage.colorImage(UIColor.clearColor(),frame:CGRectMake(0,0,width,navigationHeight)), forBarMetrics: UIBarMetrics.Default)
        
        addEditButton()
        addGraphButton()
    }
    
    func addEditButton(){
        editButton = UIButton(frame: CGRectMake(288*ratio,30,24,24))
        editButton.setBackgroundImage(UIImage.maskColor("edit.png",color:UIColor.whiteColor()), forState: UIControlState.Normal)
        editButton.addTarget(self, action: Selector("showEditTaskVC"), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(editButton)
    }
    
    func showEditTaskVC(){
        
        performSegueWithIdentifier("ShowEditTaskView", sender:self)
        
    }
    
    func showCompletePopup(){
        
        
        let popCircle = UIView(frame: CGRectMake(0, 0, 80*ratio, 80*ratio))
        popCircle.backgroundColor = task.getColor()
        popCircle.center = view.center
        popCircle.clipsToBounds = true
        popCircle.layer.cornerRadius = 40*ratio
        
        view.addSubview(popCircle)
        
        
        let popUp = UILabel(frame: CGRectMake(0, 0, 80*ratio,80*ratio))
        popUp.backgroundColor = UIColor.clearColor()
        popUp.textColor = UIColor.whiteColor()
        popUp.textAlignment = NSTextAlignment.Center
        popUp.text = "수정되었다"
        popUp.font = UIFont(name: "AvenirNext-Regular", size: 4*ratio)
        popUp.center = view.center
        
        view.addSubview(popUp)
        
        
        UIView.animateWithDuration(0.4, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            popCircle.transform = CGAffineTransformMakeScale(1.2, 1.2)
            popUp.font = UIFont(name: "AvenirNext-Regular", size: 16*self.ratio)
            
            }) { (Bool) -> Void in
                
                
                UIView.animateWithDuration(1.1, animations: { () -> Void in
                    
                    }, completion: { (Bool) -> Void in
                        
                        popCircle.removeFromSuperview()
                        popUp.removeFromSuperview()
                })
                
        }
        
    }
    
    func addGraphButton(){
        
        graphButton = UIButton(frame: CGRectMake(258*ratio,30,24,24))
        graphButton.setBackgroundImage(UIImage.maskColor("ic_drawer_statistics.png",color:UIColor.whiteColor()), forState: UIControlState.Normal)
        graphButton.addTarget(self, action: Selector("showGraphVC"), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(graphButton)
        
    }
    
    func showGraphVC(){
        
        var graphVC = GraphViewController()
        graphVC.mainColor = task.getColor()
        graphVC.task = task
        
        self.navigationController?.pushViewController(graphVC, animated: true)
        
    }
    
    
    func updateCategory(category:Category,from:String){
        
        
        refreshView()
        showCompletePopup()
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func addDoneAmount(){
        
        let entityDescription = NSEntityDescription.entityForName("AmountLog", inManagedObjectContext:managedObjectContext!)
        
        let amountLog = AmountLog(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
        
        amountLog.day_id = day
        amountLog.before_done_amount = day.done_amount
        amountLog.updated_at = NSDate()
        amountLog.dirty_flag = 0
        day.done_amount = Int(day.done_amount) + 1
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
            NSLog("DoneAmount 저장 및 업데이트성공",1)
        }
    }
    
    
    
    func backButtonClk() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
}
