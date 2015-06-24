//
//  DetailViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 2..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: BasicViewController,TodaitNavigationDelegate,UITableViewDelegate,UITableViewDataSource,touchDelegate,UIScrollViewDelegate,CategoryUpdateDelegate{
   
    var detailTableView: UITableView!
    var task:Task!
    var day:Day!
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    
    var c1:UIView!
    var c2:UIView!
    var c3:UIView!
    var c4:UIView!
    
    var progressPercent:NSNumber!
    var progressString:String!
    var timeValue:[CGFloat]! = []
    var doneCountEnabled:Bool! = true
    var editButton:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        
        setupDay()
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
    
    func addDetailTable(){
        detailTableView = UITableView(frame: CGRectMake(0,0,width,height), style: UITableViewStyle.Grouped)
        detailTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        detailTableView.contentInset = UIEdgeInsetsMake(-20*ratio, 0, 0, 0)
        detailTableView.delegate = self
        detailTableView.dataSource = self
        detailTableView.contentOffset.y = 0
        detailTableView.backgroundColor = UIColor.colorWithHexString("#FEFEFE")
        detailTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        view.addSubview(detailTableView)
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0*ratio
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        
        switch indexPath.row {
            case 0: return 150*ratio
            case 1: return 220*ratio
            case 2: return 180*ratio
            default: return 200*ratio
        }
        
        
        return 80*ratio
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        if doneCountEnabled == true {
            addDoneAmount()
        }
        
        return false
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        
        cell.backgroundColor = UIColor.todaitLightGray()
        
        for view in cell.contentView.subviews{
            view.removeFromSuperview()
        }
        
        if indexPath.row == 0 {
            
            
            let imageView = UIImageView(frame: CGRectMake(0, 0, width, 140*ratio))
            imageView.image = UIImage(named: "2.jpg")
            cell.contentView.addSubview(imageView)
        
        
            
            let dayLabel = UILabel(frame: CGRectMake(30*ratio, 60*ratio, 130*ratio,20*ratio))
            dayLabel.text = task.getStringOfPeriodProgress()
            dayLabel.font = UIFont(name: "AvenirNext-Regular", size: 13*ratio)
            dayLabel.textColor = UIColor.whiteColor()
            dayLabel.textAlignment = NSTextAlignment.Left
            cell.contentView.addSubview(dayLabel)
            
            
            let timeLabel = UILabel(frame: CGRectMake(190*ratio, 60*ratio, 130*ratio, 20*ratio))
            timeLabel.text = task.getDoneTimeString()
            timeLabel.font = UIFont(name: "AvenirNext-Regular", size: 13*ratio)
            timeLabel.textColor = UIColor.whiteColor()
            timeLabel.textAlignment = NSTextAlignment.Left
            cell.contentView.addSubview(timeLabel)
            
            
            let pageLabel = UILabel(frame: CGRectMake(30*ratio, 90*ratio, 160*ratio, 20*ratio))
            pageLabel.text = task.getDoneAmountString()
            pageLabel.font = UIFont(name: "AvenirNext-Regular", size: 13*ratio)
            pageLabel.textColor = UIColor.whiteColor()
            pageLabel.textAlignment = NSTextAlignment.Left
            cell.contentView.addSubview(pageLabel)
            
            
            let bookNameLabel = UILabel(frame: CGRectMake(190*ratio, 90*ratio, 160*ratio, 20*ratio))
            bookNameLabel.text = task.name
            bookNameLabel.font = UIFont(name: "AvenirNext-Regular", size: 13*ratio)
            bookNameLabel.textColor = UIColor.whiteColor()
            bookNameLabel.textAlignment = NSTextAlignment.Left
            cell.contentView.addSubview(bookNameLabel)
            
        }else if(indexPath.row == 1){
            
            let whiteBox = UIScrollView(frame: CGRectMake(15*ratio, 15*ratio, 290*ratio, 180*ratio))
            whiteBox.backgroundColor = UIColor.whiteColor()
            whiteBox.clipsToBounds = true
            whiteBox.layer.cornerRadius = 4*ratio
            whiteBox.contentSize = CGSizeMake(290*ratio*2,160*ratio)
            whiteBox.delegate = self
            whiteBox.bounces = false
            whiteBox.pagingEnabled = true
            whiteBox.showsHorizontalScrollIndicator = false
            cell.contentView.addSubview(whiteBox)
            
            let infoLabel = UILabel(frame: CGRectMake(30*ratio, 20*ratio, 200*ratio, 30*ratio))
            infoLabel.text = "오늘 진행도"
            infoLabel.textAlignment = NSTextAlignment.Left
            infoLabel.font = UIFont(name: "AvenirNext-Regular", size: 14*ratio)
            infoLabel.textColor = UIColor.colorWithHexString("#969696")
            cell.contentView.addSubview(infoLabel)
            
            
            
            let chart = CircleChart(frame: CGRectMake(230*ratio,30*ratio,50*ratio,50*ratio))
            
            chart.circleColor = task.getColor()
            chart.updatePercent(progressPercent)

            cell.contentView.addSubview(chart)
            
            
            
            let countLabel = UILabel(frame: CGRectMake(125*ratio, 20*ratio, 120*ratio, 30*ratio))
            countLabel.text = progressString
            countLabel.textColor = task.getColor()
            countLabel.textAlignment = NSTextAlignment.Left
            countLabel.font = UIFont(name: "AvenirNext-Regular", size: 18*ratio)
            cell.contentView.addSubview(countLabel)
            
            
            
            
            
            let timeChart = TimeChart(frame:CGRectMake(30*ratio, 90*ratio, 260*ratio, 60*ratio))
            timeChart.chartColor = task.getColor()
            timeChart.chartWidth = 3*ratio
            timeChart.updateChart(timeValue)
            timeChart.delegate = self
            cell.contentView.addSubview(timeChart)
            
            
            let timeXAxis = TimeXAxis(frame:CGRectMake(15*ratio,150*ratio,290*ratio,20*ratio))
            cell.contentView.addSubview(timeXAxis)
            
            
        }else if(indexPath.row == 2){
            
            let whiteBox = UIScrollView(frame: CGRectMake(15*ratio, 15*ratio, 290*ratio, 160*ratio))
            whiteBox.backgroundColor = UIColor.whiteColor()
            whiteBox.clipsToBounds = true
            whiteBox.layer.cornerRadius = 4*ratio
            whiteBox.contentSize = CGSizeMake(290*ratio*2,160*ratio)
            whiteBox.delegate = self
            whiteBox.bounces = false
            whiteBox.pagingEnabled = true
            whiteBox.showsHorizontalScrollIndicator = false
            
            cell.contentView.addSubview(whiteBox)
            
            
            let chart = BarChart(frame: CGRectMake(0, 0, 200*ratio, 30*ratio))
            cell.contentView.addSubview(chart)
            
            
            let infoLabel = UILabel(frame: CGRectMake(30*ratio, 20*ratio, 200*ratio, 30*ratio))
            infoLabel.text = "주간 진행도"
            infoLabel.textAlignment = NSTextAlignment.Left
            infoLabel.font = UIFont(name: "AvenirNext-Regular", size: 14*ratio)
            infoLabel.textColor = UIColor.colorWithHexString("#969696")
            cell.contentView.addSubview(infoLabel)
            
            
            
            
            let doneAmountList:[CGFloat] = task.getWeekDayDoneAmount(NSDate()) as! [CGFloat]
            
            let weekChart = WeekChart(frame: CGRectMake(15*ratio, 35*ratio, 260*ratio, 70*ratio))
            weekChart.direction = weekChartDirection.upDirection
            weekChart.chartColor = task.getColor()
            weekChart.chartWidth = 25*ratio
            whiteBox.addSubview(weekChart)
            weekChart.updateChart(doneAmountList)
            
            
            
            let timerWeekChart = WeekChart(frame: CGRectMake(305*ratio, 35*ratio, 260*ratio, 70*ratio))
            timerWeekChart.direction = weekChartDirection.upDirection
            timerWeekChart.chartColor = task.getColor()
            timerWeekChart.chartWidth = 25*ratio
            whiteBox.addSubview(timerWeekChart)
            timerWeekChart.updateChart(doneAmountList)
            
            
            
            let weekLabelString:[String] = task.getWeekDateNumberString(NSDate())
            let weekLabel = WeekLabel(frame:CGRectMake(30*ratio, 90*ratio, 260*ratio, 100*ratio))
            weekLabel.weekColor = UIColor.colorWithHexString("#969696")
            weekLabel.weekFont = UIFont(name: "AvenirNext-Regular", size: 8*ratio)
            weekLabel.updateLabelText(weekLabelString)
            weekLabel.userInteractionEnabled = false
            cell.contentView.addSubview(weekLabel)
            
            
            
            c3 = UIView(frame:CGRectMake(146*ratio, 155*ratio, 10*ratio, 10*ratio))
            c3.backgroundColor = task.getColor()
            c3.clipsToBounds = true
            c3.layer.cornerRadius = 5*ratio
            cell.contentView.addSubview(c3)
            
            
            
            c4 = UIView(frame:CGRectMake(164*ratio, 155*ratio, 10*ratio, 10*ratio))
            c4.backgroundColor = UIColor.todaitLightGray()
            c4.clipsToBounds = true
            c4.layer.cornerRadius = 5*ratio
            cell.contentView.addSubview(c4)
            
        }else if(indexPath.row == 3){
            
            
            let whiteBox = UIView(frame: CGRectMake(15*ratio, 15*ratio, 290*ratio, 150*ratio))
            whiteBox.backgroundColor = UIColor.whiteColor()
            whiteBox.clipsToBounds = true
            whiteBox.layer.cornerRadius = 4*ratio
            cell.contentView.addSubview(whiteBox)
            
            
            let infoLabel = UILabel(frame: CGRectMake(30*ratio, 20*ratio, 200*ratio, 30*ratio))
            infoLabel.text = "전체 진행도"
            infoLabel.textAlignment = NSTextAlignment.Left
            infoLabel.font = UIFont(name: "AvenirNext-Regular", size: 14*ratio)
            infoLabel.textColor = UIColor.colorWithHexString("#969696")
            cell.contentView.addSubview(infoLabel)
            
            
            
            let countLabel = UILabel(frame: CGRectMake(30*ratio, 60*ratio, 50*ratio, 24*ratio))
            countLabel.text = "분량"
            countLabel.textAlignment = NSTextAlignment.Left
            countLabel.font = UIFont(name: "AvenirNext-Regular", size: 12*ratio)
            countLabel.textColor = task.getColor()
            countLabel.textColor = UIColor.colorWithHexString("#969696")
            cell.contentView.addSubview(countLabel)
            
            let dateLabel = UILabel(frame: CGRectMake(30*ratio, 100*ratio, 50*ratio,24*ratio))
            dateLabel.text = "기간"
            dateLabel.textAlignment = NSTextAlignment.Left
            dateLabel.font = UIFont(name: "AvenirNext-Regular", size: 12*ratio)
            dateLabel.textColor = UIColor.colorWithHexString("#969696")
            cell.contentView.addSubview(dateLabel)
            
            
            let countBackgroundView = UIView(frame: CGRectMake(60*ratio, 60*ratio, 200*ratio, 24*ratio))
            countBackgroundView.layer.cornerRadius = 12*ratio
            countBackgroundView.backgroundColor = UIColor.todaitLightGray()
            countBackgroundView.clipsToBounds = true
            cell.contentView.addSubview(countBackgroundView)
            
            let countFrontView = UIView(frame: CGRectMake(0, 0, 0*ratio, 24*ratio))
            countFrontView.backgroundColor = task.getColor()
            countFrontView.layer.cornerRadius = 12*ratio
            countFrontView.clipsToBounds = true
            countBackgroundView.addSubview(countFrontView)
            
            
            
            
            let dateBackgroundView = UIView(frame: CGRectMake(60*ratio, 100*ratio, 200*ratio, 24*ratio))
            dateBackgroundView.layer.cornerRadius = 12*ratio
            dateBackgroundView.backgroundColor = UIColor.todaitLightGray()
            dateBackgroundView.clipsToBounds = true
            cell.contentView.addSubview(dateBackgroundView)
            
            let dateFrontView = UIView(frame: CGRectMake(0, 0, 0*ratio, 24*ratio))
            dateFrontView.backgroundColor = UIColor.todaitPurple()

            dateFrontView.layer.cornerRadius = 12*ratio
            dateFrontView.clipsToBounds = true
            dateBackgroundView.addSubview(dateFrontView)
            
            
            
            
            
            let countPercentLabel = UILabel(frame: CGRectMake(265*ratio, 60*ratio, 40*ratio, 24*ratio))
            countPercentLabel.text = getWeekAmountPercentString()
            countPercentLabel.textAlignment = NSTextAlignment.Left
            countPercentLabel.font = UIFont(name: "AvenirNext-Regular", size: 12*ratio)
            countPercentLabel.textColor = UIColor.colorWithHexString("#969696")
            countPercentLabel.adjustsFontSizeToFitWidth = true
            cell.contentView.addSubview(countPercentLabel)
            
            let datePercentLabel = UILabel(frame: CGRectMake(265*ratio, 100*ratio, 50*ratio,24*ratio))
            datePercentLabel.text = getWeekDatePercentString()
            datePercentLabel.textAlignment = NSTextAlignment.Left
            datePercentLabel.font = UIFont(name: "AvenirNext-Regular", size: 12*ratio)
            datePercentLabel.textColor = UIColor.colorWithHexString("#969696")
            datePercentLabel.adjustsFontSizeToFitWidth = true
            cell.contentView.addSubview(datePercentLabel)
            
            
            let countWidth = 200*ratio*CGFloat(getWeekAmountPercentValue())/100
            let dateWidth = 200*ratio*CGFloat(getWeekDatePercentValue())/100
            
            UIView.animateWithDuration(1.0, animations: { () -> Void in
                
                countFrontView.frame = CGRectMake(0,0, countWidth, 24*self.ratio)
                dateFrontView.frame = CGRectMake(0,0,dateWidth,24*self.ratio)
            })
            
        }
        
        
        
        
        
        
        return cell
    }
    
    
    func touchBegin() {
        detailTableView.scrollEnabled = false
    }
    
    func touchEnd() {
        detailTableView.scrollEnabled = true
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
        
        detailTableView.reloadData()
        
        todaitNavBar.setBackgroundImage(UIImage.colorImage(task.getColor(),frame:CGRectMake(0,0,width,navigationHeight)), forBarMetrics: UIBarMetrics.Default)
        
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
    
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        if scrollView.contentOffset.x >= 145*ratio {
            c4.backgroundColor = task.getColor()
            c3.backgroundColor = UIColor.todaitLightGray()
        }else{
            c3.backgroundColor = task.getColor()
            c4.backgroundColor = UIColor.todaitLightGray()
        }
        
    }
}
