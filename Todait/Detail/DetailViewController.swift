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

class DetailViewController: BasicViewController,TodaitNavigationDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,CategoryUpdateDelegate{
    
    
    private var headerView:DetailHeaderView!
    
    
    var detailTableView: UITableView!
    var task:Task!
    var day:Day!
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    
    var progressPercent:NSNumber!
    var progressString:String!
    var timeValue:[CGFloat]! = []
    var doneCountEnabled:Bool! = true
    
    var editButton:UIButton!
    var graphButton:UIButton!
    
    
    var weekCalendarVC:WeekCalendarViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        
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
        
            var memoHeaderLabel = UILabel(frame: CGRectMake(0, 0, width, 24.5*ratio))
            memoHeaderLabel.backgroundColor = UIColor.colorWithHexString("#EFEFEF")
            memoHeaderLabel.textColor = UIColor.todaitGray()
            memoHeaderLabel.textAlignment = NSTextAlignment.Center
            memoHeaderLabel.text = "2015.06"
            memoHeaderLabel.font = UIFont(name: "AvenirNext-Regular", size: 10*ratio)
            headerView.addSubview(memoHeaderLabel)
            
            
            
            weekCalendarVC = WeekCalendarViewController()
            addChildViewController(weekCalendarVC)
            weekCalendarVC.view.backgroundColor = UIColor.whiteColor()
            weekCalendarVC.view.frame = CGRectMake(0,24.5*ratio,width,48*ratio)
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
            
            
        }
        
        return cell
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
