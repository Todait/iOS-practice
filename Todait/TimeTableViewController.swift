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
    var monthCalendarVC:MonthCalendarViewController2!
    
    
    
    var timeTableView: UIScrollView!
    
    
    let TimeTableHeight:CGFloat = 55
    
    let HistoryViewOriginX:CGFloat = 50
    let HistoryViewWidth:CGFloat = 220
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var timeHistoryList:[TimeHistory] = []
    
    
    var selectedDateNumber:NSNumber!
    var selectedWeekDay:CGFloat! = 1
    
    var panStart:CGPoint!
    var panEnd:CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        selectedDateNumber = getDateNumberFromDate(NSDate())
        
        
        addMonthView()
        addWeekView()
        addHeaderView()
        
        addTimeTableView()
        addTimeTableSubViews()
        addGesture()
        
        loadTimeHistory()
        
        
        //addExampleHistoryView(CGRectMake(HistoryViewOriginX*ratio,150,200,60), color: UIColor.todaitRed())
        //addExampleHistoryView(CGRectMake(HistoryViewOriginX*ratio,250,200,120), color: UIColor.todaitGreen())
        
    }
    
    func addHeaderView(){
        
        headerView = UIView(frame: CGRectMake(0, 64, width, 43*ratio))
        headerView.backgroundColor = UIColor.todaitLightGray()
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
        
        selectedWeekDay = getWeekNumber(date)
        
        NSLog("%f 주차", selectedWeekDay)
        
    }
    
    func getWeekNumber(date:NSDate)->CGFloat{
        
        var time = Int(date.timeIntervalSinceDate(getFirstDateOfMonth(date)) / (7*24*60*60))
        
        return CGFloat(time + 1)
        
    }
    
    
    func addMonthView(){
        
        
        
        
        monthCalendarVC = MonthCalendarViewController2()
        
        monthCalendarVC.delegate = self
        monthCalendarVC.view.backgroundColor = UIColor.whiteColor()
        monthCalendarVC.view.frame = CGRectMake(0,102*ratio+33*ratio-selectedWeekDay*48*ratio,width,48*6*ratio)
        
        monthCalendarVC.dateNumber = selectedDateNumber
        addChildViewController(monthCalendarVC)
        view.addSubview(monthCalendarVC.view)
        
        
        var panGesture = UIPanGestureRecognizer()
        panGesture.addTarget(self, action: Selector("panGesture:"))
        panGesture.delegate = self
        monthCalendarVC.view.addGestureRecognizer(panGesture)
        
        
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
    
        var gesture = gestureRecognizer as! UIPanGestureRecognizer
        var velocity = gesture.velocityInView(self.view)
        
        return abs(velocity.y) > abs(velocity.x)
        
    
    }
    
    func panGesture(gesture:UIPanGestureRecognizer){
        NSLog("gesture", 1)
        
        switch gesture.state {
        case UIGestureRecognizerState.Began:
            panStart = gesture.locationInView(self.view)
        case UIGestureRecognizerState.Changed:
            panEnd = gesture.locationInView(self.view)
            gestureMoved()
            panStart = gesture.locationInView(self.view)
        case UIGestureRecognizerState.Ended:
            gestureEnded()
        case UIGestureRecognizerState.Cancelled:
            gestureEnded()
        default: break
            
        }
        
    }
    
    func gestureMoved(){
        
        var diff = panStart.y - panEnd.y
        
        NSLog("pan %f",monthCalendarVC.view.center.y + diff)
        
        if monthCalendarVC.view.center.y + diff < 280*ratio {
            monthCalendarVC.view.center = CGPointMake(160*ratio, monthCalendarVC.view.center.y - diff)
        }
        
        
        
    }
    
    func gestureEnded(){
        
        if monthCalendarVC.view.center.y >= 250*ratio {
            monthCalendarVC.view.center.y = 250*ratio
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
        
        
    }

    
    func addTimeTableView(){
        
        timeTableView = UIScrollView(frame: CGRectMake(0, 374*ratio, width, height-navigationHeight*ratio))
        timeTableView.contentSize = CGSizeMake(width,27*TimeTableHeight*ratio)
        timeTableView.backgroundColor = UIColor.whiteColor()
        timeTableView.delegate = self
        view.addSubview(timeTableView)
    }
    
    func addTimeTableSubViews(){
        
        let dateForm = NSDateFormatter()
        dateForm.dateFormat = "a H"
        
        let timeComp = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitHour, fromDate:NSDate())
        
        for i in 1...25 {
            
            timeComp.hour = i-1
            
            let timeLabel = UILabel(frame: CGRectMake(15*ratio,150+TimeTableHeight * CGFloat(i)*ratio,50*ratio,TimeTableHeight*ratio))
            timeLabel.text = dateForm.stringFromDate(NSCalendar.currentCalendar().dateFromComponents(timeComp)!)
            timeLabel.textAlignment = NSTextAlignment.Left
            timeLabel.textColor = UIColor.colorWithHexString("#969696")
            timeLabel.font = UIFont(name: "AvenirNext-Regular", size: 10*ratio)
            timeTableView.addSubview(timeLabel)
            
            
            let timeLineView = UIView(frame: CGRectMake(50*ratio,150+TimeTableHeight * CGFloat(i)*ratio, 160*ratio, 1*ratio))
            timeLineView.backgroundColor = UIColor.todaitLightGray()
            timeTableView.addSubview(timeLineView)
        }
    }
    
    
    
    
    
    
    
    
    func addGesture(){
        
        let longGesture = UILongPressGestureRecognizer(target:self,action:"longPress")
        timeTableView.addGestureRecognizer(longGesture)
    }
    
    func longPress(){
        NSLog("longPress",0)
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
        
        
        
        let historyView = UIView(frame:frame)
        historyView.backgroundColor = UIColor.todaitLightGray()
        //historyView.alpha = 0.5
        historyView.layer.cornerRadius = 4*ratio
        historyView.clipsToBounds = true
        
        
        
        
        let colorBox = UIView(frame:CGRectMake(0,0,10*ratio,height))
        colorBox.backgroundColor = color
        historyView.addSubview(colorBox)
        
        timeTableView.addSubview(historyView)
    }

    func addHistoryView(){
        
        for historyItem in timeHistoryList {
            
            let originX:CGFloat = HistoryViewOriginX*ratio
            let originY = getHistoryOriginY(historyItem)
            let width = HistoryViewWidth*ratio
            let height = getHistoryHeight(historyItem)
            let color = historyItem.getColor()
            
            let historyView = UIView(frame:CGRectMake(originX,originY,width,height))
            historyView.backgroundColor = UIColor.todaitLightGray()
            historyView.alpha = 0.5
            historyView.layer.cornerRadius = 4*ratio
            historyView.clipsToBounds = true
            
            let colorBox = UIView(frame:CGRectMake(0,0,10*ratio,height))
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
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        NSLog("%f %f", scrollView.contentOffset.x,scrollView.contentOffset.y)
        
        /*
        var offset = scrollView.contentOffset.y
        
        if offset >= 270*ratio {
            
            weekCalendarVC.view.hidden = false
            
        }else if offset < 270*ratio && offset > 0 {
            
            weekCalendarVC.view.hidden = true
            monthCalendarVC.view.hidden = false
            
            monthCalendarVC.view.transform = CGAffineTransformMakeTranslation(0, -1 * offset)
            //weekCalendarVC.view.transform = CGAffineTransformMakeTranslation(0, -1 * scrollView.contentOffset.y+4*48*ratio)
            scrollView.transform = CGAffineTransformMakeTranslation(0, -1 * offset)
            
            
            if offset > 235*ratio {
                scrollView.transform = CGAffineTransformMakeTranslation(0, -235*ratio)
            }
            
            
            
        }else{
            weekCalendarVC.view.hidden = true
            monthCalendarVC.view.hidden = false
        }
        */
    }
 
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        NSLog("touchesBegan", 0)
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
