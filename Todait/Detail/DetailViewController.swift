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

class DetailViewController: BasicViewController,TodaitNavigationDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,CategoryUpdateDelegate,CalendarDelegate,TimeLogDelegate,AmountLogDelegate,FocusDelegate,UIGestureRecognizerDelegate,DetailMemoViewDelegate{
    
    
    var detailView:DetailView!
    
    var memoHeaderView:UIView!
    
    var calendarView:UIView!
    
    var monthView:UIView!
    var memoView:DetailMemoView!
    
    var diaryTableView:UITableView!
    
    var calendarButton:UIButton!
    
    var detailTableView: UITableView!
    var detailScrollView: UIScrollView!
    
    
    var task:Task!
    var day:Day!
    var diaryData:[Diary]! = []
    
    var dateLabel:UILabel!
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    
    var progressPercent:NSNumber!
    var progressString:String!
    var timeValue:[CGFloat]! = []
    var doneCountEnabled:Bool! = true
    
    var editButton:UIButton!
    var graphButton:UIButton!
    
    
    var selectedDateNumber:NSNumber!
    var selectedWeekOfMonth:CGFloat! = 2
    
    let headerMinHeight:CGFloat = 100
    let hederMaxHeight:CGFloat = 215
    var showCalendarHeight:CGFloat = 48
    var isCalendarScroll:Bool = true
    
    
    var panStart:CGPoint!
    var panEnd:CGPoint!
    
    var isCalendarShow:Bool = false
    var button:UIButton!
    
    
    var weekCalendarVC:DetailWeekCalendarViewController!
    var monthCalendarVC:DetailMonthCalendarViewController!
    
    var isAnimated:Bool = false
    
    override func viewDidLoad(){
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        
        selectedDateNumber = getDateNumberFromDate(NSDate())
        selectedWeekOfMonth = getWeekNumber(NSDate())
        
        
        setupDay(getTodayDateNumber())
        loadDiary()
        
        addHeaderView()
        addCalendarView()
        
        
        addMemoView()
        addDiaryTableView()
        
        addCalendarView()
        
        
        addDetailTable()
        
        
        addMonthCalendarVC()
        addWeekCalendarVC()
        addWeekHeaderView()
        
        view.addSubview(detailView)
        view.addSubview(memoView)
        
        //addCalendarButton()
        
        
        
        
        
        
        
    }
    
    func zzz(){
        NSLog("zz")
    }
    
    func getWeekNumber(date:NSDate)->CGFloat{
        
        var time = Int(date.timeIntervalSinceDate(getFirstDateOfMonth(date)) / (7*24*60*60))
        
        return CGFloat(time + 1)
        
    }
    
