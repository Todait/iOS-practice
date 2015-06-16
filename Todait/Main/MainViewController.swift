//
//  MainViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 1..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: BasicViewController,UITableViewDataSource,UITableViewDelegate,TaskTableViewCellDelegate,UpdateDelegate,touchDelegate{
    
    var parallelView: ParallelHeaderView!
    var mainTableView: UITableView!
    var createTaskButton: UIButton!
    var settingButton: UIButton!
    var timer: NSTimer!
    
    var remainingTime: NSTimeInterval! = 24*60*60
    
    
    var calendarButton: UIButton!
    var timeTableButton: UIButton!
    var statisticsButton: UIButton!
    
    var colorData:[String] = ["#FFFB887E","#FFF1CB67","#FFAA9DDE","#FF5694CF","#FF5A5A5A","#FFBEFCEF","#FFC6B6A7","#FF25D59B","#FFDA5A68","#FFF5A26F"]
    
    let headerHeight: CGFloat = 240
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var timeChart:TimeChart!
    var timeValue:[CGFloat] = []
    
    var isShowAllCategory:Bool = true
    var category:Category!
    var dayData:[Day] = []
    var taskData:[Task] = []
    
    
    
    func needToUpdate(){
        
        loadDayData()
        updateText()
    }
    
    func updateText(){
        
        let dateForm = NSDateFormatter()
        dateForm.dateFormat = "yyyy.MM.dd"
        parallelView.dateLabel.text = dateForm.stringFromDate(NSDate())
        parallelView.studyTimeLabel.text = getTotalTimeStringOfToday()
        parallelView.completionRateLabel.text = getTotalPercentStringOfToday()
    }
    
    func showAllCategory(){
        
        self.titleLabel.text = "Todait"
        
        timeChart.chartColor = UIColor.todaitGreen()
        timeChart.updateChart(timeValue)
        parallelView.backgroundColor = UIColor.todaitGreen()
        
        let backgroundImage = UIImage.colorImage(UIColor.todaitGreen(), frame: CGRectMake(0, 0, 50*ratio, 50*ratio))
        createTaskButton.setBackgroundImage(backgroundImage, forState: UIControlState.Normal);
        
        isShowAllCategory = true
        todaitNavBar.setBackgroundImage(UIImage.colorImage(UIColor.todaitGreen(),frame:CGRectMake(0,0,width,navigationHeight)), forBarMetrics: UIBarMetrics.Default)
        
        loadDayData()
        updateText()
        
    }
    
    func showCategory(category:Category){
        
        self.category = category
        isShowAllCategory = false
        self.titleLabel.text = category.name
        
        let categoryColor = UIColor.colorWithHexString(category.color)
        
        timeChart.chartColor = categoryColor
        timeChart.updateChart(timeValue)
        parallelView.backgroundColor = categoryColor
        
        
        let backgroundImage = UIImage.colorImage(categoryColor, frame: CGRectMake(0, 0, 50*ratio, 50*ratio))
        createTaskButton.setBackgroundImage(backgroundImage, forState: UIControlState.Normal);

        
        todaitNavBar.setBackgroundImage(UIImage.colorImage(categoryColor,frame:CGRectMake(0,0,width,navigationHeight)), forBarMetrics: UIBarMetrics.Default)
        
        
        loadDayData()
        updateText()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clearColor()
        
        addParallelView()
        addMainTableView()
        addTaskButton()
        
        
        setupTimer()
        timerStart()
        calculateRemainingTime()
        setupCoreDataInit()
        loadDayData()
        
        
        
    }
    
    
    
    func addParallelView(){
        parallelView = ParallelHeaderView(frame: CGRectMake(0, 0, width, headerHeight*ratio))
        parallelView.backgroundColor = UIColor.colorWithHexString("#00D2B1")
        
        
        
        
        for index in 0...41 {
            timeValue.append(CGFloat(rand()%100))
        }
        
        timeChart = TimeChart(frame:CGRectMake(15*ratio, 180*ratio, 290*ratio, headerHeight*ratio-210*ratio))
        timeChart.chartColor = UIColor.todaitGreen()
        timeChart.chartWidth = 2.5*ratio
        timeChart.updateChart(timeValue)
        timeChart.delegate = self
        parallelView.addSubview(timeChart)
        
        
        let timeXAxis = TimeXAxis(frame:CGRectMake(15*ratio,215*ratio,290*ratio,20*ratio))
        timeXAxis.backgroundColor = UIColor.clearColor()
        parallelView.addSubview(timeXAxis)
        
    }
    
    func getMainAmountLogData()->[CGFloat]{
        
        
        
        let dayCount = dayData.count
        
        for index in 0 ... dayCount {
            
            if dayCount-1 == index {
                break
            }
            
        }
        
        return [1]
    }
    
    func touchBegin() {
        
        
        if self.revealViewController() != nil {
            view.removeGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        mainTableView.scrollEnabled = false
    }
    
    func touchEnd() {
        
        if self.revealViewController() != nil {
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        mainTableView.scrollEnabled = true
    }
    
    func addMainTableView(){
        
        mainTableView = UITableView(frame: CGRectMake(0,navigationHeight*ratio,width,height - navigationHeight*ratio), style: UITableViewStyle.Grouped)
        mainTableView.registerClass(TaskTableViewCell.self, forCellReuseIdentifier: "cell")
        mainTableView.contentInset = UIEdgeInsetsMake(-20*ratio, 0, 0, 0)
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.contentOffset.y = 0
        view.addSubview(mainTableView)
        
    }
    
    func addTaskButton(){
        
        
        let backgroundImage = UIImage.colorImage(UIColor.colorWithHexString("#00D2B1"), frame: CGRectMake(0, 0, 50*ratio, 50*ratio))
        
        createTaskButton = UIButton(frame: CGRectMake(135*ratio,height-100*ratio, 50*ratio, 50*ratio))
        createTaskButton.setBackgroundImage(backgroundImage, forState: UIControlState.Normal);
        createTaskButton.setTitle("+", forState: UIControlState.Normal)
        createTaskButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        createTaskButton.titleLabel?.font = UIFont(name: "AvenirNext-UltraLight", size: 30*ratio)
        createTaskButton.clipsToBounds = true
        createTaskButton.layer.cornerRadius = 25*ratio
        createTaskButton.addTarget(self, action: Selector("showNewTaskVC"), forControlEvents: UIControlEvents.TouchUpInside)
        
        view.addSubview(createTaskButton)
    }
    
    
    func addCalendarButton(){
        calendarButton = UIButton(frame: CGRectMake(15*ratio, 525*ratio, 30*ratio, 30*ratio))
        calendarButton.backgroundColor = UIColor.colorWithHexString("#AA9DDE")
        calendarButton.addTarget(self, action: Selector("showCalendarVC"), forControlEvents: UIControlEvents.TouchDown)
        calendarButton.clipsToBounds = true
        calendarButton.layer.cornerRadius = 4*ratio
        view.addSubview(calendarButton)
        
    }
    
    func addTimeTableButton(){
        timeTableButton = UIButton(frame: CGRectMake(50*ratio, 525*ratio, 30*ratio, 30*ratio))
        timeTableButton.backgroundColor = UIColor.colorWithHexString("#FB887E")
        timeTableButton.addTarget(self, action: Selector("showTimeTableVC"), forControlEvents: UIControlEvents.TouchDown)
        timeTableButton.clipsToBounds = true
        timeTableButton.layer.cornerRadius = 4*ratio
        
        view.addSubview(timeTableButton)
        
    }
    
    func addStatisticsButton(){
        
        statisticsButton = UIButton(frame: CGRectMake(85*ratio, 525*ratio, 30*ratio, 30*ratio))
        statisticsButton.backgroundColor = UIColor.colorWithHexString("#5694CF")
        statisticsButton.addTarget(self, action: Selector("showStatisticsVC"), forControlEvents: UIControlEvents.TouchDown)
        statisticsButton.clipsToBounds = true
        statisticsButton.layer.cornerRadius = 4*ratio
        
        view.addSubview(statisticsButton)
        
    }
    
    func showCalendarVC(){
        self.navigationController?.pushViewController(CalendarViewController(), animated: true)
    }
    
    func showTimeTableVC(){
        self.navigationController?.pushViewController(TimeTableViewController(), animated: true)
    }
    
    
    func showStatisticsVC(){
        self.navigationController?.pushViewController(StatisticsViewController(),animated:true)
        //performSegueWithIdentifier("ShowStatisticsView", sender: self)
        
    }
    
    func setupTimer(){
        //currentTime = 0
        //totalTime = 0
    }
    
    func timerStart(){
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("countDown"), userInfo: nil, repeats: true)
        countDown()
    }
    
    func countDown(){
        
        if remainingTime > 0{
            remainingTime = remainingTime - 1
        }else{
            calculateRemainingTime()
        }
        
        updateTimeLabel()
        
    }
    
    func stopTimer(){
        timer.invalidate()
    }
    
    func updateTimeLabel(){
        parallelView.remainingTimeLabel.text = "오늘 남은 시간 \(getTimeStringFromSeconds(remainingTime))"
    }
    
    func getTimeStringFromSeconds(seconds : NSTimeInterval ) -> String {
        
        
        let remainder : Int = Int(seconds % 3600 )
        let hour : Int = Int(seconds / 3600)
        let minute : Int = Int(remainder / 60)
        let second : Int = Int(remainder % 60)
        
        return String(format:  "%02lu:%02lu:%02lu", arguments: [hour,minute,second])
    }
    
    func calculateRemainingTime(){
        
        var calendar : NSCalendar! = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        calendar.locale = NSLocale.currentLocale()
        
        var nowDateComp = calendar.components(NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitHour | NSCalendarUnit.CalendarUnitMinute | NSCalendarUnit.CalendarUnitSecond, fromDate: NSDate())
        
        remainingTime = calculateSecondsFromNowToLimit(nowDateComp)
    }
    
    
    func calculateSecondsFromNowToLimit(nowDateComp : NSDateComponents) -> NSTimeInterval{
        
        var finishHour = defaults.integerForKey("finishHourOfDay")
        var finishMinute = defaults.integerForKey("finishMinuteOfDay")
        
        if finishHour < 12 || finishHour < nowDateComp.hour{
            finishHour = finishHour + 24
        }
        
        
        return 3600 * (NSTimeInterval(finishHour)-NSTimeInterval(nowDateComp.hour)) + 60 * (NSTimeInterval(finishMinute)-NSTimeInterval(nowDateComp.minute)) - (NSTimeInterval(nowDateComp.second))
    }
    
    
    func setupCoreDataInit(){
        
        let entityDescription = NSEntityDescription.entityForName("Category", inManagedObjectContext: managedObjectContext!)
        let request = NSFetchRequest()
        request.entity = entityDescription
        var error: NSError?
        var results = managedObjectContext?.executeFetchRequest(request, error: &error)
        
        if results?.count == 0 {
            //기본 카테고리를 생성한다.
            makeDefaultCategory()
            setupInitValue()
        }
        
        
    }
    
    func makeDefaultCategory(){
        
        let entityDescription = NSEntityDescription.entityForName("Category", inManagedObjectContext:managedObjectContext!)
        
        let category = Category(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
        category.name = "Todait"
        category.created_at = NSDate()
        category.color = "#FFFB887E"
        category.updated_at = NSDate()
        category.dirty_flag = 0
        
        var error: NSError?
        managedObjectContext?.save(&error)
        
        if let err = error {
            //에러처리
        }else{
            NSLog("Category Default 저장성공",1)
        }
        
    }
    
    func setupInitValue(){
        
        defaults.setInteger(1, forKey: "sortIndex")
        defaults.setInteger(1, forKey: "showIndex")
        
    }
    
    func loadDayData(){
        
        loadTaskData()
        
        
        dayData.removeAll(keepCapacity: true)
        
        let todayDateNumber = getTodayDateNumber()
        for task in taskData {
            
            let day:Day? = task.getDay(todayDateNumber)
            
            if let validDay = day {
                dayData.append(day!)
            }
        }
        
        
        mainTableView.reloadData()
    }
    
    
    
    
    
    func loadTaskData(){
        let entityDescription = NSEntityDescription.entityForName("Task",inManagedObjectContext:managedObjectContext!)
        
        let sortIndex = defaults.integerForKey("sortIndex")
        
        let request = NSFetchRequest()
        request.entity = entityDescription
        
        if sortIndex == 2 {
            request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        }else if sortIndex == 4 {
            request.sortDescriptors = [NSSortDescriptor(key: "category_id", ascending: true)]
        }
        
        if isShowAllCategory == false {
            
            let predicate = NSPredicate(format: "category_id == %@",category)
            request.predicate = predicate
        }
        
        var error: NSError?
        taskData = managedObjectContext?.executeFetchRequest(request, error: &error) as! [Task]
        
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        addSettingBtn()
        addCalendarButton()
        addTimeTableButton()
        addStatisticsButton()
        
        titleLabel.text = "Todait"
        mainTableView.contentOffset.y = 0
        parallelView.scrollViewDidScroll(mainTableView)
        calculateRemainingTime()
        
        self.screenName = "Main Activity"
        
        //needToUpdate()
        
        if isShowAllCategory == true {
            showAllCategory()
        }else{
            showCategory(category)
        }
        
        
        if self.revealViewController() != nil {
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
    }
    
    func addSettingBtn(){
        settingButton = UIButton(frame: CGRectMake(288*ratio, 30*ratio, 24*ratio, 24*ratio))
        settingButton.setImage(UIImage(named: "setting@2x.png"), forState: UIControlState.Normal)
        settingButton.addTarget(self, action: Selector("setting"), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(settingButton)
    }
    
    func setting(){
        
        self.navigationController?.pushViewController(SettingViewController(), animated: true)
    }
    
    
    
    func showNewTaskVC(){
        
        let newTaskVC = NewTaskViewController()
        newTaskVC.delegate = self
        //self.navigationController?.pushViewController(newTaskVC, animated: true)
        
        performSegueWithIdentifier("ShowNewTaskView", sender: self)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //let destination = segue.destinationViewController as! NewTaskViewController
        
        
        
        
        if segue.identifier == "ShowTimerView" {
            let timerVC = segue.destinationViewController as! TimerViewController
            let indexPath:NSIndexPath! = sender as! NSIndexPath
            
            let task:Task = taskData[indexPath.row]
            let day:Day! = task.getDay(getTodayDateNumber())
            timerVC.task = task
            timerVC.day = day
            
            //timerVC.task =
            
        }else if segue.identifier == "ShowNewTaskView" {
            let newTaskVC = segue.destinationViewController as! NewTaskViewController
            newTaskVC.delegate = self
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskData.count
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return parallelView
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TaskTableViewCell
        cell.delegate = self
        cell.indexPath = indexPath
        cell.percentLayer.strokeEnd = 0
        cell.percentLayer.strokeColor = UIColor.todaitLightGray().CGColor
        cell.percentLabel.textColor = UIColor.todaitLightGray()
        
        let task:Task! = taskData[indexPath.row]
        
        NSLog("%@",task.category_id.name)
        
        let day:Day! = task.getDay(getTodayDateNumber())
        
        
        cell.titleLabel.text = task.name
        
        if let isDayValid = day {
            
            cell.contentsLabel.text = day.getProgressString()
            cell.percentLabel.text = String(format: "%lu%@", Int(day.done_amount.floatValue/day.expect_amount.floatValue * 100),"%")
            cell.percentLayer.strokeColor = day.getColor().CGColor
            cell.percentLayer.strokeEnd = CGFloat(day.done_amount.floatValue/day.expect_amount.floatValue)
            cell.percentLabel.textColor = day.getColor()
            //cell.colorBoxView.backgroundColor = UIColor.colorWithHexString(task.category_id.color)
        }else{
            
            cell.contentsLabel.text = "공부 시작 전입니다"
        }
        
        
        return cell
    }
    
    func timerButtonClk(indexPath:NSIndexPath) {
        performSegueWithIdentifier("ShowTimerView", sender:indexPath)
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight * ratio
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50*ratio
    }
    
    // ScrollView
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        var newFrame = parallelView.frame
        if (scrollView.contentOffset.y > 0){
            parallelView.scrollViewDidScroll(scrollView)
        }else{
            scrollView.contentOffset.y = 0
        }
        
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        parallelView.scrollViewDidScroll(scrollView)
        calculateRemainingTime()
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        let detailVC = DetailViewController()
        
        detailVC.task = taskData[indexPath.row]
        //detailVC.day = taskData[indexPath.row].getDay(getTodayDateNumber())
        
        
        
        self.navigationController?.pushViewController(detailVC, animated:true)
        
        tableView.reloadData()
        
        return false
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        
        let category = taskData[indexPath.row]
        managedObjectContext?.deleteObject(category)
        
        var error:NSError?
        managedObjectContext?.save(&error)
        
        if error == nil {
            NSLog("Task 삭제완료",0)
            
            
            taskData.removeAtIndex(indexPath.row)
            
            tableView.beginUpdates()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation:UITableViewRowAnimation.Automatic)
            tableView.endUpdates()
            
        }else {
            //삭제에러처리
            
        }
    }
    
    func max<T : Comparable>(x: T, y:T) ->T{
        if x > y {
            return x
        }else{
            return y
        }
    }
    
    func getTotalTimeStringOfToday()->String{
        
        var totalSecond:Int = 0
        
        for dayItem in dayData{
            let day:Day! = dayItem
            totalSecond = totalSecond + Int(day.done_second)
            
        }
        
        return getTimeStringFromSeconds(NSTimeInterval(totalSecond))
        
    }
    
    func getTotalPercentStringOfToday()->String{
        
        var completeCount = 0
        
        
        for dayItem in dayData{
            let day:Day! = dayItem
            
            completeCount = completeCount + Int(day.done_amount.floatValue/day.expect_amount.floatValue * 100)
        }
        
        if dayData.count == 0 {
            return "0%"
        }
        
        return "\(completeCount/dayData.count)%"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
