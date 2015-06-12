//
//  DetailViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 2..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: BasicViewController,TodaitNavigationDelegate,UITableViewDelegate,UITableViewDataSource,touchDelegate{
   
    var detailTableView: UITableView!
    var task:Task!
    var day:Day!
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        addDetailTable()
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
            case 1: return 180*ratio
            case 2: return 180*ratio
            default: return 200*ratio
        }
        
        
        return 80*ratio
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        addDoneAmount()
        
        
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
            
            let whiteBox = UIView(frame: CGRectMake(15*ratio, 15*ratio, 290*ratio, 155*ratio))
            whiteBox.backgroundColor = UIColor.whiteColor()
            whiteBox.clipsToBounds = true
            whiteBox.layer.cornerRadius = 4*ratio
            cell.contentView.addSubview(whiteBox)
            
            let infoLabel = UILabel(frame: CGRectMake(30*ratio, 20*ratio, 200*ratio, 30*ratio))
            infoLabel.text = "하루 진행도"
            infoLabel.textAlignment = NSTextAlignment.Left
            infoLabel.font = UIFont(name: "AvenirNext-Regular", size: 14*ratio)
            infoLabel.textColor = UIColor.colorWithHexString("#969696")
            cell.contentView.addSubview(infoLabel)
            
            
            
            let chart = CircleChart(frame: CGRectMake(100*ratio,30*ratio,50*ratio,50*ratio))
            
            let percent:NSNumber = day.getProgressPercent()
            chart.circleColor = task.getColor()
            chart.updatePercent(percent)

            cell.contentView.addSubview(chart)
            
            
            
            let countLabel = UILabel(frame: CGRectMake(165*ratio, 30*ratio, 120*ratio, 50*ratio))
            countLabel.text = day.getProgressString()
            countLabel.textColor = UIColor.colorWithHexString("#C9C9C9")
            countLabel.textAlignment = NSTextAlignment.Left
            countLabel.font = UIFont(name: "AvenirNext-Regular", size: 18*ratio)
            cell.contentView.addSubview(countLabel)
            
            
            
            
            var value:[CGFloat] = []
            
            for index in 0...41 {
                value.append(CGFloat(rand()%100))
            }
            
            let timeChart = TimeChart(frame:CGRectMake(30*ratio, 90*ratio, 260*ratio, 80*ratio))
            timeChart.chartColor = task.getColor()
            timeChart.chartWidth = 3*ratio
            timeChart.updateChart(value)
            timeChart.delegate = self
            cell.contentView.addSubview(timeChart)
            
            
            
        }else if(indexPath.row == 2){
            
            let whiteBox = UIView(frame: CGRectMake(15*ratio, 15*ratio, 290*ratio, 160*ratio))
            whiteBox.backgroundColor = UIColor.whiteColor()
            whiteBox.clipsToBounds = true
            whiteBox.layer.cornerRadius = 4*ratio
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
            
            let weekChart = WeekChart(frame: CGRectMake(30*ratio, 50*ratio, 260*ratio, 70*ratio))
            weekChart.direction = weekChartDirection.upDirection
            weekChart.chartColor = task.getColor()
            weekChart.chartWidth = 25*ratio
            cell.contentView.addSubview(weekChart)
            weekChart.updateChart(doneAmountList)
            
            
            let weekLabelString:[String] = task.getWeekDateNumberString(NSDate())
            let weekLabel = WeekLabel(frame:CGRectMake(30*ratio, 90*ratio, 260*ratio, 100*ratio))
            weekLabel.weekColor = UIColor.colorWithHexString("#969696")
            weekLabel.weekFont = UIFont(name: "AvenirNext-Regular", size: 8*ratio)
            weekLabel.updateLabelText(weekLabelString)
            cell.contentView.addSubview(weekLabel)
            
            
            
            let c = UIView(frame:CGRectMake(146*ratio, 155*ratio, 10*ratio, 10*ratio))
            c.backgroundColor = task.getColor()
            c.clipsToBounds = true
            c.layer.cornerRadius = 5*ratio
            cell.contentView.addSubview(c)
            
            
            
            let c2 = UIView(frame:CGRectMake(164*ratio, 155*ratio, 10*ratio, 10*ratio))
            c2.backgroundColor = UIColor.todaitLightGray()
            c2.clipsToBounds = true
            c2.layer.cornerRadius = 5*ratio
            cell.contentView.addSubview(c2)
            
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
            countLabel.textColor = UIColor.colorWithHexString("#969696")
            cell.contentView.addSubview(countLabel)
            
            let dateLabel = UILabel(frame: CGRectMake(30*ratio, 100*ratio, 50*ratio,24*ratio))
            dateLabel.text = "기간"
            dateLabel.textAlignment = NSTextAlignment.Left
            dateLabel.font = UIFont(name: "AvenirNext-Regular", size: 12*ratio)
            dateLabel.textColor = UIColor.colorWithHexString("#969696")
            cell.contentView.addSubview(dateLabel)
            
            
            let countBackgroundView = UIView(frame: CGRectMake(60*ratio, 60*ratio, 220*ratio, 24*ratio))
            countBackgroundView.layer.cornerRadius = 12*ratio
            countBackgroundView.backgroundColor = UIColor.todaitLightGray()
            countBackgroundView.clipsToBounds = true
            cell.contentView.addSubview(countBackgroundView)
            
            let countFrontView = UIView(frame: CGRectMake(0, 0, 0*ratio, 24*ratio))
            countFrontView.backgroundColor = UIColor.colorWithHexString("#00D2B1")
            countFrontView.layer.cornerRadius = 12*ratio
            countFrontView.clipsToBounds = true
            countBackgroundView.addSubview(countFrontView)
            
            
            
            
            let dateBackgroundView = UIView(frame: CGRectMake(60*ratio, 100*ratio, 220*ratio, 24*ratio))
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
            cell.contentView.addSubview(countPercentLabel)
            
            let datePercentLabel = UILabel(frame: CGRectMake(265*ratio, 100*ratio, 50*ratio,24*ratio))
            datePercentLabel.text = getWeekDatePercentString()
            datePercentLabel.textAlignment = NSTextAlignment.Left
            datePercentLabel.font = UIFont(name: "AvenirNext-Regular", size: 12*ratio)
            datePercentLabel.textColor = UIColor.colorWithHexString("#969696")
            cell.contentView.addSubview(datePercentLabel)
            
            
            let countWidth = 220*ratio*CGFloat(getWeekAmountPercentValue())/100
            let dateWidth = 220*ratio*CGFloat(getWeekDatePercentValue())/100
            
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
