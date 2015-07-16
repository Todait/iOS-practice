//
//  TimeTableViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 5..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit
import CoreData

class TimeTableViewController: BasicViewController,TodaitNavigationDelegate,CalendarDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate{

    
    var headerView:UIView!
    var dateLabel:UILabel!
    
    var weekCalendarVC:WeekCalendarViewController!
    var monthCalendarVC:MonthCalendarViewController!
    
    
    
    var timeTableView: UIScrollView!
    var categoryView: UIScrollView!
    
    let TimeTableHeight:CGFloat = 40
    
    let HistoryViewOriginX:CGFloat = 50
    let HistoryViewWidth:CGFloat = 220
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var timeHistoryList:[TimeHistory] = []
    var hourTexts:[String] = []
    
    var selectedDateNumber:NSNumber!
    var selectedWeekOfMonth:CGFloat! = 2
    
    var panStart:CGPoint!
    var panEnd:CGPoint!
    
    var isLongPressed:Bool! = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        selectedDateNumber = getDateNumberFromDate(NSDate())
        
        setupHourTexts()
        
        addMonthView()
        addWeekView()
        addHeaderView()
        
        addTimeTableView()
        addTimeTableSubViews()
        addGesture()
        
        loadTimeHistory()
        
        
        addExampleHistoryView(CGRectMake(HistoryViewOriginX*ratio,150,220*ratio,60*ratio), color: UIColor.todaitRed())
        addExampleHistoryView(CGRectMake(HistoryViewOriginX*ratio,250,220*ratio,120*ratio), color: UIColor.todaitGreen())
        addExampleHistoryView(CGRectMake(HistoryViewOriginX*ratio,400,220*ratio,70*ratio), color: UIColor.todaitOrange())
        
