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
    
    
    
    let detailViewHeight:CGFloat = 115
    let weekCalendarHeight:CGFloat = 49
    let monthCalendarHeight:CGFloat = 295
    
    let headerMinHeight:CGFloat = 100
    let hederMaxHeight:CGFloat = 215
    var showCalendarHeight:CGFloat = 49
    var isCalendarScroll:Bool = true
    
    
    var panStart:CGPoint!
    var panEnd:CGPoint!
    
    var isCalendarShow:Bool = false
    var button:UIButton!
    
    
    var weekCalendarVC:DetailWeekCalendarViewController!
    var monthCalendarVC:DetailMonthCalendarViewController!
    
    var isAnimated:Bool = false
    
    var shadowView:UIView!
    
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
        addCalendarView()
        
        
        addDetailTable()
        
        
        addMonthCalendarVC()
        addWeekCalendarVC()
        addWeekHeaderView()
        
        view.addSubview(detailView)
        view.addSubview(memoView)
        
        addDiaryTableView()
        addShadowView()
    }
    
    
    func getWeekNumber(date:NSDate)->CGFloat{
        
        var time = Int(date.timeIntervalSinceDate(getFirstSundayDateOfMonth(date)) / (7*24*60*60))
        
        return CGFloat(time + 1)
        
    }
    
    func setupDay(dateNumber:NSNumber){
        if let day = task.getDay(dateNumber) {
            self.day = day
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
        
        if let day = day {
            let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: false)
            diaryData = day.diaryList.sortedArrayUsingDescriptors([sortDescriptor]) as! [Diary]
        }
        
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
        detailView = DetailView(frame: CGRectMake(0, 0, width, detailViewHeight*ratio))
        detailView.dateLabel.text = task.getStringOfPeriodProgress()
        detailView.timeLabel.text = task.getDoneTimeString()
        detailView.amountLabel.text = task.getDoneAmountString()
        detailView.categoryLabel.text = task.categoryId.name
        detailView.categoryCircle.backgroundColor = task.getColor()
        detailView.mainImageView.image = UIImage(named: "track.jpg")
        
        
        var panGesture = UIPanGestureRecognizer()
        panGesture.addTarget(self, action: Selector("panGesture:"))
        panGesture.delegate = self
        detailView.addGestureRecognizer(panGesture)
        
        
    }
    
    
    
    func addWeekHeaderView(){
        
        
        
        var headerView = UIView(frame: CGRectMake(0, detailViewHeight*ratio, width, 43*ratio))
        headerView.backgroundColor = UIColor.todaitBackgroundGray()
        headerView.clipsToBounds = true
        
        dateLabel = UILabel(frame: CGRectMake(15*ratio, 0, 290*ratio, 23*ratio))
        dateLabel.textColor = UIColor.todaitGray()
        dateLabel.font = UIFont(name:"AppleSDGothicNeo-Medium", size: 10*ratio)
        dateLabel.textAlignment = NSTextAlignment.Center
        headerView.addSubview(dateLabel)
        
        updateDateLabel(getDateFromDateNumber(getTodayDateNumber()))
        
        
        let weekTitle = ["SUN","MON","TUE","WED","THU","FRI","SAT"]
        let weekWidth = 310*ratio / 7
        
        let whiteBox = UIView(frame:CGRectMake(0,23*ratio,width,20*ratio))
        whiteBox.backgroundColor = UIColor.whiteColor()
        headerView.addSubview(whiteBox)
        
        for index in 0...6 {
            let weekDayLabel = UILabel(frame: CGRectMake(CGFloat(index)*weekWidth + 5*ratio, 23*ratio, weekWidth, 20*ratio))
            weekDayLabel.textAlignment = NSTextAlignment.Center
            weekDayLabel.text = weekTitle[index]
            weekDayLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 8*ratio)
            weekDayLabel.textColor = UIColor.todaitGray()
            weekDayLabel.backgroundColor = UIColor.clearColor()
            headerView.addSubview(weekDayLabel)
            
            if index == 0 {
                weekDayLabel.textColor = UIColor.todaitRed()
            }else if index == 6 {
                weekDayLabel.textColor = UIColor.todaitBlue()
            }
            
        }
        
        let line = UIView(frame:CGRectMake(0, 42.5*ratio, width, 0.5*ratio))
        line.backgroundColor = UIColor.todaitBackgroundGray()
        headerView.addSubview(line)
        self.view.addSubview(headerView)
        
        
        
        
        
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        
        
        
        if gestureRecognizer.view == diaryTableView {
            
            
            var gesture = gestureRecognizer as! UIPanGestureRecognizer
            var velocity = gesture.velocityInView(self.view)
            
            NSLog("time velocity %f",velocity.y)
            
            if ( abs(velocity.y) > abs(velocity.x) && velocity.y > 0 && diaryTableView.contentOffset.y < 15*ratio) {
                diaryTableView.scrollEnabled = false
                return true
            }else if weekCalendarVC.view.hidden == true  && velocity.y < 0 {
                diaryTableView.scrollEnabled = false
                return true
            }
            
            
            return false
        }
        
        
        
        var gesture = gestureRecognizer as! UIPanGestureRecognizer
        var velocity = gesture.velocityInView(self.view)
        
        NSLog("pan velocity %f",velocity.y)
        
        return abs(velocity.y) > abs(velocity.x)
        
        
    }
    
    func panGesture(gesture:UIPanGestureRecognizer){
        
        scrollCalendar(gesture)
        
    }
    
    func scrollCalendar(gesture:UIPanGestureRecognizer){
        
        NSLog("pan %f",gesture.velocityInView(self.view).y)
        
        var velocity:CGPoint = gesture.velocityInView(self.view)
        
        
        switch gesture.state {
        case UIGestureRecognizerState.Began:
            weekCalendarVC.view.hidden = true
            panStart = gesture.locationInView(self.view)
        case UIGestureRecognizerState.Changed:
            panEnd = gesture.locationInView(self.view)
            gestureMoved()
            panStart = gesture.locationInView(self.view)
        case UIGestureRecognizerState.Ended:
            gestureEnded(gesture)
        case UIGestureRecognizerState.Cancelled:
            gestureEnded(gesture)
        default: break
            
        }
    }
    
    func gestureMoved(){
        
        
        
        
        var diff = panStart.y - panEnd.y
        
        let baseOriginY = detailViewHeight*ratio + 43*ratio
        let minOriginY = baseOriginY - weekCalendarHeight*ratio*selectedWeekOfMonth
        let maxOriginY = baseOriginY - weekCalendarHeight*5*ratio
        let topDistance = weekCalendarHeight*ratio*(selectedWeekOfMonth-1)
        let bottomDistance = weekCalendarHeight*ratio*(6-selectedWeekOfMonth)
        
        
        var calendarDiff = 1*(selectedWeekOfMonth-1)*diff/6
        var timeTableDiff = 5*diff/6
        
        let monthRect = monthCalendarVC.view.frame
        let monthX = monthRect.origin.x
        let monthY = monthRect.origin.y
        let monthW = monthRect.size.width
        let monthH = monthRect.size.height
        
        
        if monthY - calendarDiff < minOriginY {
            //NSLog("최대 올라감C %f", monthY - calendarDiff)
            monthCalendarVC.view.frame = CGRectMake(monthX,baseOriginY,monthW,monthH)
            
        }else if(monthY - calendarDiff >= minOriginY && monthY - calendarDiff <= baseOriginY) {
            //NSLog("중간C %f",monthY - calendarDiff)
            monthCalendarVC.view.frame = CGRectMake(monthX,monthY - calendarDiff, monthW, monthH)
        }else {
            
            //NSLog("최대내려감C %f",monthY - calendarDiff)
            monthCalendarVC.view.frame = CGRectMake(monthX,baseOriginY,monthW,monthH)
        }
        
        
        
        if diaryTableView.frame.origin.y - timeTableDiff < baseOriginY + weekCalendarHeight*ratio {
            //NSLog("최대 올라감 %f", diaryTableView.frame.origin.y - timeTableDiff)
            
            shadowView.frame = CGRectMake(0, baseOriginY + weekCalendarHeight*ratio - 2*ratio, width,4*ratio)
            diaryTableView.frame = CGRectMake(0, baseOriginY + weekCalendarHeight*ratio, 320*ratio, diaryTableView.frame.size.height)
            monthCalendarVC.view.frame = CGRectMake(0, baseOriginY-weekCalendarHeight*ratio*(self.selectedWeekOfMonth-1), 320*self.ratio, monthCalendarHeight*ratio)
        }else if(diaryTableView.frame.origin.y - timeTableDiff >= baseOriginY + weekCalendarHeight*ratio && diaryTableView.frame.origin.y - timeTableDiff <= baseOriginY + monthCalendarHeight*ratio) {
            
            //NSLog("중간 %f",diaryTableView.frame.origin.y - timeTableDiff)
            shadowView.frame = CGRectMake(0, diaryTableView.frame.origin.y - timeTableDiff - 2*ratio, width,4*ratio)
            diaryTableView.frame = CGRectMake(0, diaryTableView.frame.origin.y - timeTableDiff, 320*ratio, diaryTableView.frame.size.height)
        }else {
            
            //NSLog("최대내려감 %f",diaryTableView.frame.origin.y - timeTableDiff)
            
             shadowView.frame = CGRectMake(0, baseOriginY + monthCalendarHeight*ratio - 2*ratio, width,4*ratio)
            diaryTableView.frame = CGRectMake(0, baseOriginY + monthCalendarHeight*ratio, 320*ratio, diaryTableView.frame.size.height)
            
        }
        
        
    }
    
    func gestureEnded(gesture:UIPanGestureRecognizer){
        
        let baseOriginY = detailViewHeight*ratio + 41.5*ratio
        
        /*
        var velocity = gesture.velocityInView(self.view)
        var slideFactor = velocity.y/1500
        var timeY = self.diaryTableView.frame.origin.y + velocity.y*slideFactor
        timeY = min(max(timeY,baseOriginY + 48*ratio),baseOriginY + 48*6*ratio)
        */
        
        if diaryTableView.frame.origin.y >= 250*ratio {
            
            UIView.animateWithDuration(0.4, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
                
                
                self.shadowView.frame = CGRectMake(0, baseOriginY + self.monthCalendarHeight*self.ratio - 2*self.ratio, self.width,4*self.ratio)
                self.diaryTableView.frame = CGRectMake(0, baseOriginY + self.monthCalendarHeight*self.ratio, 320*self.ratio, self.diaryTableView.frame.size.height)
                
                self.monthCalendarVC.view.frame = CGRectMake(0, baseOriginY, 320*self.ratio, self.monthCalendarHeight*self.ratio)
                
                
                }, completion: { (Bool) -> Void in
                    self.diaryTableView.scrollEnabled = true
                    self.weekCalendarVC.view.hidden = true
            })
        }else{
            UIView.animateWithDuration(0.4, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
                
                
                self.shadowView.frame = CGRectMake(0, baseOriginY + self.weekCalendarHeight*self.ratio - 2*self.ratio, self.width,4*self.ratio)
                
                self.diaryTableView.frame = CGRectMake(0, baseOriginY + self.weekCalendarHeight*self.ratio, 320*self.ratio, self.diaryTableView.frame.size.height)
                self.monthCalendarVC.view.frame = CGRectMake(0, baseOriginY-self.weekCalendarHeight*(self.selectedWeekOfMonth-1)*self.ratio, 320*self.ratio, self.monthCalendarHeight*self.ratio)
                
                
                }, completion: { (Bool) -> Void in
                    self.diaryTableView.scrollEnabled = true
                    self.weekCalendarVC.view.hidden = false
            })
        }
        
    }
    
    func addMemoView(){
        
        
        
        memoView = DetailMemoView(frame: CGRectMake(0, 0*ratio, 320*ratio, 186*ratio))
        memoView.backgroundColor = UIColor.whiteColor()
        
        memoView.delegate = self
        
        if let progressPercent = progressPercent {
            memoView.circleChart.updatePercent(progressPercent)
        }
        
        if let day = day {
            memoView.amountTextView.setupText(day.doneAmount.integerValue, total: day.expectAmount.integerValue, unit: task.unit)
            memoView.addFocusScore(CGFloat(day.score.floatValue))
        }
        
        
        updateMemoTimerAimLabel()
        
        
    }
    
    func addDiaryTableView(){
        
         var originY:CGFloat = detailViewHeight*ratio + 43*ratio + weekCalendarHeight*ratio
        
        diaryTableView = UITableView(frame: CGRectMake(0,originY,width,height - originY), style: UITableViewStyle.Plain)
        diaryTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        diaryTableView.registerClass(DetailCalendarCell.self, forCellReuseIdentifier: "calendarCell")
        
        diaryTableView.bounces = false
        diaryTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        diaryTableView.delegate = self
        diaryTableView.dataSource = self
        diaryTableView.contentOffset.y = 0
        diaryTableView.sectionFooterHeight = 0
        diaryTableView.backgroundColor = UIColor.todaitBackgroundGray()
        diaryTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        view.addSubview(diaryTableView)
        
        
        var panGesture = UIPanGestureRecognizer()
        panGesture.addTarget(self, action: Selector("panGesture:"))
        panGesture.delegate = self
        diaryTableView.addGestureRecognizer(panGesture)

    }
    
    func addShadowView(){
        
        var shadowLayer:CAGradientLayer!
        
        shadowLayer = CAGradientLayer()
        shadowLayer.frame = CGRectMake(0, 2*ratio, width, 2*ratio)
        shadowLayer.startPoint = CGPointMake(0.5, 1.0)
        shadowLayer.endPoint = CGPointMake(0.5, 0)
        shadowLayer.colors = [UIColor.clearColor().CGColor,UIColor.todaitBackgroundGray().CGColor]
        shadowLayer.locations = [NSNumber(float: 0.5),NSNumber(float: 1.0)]
        view.layer.addSublayer(shadowLayer)
        
        shadowView = UIView(frame: CGRectMake(0, diaryTableView.frame.origin.y - 2*ratio, width, 4*ratio))
        shadowView.layer.addSublayer(shadowLayer)
        view.addSubview(shadowView)
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
    
    func showWeekCalendar(){
        
        calendarButton.tag = 0
        weekCalendarVC.view.hidden = true
        
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            
            self.monthCalendarVC.view.frame = CGRectMake(0,self.detailView.center.y+129*self.ratio-self.weekCalendarHeight*self.ratio*(self.selectedWeekOfMonth-1)-0*self.ratio, 320*self.ratio, self.monthCalendarHeight*self.ratio)
            self.weekCalendarVC.view.hidden = true
            
            }) { (Bool) -> Void in
                
                self.weekCalendarVC.view.hidden = false
                self.isAnimated = false
        }
        
    }
    
    func showMonthCalendar(){
        
        weekCalendarVC.view.hidden = true
        calendarButton.tag = 1
        
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            
            self.monthCalendarVC.view.frame = CGRectMake(0,self.detailView.center.y+129*self.ratio,320*self.ratio,360*self.ratio)
            
            
            }) { (Bool) -> Void in
                
                self.isAnimated = false
        }
        
    }
    
    
    func updateMemoTimerAimLabel(){
        
        if let week = task.week as? Week {
            var expectedTimes:[NSNumber] = task.week.getExpectedTime()
            
            
            if let day = day {
                var expectedTime:NSTimeInterval = NSTimeInterval(expectedTimes[day.dayOfWeek.integerValue])
                memoView.timerAimLabel.text = getTimeStringFromSeconds(expectedTime)
            }
        }
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
        detailTableView.backgroundColor = UIColor.todaitBackgroundGray()
        detailTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        //view.addSubview(detailTableView)
    }
    
    func addWeekCalendarVC(){
        weekCalendarVC = DetailWeekCalendarViewController()
        weekCalendarVC.view.backgroundColor = UIColor.whiteColor()
        
        weekCalendarVC.task = task
        weekCalendarVC.delegate = self
        weekCalendarVC.dateNumber = selectedDateNumber
        weekCalendarVC.view.frame = CGRectMake(0,detailViewHeight*ratio + 43*ratio,width,47*ratio)
        
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
        
        monthCalendarVC.view.frame = CGRectMake(0,detailViewHeight*ratio + 43*ratio-(selectedWeekOfMonth-1)*weekCalendarHeight*ratio,width, monthCalendarHeight*ratio)
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
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
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
        var location2 = scrollView.panGestureRecognizer.locationInView(detailScrollView)
        
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
        
        if indexPath.section == 0 {
            return 186*ratio
        }
        
        return 57.5*ratio
        
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        if indexPath.section == 1 {
            
            var diaryDetailVC = DiaryDetailViewController()
            diaryDetailVC.day = day
            diaryDetailVC.task = task
            
            self.navigationController?.pushViewController(diaryDetailVC, animated: true)
        }
        
        return false
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    
        return 2
    
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if section == 0 {
            return 1
        }
        
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
            memoView.amountTextView.setupText(day.doneAmount.integerValue, total: day.expectAmount.integerValue, unit: task.unit)
            memoView.timerLabel.text = getTimeStringFromSeconds(NSTimeInterval(day.doneSecond))
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
        
        
        if let day = task.getDay(getDateNumberFromDate(date)) {
            self.day = day
        }
        
        
        if from == "Week" {
            let baseOriginY = detailViewHeight*ratio + 43*ratio
            
            monthCalendarVC.view.frame = CGRectMake(0, baseOriginY-weekCalendarHeight*ratio*(self.selectedWeekOfMonth-1), 320*self.ratio, monthCalendarHeight*ratio)
        }
        
        if selectedDateNumber > getTodayDateNumber().integerValue {
            memoView.setUserTouchEnable(false)
        }else{
            memoView.setUserTouchEnable(true)
        }
        
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        
        
        for view in cell.contentView.subviews{
            view.removeFromSuperview()
        }
        
        
        if indexPath.section == 0 {
            
            cell.contentView.addSubview(memoView)
            
            memoView.circleChart.updatePercent(progressPercent)
            if let day = day {
                memoView.amountTextView.setupText(day.doneAmount.integerValue, total: day.expectAmount.integerValue, unit: task.unit)
                memoView.addFocusScore(CGFloat(day.score.floatValue))
            }
            
            
            updateMemoTimerAimLabel()
            
        }else{
            
            
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
        }
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.section == 0 {
            return false
        }else{
            return true
        }
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
        
    }
    
    
    func amountButtonClk(){
        
        var amountVC = AmountViewController()
        amountVC.delegate = self
        amountVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        amountVC.taskType = task.taskType
        amountVC.unit = task.unit
        
        self.navigationController?.presentViewController(amountVC, animated: false, completion: { () -> Void in
            
        })
    }
    
    
    
    func saveAmountLog(amount:Int){
        
        
        
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
        
        refreshView()
    }
    
    
    
    
    func timeLogButtonClk(){
        
        var timeLogVC = TimeLogViewController()
        timeLogVC.delegate = self
        timeLogVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        
        self.navigationController?.presentViewController(timeLogVC, animated: false, completion: { () -> Void in
            
        })
    }
    
    func recordTimeLog(time: NSTimeInterval) {
        
        saveTimeLog(time)
        refreshView()
    }
    
    func saveTimeLog(time: NSTimeInterval){
        
        let entityDescription = NSEntityDescription.entityForName("TimeLog", inManagedObjectContext:managedObjectContext!)
        let timeLog = TimeLog(entity: entityDescription!, insertIntoManagedObjectContext:managedObjectContext)
        timeLog.dayId = day
        timeLog.timestamp = NSDate().timeIntervalSince1970
        timeLog.createdAt = NSDate()
        timeLog.beforeSecond = day.doneSecond
        day.doneSecond = Int(day.doneSecond) + Int(time)
        timeLog.afterSecond = day.doneSecond.integerValue
        timeLog.createdAt = NSDate()
        timeLog.updatedAt = NSDate()
        
        var error: NSError?
        managedObjectContext?.save(&error)
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
        detailView.categoryLabel.text = task.categoryId.name
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
        
        
        loadDiary()
        refreshView()
        diaryTableView.reloadData()
        
    }
    
    func addEditButton(){
        editButton = UIButton(frame: CGRectMake(288*ratio,30,28,28))
        editButton.setImage(UIImage.maskColor("bt_edit@3x.png",color:UIColor.whiteColor()), forState: UIControlState.Normal)
        editButton.addTarget(self, action: Selector("showEditTaskVC"), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(editButton)
    }
    
    func showEditTaskVC(){
        
        
        switch task.taskType {
        case "Timer": showEditTimerTaskVC()
        default:  showEditTimerTaskVC()

        }
        
        
        
        
        //performSegueWithIdentifier("ShowEditTaskView", sender:self)
        
    }
    
    func showEditTimerTaskVC(){
        
        let editTaskVC = EditTimerTaskViewController()
        
        editTaskVC.editedTask = task
        editTaskVC.delegate = self
        editTaskVC.mainColor = task.getColor()
        editTaskVC.category = task.categoryId
        
        self.navigationController?.pushViewController(editTaskVC, animated: true)
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
        popUp.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 4*ratio)
        popUp.center = view.center
        
        view.addSubview(popUp)
        
        
        UIView.animateWithDuration(0.4, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            popCircle.transform = CGAffineTransformMakeScale(1.2, 1.2)
            popUp.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 16*self.ratio)
            
            }) { (Bool) -> Void in
                
                
                UIView.animateWithDuration(1.1, animations: { () -> Void in
                    
                    }, completion: { (Bool) -> Void in
                        
                        popCircle.removeFromSuperview()
                        popUp.removeFromSuperview()
                })
                
        }
        
    }
    
    func addGraphButton(){
        
        graphButton = UIButton(frame: CGRectMake(254*ratio,30,28,28))
        graphButton.setImage(UIImage.maskColor("bt_graph@3x.png",color:UIColor.whiteColor()), forState: UIControlState.Normal)
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
        
        amountLog.dayId = day
        amountLog.beforeDoneAmount = day.doneAmount
        amountLog.updatedAt = NSDate()
        amountLog.dirtyFlag = 0
        day.doneAmount = Int(day.doneAmount) + 1
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
            NSLog("DoneAmount 저장 및 업데이트성공",1)
        }
    }
    
    
    
    func backButtonClk() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
}
