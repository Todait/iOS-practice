//
//  StatisticsViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 10..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit
import CoreData

class GraphViewController: BasicViewController,TodaitNavigationDelegate {
    
    var scrollView:UIScrollView!
    var mainColor:UIColor!
    var task:Task!
    
    var totalDashView:UIView!
    
    
    
    var totalPercentLabel:UILabel!
    var totalTimeLabel:UILabel!
    
    
    
    
    var weekDashView:UIView!
    
    var progressButton:UIButton!
    var progressTasks:[Task] = []
    
    var completeButton:UIButton!
    var completeTasks:[Task] = []
    
    var incompleteButton:UIButton!
    var incompleteTasks:[Task] = []
    
    
    
    
    
    var focusDashView:UIView!
    
    
    var trendDashView:UIView!
    
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.todaitLightGray()
        addScrollView()
        
        addTotalDashView()
        addWeekDashView()
        addFocusDashView()
        addTrendDashView()
        
        
        //reloadData()
    }
    
    
    func addScrollView(){
        scrollView = UIScrollView(frame:view.frame)
        scrollView.contentSize = CGSizeMake(320*ratio,668*ratio)
        view.addSubview(scrollView)
        
    }
    
    
    func addTotalDashView(){
        
        totalDashView = UIView(frame:CGRectMake(5*ratio,64+5*ratio,110*ratio,215*ratio))
        totalDashView.clipsToBounds = true
        totalDashView.layer.cornerRadius = 4*ratio
        totalDashView.backgroundColor = UIColor.whiteColor()
        scrollView.addSubview(totalDashView)
        
        addTotalInfoLabel()
        addTotalChartView()
        addDoneDashPercent()
        addDoneDashTime()
        
    }
    
    func addTotalInfoLabel(){
        
        let totalInfoLabel = UILabel(frame:CGRectMake(15*ratio, 22*ratio, 80*ratio, 20*ratio))
        totalInfoLabel.text = "전체 진행도"
        totalInfoLabel.textColor = UIColor.todaitGray()
        totalInfoLabel.textAlignment = NSTextAlignment.Center
        totalInfoLabel.font = UIFont(name:"AppleSDGothicNeo-SemiBold",size:10*ratio)
        totalDashView.addSubview(totalInfoLabel)
        
    }
    
    func addTotalChartView(){
        
        var amountChart = ReverseCircleChart(frame: CGRectMake(15*ratio, 52*ratio, 80*ratio, 80*ratio))
        amountChart.chartColor = UIColor.todaitRed()
        amountChart.lineColor = UIColor.colorWithHexString("#F9EAEA")
        amountChart.chartBorderWidth = 7*ratio
        amountChart.strokeEnd = CGFloat(task.getPercentOfDoneAmount())/100
        amountChart.strokeChart()
        totalDashView.addSubview(amountChart)
        
        
        var periodChart = ReverseCircleChart(frame: CGRectMake(23*ratio, 60*ratio, 64*ratio, 64*ratio))
        periodChart.chartColor = UIColor.todaitBlue()
        periodChart.chartBorderWidth = 5.5*ratio
        periodChart.lineColor = UIColor.colorWithHexString("#DAEAF6")
        periodChart.strokeEnd = CGFloat(task.getPercentOfPeriodProgress())/100
        periodChart.strokeChart()
        totalDashView.addSubview(periodChart)
        
        
        var amountInfoLabel = UILabel(frame:CGRectMake(18*ratio,160*ratio,100*ratio,15*ratio))
        amountInfoLabel.text = "분량"
        amountInfoLabel.textAlignment = NSTextAlignment.Left
        amountInfoLabel.font = UIFont(name: "AppleSDGothicNeo-Light", size: 12.5*ratio)
        amountInfoLabel.textColor = UIColor.todaitGray()
        totalDashView.addSubview(amountInfoLabel)
        
        
        var amountPercentLabel = UILabel(frame:CGRectMake(54*ratio,160*ratio,100*ratio,15*ratio))
        amountPercentLabel.text = String(format: "%.0f%@",CGFloat(task.getPercentOfDoneAmount()),"%")
        amountPercentLabel.textAlignment = NSTextAlignment.Left
        amountPercentLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 15.5*ratio)
        amountPercentLabel.textColor = UIColor.todaitRed()
        totalDashView.addSubview(amountPercentLabel)
        
        
        
        
        var periodInfoLabel = UILabel(frame:CGRectMake(18*ratio,175*ratio,100*ratio,25*ratio))
        periodInfoLabel.text = "기간"
        periodInfoLabel.textAlignment = NSTextAlignment.Left
        periodInfoLabel.font = UIFont(name: "AppleSDGothicNeo-Light", size: 12.5*ratio)
        periodInfoLabel.textColor = UIColor.todaitGray()
        totalDashView.addSubview(periodInfoLabel)
        
        
        
        var periodPercentLabel = UILabel(frame:CGRectMake(54*ratio,175*ratio,100*ratio,25*ratio))
        periodPercentLabel.text = String(format: "%.0f%@",CGFloat(task.getPercentOfPeriodProgress()),"%")
        periodPercentLabel.textAlignment = NSTextAlignment.Left
        periodPercentLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 15.5*ratio)
        periodPercentLabel.textColor = UIColor.todaitBlue()
        totalDashView.addSubview(periodPercentLabel)
        
        
    }
    
    
    
    
    func getAllDonePercentOfWeek()->[[String:CGFloat]]{
        
        let weekDateNumbers:[NSNumber] =  getWeekDateNumberList(NSDate())
        var allDonePercents:[[String:CGFloat]] = []
        
        for dateNumber in weekDateNumbers {
            
            allDonePercents.append(getAllDonePercentOfDateNumber(dateNumber))
            
        }
        
        return allDonePercents
    }
    
    
    func getAllDonePercentOfDateNumber(dateNumber:NSNumber)->[String:CGFloat] {
        
        let dayDescription = NSEntityDescription.entityForName("Day", inManagedObjectContext: managedObjectContext!)
        let request = NSFetchRequest()
        request.entity = dayDescription
        request.predicate = NSPredicate(format: "date == %@", dateNumber)
        
        var error:NSError?
        let dayDataOfDateNumber:[Day] = managedObjectContext?.executeFetchRequest(request, error: &error) as! [Day]
        
        if dayDataOfDateNumber.count == 0 {
            
            return ["percent":0,"time":0]
        }
        
        
        
        var percent:CGFloat! = 0
        var time:CGFloat! = 0
        
        for day in dayDataOfDateNumber {
            
            percent = percent + CGFloat(day.getProgressPercent())
            time = time + CGFloat(day.done_second)
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
        totalDashView.addSubview(totalPercentInfoLabel)
        
        totalPercentLabel = UILabel(frame:CGRectMake(170*ratio,35*ratio,100*ratio,30*ratio))
        totalPercentLabel.text = "100%"
        totalPercentLabel.textColor = UIColor.todaitGreen()
        totalPercentLabel.font = UIFont(name:"AvenirNext-Regular",size:18*ratio)
        totalPercentLabel.textAlignment = NSTextAlignment.Right
        totalDashView.addSubview(totalPercentLabel)
        
    }
    
    func addDoneDashTime(){
        
        let totalTimeInfoLabel = UILabel(frame:CGRectMake(170*ratio,80*ratio,100*ratio,25*ratio))
        totalTimeInfoLabel.text = "최근 공부 시간"
        totalTimeInfoLabel.textColor = UIColor.todaitGray()
        totalTimeInfoLabel.font = UIFont(name:"AvenirNext-Regular",size:14*ratio)
        totalTimeInfoLabel.textAlignment = NSTextAlignment.Left
        totalDashView.addSubview(totalTimeInfoLabel)
        
        totalTimeLabel = UILabel(frame:CGRectMake(170*ratio,105*ratio,100*ratio,30*ratio))
        totalTimeLabel.text = "00시간 00분"
        totalTimeLabel.textColor = UIColor.todaitGreen()
        totalTimeLabel.font = UIFont(name:"AvenirNext-Regular",size:18*ratio)
        totalTimeLabel.textAlignment = NSTextAlignment.Right
        totalDashView.addSubview(totalTimeLabel)
    }
    
    
    func addWeekDashView(){
        
        weekDashView = UIView(frame:CGRectMake(120*ratio,64 + 5*ratio,195*ratio,383*ratio))
        weekDashView.clipsToBounds = true
        weekDashView.layer.cornerRadius = 4*ratio
        weekDashView.backgroundColor = UIColor.whiteColor()
        scrollView.addSubview(weekDashView)
        
    }
    
    
    func addIncompleteCircle(){
        
        
        incompleteButton = UIButton(frame:CGRectMake(210*ratio,15*ratio,40*ratio,40*ratio))
        incompleteButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        incompleteButton.setBackgroundImage(UIImage.colorImage(UIColor.todaitRed(), frame: CGRectMake(0, 0, 40*ratio, 40*ratio)), forState: UIControlState.Normal)
        incompleteButton.clipsToBounds = true
        incompleteButton.layer.cornerRadius = 20*ratio
        incompleteButton.titleLabel?.font = UIFont(name:"AvenirNext-Medium",size:14*ratio);
        incompleteButton.addTarget(self, action: Selector("touchDown:"), forControlEvents: UIControlEvents.TouchDown)
        incompleteButton.addTarget(self, action: Selector("touchOut:"),forControlEvents:UIControlEvents.TouchCancel)
        weekDashView.addSubview(incompleteButton)
        
        
        
        let incompleteInfoLabel = UILabel(frame:CGRectMake(210*ratio,60*ratio,40*ratio,20*ratio))
        incompleteInfoLabel.textAlignment = NSTextAlignment.Center
        incompleteInfoLabel.textColor = UIColor.todaitGray()
        incompleteInfoLabel.font = UIFont(name:"AvenirNext-Medium",size:14*ratio);
        incompleteInfoLabel.text = "미완료"
        
        weekDashView.addSubview(incompleteInfoLabel)
    }
    
    func addFocusDashView(){
        focusDashView = UIView(frame:CGRectMake(5*ratio,280*ratio,110*ratio,163*ratio))
        focusDashView.backgroundColor = UIColor.whiteColor()
        focusDashView.layer.cornerRadius = 4*ratio
        focusDashView.clipsToBounds = true
        scrollView.addSubview(focusDashView)
        
        addBarDashTableView()
        
    }
    
    
    func addBarDashTableView(){
        
        
        
        let titleLabel = UILabel(frame:CGRectMake(15*ratio, 23*ratio, 80*ratio, 20*ratio))
        titleLabel.text = "집중도"
        titleLabel.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 10*ratio)
        titleLabel.textColor = UIColor.todaitGray()
        titleLabel.textAlignment = NSTextAlignment.Center
        focusDashView.addSubview(titleLabel)
        
        
        let focusLabel = UILabel(frame: CGRectMake(15*ratio, 53*ratio, 80*ratio, 60*ratio))
        focusLabel.text = "3.5"
        focusLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 52.5*ratio)
        focusLabel.textAlignment = NSTextAlignment.Center
        focusLabel.textColor = UIColor.todaitGray()
        focusDashView.addSubview(focusLabel)
        
        
    }
    
    
    
    func addTrendDashView(){
        trendDashView = UIView(frame:CGRectMake(5*ratio,452*ratio,310*ratio,180*ratio))
        trendDashView.backgroundColor = UIColor.whiteColor()
        trendDashView.layer.cornerRadius = 4*ratio
        trendDashView.clipsToBounds = true
        scrollView.addSubview(trendDashView)
        
        addPieView()
    }
    
    func addPieView(){
        
        
        
        let pieChartItems:[PNPieChartDataItem] = getAllCategoryTimes()
        let pieChartView = PNPieChart(frame:CGRectMake(15*ratio,15*ratio,215*ratio/2,120*ratio),items:pieChartItems)
        
        pieChartView.descriptionTextColor = UIColor.todaitLightGray()
        pieChartView.descriptionTextFont = UIFont(name:"AvenirNext-Regular",size:14*ratio)
        pieChartView.descriptionTextShadowColor = UIColor.clearColor()
        
        trendDashView.addSubview(pieChartView)
        
        
        pieChartView.strokeChart()
        
    }
    
    
    func getAllCategoryTimes()->[PNPieChartDataItem]{
        
        var pnItems:[PNPieChartDataItem] = []
        
        
        let categoryEntity = NSEntityDescription.entityForName("Category", inManagedObjectContext: managedObjectContext!)
        
        let request = NSFetchRequest()
        request.entity = categoryEntity
        
        var error:NSError?
        var categorys:[Category] = managedObjectContext?.executeFetchRequest(request, error: &error) as! [Category]
        
        for category in categorys {
            
            let categoryItem:Category = category as Category
            var pnItem = PNPieChartDataItem(value: CGFloat(categoryItem.getTotalTime()), color: UIColor.colorWithHexString(category.color))
            
            pnItems.append(pnItem)
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
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        todaitNavBar.todaitDelegate = self
        todaitNavBar.backButton.hidden = false
        todaitNavBar.shadowImage = UIImage()
        self.titleLabel.text = task.category_id.name + " - " + task.name
        self.screenName = "Statistics Activity"
        
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
        request.predicate = NSPredicate(format:"%@ <= date && date <= %@",startDateNumber,endDateNumber)
        
        
        var error: NSError?
        allDayList = managedObjectContext?.executeFetchRequest(request, error: &error) as! [Day]
        
        
        var totalPercent:CGFloat = 0
        var totalDoneTime:Int = 0
        
        var totalCount = allDayList.count
        
        
        if allDayList.count == 0 {
            totalPercentLabel.text = "\(Int(0))%"
            totalTimeLabel.text = NSNumber(integer: 0).toTimeString()
            return
        }
        
        for dayItem in allDayList {
            
            totalPercent = totalPercent + CGFloat(dayItem.getProgressPercent())
            totalDoneTime = totalDoneTime + Int(dayItem.done_second)
        }
        
        
        
        totalPercent = totalPercent / CGFloat(totalCount)
        
        
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
            totalDoneTime = totalDoneTime + Int(dayItem.done_second)
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
    
    
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