        addCategoryView()
    }
    
    func setupHourTexts(){
        
        for var index = 0 ; index < 24 ; index++ {
            
            let hour = (index+11)%12 + 1
            
            if index < 12 {
                hourTexts.append("\(hour)"+" "+"AM")
            }else{
                hourTexts.append("\(hour)"+" "+"PM")
            }
        }
        
    }
    
    func addHeaderView(){
        
        headerView = UIView(frame: CGRectMake(0, 64, width, 43*ratio))
        headerView.backgroundColor = UIColor.colorWithHexString("FEFEFE")
        view.addSubview(headerView)
        
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
        
        let line = UIView(frame:CGRectMake(0, 42.5*ratio, width, 0.5*ratio))
        line.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)
        headerView.addSubview(line)
        
    }
    
    func updateDateLabel(date:NSDate){
        let dateForm = NSDateFormatter()
        dateForm.dateFormat = "yyyy.MM"
        dateLabel.text = dateForm.stringFromDate(date)
        
        selectedWeekOfMonth = getWeekNumber(date)
        
        NSLog("%f 주차", selectedWeekOfMonth)
        
    }
    
    func getWeekNumber(date:NSDate)->CGFloat{
        
        var time = Int(date.timeIntervalSinceDate(getFirstDateOfMonth(date)) / (7*24*60*60))
        
        return CGFloat(time + 1)
        
    }
    
    
    func addMonthView(){
        
        
        
        
        monthCalendarVC = MonthCalendarViewController()
        
        monthCalendarVC.delegate = self
        monthCalendarVC.view.backgroundColor = UIColor.whiteColor()
        monthCalendarVC.view.frame = CGRectMake(0,64+43*ratio-(selectedWeekOfMonth-1)*48*ratio,width,48*6*ratio)
        
        monthCalendarVC.dateNumber = selectedDateNumber
        addChildViewController(monthCalendarVC)
        view.addSubview(monthCalendarVC.view)
        
        
        var panGesture = UIPanGestureRecognizer()
        panGesture.addTarget(self, action: Selector("panGesture:"))
        panGesture.delegate = self
        monthCalendarVC.view.addGestureRecognizer(panGesture)
        
        
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
    
        
        
        
        if gestureRecognizer.view == timeTableView {
            
            
            var gesture = gestureRecognizer as! UIPanGestureRecognizer
            var velocity = gesture.velocityInView(self.view)
            
            NSLog("time velocity %f",velocity.y)
            
            if ( abs(velocity.y) > abs(velocity.x) && velocity.y > 0 && timeTableView.contentOffset.y < 15*ratio) {
                timeTableView.scrollEnabled = false
                return true
            }else if weekCalendarVC.view.hidden == true  && velocity.y < 0 {
                timeTableView.scrollEnabled = false
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
        
        /*
        if gesture.view == timeTableView {
         
            NSLog("time gesture")
            var velocity = gesture.velocityInView(self.view)
            
            if timeTableView.contentOffset.y < 0 && velocity.y > 0 {
                scrollCalendar(gesture)
            }
            
            return
        }
        */
        
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
        
        let baseOriginY = 64 + 43*ratio
        let minOriginY = baseOriginY - 48*ratio*selectedWeekOfMonth
        let maxOriginY = baseOriginY - 48*5*ratio
        let topDistance = 48*ratio*(selectedWeekOfMonth-1)
        let bottomDistance = 48*ratio*(6-selectedWeekOfMonth)
        
        
        var calendarDiff = 1*(selectedWeekOfMonth-1)*diff/6
        var timeTableDiff = 5*diff/6
        
        let monthRect = monthCalendarVC.view.frame
        let monthX = monthRect.origin.x
        let monthY = monthRect.origin.y
        let monthW = monthRect.size.width
        let monthH = monthRect.size.height
        
        
        
        //NSLog("위는 %f 움직이고 , 아래 %f 움직이기",selectedWeekOfMonth,6-selectedWeekOfMonth)
        
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
        
        
        
        if timeTableView.frame.origin.y - timeTableDiff < baseOriginY + 48*ratio {
            //NSLog("최대 올라감 %f", timeTableView.frame.origin.y - timeTableDiff)
            timeTableView.frame = CGRectMake(0, baseOriginY + 48*ratio, 245*ratio, timeTableView.frame.size.height)
            categoryView.frame = CGRectMake(245*ratio, baseOriginY + 48*ratio, 75*ratio, timeTableView.frame.size.height)
            monthCalendarVC.view.frame = CGRectMake(0, baseOriginY-48*self.ratio*(self.selectedWeekOfMonth-1), 320*self.ratio, 48*6*self.ratio)
        }else if(timeTableView.frame.origin.y - timeTableDiff >= baseOriginY + 48*ratio && timeTableView.frame.origin.y - timeTableDiff <= baseOriginY + 48*6*ratio) {
            
            //NSLog("중간 %f",timeTableView.frame.origin.y - timeTableDiff)
            timeTableView.frame = CGRectMake(0, timeTableView.frame.origin.y - timeTableDiff, 245*ratio, timeTableView.frame.size.height)
             categoryView.frame = CGRectMake(245*ratio, timeTableView.frame.origin.y - timeTableDiff, 75*ratio, timeTableView.frame.size.height)
        }else {
            
            //NSLog("최대내려감 %f",timeTableView.frame.origin.y - timeTableDiff)
            timeTableView.frame = CGRectMake(0, baseOriginY + 48*6*ratio, 245*ratio, timeTableView.frame.size.height)
            
            categoryView.frame = CGRectMake(245*ratio, baseOriginY + 48*6*ratio, 75*ratio, timeTableView.frame.size.height)
        }
        
        
    }
    
    func gestureEnded(gesture:UIPanGestureRecognizer){
        
        let baseOriginY = 64 + 43*ratio
        
        /*
        var velocity = gesture.velocityInView(self.view)
        var slideFactor = velocity.y/1500
        var timeY = self.timeTableView.frame.origin.y + velocity.y*slideFactor
        timeY = min(max(timeY,baseOriginY + 48*ratio),baseOriginY + 48*6*ratio)
        */
        
        if timeTableView.frame.origin.y >= 250*ratio {
            
            UIView.animateWithDuration(0.4, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
                self.categoryView.frame = CGRectMake(245*self.ratio, baseOriginY + 48*6*self.ratio, 75*self.ratio, self.timeTableView.frame.size.height)
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
                
                self.categoryView.frame = CGRectMake(245*self.ratio, baseOriginY + 48*self.ratio, 75*self.ratio, self.timeTableView.frame.size.height)
                
                }, completion: { (Bool) -> Void in
                    self.timeTableView.scrollEnabled = true
                    self.weekCalendarVC.view.hidden = false
            })
        }
        
    }
    
    func updateDate(monthDate: NSDate,from:String) {
        NSLog("Receive Date %@", monthDate)
        updateDateLabel(monthDate)
        
        selectedDateNumber = getDateNumberFromDate(monthDate)
        
        monthCalendarVC.setSelectedDateNumber(selectedDateNumber)
        weekCalendarVC.setSelectedDateNumber(selectedDateNumber)
        
        
        /*
        switch from {
        case "Month": weekCalendarVC.setSelectedDateNumber(selectedDateNumber)
        case "Week": monthCalendarVC.setSelectedDateNumber(selectedDateNumber)
        default: monthCalendarVC.setSelectedDateNumber(selectedDateNumber)
                 weekCalendarVC.setSelectedDateNumber(selectedDateNumber)

        }
        */
    }
    
    func addWeekView(){
        
        weekCalendarVC = WeekCalendarViewController()
        addChildViewController(weekCalendarVC)
        weekCalendarVC.delegate = self
        
        weekCalendarVC.view.backgroundColor = UIColor.whiteColor()
        weekCalendarVC.view.frame = CGRectMake(0,64+43*ratio,width,48*ratio)
        //weekCalendarVC.view.alpha = 0.1
        weekCalendarVC.dateNumber = selectedDateNumber
        view.addSubview(weekCalendarVC.view)
        
        
        var panGesture = UIPanGestureRecognizer()
        panGesture.addTarget(self, action: Selector("panGesture:"))
        panGesture.delegate = self
        weekCalendarVC.view.addGestureRecognizer(panGesture)
        
    }

    
    func addTimeTableView(){
        
        var originY:CGFloat = 64 + 43*ratio + 48*ratio
        
        timeTableView = UIScrollView(frame: CGRectMake(0, originY, 245*ratio, height-originY))
        timeTableView.contentSize = CGSizeMake(245*ratio,27*TimeTableHeight*ratio)
        timeTableView.backgroundColor = UIColor.whiteColor()
        timeTableView.delegate = self
        
        timeTableView.layer.shadowOffset = CGSizeMake(0, 0.5*ratio)
        timeTableView.layer.shadowColor = UIColor.blackColor().CGColor
        timeTableView.layer.shadowRadius = 2
        timeTableView.layer.shadowOpacity = 1
        
        view.addSubview(timeTableView)
        
    
        var panGesture = UIPanGestureRecognizer()
        panGesture.addTarget(self, action: Selector("panGesture:"))
        panGesture.delegate = self
        timeTableView.addGestureRecognizer(panGesture)
    }
    
    func addCategoryView(){
        
        var originY:CGFloat = 64 + 43*ratio + 48*ratio
        
        categoryView = UIScrollView(frame: CGRectMake(245*ratio, originY, 75*ratio, height-originY))
        categoryView.contentSize = CGSizeMake(245*ratio,27*TimeTableHeight*ratio)
        categoryView.backgroundColor = UIColor.colorWithHexString("#EEEEEE")
        categoryView.delegate = self
        
        categoryView.layer.shadowOffset = CGSizeMake(0, 0.5*ratio)
        categoryView.layer.shadowColor = UIColor.blackColor().CGColor
        categoryView.layer.shadowRadius = 2
        categoryView.layer.shadowOpacity = 1
        
        view.addSubview(categoryView)
        
        
        var panGesture = UIPanGestureRecognizer()
        panGesture.addTarget(self, action: Selector("panGesture:"))
        panGesture.delegate = self
        categoryView.addGestureRecognizer(panGesture)
        
        
    }
    
    func addTimeTableSubViews(){
        
        for i in 0...23 {
            
            let timeLabel = UILabel(frame: CGRectMake(9*ratio,+20*ratio+TimeTableHeight * CGFloat(i)*ratio,50*ratio,12*ratio))
            timeLabel.text = hourTexts[i]
            timeLabel.textAlignment = NSTextAlignment.Left
            timeLabel.textColor = UIColor.todaitDarkGray()
            timeLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 7.5*ratio)
            
            timeTableView.addSubview(timeLabel)
            
            
            let timeLineView = UIView(frame: CGRectMake(50*ratio,25*ratio+TimeTableHeight * CGFloat(i)*ratio, 160*ratio, 1*ratio))
            timeLineView.backgroundColor = UIColor.todaitDarkGray().colorWithAlphaComponent(0.3)
            timeTableView.addSubview(timeLineView)
        }
    }
    
    
    
    
    func addGesture(){
        
        let longGesture = UILongPressGestureRecognizer(target:self,action:"longPress:")
        timeTableView.addGestureRecognizer(longGesture)
    }
    
    func longPress(gesture:UILongPressGestureRecognizer){
        
        if isLongPressed == true{
            return
        }
        
        isLongPressed = true
        
        
        addExampleHistoryView(CGRectMake(HistoryViewOriginX*ratio,500,220*ratio,70*ratio), color: UIColor.todaitBlue())
        
    }
    
    
    func loadTimeHistory(){
        
        let entityDescription = NSEntityDescription.entityForName("TimeHistory",inManagedObjectContext:managedObjectContext!)
        
        let request = NSFetchRequest()
        request.entity = entityDescription
        
        var error: NSError?
        timeHistoryList = managedObjectContext?.executeFetchRequest(request, error: &error) as! [TimeHistory]
        
        addHistoryView()
    }
    
    func addExampleHistoryView(frame:CGRect,color:UIColor){
        
        
        /*
        let historyView = UIView(frame:frame)
        historyView.backgroundColor = color.colorWithAlphaComponent(0.05)
        
        
        
        
        let colorBox = UIView(frame:CGRectMake(0,0,6*ratio,frame.size.height))
        colorBox.backgroundColor = color
        historyView.addSubview(colorBox)
        
        timeTableView.addSubview(historyView)
        */
        
        var timeTile = TimeTileView(frame: frame)
        timeTile.setupColor(color)
        timeTableView.addSubview(timeTile)
        
    }

    func addHistoryView(){
        
        for historyItem in timeHistoryList {
            
            let originX:CGFloat = HistoryViewOriginX*ratio
            let originY = getHistoryOriginY(historyItem)
            let width = HistoryViewWidth*ratio
            let height = getHistoryHeight(historyItem)
            let color = historyItem.getColor()
            
            let historyView = UIView(frame:CGRectMake(originX,originY,width,height))
            historyView.backgroundColor = color.colorWithAlphaComponent(0.3)
            historyView.alpha = 0.5
            historyView.layer.cornerRadius = 4*ratio
            historyView.clipsToBounds = true
            
            let colorBox = UIView(frame:CGRectMake(0,0,6*ratio,height))
            colorBox.backgroundColor = color
            historyView.addSubview(colorBox)
            
            
            timeTableView.addSubview(historyView)
            
        }
    }
    
    func getHistoryHeight(history:TimeHistory)->CGFloat{
        
        return CGFloat(history.getHistoryTime()) * TimeTableHeight * ratio / (60*60)
    }
    
    
    func getHistoryOriginY(history:TimeHistory)->CGFloat{
        
        let dateComps = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitHour|NSCalendarUnit.CalendarUnitMinute|NSCalendarUnit.CalendarUnitSecond, fromDate:history.started_at)
        
        
        return getHeightFromComps(dateComps)
    }
    
    func getHeightFromComps(comps:NSDateComponents)->CGFloat{
        
        if comps.hour == 0 && comps.minute == 0 {
            return 10*ratio
        }
        
        return getHeightFromHour(comps.hour) + getHeightFromMinute(comps.minute)
        
    }
    
    func getHeightFromHour(hour:Int)->CGFloat{
        
        return TimeTableHeight * ratio * CGFloat(hour)
    }
    
    func getHeightFromMinute(minute:Int)->CGFloat{
        
        return TimeTableHeight * ratio * CGFloat(minute) / 60
    }
    
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        
        if gestureRecognizer.view == timeTableView {
            NSLog("time ->",1)
        }else{
            NSLog("cal ->",1)
        }
        
        if otherGestureRecognizer.view == timeTableView {
            NSLog("time ",1)
        }else{
            NSLog("cal ",1)
        }
        
        
        return false
    }
    
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        
        
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y < 0 {
            
            
            //gestureRecognizer(<#gestureRecognizer: UIGestureRecognizer#>, shouldRecognizeSimultaneouslyWithGestureRecognizer: <#UIGestureRecognizer#>)
        }
        
    }
 
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        todaitNavBar.todaitDelegate = self
        todaitNavBar.backButton.hidden = true
        todaitNavBar.shadowImage = UIImage()
        self.titleLabel.text = "Time Table"
        
        self.screenName = "TimeTable Activity"
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func backButtonClk() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
