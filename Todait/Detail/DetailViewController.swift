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

class DetailViewController: BasicViewController,TodaitNavigationDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,CategoryUpdateDelegate,CalendarDelegate,TimeLogDelegate{
    
    
    private var headerView:DetailHeaderView!
    var weekCalendarVC:DetailWeekCalendarViewController!
    
    var detailTableView: UITableView!
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        
        selectedDateNumber = getDateNumberFromDate(NSDate())
        
        setupDay()
        addHeaderView()
        addDetailTable()
        
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
        
        headerView = DetailHeaderView(frame: CGRectMake(0, 0, width, 215*ratio))
        headerView.dateLabel.text = task.getStringOfPeriodProgress()
        headerView.timeLabel.text = task.getDoneTimeString()
        headerView.amountLabel.text = task.getDoneAmountString()
        headerView.categoryLabel.text = task.category_id.name
        headerView.categoryCircle.backgroundColor = task.getColor()
        view.addSubview(headerView)
        
    }
    
    
        
    func addDetailTable(){
        detailTableView = UITableView(frame: CGRectMake(0,215*ratio,width,height-215*ratio), style: UITableViewStyle.Grouped)
        detailTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        detailTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        detailTableView.delegate = self
        detailTableView.dataSource = self
        detailTableView.contentOffset.y = 0
        detailTableView.sectionFooterHeight = 0
        detailTableView.backgroundColor = UIColor.colorWithHexString("#EFEFEF")
        detailTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        view.addSubview(detailTableView)
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return 104*ratio
        }else{
            return 70*ratio
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 116*ratio
        }else{
            return 58*ratio
        }
        
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
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var headerView = UIView()
        headerView.backgroundColor = UIColor.whiteColor()
        
        
        if section == 0 {
        
            
            
            headerView = UIView(frame: CGRectMake(0, 64, width, 43*ratio))
            headerView.backgroundColor = UIColor.todaitLightGray()
            //view.addSubview(headerView)
            
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
            headerView.addSubview(line)
            
            
            
            
            weekCalendarVC = DetailWeekCalendarViewController()
            addChildViewController(weekCalendarVC)
            weekCalendarVC.view.backgroundColor = UIColor.whiteColor()
            weekCalendarVC.view.frame = CGRectMake(0,43.5*ratio,width,60*ratio)
            weekCalendarVC.dateNumber = selectedDateNumber
            weekCalendarVC.delegate = self
            headerView.addSubview(weekCalendarVC.view)
            headerView.clipsToBounds = true
            
            
            
            
        
        }else if section == 1 {
            
            var memoHeaderLabel = UILabel(frame: CGRectMake(0, 0, width, 24.5*ratio))
            memoHeaderLabel.backgroundColor = UIColor.colorWithHexString("#EFEFEF")
            memoHeaderLabel.textColor = UIColor.todaitGray()
            memoHeaderLabel.textAlignment = NSTextAlignment.Center
            memoHeaderLabel.text = "공부메모"
            memoHeaderLabel.font = UIFont(name: "AvenirNext-Regular", size: 10*ratio)
            headerView.addSubview(memoHeaderLabel)
            
            
            var memoImageView = UIImageView(frame:CGRectMake(18*ratio,39*ratio,16*ratio,16*ratio))
            memoImageView.image = UIImage(named: "ic_fragment_diary_pencil")
            headerView.addSubview(memoImageView)
            
            var memoInfoLabel = UILabel(frame: CGRectMake(37*ratio, 24.5*ratio, 180*ratio, 45.5*ratio))
            memoInfoLabel.textColor = UIColor.todaitGray()
            memoInfoLabel.textAlignment = NSTextAlignment.Left
            memoInfoLabel.text = "공부 일기를 추가하세요."
            memoInfoLabel.font = UIFont(name: "AvenirNext-Regular", size: 12*ratio)
            headerView.addSubview(memoInfoLabel)
            
            
        }
        
    
        
        return headerView
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
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        
        cell.backgroundColor = UIColor.whiteColor()
        
        for view in cell.contentView.subviews{
            view.removeFromSuperview()
        }
        
        
        if indexPath.section == 0 && indexPath.row == 0 {
            
            
            
            var upperLine = UIView(frame:CGRectMake(0,0,width,0.5*ratio))
            upperLine.backgroundColor = UIColor.colorWithHexString("#EFEFEF")
            cell.contentView.addSubview(upperLine)
            
            
            
            var timerButton = UIButton(frame:CGRectMake(50*ratio, 12.5*ratio, 58*ratio, 58*ratio))
            
            timerButton.setBackgroundImage(UIImage(named: "ic_calendar_next.png"), forState: UIControlState.Normal)
            timerButton.clipsToBounds = true
            timerButton.layer.cornerRadius = 29*ratio
            timerButton.layer.borderWidth = 1*ratio
            timerButton.layer.borderColor = UIColor.todaitGray().CGColor
            
            cell.contentView.addSubview(timerButton)
            
            
            
            var timerAimLabel = UILabel(frame:CGRectMake(15*ratio,77*ratio,130*ratio,12*ratio))
            timerAimLabel.text = "목표시간 01:30:00"
            timerAimLabel.font = UIFont(name: "AppleSDGothicNeo-Light", size: 10*ratio)
            timerAimLabel.textAlignment = NSTextAlignment.Center
            timerAimLabel.textColor = UIColor.todaitGray()
            cell.contentView.addSubview(timerAimLabel)
            
            
            var timerLabel = UILabel(frame:CGRectMake(15*ratio,89*ratio,130*ratio,22*ratio))
            timerLabel.text = "00:00:00"
            timerLabel.font = UIFont(name: "AppleSDGothicNeo-Light",size:20*ratio)
            timerLabel.textAlignment = NSTextAlignment.Center
            timerLabel.textColor = UIColor.todaitOrange()
            cell.contentView.addSubview(timerLabel)
            
            
            
            var timeLogButton = UIButton(frame: CGRectMake(15*ratio, 70*ratio, 130*ratio, 45*ratio))
            timeLogButton.backgroundColor = UIColor.clearColor()
            timeLogButton.addTarget(self, action: Selector("timeButtonClk"), forControlEvents: UIControlEvents.TouchDown)
            cell.contentView.addSubview(timeLogButton)
            
            
            
            var middleLine = UIView(frame:CGRectMake(159.75*ratio,0,0.5*ratio,115*ratio))
            middleLine.backgroundColor = UIColor.colorWithHexString("#EFEFEF")
            cell.contentView.addSubview(middleLine)
            
            var circleChart = CircleChart(frame: CGRectMake(210*ratio, 12.5*ratio, 58*ratio, 58*ratio))
            circleChart.circleColor = UIColor.todaitOrange()
            circleChart.updatePercent(progressPercent)
            circleChart.percentLabel.frame = CGRectMake(5*ratio,5*ratio,48*ratio,48*ratio)
            circleChart.percentLabel.font = UIFont(name: "AppleSDGothicNeo-Light",size: 25*ratio)
            circleChart.percentLabel.adjustsFontSizeToFitWidth = true
            
            cell.contentView.addSubview(circleChart)
            
            
            var background:UIImage = UIImage(named: "graph_bg.png")!
            var maskLayer:CALayer = CALayer()
            maskLayer.contents = background.CGImage
            maskLayer.frame = CGRectMake(0,0,58*ratio,58*ratio)
            maskLayer.mask = circleChart.percentLayer
            circleChart.layer.addSublayer(maskLayer)
            
            var amountTextView = AmountTextView(frame: CGRectMake(175*ratio,74*ratio, 130*ratio, 25*ratio))
            amountTextView.setupText(day.done_amount.integerValue, total: day.expect_amount.integerValue, unit: task.unit)
            cell.contentView.addSubview(amountTextView)
            
            
            var amountInputButton = UIButton(frame:CGRectMake(160*ratio, 0*ratio, 160*ratio, 115*ratio))
            amountInputButton.backgroundColor = UIColor.clearColor()
            amountInputButton.addTarget(self, action: Selector("showAmountInputVC"), forControlEvents: UIControlEvents.TouchDown)
            cell.contentView.addSubview(amountInputButton)
            
        }
        
        return cell
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
        timeLog.after_second = day.done_second.integerValue + Int(time)
        timeLog.done_second = Int(time)
        timeLog.created_at = NSDate()
        timeLog.updated_at = NSDate()
        
        var error: NSError?
        managedObjectContext?.save(&error)
        
        
        refreshView()
    }
    
    func refreshView(){
        
        detailTableView.reloadData()
        
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
    
    
    func showAmountInputVC(){
        
        var amountInputVC = AmountInputViewController()
        amountInputVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        
        self.navigationController?.presentViewController(amountInputVC, animated: false, completion: { () -> Void in
            
        })
        
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ShowEditTaskView" {
            
            let editTaskVC = segue.destinationViewController as! EditTaskViewController
            editTaskVC.editedTask = task
            editTaskVC.delegate = self
            editTaskVC.mainColor = task.getColor()
            editTaskVC.category = task.category_id
            
        }
    }
    
    
    func updateCategory(category:Category,from:String){
        
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
