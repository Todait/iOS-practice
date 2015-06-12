//
//  StatisticsViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 10..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit
import CoreData

class StatisticsViewController: BasicViewController,TodaitNavigationDelegate {

    
    var scrollView:UIScrollView!
    
    var doneDashView:UIView!
    var totalPercentLabel:UILabel!
    var totalTimeLabel:UILabel!
    
    
    var statusDashView:UIView!
    var progressLabel:UILabel!
    var completeLabel:UILabel!
    var incompleteLabel:UILabel!
    
    
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
        scrollView.contentSize = CGSizeMake(320*ratio,568*ratio)
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
        percentInfoLabel.textColor = UIColor.todaitGreen()
        percentInfoLabel.font = UIFont(name:"AvenirNext-Regular",size:8*ratio)
        doneDashView.addSubview(percentInfoLabel)
        
        
        let grayBox = UIView(frame:CGRectMake(20*ratio,70*ratio,140*ratio,15*ratio))
        grayBox.backgroundColor = UIColor.todaitGray()
        doneDashView.addSubview(grayBox)
        
        let percent:[CGFloat]=[50,40,30,50,10,30,20]
        let dayTitle:[String]=["7","8","9","10","11","12","13"]
        let time:[CGFloat]=[40,30,10,40,30,40,45]
        
        let maxHeight = 45*ratio
        
        
        
        let weekPercentChart = WeekChart(frame: CGRectMake(20*ratio,30*ratio,140*ratio,40*ratio))
        weekPercentChart.chartWidth = 14*ratio
        weekPercentChart.padding = 3*ratio
        weekPercentChart.direction = weekChartDirection.upDirection
        weekPercentChart.chartColor = UIColor.todaitGreen()
        doneDashView.addSubview(weekPercentChart)
        weekPercentChart.updateChart(percent)
        
        
        
        let weekTimeChart = WeekChart(frame:CGRectMake(20*ratio, 85*ratio, 140*ratio, 40*ratio))
        weekTimeChart.chartWidth = 14*ratio
        weekTimeChart.padding = 3*ratio
        weekTimeChart.direction = weekChartDirection.downDirection
        weekTimeChart.chartColor = UIColor.todaitPurple()
        doneDashView.addSubview(weekTimeChart)
        weekTimeChart.updateChart(time)
        
        
        
        let weekLabel = WeekLabel(frame: CGRectMake(0, 0, 140*ratio, 15*ratio))
        weekLabel.weekColor = UIColor.whiteColor()
        weekLabel.weekFont = UIFont(name: "AvenirNext-Regular", size: 8*ratio)
        weekLabel.updateLabelText(dayTitle)
        
        grayBox.addSubview(weekLabel)
        
