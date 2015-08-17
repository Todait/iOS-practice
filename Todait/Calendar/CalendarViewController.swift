//
//  CalendarViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 3..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class CalendarViewController: BasicViewController,UITableViewDataSource,UITableViewDelegate,TodaitNavigationDelegate,CalendarDayDelegate{
    
    var calendarTableView: UITableView!
    let weekName:[String] = ["일","월","화","수","목","금","토"]
    
    var calendar:NSCalendar!
    var dayLabel:UILabel!
    var currentIndexPath:NSIndexPath!
    
    var taskTableVC:TaskTableViewController!
    //let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCalendar()
        addDayLabel()
        addWeekLabels()
        addCalendarTableView()
        addTaskTableView()
        
        view.backgroundColor = UIColor.colorWithHexString("#00D2B1")
    }
    
    func setupCalendar(){
        calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
    }
    
    func addDayLabel(){
        dayLabel = UILabel(frame: CGRectMake(0,navigationHeight*ratio,width,22*ratio))
        dayLabel.textAlignment = NSTextAlignment.Center
        dayLabel.text = "2015. 06"
        dayLabel.font = UIFont(name:"AppleSDGothicNeo-Regular", size: 16*ratio)
        dayLabel.textColor = UIColor.whiteColor()
        view.addSubview(dayLabel)
    }
    
    func addWeekLabels(){
        
        
        for index in 0...6 {
            
            let labelWidth = width / 7
            let originX = CGFloat(index) * labelWidth
            let originY = navigationHeight*ratio + 22*ratio
            let weekLabel = UILabel(frame: CGRectMake(originX,originY,labelWidth, 22*ratio))
            weekLabel.text = weekName[index]
            weekLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 10*ratio)
            weekLabel.textAlignment = NSTextAlignment.Center
            weekLabel.textColor = UIColor.whiteColor()
            view.addSubview(weekLabel)
            
        }
    }
    
    func addCalendarTableView(){
        
        calendarTableView = UITableView(frame: CGRectMake(0,navigationHeight*ratio+44*ratio,width,340*ratio), style: UITableViewStyle.Grouped)
        calendarTableView.registerClass(CalendarTableViewCell.self, forCellReuseIdentifier: "cell")
        calendarTableView.contentInset = UIEdgeInsetsMake(-20*ratio, 0, 0, 0)
        calendarTableView.delegate = self
        calendarTableView.dataSource = self
        calendarTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        view.addSubview(calendarTableView)
        
        
        
    }
    
    
    func addTaskTableView(){
        
        taskTableVC = TaskTableViewController()
        addChildViewController(taskTableVC)
        
        taskTableVC.view.frame = CGRectMake(0,453*ratio,width,height-458*ratio)
        taskTableVC.taskResults = getTaskData(getTodayDateNumber())
        
        view.addSubview(taskTableVC.view)
        
        
    }
    
    func getTaskData(dateNumber:NSNumber)->Results<Task>{
        
        //클릭된 날의 Task
        
        var taskData:[Task] = []
        
        /*
        let entityDescription = NSEntityDescription.entityForName("Task",inManagedObjectContext:managedObjectContext!)
        
        let predicate:NSPredicate = NSPredicate(format: "start_date <= %@ && %@ <= end_date", dateNumber,dateNumber)
        
        let request = NSFetchRequest()
        request.entity = entityDescription
        request.predicate = predicate
        
        var error: NSError?
        taskData = managedObjectContext?.executeFetchRequest(request, error: &error) as! [Task]
        
        */
        
        let predicate:NSPredicate = NSPredicate(format: "startDate <= %@ && %@ <= endDate", dateNumber,dateNumber)
        
        var taskResults = realm.objects(Task).filter(predicate)
        
        return taskResults
    }
    
    func daySelected(dateNumber:NSNumber){
        
        taskTableVC.taskResults = getTaskData(dateNumber)
        taskTableVC.tableView.reloadData()
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1000
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let dateComponents = calendar.components(NSCalendarUnit.CalendarUnitYear|NSCalendarUnit.CalendarUnitMonth|NSCalendarUnit.CalendarUnitDay, fromDate:NSDate())
        dateComponents.month = dateComponents.month + indexPath.row - 500
        //dateComponents.day = 1
        let mainDate:NSDate! = NSCalendar.currentCalendar().dateFromComponents(dateComponents)
        
        
        let firstDate:NSDate! = getFirstDate(mainDate)
        let lastDate:NSDate! = getLastDate(mainDate)
        
        let weekCount:Int = getWeekCount(mainDate)
        
        
        
        return CGFloat(50*weekCount)*ratio + 30*ratio
    }
    
    func getWeekCount(date:NSDate)->Int{
        
        let firstDate = getFirstDate(date)
        let firstDayOfWeek = getStartIndexFromDate(firstDate)
        let lastDate = getLastDate(date)
        let lastDay = getLastDateDay(lastDate)
        
        var weekCount =  Int((firstDayOfWeek + lastDay - 1)/7)
        let weekRemainder = (firstDayOfWeek + lastDay - 1)%7
        if weekRemainder != 0 {
            weekCount = weekCount + 1
        }
        
        return weekCount
    }
    
    
    func getFirstDate(date:NSDate)->NSDate{
        
        let firstDayOfMonthComp = calendar.components(NSCalendarUnit.CalendarUnitYear|NSCalendarUnit.CalendarUnitMonth|NSCalendarUnit.CalendarUnitDay|NSCalendarUnit.CalendarUnitWeekday, fromDate:date)
        firstDayOfMonthComp.day = 1
        let firstDate:NSDate = calendar.dateFromComponents(firstDayOfMonthComp)!
        
        return firstDate
    }
    
    func getLastDate(date:NSDate)->NSDate{
        let lastDayOfMonthComp = calendar.components(NSCalendarUnit.CalendarUnitYear|NSCalendarUnit.CalendarUnitMonth|NSCalendarUnit.CalendarUnitDay, fromDate:date)
        lastDayOfMonthComp.month = lastDayOfMonthComp.month+1
        lastDayOfMonthComp.day = 0
        
        let lastDate:NSDate = calendar.dateFromComponents(lastDayOfMonthComp)!
        
        return lastDate
    }
    
    func getStartIndexFromDate(firstDate:NSDate)->Int{
        
        let firstDayOfWeek = getDayOfWeek(firstDate)
        
        return firstDayOfWeek % 7
    }
    
    func getDayOfWeek(date:NSDate)->Int{
        
        let dayOfWeek = calendar.components(NSCalendarUnit.CalendarUnitWeekday, fromDate:date)
        
        return dayOfWeek.weekday
    }
    
    
    func getLastDateDay(lastDate:NSDate)->Int{
        
        let dayComp = calendar.components(NSCalendarUnit.CalendarUnitDay, fromDate:lastDate)
        
        return dayComp.day
        
    }
    
    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        
        if indexPath.row != currentIndexPath.row {
            
            let dateComponents = calendar.components(NSCalendarUnit.CalendarUnitYear|NSCalendarUnit.CalendarUnitMonth, fromDate:NSDate())
            dateComponents.month = dateComponents.month + currentIndexPath.row - 500
            let mainDate:NSDate! = NSCalendar.currentCalendar().dateFromComponents(dateComponents)
            
            let dateForm = NSDateFormatter()
            dateForm.dateFormat = "YYYY. MM"
            dayLabel.text = dateForm.stringFromDate(mainDate)
            
            
        }else{
            
            let cell = tableView.visibleCells().first as! UITableViewCell
            let path = tableView.indexPathForCell(cell)!
            
            let dateComponents = calendar.components(NSCalendarUnit.CalendarUnitYear|NSCalendarUnit.CalendarUnitMonth, fromDate:NSDate())
            dateComponents.month = dateComponents.month + path.row - 500
            let mainDate:NSDate! = NSCalendar.currentCalendar().dateFromComponents(dateComponents)
            
            let dateForm = NSDateFormatter()
            dateForm.dateFormat = "YYYY. MM"
            dayLabel.text = dateForm.stringFromDate(mainDate)
        }
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CalendarTableViewCell
        cell.delegate = self
        
        currentIndexPath = indexPath
        
        NSLog("%f", cell.frame.size.height)
        
        let dateComponents = calendar.components(NSCalendarUnit.CalendarUnitYear|NSCalendarUnit.CalendarUnitMonth, fromDate:NSDate())
        dateComponents.month = dateComponents.month + indexPath.row - 500
        let mainDate:NSDate! = NSCalendar.currentCalendar().dateFromComponents(dateComponents)
        
        
        cell.setupDate(mainDate)
        
        let dateForm = NSDateFormatter()
        dateForm.dateFormat = "YYYY. MM"
        dayLabel.text = dateForm.stringFromDate(mainDate)
        
        let monthForm = NSDateFormatter()
        monthForm.dateFormat = "MMMMM"
        cell.monthDateLabel.text = monthForm.stringFromDate(mainDate)
        
        return cell
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    func calculateDayCellFrame(date:NSDate)->CGRect {
        
        
        
        return CGRectMake(0, 0, width/7, 70)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        todaitNavBar.todaitDelegate = self
        todaitNavBar.backButton.hidden = false
        todaitNavBar.shadowImage = UIImage()
        self.titleLabel.text = "Calendar"
        self.screenName = "Calendar Activity"
        
        
        calendarTableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 500, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: false)
        
        
        //let currentCell = calendarTableView.cellForRowAtIndexPath(NSIndexPath(forRow: 500, inSection: 0)) as! CalendarTableViewCell
        
        
        //calendarTableView.contentOffset.y = currentCell.frame.origin.y
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func backButtonClk() {
        self.navigationController?.popViewControllerAnimated(true)
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