    func setupDay(dateNumber:NSNumber){
        if let dayValid = task.getDay(dateNumber) {
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
    
    func loadDiary(){
        
        diaryData = day.diaryList.array as! [Diary]
        
    }
    
    func addHeaderView(){
        
        addDetailView()
        addMemoView()
    }
    
    func addCalendarView(){
        calendarView = UIView(frame: CGRectMake(0, 255*ratio, width, 60*ratio))
        calendarView.clipsToBounds = true
        //view.addSubview(calendarView)
        
    }
    
    func addDetailView(){
        detailView = DetailView(frame: CGRectMake(0, 0, width, 258*ratio))
        detailView.dateLabel.text = task.getStringOfPeriodProgress()
        detailView.timeLabel.text = task.getDoneTimeString()
        detailView.amountLabel.text = task.getDoneAmountString()
        detailView.categoryLabel.text = task.category_id.name
        detailView.categoryCircle.backgroundColor = task.getColor()
        detailView.mainImageView.image = UIImage(named: "track.jpg")
        detailView.hidden = true
        
        
        var panGesture = UIPanGestureRecognizer()
        panGesture.addTarget(self, action: Selector("panGesture:"))
        panGesture.delegate = self
        detailView.addGestureRecognizer(panGesture)
        
        
    }
    
    
    
    func addWeekHeaderView(){
        
        
        
        var headerView = UIView(frame: CGRectMake(0, 64, width, 43*ratio))
        headerView.backgroundColor = UIColor.colorWithHexString("#EFEFEF")
        headerView.clipsToBounds = true
        
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
            }else if index == 6 {
                weekDayLabel.textColor = UIColor.todaitBlue()
            }
            
        }
        
        let line = UIView(frame:CGRectMake(0, 65.5*ratio, width, 0.5*ratio))
        line.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)
        self.view.addSubview(headerView)
        
        
        
        
        
    }
    
    
    func panGesture(gesture:UIPanGestureRecognizer){
        
        scrollCalendar(gesture)
        
    }
    
    func scrollCalendar(gesture:UIPanGestureRecognizer){
        
        switch gesture.state {
        case UIGestureRecognizerState.Began:
            //weekCalendarVC.view.hidden = true
            panStart = gesture.locationInView(self.view)
        case UIGestureRecognizerState.Changed:
            panEnd = gesture.locationInView(self.view)
            gestureMoved(gesture)
            panStart = gesture.locationInView(self.view)
        case UIGestureRecognizerState.Ended:
            gestureEnded(gesture)
        case UIGestureRecognizerState.Cancelled:
            gestureEnded(gesture)
        default: break
            
        }
    }
    
    func gestureMoved(gesture:UIPanGestureRecognizer){
        
        
        
        var translation = gesture.translationInView(self.view)
        var gestureView = gesture.view as UIView!
        
        //NSLog("velocity %f",gesture.velocityInView(self.view).y)
        
        
        if gestureView == detailView {
            gestureView.center = CGPointMake(gestureView.center.x , gestureView.center.y + translation.y)
            
            detailViewScroll(gesture)
        }else if gestureView == monthCalendarVC.view {
            
            //memoViewScroll(gesture)
            
            if isAnimated == false {
                showWeekCalendar()
                isAnimated = true
            }
            
            
            
            //monthCalendarScroll(gesture)
            
        }else if gestureView == weekCalendarVC.view {
            
            //NSLog("Week")
            
            
            weekCalendarVC.view.hidden = true
            
            if isAnimated == false {
                showMonthCalendar()
                isAnimated = true
            }
            
        }else if gestureView == memoView {
            
            memoViewScroll(gesture)
            
        }
        
        gesture.setTranslation(CGPointMake(0, 0), inView: self.view)
        
    }
    
    func detailViewScroll(gesture:UIPanGestureRecognizer){
        //NSLog("Detail")
        
        
        if detailView.center.y <= 20*ratio {
            detailView.center = CGPointMake(detailView.center.x, 20*ratio)
            weekCalendarVC.view.center = CGPointMake(weekCalendarVC.view.center.x, 20*ratio + 258*ratio)
        }else if(detailView.center.y >= 129*ratio) {
            detailView.center = CGPointMake(detailView.center.x, 129*ratio)
            weekCalendarVC.view.center = CGPointMake(weekCalendarVC.view.center.x, 129*ratio + 258*ratio)
        }
        
        weekCalendarVC.view.center = CGPointMake(weekCalendarVC.view.center.x, detailView.center.y + detailView.frame.size.height/2 + weekCalendarVC.view.frame.size.height/2)
        
        if weekCalendarVC.view.hidden {
            
            monthCalendarVC.view.center = CGPointMake(monthCalendarVC.view.center.x , detailView.center.y + 129*ratio + 180*ratio)
            memoView.frame = CGRectMake(0, monthCalendarVC.view.frame.origin.y + 360*ratio, 320*ratio, memoView.frame.size.height)
            
        }else{
            monthCalendarVC.view.center = CGPointMake(monthCalendarVC.view.center.x , detailView.center.y + 129*ratio + 180*ratio)
            //memoView.center = CGPointMake(memoView.center.x,weekCalendarVC.view.center.y + 30*ratio + )
            memoView.frame = CGRectMake(0, weekCalendarVC.view.frame.origin.y + 60*ratio, 320*ratio, memoView.frame.size.height)
        }
    }
    
    func monthCalendarScroll(gesture:UIPanGestureRecognizer){
        
        NSLog("Month")
        
        
        var translation = gesture.translationInView(self.view)
        var gestureView = gesture.view as UIView!
        
        //var velocity = gesture.velocityInView(self.view).y
        var diff = translation.y
        var calendarDiff = 1*(selectedWeekOfMonth-1)*diff/6
        var timeTableDiff = 5*diff/6
        
        //gestureView.center = CGPointMake(gestureView.center.x , gestureView.center.y + translation.y)
        
        var minOfMonth = weekCalendarVC.view.frame.origin.y - 60 * ratio * (selectedWeekOfMonth-1) + 60 * 3 * ratio
        
        //Month 위치조정
        
        
        if monthCalendarVC.view.center.y + calendarDiff < minOfMonth {
            NSLog("최대 올라감C %f", monthCalendarVC.view.center.y + calendarDiff)
            monthCalendarVC.view.center = CGPointMake(monthCalendarVC.view.center.x , minOfMonth)
            //monthCalendarVC.view.frame = CGRectMake(monthX,baseOriginY,monthW,monthH)
            
        }else if(monthCalendarVC.view.center.y + calendarDiff >= minOfMonth && monthCalendarVC.view.center.y - calendarDiff <= minOfMonth + 60*6*ratio) {
            
            NSLog("중간C %f",monthCalendarVC.view.center.y - calendarDiff)
            monthCalendarVC.view.center =  CGPointMake(monthCalendarVC.view.center.x, minOfMonth + calendarDiff)//CGRectMake(monthX,monthY - calendarDiff, monthW, monthH)
        }else {
            
            NSLog("최대내려감C %f",monthCalendarVC.view.center.y - calendarDiff)
            monthCalendarVC.view.center =  CGPointMake(monthCalendarVC.view.center.x, minOfMonth + calendarDiff)
        }
        
    }
    
    func memoViewScroll(gesture:UIPanGestureRecognizer){
        
        
        var translation = gesture.translationInView(self.view)
        var gestureView = gesture.view as UIView!
        
        //gestureView.center = CGPointMake(gestureView.center.x , gestureView.center.y + translation.y)
        
        
        /*
        
        if detailView.center.y + translation.y <= 20*ratio {
        
        detailView.center = CGPointMake(detailView.center.x, 20*ratio)
        
        
        //weekCalendarVC.view.center = CGPointMake(weekCalendarVC.view.center.x, 20*ratio + 215*ratio/2 + weekCalendarVC.view.frame.size.height/2)
        
        
        if weekCalendarVC.view.hidden {
        
        
        }else{
        
        if memoView.center.y + translation.y <= 20*ratio + detailView.frame.size.height/2 + weekCalendarVC.view.frame.size.height {
        NSLog("memo Top")
        memoView.center = CGPointMake(memoView.center.x, 20*ratio + detailView.frame.size.height/2 + weekCalendarVC.view.frame.size.height)
        
        }else if memoView.center.y + translation.y >= 215*ratio/2 + detailView.frame.size.height/2 + memoView.frame.size.height{
        NSLog("memo Bottom")
        memoView.center = CGPointMake(memoView.center.x, 215*ratio + detailView.frame.size.height/2 + weekCalendarVC.view.frame.size.height)
        }else{
        NSLog("Memo!!")
        }
        
        }
        
        
        }else if(detailView.center.y + translation.y >= 129*ratio) {
        detailView.center = CGPointMake(detailView.center.x, 129*ratio)
        //weekCalendarVC.view.center = CGPointMake(weekCalendarVC.view.center.x, 215*ratio/2 + 215*ratio)
        //weekCalendarVC.view.center = CGPointMake(weekCalendarVC.view.center.x, 20*ratio + 215*ratio/2 + weekCalendarVC.view.frame.size.height/2)
        }
        
        if memoView.center.y + translation.y <= 169*ratio + 243*ratio {
        
        memoView.center = CGPointMake(memoView.center.x, 169*ratio + 243*ratio)
        
        }else if memoView.center.y + translation.y >= 618*ratio {
        memoView.center = CGPointMake(memoView.center.x, 618*ratio)
        }
        */
        
        
        if weekCalendarVC.view.hidden {
            
            if detailView.center.y + translation.y <= 20*ratio {
                showWeekCalendar()
            }
        }else{
            
            memoView.center = CGPointMake(gestureView.center.x , gestureView.center.y + translation.y)
            detailView.center = CGPointMake(detailView.center.x , detailView.center.y + translation.y)
            weekCalendarVC.view.center = CGPointMake(weekCalendarVC.view.center.x, weekCalendarVC.view.center.y + translation.y)
            
            if detailView.center.y + translation.y <= 20*ratio {
                
                detailView.center = CGPointMake(detailView.center.x, 20*ratio)
                weekCalendarVC.view.center = CGPointMake(weekCalendarVC.view.center.x, 20*ratio + 129*ratio + 30*ratio)
                memoView.center = CGPointMake(memoView.center.x, 20*ratio + 129*ratio + 60*ratio + 243*ratio)
                
                /*
                if memoView.center.y + translation.y <= 20*ratio + detailView.frame.size.height/2 + weekCalendarVC.view.frame.size.height {
                NSLog("memo Top")
                memoView.center = CGPointMake(memoView.center.x, 20*ratio + detailView.frame.size.height/2 + weekCalendarVC.view.frame.size.height)
                
                }else if memoView.center.y + translation.y >= 215*ratio/2 + detailView.frame.size.height/2 + memoView.frame.size.height{
                NSLog("memo Bottom")
                memoView.center = CGPointMake(memoView.center.x, 215*ratio + detailView.frame.size.height/2 + weekCalendarVC.view.frame.size.height)
                }else{
                NSLog("Memo!!")
                }
                */
                
            }else if(detailView.center.y + translation.y >= 129*ratio) {
                detailView.center = CGPointMake(detailView.center.x, 129*ratio)
                weekCalendarVC.view.center = CGPointMake(weekCalendarVC.view.center.x, 129*ratio + 129*ratio + 30*ratio)
                memoView.center = CGPointMake(memoView.center.x, 129*ratio + 129*ratio + 60*ratio + 243*ratio)
                
                //weekCalendarVC.view.center = CGPointMake(weekCalendarVC.view.center.x, 215*ratio/2 + 215*ratio)
                //weekCalendarVC.view.center = CGPointMake(weekCalendarVC.view.center.x, 20*ratio + 215*ratio/2 + weekCalendarVC.view.frame.size.height/2)
            }
            
            /*
            if memoView.center.y + translation.y <= 169*ratio + 243*ratio {
            
            memoView.center = CGPointMake(memoView.center.x, 169*ratio + 243*ratio)
            
            }else if memoView.center.y + translation.y >= 618*ratio {
            memoView.center = CGPointMake(memoView.center.x, 618*ratio)
            }
            */
        }
        
    }
    
    func gestureEnded(gesture:UIPanGestureRecognizer){
        
        /*
        var velocity = gesture.velocityInView(self.view)
        var magnitude = sqrt(velocity.y*velocity.y)
        var slideMult = magnitude / 200
        
        var slideView:UIView! = gesture.view
        var slideFactor:Float = 0.05 * Float(slideMult)
        
        var finalPoint = CGPointMake(160*ratio, slideView.center.y + velocity.y*CGFloat(slideFactor))
        
        
        if slideView == detailView {
        
        finalPoint.y = min(max(finalPoint.y,20*ratio),215*ratio/2)
        
        UIView.animateWithDuration(0.5, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
        self.detailView.center = finalPoint
        }, completion: { (Bool) -> Void in
        
        })
        }
        
        */
        
        /*
        let baseOriginY = 64 + 43*ratio
        
        if timeTableView.frame.origin.y >= 250*ratio {
        
        UIView.animateWithDuration(0.4, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
        self.timeTableView.frame = CGRectMake(0, baseOriginY + 48*6*self.ratio, 245*self.ratio, self.timeTableView.frame.size.height)
        self.monthCalendarVC.view.frame = CGRectMake(0, baseOriginY, 320*self.ratio, 48*6*self.ratio)
        
        }, completion: { (Bool) -> Void in
        self.timeTableView.scrollEnabled = true
        self.weekCalendarVC.view.hidden = true
        })
        }else{
        UIView.animateWithDuration(0.4, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
        self.timeTableView.frame = CGRectMake(0, baseOriginY + 48*self.ratio, 245*self.ratio, self.timeTableView.frame.size.height)
        self.monthCalendarVC.view.frame = CGRectMake(0, baseOriginY-48*self.ratio*(self.selectedWeekOfMonth-1), 320*self.ratio, 48*6*self.ratio)
        }, completion: { (Bool) -> Void in
        self.timeTableView.scrollEnabled = true
        self.weekCalendarVC.view.hidden = false
        })
        }
        
        */
    }
    
    
    func addMemoView(){
        
        
        
        memoView = DetailMemoView(frame: CGRectMake(0, 315*ratio, 320*ratio, 486*ratio))
        memoView.backgroundColor = UIColor.whiteColor()
        memoView.circleChart.updatePercent(progressPercent)
        memoView.amountTextView.setupText(day.done_amount.integerValue, total: day.expect_amount.integerValue, unit: task.unit)
        memoView.delegate = self
        memoView.addFocusScore(CGFloat(day.score.floatValue))
        
        updateMemoTimerAimLabel()
        
        
        
        
        
        var panGesture = UIPanGestureRecognizer()
        panGesture.addTarget(self, action: Selector("panGesture:"))
        panGesture.delegate = self
        //memoView.addGestureRecognizer(panGesture)
    }
    
    func addDiaryTableView(){
        
        
        diaryTableView = UITableView(frame: CGRectMake(0,195*ratio,width,250*ratio), style: UITableViewStyle.Plain)
        diaryTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        diaryTableView.registerClass(DetailCalendarCell.self, forCellReuseIdentifier: "calendarCell")
        
        diaryTableView.bounces = false
        diaryTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        diaryTableView.delegate = self
        diaryTableView.dataSource = self
        diaryTableView.contentOffset.y = 0
        diaryTableView.sectionFooterHeight = 0
        diaryTableView.backgroundColor = UIColor.colorWithHexString("#EFEFEF")
        diaryTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        memoView.addSubview(diaryTableView)
        
    }
    
    
    
    func addCalendarButton(){
        
        calendarButton = UIButton(frame: CGRectMake(115*ratio, 70*ratio, 90*ratio, 90*ratio))
        calendarButton.backgroundColor = UIColor.todaitBlue()
        calendarButton.tag = 0
        calendarButton.addTarget(self, action: Selector("calendarButtonClk"), forControlEvents: UIControlEvents.TouchDown)
        view.addSubview(calendarButton)
    }
    
    func calendarButtonClk(){
        
        if calendarButton.tag == 0 {
            showMonthCalendar()
        }else{
            showWeekCalendar()
        }
        
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        
        return !isAnimated
        
    }
    
    func showWeekCalendar(){
        
        NSLog("Show Week")
        calendarButton.tag = 0
        
        weekCalendarVC.view.hidden = true
        
        /*
        if isAnimated == true {
        return
        }else{
        isAnimated = false
        }
        */
        
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            
            self.monthCalendarVC.view.frame = CGRectMake(0,self.detailView.center.y+129*self.ratio-60*self.ratio*(self.selectedWeekOfMonth-1)-0*self.ratio, 320*self.ratio, 360*self.ratio)
            self.weekCalendarVC.view.hidden = true
            self.memoView.frame = CGRectMake(0, self.detailView.center.y+129*self.ratio+60*self.ratio, 320*self.ratio, 486*self.ratio)
            
            }) { (Bool) -> Void in
                
                self.weekCalendarVC.view.hidden = false
                self.isAnimated = false
        }
        
    }
    
    func showMonthCalendar(){
        
        weekCalendarVC.view.hidden = true
        NSLog("Show Month")
        calendarButton.tag = 1
        
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            
            self.monthCalendarVC.view.frame = CGRectMake(0,self.detailView.center.y+129*self.ratio,320*self.ratio,360*self.ratio)
            self.memoView.frame = CGRectMake(0, self.detailView.center.y+129*self.ratio+360*self.ratio, 320*self.ratio, 486*self.ratio)
            
            
            }) { (Bool) -> Void in
                
                self.isAnimated = false
        }
        
    }
    
    
    func updateMemoTimerAimLabel(){
        var expectedTimes:[NSNumber] = task.week.getExpectedTime()
        var expectedTime:NSTimeInterval = NSTimeInterval(expectedTimes[day.day_of_week.integerValue])
        memoView.timerAimLabel.text = getTimeStringFromSeconds(expectedTime)
    }
    
    
    func addDetailTable(){
        detailTableView = UITableView(frame: CGRectMake(0,0,width,height), style: UITableViewStyle.Plain)
        detailTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        detailTableView.registerClass(DetailCalendarCell.self, forCellReuseIdentifier: "calendarCell")
        
        detailTableView.bounces = false
        detailTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        detailTableView.delegate = self
        detailTableView.dataSource = self
        detailTableView.contentOffset.y = 0
        detailTableView.sectionFooterHeight = 0
        detailTableView.backgroundColor = UIColor.colorWithHexString("#EFEFEF")
        detailTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        //view.addSubview(detailTableView)
    }
    
    func addWeekCalendarVC(){
        weekCalendarVC = DetailWeekCalendarViewController()
        weekCalendarVC.view.backgroundColor = UIColor.whiteColor()
        
        weekCalendarVC.task = task
        weekCalendarVC.delegate = self
        weekCalendarVC.dateNumber = selectedDateNumber
        weekCalendarVC.view.frame = CGRectMake(0,64 + 43*ratio,width,60*ratio)
        
        addChildViewController(weekCalendarVC)
        view.addSubview(weekCalendarVC.view)
        
        
        
        var panGesture = UIPanGestureRecognizer()
        panGesture.addTarget(self, action: Selector("panGesture:"))
        panGesture.delegate = self
        weekCalendarVC.view.addGestureRecognizer(panGesture)
    }
    
    func addMonthCalendarVC(){
        
        monthCalendarVC = DetailMonthCalendarViewController()
        monthCalendarVC.view.backgroundColor = UIColor.whiteColor()
        monthCalendarVC.delegate = self
        monthCalendarVC.task = task
        monthCalendarVC.dateNumber = selectedDateNumber
        
        monthCalendarVC.view.frame = CGRectMake(0,64 + 43*ratio-(selectedWeekOfMonth-1)*60*ratio,width,60*6*ratio)
        addChildViewController(monthCalendarVC)
        view.addSubview(monthCalendarVC.view)
        
        
        var panGesture = UIPanGestureRecognizer()
        panGesture.addTarget(self, action: Selector("panGesture:"))
        panGesture.delegate = self
        monthCalendarVC.view.addGestureRecognizer(panGesture)
    }
    
    
    
    func addDetailScrollView(){
        
        detailScrollView = UIScrollView(frame: CGRectMake(0, 200, 320*ratio, 568*ratio))
        detailScrollView.contentSize = CGSizeMake(320*ratio, 1500*ratio)
        //detailScrollView.backgroundColor = UIColor.magentaColor()
        detailScrollView.delegate = self
        
        
        detailScrollView.alpha = 0.8
        view.addSubview(detailScrollView)
        
        
        detailScrollView.addSubview(detailView)
        //detailScrollView.addSubview(memoView)
        
    }
    
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        NSLog("놓앗다", 1)
        
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        NSLog("SCROLL Y %f originY %f",scrollView.contentOffset.y,detailView.frame.origin.y)
        
        
        
        
        
        let offset = scrollView.contentOffset.y
        
        scrollView.contentOffset.x = 0
        
        
        if offset >= 120*ratio {
            detailView.transform = CGAffineTransformMakeTranslation(0, -120*ratio)
            monthCalendarVC.view.transform = CGAffineTransformMakeTranslation(0, -120*ratio)
            weekCalendarVC.view.transform = CGAffineTransformMakeTranslation(0, -120*ratio)
            //memoView.transform = CGAffineTransformMakeTranslation(0, offset-115*ratio)
            //monthView.transform = CGAffineTransformMakeTranslation(0, offset-115*ratio)
            
        }else if offset <= 0*ratio {
            
            //detailView.frame = CGRectMake(0, -offset, 320*ratio,215*ratio)
            
            
            detailView.transform = CGAffineTransformMakeTranslation(0, 0)
            monthCalendarVC.view.transform = CGAffineTransformMakeTranslation(0, 0)
            weekCalendarVC.view.transform = CGAffineTransformMakeTranslation(0, 0)
            
            //memoView.transform = CGAffineTransformMakeTranslation(0, offset)
            //monthView.transform = CGAffineTransformMakeTranslation(0, offset)
            
        }else{
            detailView.transform = CGAffineTransformMakeTranslation(0, -offset)
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
        return 0
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 57.5*ratio
        
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        
        var diaryDetailVC = DiaryDetailViewController()
        diaryDetailVC.day = day
        diaryDetailVC.task = task
        
        self.navigationController?.pushViewController(diaryDetailVC, animated: true)
        
        
        return false
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    
        return 1
    
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return diaryData.count
    }
    
    
    func diaryButtonClk(){
        
        showDiaryVC()
        
    }
    
    func showDiaryVC(){
        
        let diaryVC = DiaryViewController()
        diaryVC.task = task
        diaryVC.day = day
        self.navigationController?.pushViewController(diaryVC, animated: true)
        
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
        
        memoView.addFocusScore(CGFloat(day.score.floatValue))
        
        //detailTableView.reloadData()
    }
    
    
    func updateDateLabel(date:NSDate){
        let dateForm = NSDateFormatter()
        dateForm.dateFormat = "yyyy.MM"
        dateLabel.text = dateForm.stringFromDate(date)
        selectedWeekOfMonth = getWeekNumber(date)
        
        
        updateMemo(date)
    }
    
    
    func updateMemo(date:NSDate){
        
        var dateNumber = getDateNumberFromDate(date)
        var newDay =  task.getDay(dateNumber)
        
        if let check = newDay {
            
            day = newDay
            setupDay(dateNumber)
            memoView.circleChart.updatePercent(progressPercent)
            memoView.amountTextView.setupText(day.done_amount.integerValue, total: day.expect_amount.integerValue, unit: task.unit)
            memoView.timerLabel.text = getTimeStringFromSeconds(NSTimeInterval(day.done_second))
            memoView.addFocusScore(CGFloat(day.score.floatValue))
            
            updateMemoTimerAimLabel()
        }else{
            
            if let check = day {
                memoView.circleChart.updatePercent(0)
                memoView.amountTextView.setupText(0, total: 0.integerValue, unit: task.unit)
                memoView.timerLabel.text = getTimeStringFromSeconds(NSTimeInterval(0))
                memoView.addFocusScore(CGFloat(day.score.floatValue))
            }
        }
    }
    
    
    func updateDate(date:NSDate,from:String){
        
        NSLog("Receive Date %@", date)
        updateDateLabel(date)
        
        selectedDateNumber = getDateNumberFromDate(date)
        weekCalendarVC.setSelectedDateNumber(selectedDateNumber)
        monthCalendarVC.setSelectedDateNumber(selectedDateNumber)
        selectedWeekOfMonth = getWeekNumber(date)
        
        
        
        day = task.getDay(getDateNumberFromDate(date))
        //detailTableView.reloadData()
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        
        
        for view in cell.contentView.subviews{
            view.removeFromSuperview()
        }
        
        var imageView = UIImageView(frame:CGRectMake(0,0,82*ratio,57.5*ratio))
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.clipsToBounds = true
        cell.addSubview(imageView)
        
        
        var diary:Diary = diaryData[indexPath.row] as Diary
        
        
        for imageData in diary.imageList {
            
            let imageData:ImageData = imageData as! ImageData
            
            var image = UIImage(data: imageData.image)
            imageView.image = image
            
            
        }
        
        
        var diaryLabel = UILabel(frame:CGRectMake(100*ratio,15*ratio,150*ratio,27.5*ratio))
        
        diaryLabel.text = diary.body
        
        diaryLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 11*ratio)
        diaryLabel.textColor = UIColor.todaitDarkGray()
        cell.contentView.addSubview(diaryLabel)
        
        
        var timeLabel = UILabel(frame:CGRectMake(250*ratio,15*ratio,55*ratio,27.5*ratio))
        timeLabel.textAlignment = NSTextAlignment.Right
        timeLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 11*ratio)
        timeLabel.textColor = UIColor.todaitDarkGray()
        timeLabel.text = getTimeStringFromSeconds(1000)
        cell.contentView.addSubview(timeLabel)
        
        return cell
        
    }
    
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        
        let deleteButton = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: getDeleteString()) { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            
            self.tableView(tableView, commitEditingStyle: UITableViewCellEditingStyle.Delete, forRowAtIndexPath: indexPath)
            
        }
        
        
        
        
        deleteButton.backgroundColor = UIColor.todaitRed()
        
        return [deleteButton]
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        
        let diary = diaryData[indexPath.row]
        managedObjectContext?.deleteObject(diary)
        
        var error:NSError?
        managedObjectContext?.save(&error)
        
        if error == nil {
            NSLog("Diary 삭제완료",0)
            
            
            diaryData.removeAtIndex(indexPath.row)
            
            tableView.beginUpdates()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation:UITableViewRowAnimation.Automatic)
            tableView.endUpdates()
            
            //loadDiary()
            
        }else {
            //삭제에러처리
            
        }
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
    
    
    
    
    func timeLogButtonClk(){
        
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
        
        var refreshDateNumber = getDateFromDateNumber(selectedDateNumber)
        
        setupDay(selectedDateNumber)
        refreshHeaderText()
        
        updateMemo(refreshDateNumber)
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
        todaitNavBar.setBackgroundImage(UIImage.colorImage(UIColor.todaitGreen(),frame:CGRectMake(0,0,width,navigationHeight)), forBarMetrics: UIBarMetrics.Default)
        
        addEditButton()
        addGraphButton()
        
        
        
        diaryTableView.reloadData()
        
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
        
        graphButton = UIButton(frame: CGRectMake(258*ratio,34,24,16))
        graphButton.setBackgroundImage(UIImage.maskColor("detail_basic_06@3x.png",color:UIColor.whiteColor()), forState: UIControlState.Normal)
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