        /*
        
        for index in 0...6 {
            
            let radius = 10*ratio
            let originX = 70*ratio-7*radius + 2*radius*CGFloat(index)
            
            let label = UILabel(frame:CGRectMake(originX,0,2*radius,15*ratio))
            label.textAlignment = NSTextAlignment.Center
            label.textColor = UIColor.whiteColor()
            label.text = dayTitle[index]
            label.font = UIFont(name:"AvenirNext-Regular",size:8*ratio)
            
            grayBox.addSubview(label)
            
            
            let padding = 3*ratio
            let boxWidth:CGFloat = 2*radius-2*padding
            let boxHeight:CGFloat = CGFloat(percent[index])
            let boxFrame = CGRectMake(originX+padding,0,boxWidth,0)
            let boxNewFrame = CGRectMake(originX+padding,0,boxWidth,-1*boxHeight)
            
            let upBox = UIView(frame:boxFrame)
            upBox.backgroundColor = UIColor.todaitGreen()
            grayBox.addSubview(upBox)
            
            
            
            UIView.animateWithDuration(1.5, animations: { () -> Void in
                
                upBox.frame = boxNewFrame
                
            })
            
            
            let downBoxHeight = CGFloat(time[index])
            let downBoxFrame = CGRectMake(originX+padding,15*ratio,boxWidth,0)
            let downNewBoxFrame = CGRectMake(originX+padding,15*ratio,boxWidth,downBoxHeight)
            let downBox = UIView(frame:downBoxFrame)
            
            downBox.backgroundColor = UIColor.todaitPurple()
            grayBox.addSubview(downBox)
            
            
            
            UIView.animateWithDuration(1.5, animations: { () -> Void in
                
                upBox.frame = boxNewFrame
                downBox.frame = downNewBoxFrame
                
            })
            
        }
        */
    }
    
    func addDoneDashPercent(){
        let totalPercentInfoLabel = UILabel(frame:CGRectMake(170*ratio,10*ratio,100*ratio,25*ratio))
        totalPercentInfoLabel.text = "평균 성취율"
        totalPercentInfoLabel.textColor = UIColor.todaitGray()
        totalPercentInfoLabel.font = UIFont(name:"AvenirNext-Regular",size:14*ratio)
        totalPercentInfoLabel.textAlignment = NSTextAlignment.Left
        doneDashView.addSubview(totalPercentInfoLabel)
        
        totalPercentLabel = UILabel(frame:CGRectMake(170*ratio,35*ratio,100*ratio,30*ratio))
        totalPercentLabel.text = "100%"
        totalPercentLabel.textColor = UIColor.todaitGreen()
        totalPercentLabel.font = UIFont(name:"AvenirNext-Regular",size:18*ratio)
        totalPercentLabel.textAlignment = NSTextAlignment.Right
        doneDashView.addSubview(totalPercentLabel)
        
    }
    
    func addDoneDashTime(){
        
        let totalTimeInfoLabel = UILabel(frame:CGRectMake(170*ratio,80*ratio,100*ratio,25*ratio))
        totalTimeInfoLabel.text = "총 공부 시간"
        totalTimeInfoLabel.textColor = UIColor.todaitGray()
        totalTimeInfoLabel.font = UIFont(name:"AvenirNext-Regular",size:14*ratio)
        totalTimeInfoLabel.textAlignment = NSTextAlignment.Left
        doneDashView.addSubview(totalTimeInfoLabel)
        
        totalTimeLabel = UILabel(frame:CGRectMake(170*ratio,105*ratio,100*ratio,30*ratio))
        totalTimeLabel.text = "00시간 00분"
        totalTimeLabel.textColor = UIColor.todaitGreen()
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
        progressLabel = UILabel(frame:CGRectMake(40*ratio,15*ratio,40*ratio,40*ratio))
        progressLabel.backgroundColor = UIColor.todaitGreen()
        progressLabel.layer.cornerRadius = 20*ratio
        progressLabel.clipsToBounds = true
        progressLabel.textAlignment = NSTextAlignment.Center
        progressLabel.textColor = UIColor.whiteColor()
        progressLabel.font = UIFont(name:"AvenirNext-Medium",size:14*ratio);
        progressLabel.text = "12"
        
        statusDashView.addSubview(progressLabel)
        
        let progressInfoLabel = UILabel(frame:CGRectMake(40*ratio,60*ratio,40*ratio,20*ratio))
        progressInfoLabel.textAlignment = NSTextAlignment.Center
        progressInfoLabel.textColor = UIColor.todaitGray()
        progressInfoLabel.font = UIFont(name:"AvenirNext-Medium",size:14*ratio);
        progressInfoLabel.text = "진행중"
        
        statusDashView.addSubview(progressInfoLabel)
        
        
        
    }
    
    func addCompleteCircle(){
        completeLabel = UILabel(frame:CGRectMake(125*ratio,15*ratio,40*ratio,40*ratio))
        completeLabel.backgroundColor = UIColor.todaitPurple()
        completeLabel.layer.cornerRadius = 20*ratio
        completeLabel.clipsToBounds = true
        completeLabel.textAlignment = NSTextAlignment.Center
        completeLabel.textColor = UIColor.whiteColor()
        completeLabel.font = UIFont(name:"AvenirNext-Medium",size:14*ratio);
        completeLabel.text = "21"
        
        statusDashView.addSubview(completeLabel)
        
        
        let completeInfoLabel = UILabel(frame:CGRectMake(125*ratio,60*ratio,40*ratio,20*ratio))
        completeInfoLabel.textAlignment = NSTextAlignment.Center
        completeInfoLabel.textColor = UIColor.todaitGray()
        completeInfoLabel.font = UIFont(name:"AvenirNext-Medium",size:14*ratio);
        completeInfoLabel.text = "완료"
        
        statusDashView.addSubview(completeInfoLabel)
    }
    
    func addIncompleteCircle(){
        incompleteLabel = UILabel(frame:CGRectMake(210*ratio,15*ratio,40*ratio,40*ratio))
        incompleteLabel.backgroundColor = UIColor.todaitRed()
        incompleteLabel.layer.cornerRadius = 20*ratio
        incompleteLabel.clipsToBounds = true
        incompleteLabel.textAlignment = NSTextAlignment.Center
        incompleteLabel.textColor = UIColor.whiteColor()
        incompleteLabel.font = UIFont(name:"AvenirNext-Medium",size:14*ratio);
        incompleteLabel.text = "3"
        
        statusDashView.addSubview(incompleteLabel)
        
        
        
        let incompleteInfoLabel = UILabel(frame:CGRectMake(210*ratio,60*ratio,40*ratio,20*ratio))
        incompleteInfoLabel.textAlignment = NSTextAlignment.Center
        incompleteInfoLabel.textColor = UIColor.todaitGray()
        incompleteInfoLabel.font = UIFont(name:"AvenirNext-Medium",size:14*ratio);
        incompleteInfoLabel.text = "미완료"
        
        statusDashView.addSubview(incompleteInfoLabel)
    }
    
    func addBarDashView(){
        barDashView = UIView(frame:CGRectMake(15*ratio,350*ratio,275*ratio/2,150*ratio))
        barDashView.backgroundColor = UIColor.whiteColor()
        barDashView.layer.cornerRadius = 4*ratio
        barDashView.clipsToBounds = true
        scrollView.addSubview(barDashView)
        
        addBarDashTableView()
        
    }
    
    func addBarDashTableView(){
        
        let barDashVC = BarDashViewController()
        barDashVC.dataSource = [ChartItem(color: UIColor.todaitGreen(), value: 80),
                                ChartItem(color: UIColor.todaitPurple(), value: 55),
                                ChartItem(color: UIColor.todaitRed(), value: 45)]
        
        addChildViewController(barDashVC)
        barDashVC.view.frame = CGRectMake(10*ratio,15*ratio,240*ratio/2,120*ratio)
        barDashVC.view.backgroundColor = UIColor.todaitLightGray()
        barDashView.addSubview(barDashVC.view)
        
    }
    
    func addPieDashView(){
        pieDashView = UIView(frame:CGRectMake(30*ratio+275*ratio/2,350*ratio,275*ratio/2,150*ratio))
        pieDashView.backgroundColor = UIColor.whiteColor()
        pieDashView.layer.cornerRadius = 4*ratio
        pieDashView.clipsToBounds = true
        scrollView.addSubview(pieDashView)

        addPieView()
    }
    
    func addPieView(){
        
        
        let pieChartItems:[PNPieChartDataItem] = [PNPieChartDataItem(value: 80, color: UIColor.todaitGreen()),
            PNPieChartDataItem(value: 50, color: UIColor.todaitPurple()),
            PNPieChartDataItem(value: 25, color: UIColor.todaitRed())]
        
        let pieChartView = PNPieChart(frame:CGRectMake(15*ratio,15*ratio,215*ratio/2,120*ratio),items:pieChartItems)
        
        pieChartView.descriptionTextColor = UIColor.todaitLightGray()
        pieChartView.descriptionTextFont = UIFont(name:"AvenirNext-Regular",size:14*ratio)
        pieChartView.descriptionTextShadowColor = UIColor.clearColor()
        
        pieDashView.addSubview(pieChartView)
        
        
        pieChartView.strokeChart()
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        todaitNavBar.todaitDelegate = self
        todaitNavBar.backButton.hidden = false
        todaitNavBar.shadowImage = UIImage()
        self.titleLabel.text = "Statistics"
        
    }
    
    
    func reloadData(){
        
        loadAverageDonePercentAndTotalTime()
        loadProgressStatusCount()
    
    }
    
    func loadAverageDonePercentAndTotalTime(){
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
            }else{
                
                if taskItem.isProgress(){
                    progressCount = progressCount + 1
                }else{
                    incompleteCount = incompleteCount + 1
                }
            }
        }
        
        progressLabel.text = "\(progressCount)"
        completeLabel.text = "\(completeCount)"
        incompleteLabel.text = "\(incompleteCount)"

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
