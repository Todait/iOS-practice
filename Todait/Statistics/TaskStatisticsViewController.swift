//
//  TaskStatisticsViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 19..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit
import CoreData

class TaskStatisticsViewController: BasicViewController,TodaitNavigationDelegate {
    
    
    var category:Category!
    
    var mainColor:UIColor!

    
    
    
    var scrollView:UIScrollView!
    
    var doneDashView:UIView!
    var totalPercentLabel:UILabel!
    var totalTimeLabel:UILabel!
    
    
    var statusDashView:UIView!
    
    var progressButton:UIButton!
    var progressTasks:[Task] = []
    
    var completeButton:UIButton!
    var completeTasks:[Task] = []
    
    var incompleteButton:UIButton!
    var incompleteTasks:[Task] = []
    
    
    var barDashView:UIView!
    var pieDashView:UIView!
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.todaitLightGray()
        addScrollView()
        
        addDoneDashView()
        addStatusDashView()
        addBarDashView()
        addPieDashView()
        
        
        reloadData()
    }
    
    
    func addScrollView(){
        scrollView = UIScrollView(frame:view.frame)
        scrollView.contentSize = CGSizeMake(320*ratio,668*ratio)
        view.addSubview(scrollView)
        
    }
    
    
    func addDoneDashView(){
        
        doneDashView = UIView(frame:CGRectMake(15*ratio,80*ratio,290*ratio,150*ratio))
        doneDashView.clipsToBounds = true
        doneDashView.layer.cornerRadius = 4*ratio
        doneDashView.backgroundColor = UIColor.whiteColor()
        scrollView.addSubview(doneDashView)
        
        addDoneDashChart()
        addDoneDashPercent()
        addDoneDashTime()
        
    }
    
    func addDoneDashChart(){
        
        let percentInfoLabel = UILabel(frame:CGRectMake(20*ratio, 10*ratio, 100*ratio, 20*ratio))
        percentInfoLabel.text = "성취율"
        percentInfoLabel.textColor = mainColor
        percentInfoLabel.font = UIFont(name:"AvenirNext-Regular",size:8*ratio)
        doneDashView.addSubview(percentInfoLabel)
        
        
        let grayBox = UIView(frame:CGRectMake(20*ratio,70*ratio,140*ratio,15*ratio))
        grayBox.backgroundColor = UIColor.todaitGray()
        doneDashView.addSubview(grayBox)
        
        
        let weekData:[[String:CGFloat]] = getTaskAllDonePercentOfWeek()
        var dones:[CGFloat] = []
        var times:[CGFloat] = []
        //var percent:CGFloat
        
        
        
        for index in 0...6 {
            
            
            dones.append(weekData[index]["percent"]!)
            times.append(weekData[index]["time"]!)
            
        }
        
        
        let donePercent:[CGFloat] = dones
        let dayTitle:[String] = getDayString(getWeekDateNumberList(NSDate()))
        let time:[CGFloat] = times
        
        
        
        
        
        let maxHeight = 45*ratio
        
        
        
        
        
        
        let weekPercentChart = WeekChart(frame: CGRectMake(20*ratio,30*ratio,140*ratio,40*ratio))
        weekPercentChart.chartWidth = 14*ratio
        weekPercentChart.padding = 3*ratio
        weekPercentChart.direction = weekChartDirection.upDirection
        weekPercentChart.chartColor = mainColor
        doneDashView.addSubview(weekPercentChart)
        weekPercentChart.updateChart(donePercent)
        
        
        
        let weekTimeChart = WeekChart(frame:CGRectMake(20*ratio, 85*ratio, 140*ratio, 40*ratio))
        weekTimeChart.chartWidth = 14*ratio
        weekTimeChart.padding = 3*ratio
        weekTimeChart.direction = weekChartDirection.downDirection
        weekTimeChart.chartColor = mainColor
        doneDashView.addSubview(weekTimeChart)
        weekTimeChart.updateChart(time)
        
        
        
        let weekLabel = WeekLabel(frame: CGRectMake(0, 0, 140*ratio, 15*ratio))
        weekLabel.weekColor = UIColor.whiteColor()
        weekLabel.weekFont = UIFont(name: "AvenirNext-Regular", size: 8*ratio)
        weekLabel.updateLabelText(dayTitle)
        
        grayBox.addSubview(weekLabel)
        
        
        
    }
    
    
    func getTaskAllDonePercentOfWeek()->[[String:CGFloat]]{
        
        let weekDateNumbers:[NSNumber] =  getWeekDateNumberList(NSDate())
        var allDonePercents:[[String:CGFloat]] = []
        
        for dateNumber in weekDateNumbers {
            
            allDonePercents.append(getTaskAllDonePercentOfDateNumber(dateNumber))
            
        }
        
        return allDonePercents
    }
    
    
    func getTaskAllDonePercentOfDateNumber(dateNumber:NSNumber)->[String:CGFloat] {
        
        let dayDescription = NSEntityDescription.entityForName("Day", inManagedObjectContext: managedObjectContext!)
        let request = NSFetchRequest()
        request.entity = dayDescription
        request.predicate = NSPredicate(format: "date == %@ && task_id.category_id == %@", dateNumber,category)
        
        var error:NSError?
        let dayDataOfDateNumber:[Day] = managedObjectContext?.executeFetchRequest(request, error: &error) as! [Day]
        
        if dayDataOfDateNumber.count == 0 {
            
            return ["percent":0,"time":0]
        }
        
        
        
        var percent:CGFloat! = 0
        var time:CGFloat! = 0
        
        for day in dayDataOfDateNumber {
            
            percent = percent + CGFloat(day.getProgressPercent())
            time = time + CGFloat(day.doneSecond)
        }
        
        return ["percent":100*percent/CGFloat(dayDataOfDateNumber.count),"time":time/CGFloat(dayDataOfDateNumber.count)]
    }
    
    
    
    
    //테스트완료
    func getDayString(numbers:[NSNumber])->[String]{
        
        var strings:[String] = []
        
        for number in numbers {
            
            
            let date = getDateFromDateNumber(number)
            let dateComp = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitDay, fromDate: date)
            
            strings.append("\(dateComp.day)")
            
        }
        
        return strings
    }
    
    
    
    func addDoneDashPercent(){
        let totalPercentInfoLabel = UILabel(frame:CGRectMake(170*ratio,10*ratio,100*ratio,25*ratio))
        totalPercentInfoLabel.text = "최근 평균 성취율"
        totalPercentInfoLabel.textColor = UIColor.todaitGray()
        totalPercentInfoLabel.font = UIFont(name:"AvenirNext-Regular",size:14*ratio)
        totalPercentInfoLabel.textAlignment = NSTextAlignment.Left
        doneDashView.addSubview(totalPercentInfoLabel)
        
        totalPercentLabel = UILabel(frame:CGRectMake(170*ratio,35*ratio,100*ratio,30*ratio))
        totalPercentLabel.text = "100%"
        totalPercentLabel.textColor = mainColor
        totalPercentLabel.font = UIFont(name:"AvenirNext-Regular",size:18*ratio)
        totalPercentLabel.textAlignment = NSTextAlignment.Right
        doneDashView.addSubview(totalPercentLabel)
        
    }
    
    func addDoneDashTime(){
        
        let totalTimeInfoLabel = UILabel(frame:CGRectMake(170*ratio,80*ratio,100*ratio,25*ratio))
        totalTimeInfoLabel.text = "최근 공부 시간"
        totalTimeInfoLabel.textColor = UIColor.todaitGray()
        totalTimeInfoLabel.font = UIFont(name:"AvenirNext-Regular",size:14*ratio)
        totalTimeInfoLabel.textAlignment = NSTextAlignment.Left
        doneDashView.addSubview(totalTimeInfoLabel)
        
        totalTimeLabel = UILabel(frame:CGRectMake(170*ratio,105*ratio,100*ratio,30*ratio))
        totalTimeLabel.text = "00시간 00분"
        totalTimeLabel.textColor = mainColor
        totalTimeLabel.font = UIFont(name:"AvenirNext-Regular",size:18*ratio)
        totalTimeLabel.textAlignment = NSTextAlignment.Right
        doneDashView.addSubview(totalTimeLabel)
    }
    
    
    func addStatusDashView(){
        
        statusDashView = UIView(frame:CGRectMake(15*ratio,245*ratio,290*ratio,90*ratio))
        statusDashView.clipsToBounds = true
        statusDashView.layer.cornerRadius = 4*ratio
        statusDashView.backgroundColor = UIColor.whiteColor()
        scrollView.addSubview(statusDashView)
        
        addStatusCircle()
        
    }
    
    func addStatusCircle(){
        
        addProgressCircle()
        addCompleteCircle()
        addIncompleteCircle()
    }
    
    func addProgressCircle(){
        
        progressButton = UIButton(frame:CGRectMake(40*ratio,15*ratio,40*ratio,40*ratio))
        progressButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        progressButton.setBackgroundImage(UIImage.colorImage(mainColor, frame: CGRectMake(0, 0, 40*ratio, 40*ratio)), forState: UIControlState.Normal)
        progressButton.clipsToBounds = true
        progressButton.layer.cornerRadius = 20*ratio
        progressButton.titleLabel?.font = UIFont(name:"AvenirNext-Medium",size:14*ratio);
        progressButton.addTarget(self, action: Selector("touchDown:"), forControlEvents: UIControlEvents.TouchDown)
        progressButton.addTarget(self, action: Selector("touchOut:"),forControlEvents:UIControlEvents.TouchDragOutside)
        statusDashView.addSubview(progressButton)
        
        
        let progressInfoLabel = UILabel(frame:CGRectMake(40*ratio,60*ratio,40*ratio,20*ratio))
        progressInfoLabel.textAlignment = NSTextAlignment.Center
        progressInfoLabel.textColor = UIColor.todaitGray()
        progressInfoLabel.font = UIFont(name:"AvenirNext-Medium",size:14*ratio);
        progressInfoLabel.text = "진행중"
        
        statusDashView.addSubview(progressInfoLabel)
        
    }
    
    
    
    func touchDown(button:UIButton){
        
        let center = button.center
        
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            button.transform = CGAffineTransformMakeScale(0.8,0.8)
            
            }) { (Bool) -> Void in
                
                let progressVC = ProgressListViewController()
                
                if button == self.progressButton {
                    progressVC.sectionTitles = ["진행리스트"]
                    progressVC.cellTitles = [["현재버전","오픈소스 라이선스"]];
                    progressVC.titleString = "진행중"
                    progressVC.mainColor = self.mainColor
                    progressVC.tasks = self.progressTasks
                }else if button == self.completeButton {
                    progressVC.sectionTitles = ["완료리스트"]
                    progressVC.cellTitles = [["현재버전","오픈소스 라이선스"]];
                    progressVC.titleString = "완료"
                    progressVC.mainColor = self.mainColor
                    progressVC.tasks = self.completeTasks
                }else if button == self.incompleteButton {
                    progressVC.sectionTitles = ["미완료리스트"]
                    progressVC.cellTitles = [["현재버전","오픈소스 라이선스"]];
                    progressVC.titleString = "미완료"
                    progressVC.mainColor = self.mainColor
                    progressVC.tasks = self.incompleteTasks
                }
                
                
                
                self.navigationController?.pushViewController(progressVC, animated: true)
                
                
                UIView.animateWithDuration(1.5, animations: { () -> Void in
                    button.transform = CGAffineTransformMakeScale(1,1)
                    
                })
                
        }
    }
    
    func showDetailVC(){
        
        
    }
    
    
    
    func touchOut(button:UIButton){
        
        let center = button.center
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            button.frame = CGRectMake(0,0,40*self.ratio,40*self.ratio)
            button.center = center
            button.layer.cornerRadius = 20*self.ratio
        })
        
    }
    
    
    func addCompleteCircle(){
        
        
        completeButton = UIButton(frame:CGRectMake(125*ratio,15*ratio,40*ratio,40*ratio))
        completeButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        completeButton.setBackgroundImage(UIImage.colorImage(mainColor.colorWithAlphaComponent(0.75), frame: CGRectMake(0, 0, 40*ratio, 40*ratio)), forState: UIControlState.Normal)
        completeButton.clipsToBounds = true
        completeButton.layer.cornerRadius = 20*ratio
        completeButton.titleLabel?.font = UIFont(name:"AvenirNext-Medium",size:14*ratio);
        completeButton.addTarget(self, action: Selector("touchDown:"), forControlEvents: UIControlEvents.TouchDown)
        completeButton.addTarget(self, action: Selector("touchOut:"),forControlEvents:UIControlEvents.TouchCancel)
        statusDashView.addSubview(completeButton)
        
        
        
        let completeInfoLabel = UILabel(frame:CGRectMake(125*ratio,60*ratio,40*ratio,20*ratio))
        completeInfoLabel.textAlignment = NSTextAlignment.Center
        completeInfoLabel.textColor = UIColor.todaitGray()
        completeInfoLabel.font = UIFont(name:"AvenirNext-Medium",size:14*ratio);
        completeInfoLabel.text = "완료"
        
        statusDashView.addSubview(completeInfoLabel)
    }
    
    func addIncompleteCircle(){
        
        incompleteButton = UIButton(frame:CGRectMake(210*ratio,15*ratio,40*ratio,40*ratio))
        incompleteButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        incompleteButton.setBackgroundImage(UIImage.colorImage(mainColor.colorWithAlphaComponent(0.5), frame: CGRectMake(0, 0, 40*ratio, 40*ratio)), forState: UIControlState.Normal)
        incompleteButton.clipsToBounds = true
        incompleteButton.layer.cornerRadius = 20*ratio
        incompleteButton.titleLabel?.font = UIFont(name:"AvenirNext-Medium",size:14*ratio);
        incompleteButton.addTarget(self, action: Selector("touchDown:"), forControlEvents: UIControlEvents.TouchDown)
        incompleteButton.addTarget(self, action: Selector("touchOut:"),forControlEvents:UIControlEvents.TouchCancel)
        statusDashView.addSubview(incompleteButton)
        
        
        
        let incompleteInfoLabel = UILabel(frame:CGRectMake(210*ratio,60*ratio,40*ratio,20*ratio))
        incompleteInfoLabel.textAlignment = NSTextAlignment.Center
        incompleteInfoLabel.textColor = UIColor.todaitGray()
        incompleteInfoLabel.font = UIFont(name:"AvenirNext-Medium",size:14*ratio);
        incompleteInfoLabel.text = "미완료"
        
        statusDashView.addSubview(incompleteInfoLabel)
    }
    
    func addBarDashView(){
        barDashView = UIView(frame:CGRectMake(15*ratio,350*ratio,275*ratio/2,220*ratio))
        barDashView.backgroundColor = UIColor.whiteColor()
        barDashView.layer.cornerRadius = 4*ratio
        barDashView.clipsToBounds = true
        scrollView.addSubview(barDashView)
        
        addBarDashTableView()
        
    }
    
    
    func addBarDashTableView(){
        
        
        
        let infoLabel = UILabel(frame:CGRectMake(10*ratio, 10*ratio, 100*ratio, 20*ratio))
        infoLabel.text = "목표 순위"
        infoLabel.font = UIFont(name: "AvenirNext-Regular", size: 12*ratio)
        infoLabel.textColor = mainColor
        barDashView.addSubview(infoLabel)
        let barDashVC = TaskBarDashViewController()
        barDashVC.mainColor = mainColor
        
        
        barDashVC.dataSource = getAllCategory()
        addChildViewController(barDashVC)
        barDashVC.view.frame = CGRectMake(0*ratio,35*ratio,275*ratio/2,150*ratio)
        barDashVC.view.backgroundColor = UIColor.todaitLightGray()
        barDashView.addSubview(barDashVC.view)
        
    }
    
    /*
    func getAllTask()->[[String:AnyObject]]{
        
        var taskItems:[[String:AnyObject]] = []
        
        for task in taskItems {
            
            let taskItem:Task! = task as Task
            
            
            var item:[String:AnyObject] = [:]
            item["task"] = taskItem
            item["value"] = taskItem.getPercentOfPeriodProgress()
            
        }
    }
    */
    
    func getAllCategory()->[[String:AnyObject]]{
        
        var categoryItems:[[String:AnyObject]] = []
        
        let categoryEntity = NSEntityDescription.entityForName("Category", inManagedObjectContext: managedObjectContext!)
        
        let request = NSFetchRequest()
        request.entity = categoryEntity
        
        var error:NSError?
        var categorys:[Category] = managedObjectContext?.executeFetchRequest(request, error: &error) as! [Category]
        
        for category in categorys {
            
            let categoryItem:Category = category as Category
            
            var item:[String:AnyObject] = [:]
            item["category"] = categoryItem
            item["value"] = categoryItem.getAveragePercent()
            
            categoryItems.append(item)
        }
        
        
        //var sorted = chartItems
        
        let sortDescriptor:NSSortDescriptor = NSSortDescriptor(key: "value", ascending: false)
        var sortItems:[[String:AnyObject]] = (categoryItems as NSArray).sortedArrayUsingDescriptors([sortDescriptor]) as! [[String:AnyObject]]
        
        
        return sortItems
    }
    
    
    func getAllCategoryPercent()->[ChartItem]{
        
        
        var chartItems:[ChartItem] = []
        
        let categoryEntity = NSEntityDescription.entityForName("Category", inManagedObjectContext: managedObjectContext!)
        
        let request = NSFetchRequest()
        request.entity = categoryEntity
        
        var error:NSError?
        var categorys:[Category] = managedObjectContext?.executeFetchRequest(request, error: &error) as! [Category]
        
        for category in categorys {
            
            let categoryItem:Category = category as Category
            
            var chartItem = ChartItem(color:UIColor.colorWithHexString(categoryItem.color),value:categoryItem.getAveragePercent())
            
            chartItems.append(chartItem)
        }
        
        
        //var sorted = chartItems
        
        let sortDescriptor:NSSortDescriptor = NSSortDescriptor(key: "value", ascending: false)
        var sortItems:[ChartItem] = (chartItems as NSArray).sortedArrayUsingDescriptors([sortDescriptor]) as! [ChartItem]
        return sortItems
    }
    
    
    
    
    
    func addPieDashView(){
        pieDashView = UIView(frame:CGRectMake(30*ratio+275*ratio/2,350*ratio,275*ratio/2,220*ratio))
        pieDashView.backgroundColor = UIColor.whiteColor()
        pieDashView.layer.cornerRadius = 4*ratio
        pieDashView.clipsToBounds = true
        scrollView.addSubview(pieDashView)
        
        //addPieView()
    }
    /*
    func addPieView(){
        
        
        
        let pieChartItems:[PNPieChartDataItem] = getAllCategoryTimes()
        let pieChartView = PNPieChart(frame:CGRectMake(15*ratio,15*ratio,215*ratio/2,120*ratio),items:pieChartItems)
        
        pieChartView.descriptionTextColor = UIColor.todaitLightGray()
        pieChartView.descriptionTextFont = UIFont(name:"AvenirNext-Regular",size:14*ratio)
        pieChartView.descriptionTextShadowColor = UIColor.clearColor()
        
        pieDashView.addSubview(pieChartView)
        
        
        pieChartView.strokeChart()
        
    }
    
    
    func getAllCategoryTimes()->[PNPieChartDataItem]{
        
        var pnItems:[PNPieChartDataItem] = []
        
        
        let categoryEntity = NSEntityDescription.entityForName("Category", inManagedObjectContext: managedObjectContext!)
        
        let request = NSFetchRequest()
        request.entity = categoryEntity
        
        var error:NSError?
        var categorys:[Category] = managedObjectContext?.executeFetchRequest(request, error: &error) as! [Category]
        
        var index:CGFloat = 0
        
        for category in categorys {
            
            
            let categoryItem:Category = category as Category
            var pnItem = PNPieChartDataItem(value: CGFloat(categoryItem.getTotalTime()), color:mainColor.colorWithAlphaComponent(1 - index*0.15))
            
            pnItems.append(pnItem)
            
            index = index + 1
        }
        
        return pnItems
    }
    

    func getWeekCategoryTimes()->[PNPieChartDataItem]{
        
        var pnItems:[PNPieChartDataItem] = []
        
        
        let categoryEntity = NSEntityDescription.entityForName("Category", inManagedObjectContext: managedObjectContext!)
        
        let request = NSFetchRequest()
        request.entity = categoryEntity
        
        var error:NSError?
        var categorys:[Category] = managedObjectContext?.executeFetchRequest(request, error: &error) as! [Category]
        
        for category in categorys {
            
            let categoryItem:Category = category as Category
            var pnItem = PNPieChartDataItem(value: CGFloat(categoryItem.getWeekTime()), color: UIColor.colorWithHexString(category.color))
            
            pnItems.append(pnItem)
        }
        
        return pnItems
    }
    
    */
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        todaitNavBar.todaitDelegate = self
        todaitNavBar.backButton.hidden = false
        todaitNavBar.shadowImage = UIImage()
        self.titleLabel.text = "Statistics"
        self.screenName = "Statistics Activity"
        setNavigationBarColor(mainColor)
    }
    
    
    func reloadData(){
        
        getWeekPercent()
        loadProgressStatusCount()
        
    }
    
    
    func getWeekPercent(){
        
        
        let weekDateNumber:[NSNumber] = getWeekDateNumberList(NSDate())
        
        let startDateNumber:NSNumber = weekDateNumber.first!
        let endDateNumber:NSNumber = weekDateNumber.last!
        
        var allDayList:[Day] = []
        
        let entityDescription = NSEntityDescription.entityForName("Day",inManagedObjectContext:managedObjectContext!)
        
        let request = NSFetchRequest()
        request.entity = entityDescription
        request.predicate = NSPredicate(format:"%@ <= date && date <= %@ && task_id.category_id == %@",startDateNumber,endDateNumber,category)
        
        
        var error: NSError?
        allDayList = managedObjectContext?.executeFetchRequest(request, error: &error) as! [Day]
        
        
        var totalPercent:CGFloat = 0
        var totalDoneTime:Int = 0
        
        var totalCount = allDayList.count
        
        for dayItem in allDayList {
            
            totalPercent = totalPercent + CGFloat(dayItem.getProgressPercent())
            totalDoneTime = totalDoneTime + Int(dayItem.doneSecond)
        }
        
        if totalCount == 0 {
            totalPercent = 0
        }else{
            totalPercent = totalPercent / CGFloat(totalCount)
        }
        
        
        totalPercentLabel.text = "\(Int(totalPercent*100))%"
        totalTimeLabel.text = NSNumber(integer: totalDoneTime).toTimeString()
        
    }
    
    
    
    
    
    func getAllPercent(){
        
        var allDayList:[Day] = []
        
        let entityDescription = NSEntityDescription.entityForName("Day",inManagedObjectContext:managedObjectContext!)
        
        let request = NSFetchRequest()
        request.entity = entityDescription
        
        var error: NSError?
        allDayList = managedObjectContext?.executeFetchRequest(request, error: &error) as! [Day]
        
        
        var totalPercent:CGFloat = 0
        var totalDoneTime:Int = 0
        
        var totalCount = allDayList.count
        
        for dayItem in allDayList {
            
            totalPercent = totalPercent + CGFloat(dayItem.getProgressPercent())
            totalDoneTime = totalDoneTime + Int(dayItem.doneSecond)
        }
        
        
        totalPercent = totalPercent / CGFloat(totalCount)
        
        
        totalPercentLabel.text = "\(Int(totalPercent*100))%"
        totalTimeLabel.text = NSNumber(integer: totalDoneTime).toTimeString()
        
    }
    
    func loadProgressStatusCount(){
        
        
        //resetTasks()
        
        var allTaskList:[Task] = []
        let entityDescription = NSEntityDescription.entityForName("Task",inManagedObjectContext:managedObjectContext!)
        
        let request = NSFetchRequest()
        request.entity = entityDescription
        //request.predicate = NSPredicate(format: "", <#args: CVarArgType#>...))
        
        var error: NSError?
        allTaskList = managedObjectContext?.executeFetchRequest(request, error: &error) as! [Task]
        
        
        var progressCount = 0
        var completeCount = 0
        var incompleteCount = 0
        
        for taskItem in allTaskList {
            
            if taskItem.isComplete(){
                completeCount = completeCount + 1
                completeTasks.append(taskItem as Task)
            }else{
                
                if taskItem.isProgress(){
                    progressCount = progressCount + 1
                    progressTasks.append(taskItem as Task)
                }else{
                    incompleteCount = incompleteCount + 1
                    incompleteTasks.append(taskItem as Task)
                }
            }
        }
        
        
        progressButton.setTitle("\(progressCount)", forState:UIControlState.Normal)
        completeButton.setTitle("\(completeCount)", forState:UIControlState.Normal)
        incompleteButton.setTitle("\(incompleteCount)", forState:UIControlState.Normal)
        
    }
    
    func resetTasks(){
        
        progressTasks.removeAll(keepCapacity: false)
        completeTasks.removeAll(keepCapacity: false)
        incompleteTasks.removeAll(keepCapacity: false)
        
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
    
    
    
}


