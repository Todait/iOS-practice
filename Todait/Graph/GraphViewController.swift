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
    
    
    
    
    
    func addWeekDashView(){
        
        weekDashView = UIView(frame:CGRectMake(120*ratio,64 + 5*ratio,195*ratio,383*ratio))
        weekDashView.clipsToBounds = true
        weekDashView.layer.cornerRadius = 4*ratio
        weekDashView.backgroundColor = UIColor.whiteColor()
        scrollView.addSubview(weekDashView)
        
        
        addWeekView()
        addWeekAmountChart()
        addWeekPeriodChart()
    }
    
    func addWeekView(){
        
        let weekInfoLabel = UILabel(frame:CGRectMake(15*ratio, 22*ratio, 165*ratio, 20*ratio))
        weekInfoLabel.text = "주간 진행도"
        weekInfoLabel.textColor = UIColor.todaitGray()
        weekInfoLabel.textAlignment = NSTextAlignment.Center
        weekInfoLabel.font = UIFont(name:"AppleSDGothicNeo-SemiBold",size:10*ratio)
        weekDashView.addSubview(weekInfoLabel)
        
        
        let amountInfoLabel = UILabel(frame:CGRectMake(15*ratio, 50*ratio, 165*ratio, 20*ratio))
        amountInfoLabel.text = "분량"
        amountInfoLabel.textColor = UIColor.todaitGray()
        amountInfoLabel.textAlignment = NSTextAlignment.Center
        amountInfoLabel.font = UIFont(name:"AppleSDGothicNeo-SemiBold",size:15*ratio)
        weekDashView.addSubview(amountInfoLabel)
        
        
        let periodInfoLabel = UILabel(frame:CGRectMake(15*ratio, 250*ratio, 165*ratio, 20*ratio))
        periodInfoLabel.text = "시간"
        periodInfoLabel.textColor = UIColor.todaitGray()
        periodInfoLabel.textAlignment = NSTextAlignment.Center
        periodInfoLabel.font = UIFont(name:"AppleSDGothicNeo-SemiBold",size:15*ratio)
        weekDashView.addSubview(periodInfoLabel)
        
    }
    
    
    func addWeekAmountChart(){
        
        
        var weekChart = WeekMaxChart(frame: CGRectMake(15*ratio, 88*ratio, 165*ratio, 94*ratio))
        weekChart.direction = weekChartDirection.upDirection
        weekChart.frontColor = UIColor.todaitRed()
        weekChart.backColor = UIColor.colorWithHexString("#F9EAEA")
        weekChart.chartWidth = 10*ratio
        weekChart.chartFont = UIFont(name: "AppleSDGothicNeo-UltraLight", size: 7.5*ratio)
        weekChart.updateChart([["doneAmount":15,"expectAmount":50],["doneAmount":15,"expectAmount":20],["doneAmount":15,"expectAmount":20],["doneAmount":10,"expectAmount":35],["doneAmount":20,"expectAmount":20],["doneAmount":15,"expectAmount":20],["doneAmount":30,"expectAmount":55]])
        
        weekDashView.addSubview(weekChart)
        
        
        var weekLabel = WeekLabel(frame: CGRectMake(15*ratio, 190*ratio, 165*ratio, 20*ratio))
        weekLabel.weekFont = UIFont(name: "AppleSDGothicNeo-Medium", size: 6*ratio)
        weekLabel.weekColor = UIColor.todaitGray()
        weekLabel.updateLabelText(task.getWeekDateNumberShortString(NSDate()))
        weekDashView.addSubview(weekLabel)
        
    }
    
    func addWeekPeriodChart(){
        
        
        var weekChart = WeekMaxChart(frame: CGRectMake(15*ratio, 268*ratio, 165*ratio, 94*ratio))
        weekChart.direction = weekChartDirection.upDirection
        weekChart.frontColor = UIColor.todaitBlue()
        weekChart.backColor = UIColor.colorWithHexString("#DAEAF6")
        weekChart.chartWidth = 10*ratio
        weekChart.chartFont = UIFont(name: "AppleSDGothicNeo-UltraLight", size: 7.5*ratio)
        
        weekChart.updateChart([["doneAmount":15,"expectAmount":20],["doneAmount":15,"expectAmount":20],["doneAmount":15,"expectAmount":20],["doneAmount":60,"expectAmount":70],["doneAmount":40,"expectAmount":20],["doneAmount":15,"expectAmount":20],["doneAmount":80,"expectAmount":60]])
        
        weekDashView.addSubview(weekChart)
        
        
        var weekLabel = WeekLabel(frame: CGRectMake(15*ratio, 360*ratio, 165*ratio, 20*ratio))
        weekLabel.weekFont = UIFont(name: "AppleSDGothicNeo-Medium", size: 6*ratio)
        weekLabel.weekColor = UIColor.todaitGray()
        weekLabel.updateLabelText(task.getWeekDateNumberShortString(NSDate()))
        weekDashView.addSubview(weekLabel)
        
        
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
        
        
        
        var focusScore:CGFloat = 3.4
        
        for index in 0...4 {
            
            var imageView = UIImageView(frame: CGRectMake(15*ratio + 17*ratio * CGFloat(index), 125*ratio, 14*ratio, 14*ratio))
            imageView.image = UIImage(named: "ic_fragment_diary_rating_disabled.png")
            
            focusDashView.addSubview(imageView)
            
            
            if index > Int(focusScore) {
                
            }else if index == Int(focusScore){
                
                //imageView.image = UIImage(named: "ic_fragment_diary_rating_disabled.png")
                var percent = focusScore - CGFloat(index)
                
                var path = UIBezierPath()
                path.moveToPoint(CGPointMake(0*ratio,7*ratio))
                path.addLineToPoint(CGPointMake(14*ratio,7*ratio))
                
                
                var colorLayer = CAShapeLayer()
                colorLayer.path = path.CGPath
                //colorLayer.frame = CGRectMake(15*ratio + 17*ratio * CGFloat(index), 125*ratio, 14*ratio, 14*ratio)
                colorLayer.fillColor = UIColor.todaitGreen().CGColor
                colorLayer.strokeColor = UIColor.todaitRed().CGColor
                colorLayer.strokeStart = 0
                colorLayer.strokeEnd = percent
                colorLayer.lineWidth = 14*ratio
                
                //focusDashView.layer.addSublayer(colorLayer)
                
                
                var maskLayer = CALayer()
                maskLayer.contents = UIImage(named: "ic_fragment_diary_rating.png")!.CGImage
                maskLayer.frame = CGRectMake(15*ratio + 17*ratio * CGFloat(index), 125*ratio, 14*ratio, 14*ratio)
                maskLayer.mask = colorLayer
                
                focusDashView.layer.addSublayer(maskLayer)
                
            }else{
                
                var imageView = UIImageView(frame: CGRectMake(15*ratio + 17*ratio * CGFloat(index), 125*ratio, 14*ratio, 14*ratio))
                imageView.image = UIImage(named: "ic_fragment_diary_rating.png")
                focusDashView.addSubview(imageView)
            }
        }
    }
    
    
    
    func addTrendDashView(){
        trendDashView = UIView(frame:CGRectMake(5*ratio,452*ratio,310*ratio,250*ratio))
        trendDashView.backgroundColor = UIColor.whiteColor()
        trendDashView.layer.cornerRadius = 4*ratio
        trendDashView.clipsToBounds = true
        scrollView.addSubview(trendDashView)
        
        addTrendChart()
    }
    
    func addTrendChart(){
        
        
        
        var trendChart = TrendChartView(frame:CGRectMake(30*ratio,45*ratio,280*ratio,155*ratio))
        trendChart.backgroundColor = UIColor.whiteColor()
        trendChart.width = 40*ratio
        trendChart.updateChart(
            [["color":UIColor.todaitBlue(),"value":[0.5,0.3,0.8,0.9,0,0.3,0.6,0.7,0.9,0.5,0.3,0.8,0.9,0,0.3,0.6,0.7,0.9]],
            ["color":UIColor.todaitRed(),"value":[0.7,0.9,0.5,0.3,0.8,0.5,0.3,0.8,0.9,0,0.3,0.6,0.9,0.3,0.6,0.7,0.9,0.5]]])
        
        
        trendDashView.addSubview(trendChart)
        
    }
    
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        todaitNavBar.todaitDelegate = self
        todaitNavBar.backButton.hidden = false
        todaitNavBar.shadowImage = UIImage()
        self.titleLabel.text = task.category_id.name + " - " + task.name
        self.screenName = "Statistics Activity"
        
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
