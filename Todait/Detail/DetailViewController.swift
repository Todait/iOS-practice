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
import RealmSwift

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
    var taskDate:TaskDate!
    var day:Day?
    //var diaryData:[Diary]! = []
    var diaryResults:Results<Diary>?
    
    var dateLabel:UILabel!
    
    //let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    
    var progressPercent:NSNumber?
    var progressString:String?
    var doneCountEnabled:Bool! = true
    
    var editButton:UIButton!
    var graphButton:UIButton!
    
    
    var selectedDateNumber:Int!
    var selectedWeekOfMonth:CGFloat! = 2
    
    
    
    let DETAILVIEW_HEIGHT:CGFloat = 115
    let WEEK_CALENDAR_HEIGHT:CGFloat = 49
    let MONTH_CALENDAR_HEIGHT:CGFloat = 295
    
    let MIN_HEADER_HEIGHT:CGFloat = 100
    let MAX_HEADER_HEIGHT:CGFloat = 215
    var showCalendarHeight:CGFloat = 49
    var isCalendarScroll:Bool = true
    
    
    var panStart:CGPoint!
    var panEnd:CGPoint!
    
    var isCalendarDown:Bool = false
    var button:UIButton!
    
    
    var weekCalendarVC:DetailWeekCalendarViewController!
    var monthCalendarVC:DetailMonthCalendarViewController!
    
    var isAnimated:Bool = false
    
    var shadowView:UIView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        
        if let day = task.getTodayDay() {
            self.day = day
        }
        
        
        
        ProgressManager.show()
        selectedDateNumber = getDateNumberFromDate(NSDate())
        selectedWeekOfMonth = getWeekNumber(NSDate())
        
        

        
        addHeaderView()
        addMemoView()
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
    
    func setupDay(dateNumber:Int){
        
        
        if let day = task.getDay(dateNumber) {
            self.day = day
            doneCountEnabled = true
            progressPercent = day.getDonePercentCGFloat()
            progressString = day.getProgressString()
            
        } else {
            
            progressPercent = 0
            progressString = "0%"
            
            doneCountEnabled = false
            
        }
    }
    
    func loadDiary(){
        
        if let day = day {
            let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: false)
            
            
            //diaryData = day.diarys.sortedArrayUsingDescriptors([sortDescriptor]) as! [Diary]
        }
        
    }
    
    func addHeaderView(){
        
        addDetailView()
        addMemoView()
    }
    
    func addDetailView(){
        detailView = DetailView(frame: CGRectMake(0, 0, width, DETAILVIEW_HEIGHT*ratio))
        detailView.mainImageView.image = UIImage(named: "track.jpg")
        
        
        var panGesture = UIPanGestureRecognizer()
        panGesture.addTarget(self, action: Selector("panGesture:"))
        panGesture.delegate = self
        detailView.addGestureRecognizer(panGesture)
        
        
    }
    
    
    
    
    func addWeekHeaderView(){
        
        
        
        var headerView = UIView(frame: CGRectMake(0, DETAILVIEW_HEIGHT*ratio, width, 43*ratio))
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
            
            weekDayLabel.setKern(1)
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
        
        let baseOriginY = DETAILVIEW_HEIGHT*ratio + 43*ratio
        let baseMonthY = DETAILVIEW_HEIGHT*ratio + 41*ratio
        let minOriginY = baseOriginY - WEEK_CALENDAR_HEIGHT*ratio*selectedWeekOfMonth
        let maxOriginY = baseOriginY - WEEK_CALENDAR_HEIGHT*5*ratio
        let topDistance = WEEK_CALENDAR_HEIGHT*ratio*(selectedWeekOfMonth-1)
        let bottomDistance = WEEK_CALENDAR_HEIGHT*ratio*(6-selectedWeekOfMonth)
        
        
        var calendarDiff = 1*(selectedWeekOfMonth-1)*diff/6
        var timeTableDiff = 5*diff/6
        
        let monthRect = monthCalendarVC.view.frame
        let monthX = monthRect.origin.x
        let monthY = monthRect.origin.y
        let monthW = monthRect.size.width
        let monthH = monthRect.size.height
        
        
        if monthY - calendarDiff < minOriginY {
            //NSLog("최대 올라감C %f", monthY - calendarDiff)
            monthCalendarVC.view.frame = CGRectMake(monthX,baseMonthY,monthW,monthH)
            
        }else if(monthY - calendarDiff >= minOriginY && monthY - calendarDiff <= baseMonthY) {
            //NSLog("중간C %f",monthY - calendarDiff)
            monthCalendarVC.view.frame = CGRectMake(monthX,monthY - calendarDiff, monthW, monthH)
        }else {
            
            //NSLog("최대내려감C %f",monthY - calendarDiff)
            monthCalendarVC.view.frame = CGRectMake(monthX,baseMonthY,monthW,monthH)
        }
        
        
        
        if diaryTableView.frame.origin.y - timeTableDiff < baseMonthY + WEEK_CALENDAR_HEIGHT*ratio {
            //NSLog("최대 올라감 %f", diaryTableView.frame.origin.y - timeTableDiff)
            
            shadowView.frame = CGRectMake(0, baseMonthY + WEEK_CALENDAR_HEIGHT*ratio - 2*ratio, width,4*ratio)
            diaryTableView.frame = CGRectMake(0, baseMonthY + WEEK_CALENDAR_HEIGHT*ratio, 320*ratio, diaryTableView.frame.size.height)
            monthCalendarVC.view.frame = CGRectMake(0, baseMonthY-WEEK_CALENDAR_HEIGHT*ratio*(self.selectedWeekOfMonth-1), 320*self.ratio, MONTH_CALENDAR_HEIGHT*ratio)
        }else if(diaryTableView.frame.origin.y - timeTableDiff >= baseMonthY + WEEK_CALENDAR_HEIGHT*ratio && diaryTableView.frame.origin.y - timeTableDiff <= baseMonthY + MONTH_CALENDAR_HEIGHT*ratio) {
            
            //NSLog("중간 %f",diaryTableView.frame.origin.y - timeTableDiff)
            shadowView.frame = CGRectMake(0, diaryTableView.frame.origin.y - timeTableDiff - 2*ratio, width,4*ratio)
            diaryTableView.frame = CGRectMake(0, diaryTableView.frame.origin.y - timeTableDiff, 320*ratio, diaryTableView.frame.size.height)
        }else {
            
            //NSLog("최대내려감 %f",diaryTableView.frame.origin.y - timeTableDiff)
            
             shadowView.frame = CGRectMake(0, baseMonthY + MONTH_CALENDAR_HEIGHT*ratio - 2*ratio, width,4*ratio)
            diaryTableView.frame = CGRectMake(0, baseMonthY + MONTH_CALENDAR_HEIGHT*ratio, 320*ratio, diaryTableView.frame.size.height)
            
        }
        
        
    }
    
    func gestureEnded(gesture:UIPanGestureRecognizer){
        
        let baseOriginY = DETAILVIEW_HEIGHT*ratio + 43*ratio
        
        /*
        var velocity = gesture.velocityInView(self.view)
        var slideFactor = velocity.y/1500
        var timeY = self.diaryTableView.frame.origin.y + velocity.y*slideFactor
        timeY = min(max(timeY,baseOriginY + 48*ratio),baseOriginY + 48*6*ratio)
        */
        
        
        var scrollLine = baseOriginY + 0.5 * MONTH_CALENDAR_HEIGHT * ratio
        
        if isCalendarDown == true {
            scrollLine = baseOriginY + WEEK_CALENDAR_HEIGHT*ratio + MONTH_CALENDAR_HEIGHT*ratio * 2 / 3
        }else {
            scrollLine = baseOriginY + WEEK_CALENDAR_HEIGHT*ratio + MONTH_CALENDAR_HEIGHT*ratio / 6
        }
        
        NSLog("scroll %f table %f",scrollLine,diaryTableView.frame.origin.y)
        
        
        if diaryTableView.frame.origin.y >= scrollLine {
            
            isCalendarDown = true
            
            UIView.animateWithDuration(0.4, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
                
                
                self.shadowView.frame = CGRectMake(0, baseOriginY + self.MONTH_CALENDAR_HEIGHT*self.ratio - 2*self.ratio, self.width,4*self.ratio)
                self.diaryTableView.frame = CGRectMake(0, baseOriginY + self.MONTH_CALENDAR_HEIGHT*self.ratio, 320*self.ratio, self.diaryTableView.frame.size.height)
                
                self.monthCalendarVC.view.frame = CGRectMake(0, baseOriginY, 320*self.ratio, self.MONTH_CALENDAR_HEIGHT*self.ratio)
                
                
                }, completion: { (Bool) -> Void in
                    self.diaryTableView.scrollEnabled = true
                    self.weekCalendarVC.view.hidden = true
            })
        }else{
            
            isCalendarDown = false
            
            UIView.animateWithDuration(0.4, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
                
                
                self.shadowView.frame = CGRectMake(0, baseOriginY + self.WEEK_CALENDAR_HEIGHT*self.ratio - 2*self.ratio, self.width,4*self.ratio)
                
                self.diaryTableView.frame = CGRectMake(0, baseOriginY + self.WEEK_CALENDAR_HEIGHT*self.ratio, 320*self.ratio, self.diaryTableView.frame.size.height)
                self.monthCalendarVC.view.frame = CGRectMake(0, baseOriginY-self.WEEK_CALENDAR_HEIGHT*(self.selectedWeekOfMonth-1)*self.ratio, 320*self.ratio, self.MONTH_CALENDAR_HEIGHT*self.ratio)
                
                
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
            memoView.amountTextView.setupText(day.doneAmount, total: day.expectAmount, unit: task.unit)
            memoView.addFocusScore(CGFloat(day.score))
        }else{
            memoView.amountTextView.setupText(task.getTotalDoneAmount(), total: task.amount, unit: task.unit)
            memoView.addFocusScore(CGFloat(0.0))
        }
        
        
        updateMemoTimerAimLabel()
        
        
    }
    
    func addDiaryTableView(){
        
         var originY:CGFloat = DETAILVIEW_HEIGHT*ratio + 43*ratio + WEEK_CALENDAR_HEIGHT*ratio
        
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
        shadowLayer.colors = [UIColor.clearColor().CGColor,UIColor.todaitBackgroundGray().colorWithAlphaComponent(0.5).CGColor]
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
            
            self.monthCalendarVC.view.frame = CGRectMake(0,self.detailView.center.y+129*self.ratio-self.WEEK_CALENDAR_HEIGHT*self.ratio*(self.selectedWeekOfMonth-1)-0*self.ratio, 320*self.ratio, self.MONTH_CALENDAR_HEIGHT*self.ratio)
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
        
        
        if let day = day {
            
            if let week = day.taskDate!.week {
                
                var expectedTimes:[Int] = week.getExpectedTime()
                var expectedTime:NSTimeInterval = NSTimeInterval(expectedTimes[day.dayOfWeek()])
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
        weekCalendarVC.view.frame = CGRectMake(0,DETAILVIEW_HEIGHT*ratio + 43*ratio,width,49*ratio)
        
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
        
        monthCalendarVC.view.frame = CGRectMake(0,DETAILVIEW_HEIGHT*ratio + 43*ratio-(selectedWeekOfMonth-1)*WEEK_CALENDAR_HEIGHT*ratio,width, MONTH_CALENDAR_HEIGHT*ratio)
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
    
    
    /*
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
    */
    
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
        
        
        if let diaryResults = diaryResults {
            
            return diaryResults.count
        }
        
        return 0
        
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
        
        
        if let day = day {
            realm.write{
                day.score = Double(focus)
                self.realm.add(day,update:true)
            }
            
            memoView.addFocusScore(CGFloat(day.score))
        }
        
        
    }
    
    
    func updateDateLabel(date:NSDate){
        let dateForm = NSDateFormatter()
        dateForm.dateFormat = "yyyy.MM"
        dateLabel.text = dateForm.stringFromDate(date)
        dateLabel.setKern(1)
        selectedWeekOfMonth = getWeekNumber(date)
        
        
        updateMemo(date)
    }
    
    
    
    func updateMemo(date:NSDate){
        
        var dateNumber = getDateNumberFromDate(date)
        var newDay =  task.getDay(dateNumber)
        
        if let day = newDay {
            
            setupDay(dateNumber)
            
            if let progressPercent = progressPercent {
                memoView.circleChart.updatePercent(progressPercent)
            }
            
            memoView.amountTextView.setupText(day.doneAmount, total: day.expectAmount, unit: task.unit)
            memoView.timerLabel.text = getTimeStringFromSeconds(NSTimeInterval(day.doneSecond))
            memoView.addFocusScore(CGFloat(day.score))
            
            updateMemoTimerAimLabel()
        }else{
            
            memoView.circleChart.updatePercent(0)
            memoView.amountTextView.setupText(0, total: task.amount, unit: task.unit)
            memoView.timerLabel.text = getTimeStringFromSeconds(NSTimeInterval(0))
            memoView.addFocusScore(CGFloat(0.0))
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
            let baseOriginY = DETAILVIEW_HEIGHT*ratio + 43*ratio
            
            monthCalendarVC.view.frame = CGRectMake(0, baseOriginY-WEEK_CALENDAR_HEIGHT*ratio*(self.selectedWeekOfMonth-1), 320*self.ratio, MONTH_CALENDAR_HEIGHT*ratio)
        }
        
        if selectedDateNumber > getTodayDateNumber() {
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
            
            if let progressPercent = progressPercent {
                memoView.circleChart.updatePercent(progressPercent)
            }
            
            if let day = day {
                memoView.amountTextView.setupText(day.doneAmount, total: day.expectAmount, unit: task.unit)
                memoView.addFocusScore(CGFloat(day.score))
            }
            
            
            updateMemoTimerAimLabel()
            
        }else{
            
            
            var imageView = UIImageView(frame:CGRectMake(0,0,82*ratio,57.5*ratio))
            imageView.contentMode = UIViewContentMode.ScaleAspectFill
            imageView.clipsToBounds = true
            cell.addSubview(imageView)
            
            
            let diary = diaryResults![indexPath.row]
            
            
            for image in diary.images {
                
                let fileManager = NSFileManager.defaultManager()
                var path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
                var paths = path + "/" + image.fileName
                
                if fileManager.fileExistsAtPath(paths){
                    imageView.image = UIImage(contentsOfFile: paths)
                }
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
        
        
        
        let diary = diaryResults![indexPath.row]
        diary.archived = true
        
        realm.write{
            
            self.realm.add(diary,update:true)
        }
        
       diaryResults = diaryResults!.filter("archived == false")
        
        tableView.beginUpdates()
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation:UITableViewRowAnimation.Automatic)
        tableView.endUpdates()
        
        
    }
    
    
    func timerButtonClk(){
        
        let timerVC = TimerViewController()
        
        let day:Day! = task.getDay(getTodayDateNumber())
        timerVC.task = task
        timerVC.day = day
        self.navigationController?.pushViewController(timerVC, animated: true)
        
        
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
        
        
        if let day = day {
            
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
                
                day.doneAmount = Int(day.doneAmount) + Int(amount)
                day.amountLogs.append(amountLog)
                
                self.realm.add(day,update:true)
            }

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
        
        /*
        let entityDescription = NSEntityDescription.entityForName("TimeLog", inManagedObjectContext:managedObjectContext!)
        let timeLog = TimeLog(entity: entityDescription!, insertIntoManagedObjectContext:managedObjectContext)
        timeLog.day = day
        timeLog.timestamp = NSDate().timeIntervalSince1970
        timeLog.createdAt = NSDate()
        timeLog.beforeSecond = day.doneSecond
        day.doneSecond = Int(day.doneSecond) + Int(time)
        timeLog.afterSecond = day.doneSecond.integerValue
        timeLog.createdAt = NSDate()
        timeLog.updatedAt = NSDate()
        
        
        var error: NSError?
        managedObjectContext?.save(&error)
        */
        
        
        if let day = day {
            
            let timeLog = TimeLog()
            timeLog.id = NSUUID().UUIDString
            timeLog.day = day
            timeLog.timestamp = Int(NSDate().timeIntervalSince1970)
            timeLog.beforeSecond = day.doneSecond
            
            timeLog.afterSecond = day.doneSecond
            
            
            realm.write{
                self.realm.add(timeLog)
                
                day.doneSecond = Int(day.doneSecond) + Int(time)
                day.timeLogs.append(timeLog)
                
                self.realm.add(day,update:true)
            }
        }
    }
    
    func refreshView(){
        
        var refreshDateNumber = getDateFromDateNumber(selectedDateNumber)
        
        loadDiary()
        setupDay(selectedDateNumber)
        refreshHeaderText()
        
        updateMemo(refreshDateNumber)
        weekCalendarVC.weekView.reloadData()
        monthCalendarVC.monthView.reloadData()
        diaryTableView.reloadData()
        
    }
    
    func refreshHeaderText(){
        
        detailView.dateLabel.text = task.getStringOfPeriodProgress()
        detailView.timeLabel.text = task.getDoneTimeString()
        detailView.amountLabel.text = task.getDoneAmountString()
        
        if let category = task.category {
            detailView.categoryLabel.text = category.name
        }
        
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
    
    override func viewDidAppear(animated: Bool) {
        
        refreshView()
        ProgressManager.hide()
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
        
        
        //setupDay(getTodayDateNumber())
        //loadDiary()
        
        
        //diaryTableView.reloadData()
        
    }
    
    func addEditButton(){
        
        if editButton != nil {
            return
        }
        
        editButton = UIButton(frame: CGRectMake(320*ratio - 44 - 6,22,44,44))
        editButton.setImage(UIImage.maskColor("nav_bt_edit@3x.png",color:UIColor.whiteColor()), forState: UIControlState.Normal)
        editButton.addTarget(self, action: Selector("showEditTaskVC"), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(editButton)
    }
    
    func showEditTaskVC(){
        
        
        switch task.taskType {
        case "time": showEditTimerTaskVC()
        case "daily": return
        case "total_by_time" : showEditTimeTaskVC()
        case "range_by_time" : showEditTimeTaskVC()
        case "total_by_amount" : showEditAmountTaskVC()
        case "range_by_amount" : showEditAmountTaskVC()
        default:  showEditTimerTaskVC()

        }
    }
    
    func showEditTimerTaskVC(){
        
        let editTaskVC = EditTimerTaskViewController()
        
        editTaskVC.editedTask = task
        editTaskVC.mainColor = task.getColor()
        
        if let category = task.category {
            editTaskVC.category = category

        }
        
        self.navigationController?.pushViewController(editTaskVC, animated: true)
    }
    
    func showEditTimeTaskVC(){
        
        
        let editTimeVC = EditTimeTaskViewController()
        editTimeVC.editedTask = task
        
        if let category = task.category {
            editTimeVC.category = category
        }
        
        self.navigationController?.pushViewController(editTimeVC, animated: true)
    }
    
    
    func showEditAmountTaskVC(){
        
        
        let editAmountVC = EditAmountTaskViewController()
        editAmountVC.editedTask = task
        
        if let category = task.category {
            editAmountVC.category = category
        }
        
        self.navigationController?.pushViewController(editAmountVC, animated: true)
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
        
        if graphButton != nil {
            return
        }
        
        graphButton = UIButton(frame: CGRectMake(320*ratio - 88 - 6,22,44,44))
        graphButton.setImage(UIImage.maskColor("nav_bt_graph@3x.png",color:UIColor.whiteColor()), forState: UIControlState.Normal)
        graphButton.addTarget(self, action: Selector("showGraphVC"), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(graphButton)
        
    }
    
    func showGraphVC(){
        
        
        if task.taskType == "timer" {
            
            var timerGraphVC = TimerGraphViewController()
            timerGraphVC.mainColor = task.getColor()
            timerGraphVC.task = task
            self.navigationController?.pushViewController(timerGraphVC, animated: true)
            
        }else {
            
            var graphVC = GraphViewController()
            graphVC.mainColor = task.getColor()
            graphVC.task = task
            
            self.navigationController?.pushViewController(graphVC, animated: true)
        }
        
    }
    
    
    func updateCategory(category:Category,from:String){
        
        
        refreshView()
        showCompletePopup()
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func addDoneAmount(){
        
        
        if let day = day {
            
            let amountLog = AmountLog()
            amountLog.day = day
            amountLog.beforeAmount = day.doneAmount
            amountLog.dirtyFlag = false
            day.doneAmount = Int(day.doneAmount) + 1
            amountLog.afterAmount = day.doneAmount
            amountLog.timestamp = Int(NSDate().timeIntervalSince1970)
            amountLog.serverId = 0
            amountLog.archived = false
            
            day.amountLogs.append(amountLog)
            
            realm.write{
                self.realm.add(amountLog)
                self.realm.add(day,update:true)
            }

        }
        
    }
    
    
    
    func backButtonClk() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
}
