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
    var weekDoneAmountLabel:UILabel!
    var weekDoneTimeLabel:UILabel!
    
    var focusDashView:UIView!
    var trendDashView:UIView!
    
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.todaitBackgroundGray()
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
        scrollView.contentInset = UIEdgeInsetsMake(-17*ratio,0,0,0)
        view.addSubview(scrollView)
        
    }
    
    
    func addTotalDashView(){
        
        totalDashView = UIView(frame:CGRectMake(4*ratio,64+5*ratio,110*ratio,184*ratio))
        totalDashView.clipsToBounds = true
        totalDashView.layer.cornerRadius = 4*ratio
        totalDashView.backgroundColor = UIColor.whiteColor()
        scrollView.addSubview(totalDashView)
        
        addTotalInfoLabel()
        addTotalChartView()
        
    }
    
    func addTotalInfoLabel(){
        
        let totalInfoLabel = UILabel(frame:CGRectMake(15*ratio, 17*ratio, 80*ratio, 12*ratio))
        totalInfoLabel.text = "전체 진행도"
        totalInfoLabel.textColor = UIColor.todaitDarkGray()
        totalInfoLabel.textAlignment = NSTextAlignment.Center
        totalInfoLabel.font = UIFont(name:"AppleSDGothicNeo-SemiBold",size:10*ratio)
        totalDashView.addSubview(totalInfoLabel)
        
    }
    
    func addTotalChartView(){
        
        var amountChart = ReverseCircleChart(frame: CGRectMake(15*ratio, 45*ratio, 80*ratio, 80*ratio))
        amountChart.chartColor = UIColor.todaitRed()
        amountChart.lineColor = UIColor.colorWithHexString("#F9EAEA")
        amountChart.chartBorderWidth = 7*ratio
        amountChart.strokeEnd = CGFloat(task.getPercentOfDoneAmount())/100
        amountChart.strokeChart()
        totalDashView.addSubview(amountChart)
        
        
        var periodChart = ReverseCircleChart(frame: CGRectMake(23*ratio, 53*ratio, 64*ratio, 64*ratio))
        periodChart.chartColor = UIColor.todaitBlue()
        periodChart.chartBorderWidth = 5.5*ratio
        periodChart.lineColor = UIColor.colorWithHexString("#DAEAF6")
        periodChart.strokeEnd = CGFloat(task.getPercentOfPeriodProgress())/100
        periodChart.strokeChart()
        totalDashView.addSubview(periodChart)
        
        
        var amountInfoLabel = UILabel(frame:CGRectMake(21*ratio,137*ratio,100*ratio,12*ratio))
        amountInfoLabel.text = "분량"
        amountInfoLabel.textAlignment = NSTextAlignment.Left
        amountInfoLabel.font = UIFont(name: "AppleSDGothicNeo-Light", size: 10*ratio)
        amountInfoLabel.textColor = UIColor.todaitDarkGray()
        totalDashView.addSubview(amountInfoLabel)
        
        
        var amountPercentLabel = UILabel(frame:CGRectMake(57*ratio,134*ratio,100*ratio,17*ratio))
        amountPercentLabel.text = String(format: "%.0f%@",CGFloat(task.getPercentOfDoneAmount()),"%")
        amountPercentLabel.textAlignment = NSTextAlignment.Left
        amountPercentLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 15*ratio)
        amountPercentLabel.textColor = UIColor.todaitRed()
        totalDashView.addSubview(amountPercentLabel)
        
        
        
        
        var periodInfoLabel = UILabel(frame:CGRectMake(21*ratio,158*ratio,100*ratio,12*ratio))
        periodInfoLabel.text = "기간"
        periodInfoLabel.textAlignment = NSTextAlignment.Left
        periodInfoLabel.font = UIFont(name: "AppleSDGothicNeo-Light", size: 10*ratio)
        periodInfoLabel.textColor = UIColor.todaitDarkGray()
        totalDashView.addSubview(periodInfoLabel)
        
        
        
        var periodPercentLabel = UILabel(frame:CGRectMake(57*ratio,151*ratio,100*ratio,25*ratio))
        periodPercentLabel.text = String(format: "%.0f%@",CGFloat(task.getPercentOfPeriodProgress()),"%")
        periodPercentLabel.textAlignment = NSTextAlignment.Left
        periodPercentLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 15*ratio)
        periodPercentLabel.textColor = UIColor.todaitBlue()
        totalDashView.addSubview(periodPercentLabel)
        
        
    }
    
    
    
    
    
    func addWeekDashView(){
        
        weekDashView = UIView(frame:CGRectMake(118*ratio,64 + 5*ratio,198*ratio,328*ratio))
        weekDashView.clipsToBounds = true
        weekDashView.layer.cornerRadius = 4*ratio
        weekDashView.backgroundColor = UIColor.whiteColor()
        scrollView.addSubview(weekDashView)
        
        
        addWeekView()
        addWeekAmountChart()
        addWeekPeriodChart()
    }
    
    func addWeekView(){
        
        let weekInfoLabel = UILabel(frame:CGRectMake(15*ratio, 17*ratio, 165*ratio, 12*ratio))
        weekInfoLabel.text = "주간 진행도"
        weekInfoLabel.textColor = UIColor.todaitDarkGray()
        weekInfoLabel.textAlignment = NSTextAlignment.Center
        weekInfoLabel.font = UIFont(name:"AppleSDGothicNeo-SemiBold",size:10*ratio)
        weekDashView.addSubview(weekInfoLabel)
        
        
        let amountInfoLabel = UILabel(frame:CGRectMake(15*ratio, 38*ratio, 165*ratio, 17*ratio))
        amountInfoLabel.text = "분량"
        amountInfoLabel.textColor = UIColor.todaitDarkGray()
        amountInfoLabel.textAlignment = NSTextAlignment.Center
        amountInfoLabel.font = UIFont(name:"AppleSDGothicNeo-SemiBold",size:15*ratio)
        weekDashView.addSubview(amountInfoLabel)
        
        
        weekDoneAmountLabel = UILabel(frame: CGRectMake(15*ratio, 56*ratio, 165*ratio, 20*ratio))
        weekDoneAmountLabel.text = "8/11문제"
        weekDoneAmountLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 8*ratio)
        weekDoneAmountLabel.textColor = UIColor.todaitGray()
        weekDoneAmountLabel.textAlignment = NSTextAlignment.Center
        weekDashView.addSubview(weekDoneAmountLabel)
        
        
        let periodInfoLabel = UILabel(frame:CGRectMake(15*ratio, 193*ratio, 165*ratio, 17*ratio))
        periodInfoLabel.text = "시간"
        periodInfoLabel.textColor = UIColor.todaitDarkGray()
        periodInfoLabel.textAlignment = NSTextAlignment.Center
        periodInfoLabel.font = UIFont(name:"AppleSDGothicNeo-SemiBold",size:15*ratio)
        weekDashView.addSubview(periodInfoLabel)
        
        
        weekDoneTimeLabel = UILabel(frame: CGRectMake(15*ratio, 213*ratio, 165*ratio, 20*ratio))
        weekDoneTimeLabel.text = "0시간 50분/1시간 00분"
        weekDoneTimeLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 8*ratio)
        weekDoneTimeLabel.textColor = UIColor.todaitGray()
        weekDoneTimeLabel.textAlignment = NSTextAlignment.Center
        weekDashView.addSubview(weekDoneTimeLabel)
        
        
    }
    
    
    
    func addWeekAmountChart(){
        
        let weekAmountProgressData = task.getWeekAmountProgressData(NSDate())
        
        
        var weekChart = WeekMaxChart(frame: CGRectMake(10*ratio, 75*ratio, 180*ratio, 74*ratio))
        weekChart.direction = weekChartDirection.upDirection
        weekChart.frontColor = UIColor.todaitRed()
        weekChart.backColor = UIColor.colorWithHexString("#F9EAEA")
        weekChart.chartWidth = 10*ratio
        weekChart.chartFont = UIFont(name: "AppleSDGothicNeo-UltraLight", size: 8*ratio)
        weekChart.updateChart(weekAmountProgressData)
        weekDashView.addSubview(weekChart)
        
        
        var weekExpectAmount:Int = 0
        var weekDoneAmount:Int = 0
        
        for chartItem in weekAmountProgressData {
            weekDoneAmount = weekDoneAmount + chartItem["done"]!.integerValue
            weekExpectAmount = weekExpectAmount + chartItem["expect"]!.integerValue
        }
        
        weekDoneAmountLabel.text = getAmountWeekProgressString(weekDoneAmount, expectAmount: weekExpectAmount)
        
        
        
        var weekLabel = WeekLabel(frame: CGRectMake(10*ratio, 153*ratio, 180*ratio, 9*ratio))
        weekLabel.weekFont = UIFont(name: "AppleSDGothicNeo-Medium", size: 7*ratio)
        weekLabel.weekColor = UIColor.todaitGray()
        weekLabel.updateLabelText(task.getWeekDateNumberShortString(NSDate()))
        weekDashView.addSubview(weekLabel)
        
    }
    
    
    func getAmountWeekProgressString(doneAmount:Int,expectAmount:Int)->String{
        return "\(doneAmount)/\(expectAmount)" + task.unit
    }
    
    func addWeekPeriodChart(){
        
        let weekSecondProgressData = task.getWeekTimeProgressData(NSDate())
        
        var weekChart = WeekMaxChart(frame: CGRectMake(10*ratio, 230*ratio, 180*ratio, 74*ratio))
        weekChart.direction = weekChartDirection.upDirection
        weekChart.frontColor = UIColor.todaitBlue()
        weekChart.backColor = UIColor.colorWithHexString("#DAEAF6")
        weekChart.chartWidth = 10*ratio
        weekChart.chartFont = UIFont(name: "AppleSDGothicNeo-UltraLight", size: 8*ratio)
        weekChart.updateTimeChart(weekSecondProgressData)
        weekDashView.addSubview(weekChart)
        
        
        var weekExpectSecond:Int = 0
        var weekDoneSecond:Int = 0
        
        for chartItem in weekSecondProgressData {
            weekDoneSecond = weekDoneSecond + chartItem["done"]!.integerValue
            weekExpectSecond = weekExpectSecond + chartItem["expect"]!.integerValue
        }
        
        weekDoneTimeLabel.text = getTimeWeekProgressString(weekDoneSecond, expectSecond: weekExpectSecond)
        
        
        
        var weekLabel = WeekLabel(frame: CGRectMake(10*ratio, 308*ratio, 180*ratio, 9*ratio))
        weekLabel.weekFont = UIFont(name: "AppleSDGothicNeo-Medium", size: 7*ratio)
        weekLabel.weekColor = UIColor.todaitGray()
        weekLabel.updateLabelText(task.getWeekDateNumberShortString(NSDate()))
        weekDashView.addSubview(weekLabel)
        
        
    }
    
    func getTimeWeekProgressString(doneSecond:Int,expectSecond:Int)->String{
        
        return getTimeString(doneSecond) + " / " + getTimeString(expectSecond)
    }
    
    
    
    func addFocusDashView(){
        focusDashView = UIView(frame:CGRectMake(4*ratio,64 + 193*ratio,110*ratio,140*ratio))
        focusDashView.backgroundColor = UIColor.whiteColor()
        focusDashView.layer.cornerRadius = 4*ratio
        focusDashView.clipsToBounds = true
        scrollView.addSubview(focusDashView)
        
        addBarDashTableView()
        
    }
    
    
    func addBarDashTableView(){
        
        
        var focus:CGFloat = CGFloat(task.getAverageFocusScore().floatValue)
        
        let titleLabel = UILabel(frame:CGRectMake(15*ratio, 17*ratio, 80*ratio, 12*ratio))
        titleLabel.text = "집중도"
        titleLabel.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 10*ratio)
        titleLabel.textColor = UIColor.todaitDarkGray()
        titleLabel.textAlignment = NSTextAlignment.Center
        focusDashView.addSubview(titleLabel)
        
        
        let focusLabel = UILabel(frame: CGRectMake(15*ratio, 40*ratio, 80*ratio, 63*ratio))
        focusLabel.text = String(format: "%.1f", focus)
        focusLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 53*ratio)
        focusLabel.textAlignment = NSTextAlignment.Center
        focusLabel.textColor = UIColor.todaitDarkGray()
        focusDashView.addSubview(focusLabel)
        
        
        
        for index in 0...4 {
            
            var imageView = UIImageView(frame: CGRectMake(15*ratio + 17*ratio * CGFloat(index), 108*ratio, 14*ratio, 14*ratio))
            imageView.image = UIImage(named: "detail_basic_30@3x.png")
            
            focusDashView.addSubview(imageView)
            
            
            if index > Int(focus) {
                
            }else if index == Int(focus){
                
                //imageView.image = UIImage(named: "ic_fragment_diary_rating_disabled.png")
                var percent = focus - CGFloat(index)
                
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
                maskLayer.contents = UIImage(named: "detail_diary_input_star@3x.png")!.CGImage
                maskLayer.frame = CGRectMake(15*ratio + 17*ratio * CGFloat(index), 108*ratio, 14*ratio, 14*ratio)
                maskLayer.mask = colorLayer
                
                focusDashView.layer.addSublayer(maskLayer)
                
            }else{
                
                var imageView = UIImageView(frame: CGRectMake(15*ratio + 17*ratio * CGFloat(index), 108*ratio, 14*ratio, 14*ratio))
                imageView.image = UIImage(named: "detail_diary_input_star@3x.png")
                focusDashView.addSubview(imageView)
            }
        }
    }
    
    
    
    func addTrendDashView(){
        trendDashView = UIView(frame:CGRectMake(4*ratio,64 + 337*ratio,312*ratio,160*ratio))
        trendDashView.backgroundColor = UIColor.whiteColor()
        trendDashView.layer.cornerRadius = 4*ratio
        trendDashView.clipsToBounds = true
        scrollView.addSubview(trendDashView)
        
        addTrendLabel()
        addTrendChart()
    }
    
    func addTrendLabel(){
        
        let trendLabel = UILabel(frame:CGRectMake(11*ratio,12*ratio,290*ratio,12*ratio))
        trendLabel.textAlignment = NSTextAlignment.Center
        trendLabel.text = "트랜드"
        trendLabel.textColor = UIColor.todaitDarkGray()
        trendLabel.font = UIFont(name:"AppleSDGothicNeo-Semibold",size:10*ratio)
        trendDashView.addSubview(trendLabel)
        
    }
    
    func addTrendChart(){
        
        
        
        addYAxisLabel()
        
        var trendChart = TrendChartView(frame:CGRectMake(28*ratio,36*ratio,270*ratio,123*ratio))
        trendChart.backgroundColor = UIColor.clearColor()
        trendChart.width = 40*ratio
        trendChart.updateChart(task.getTrendData())
        
        
        trendDashView.addSubview(trendChart)
        
        
        
        
        
        
    }
    
    
    func addYAxisLabel(){
        
        for index in 0...5 {
            
            let yAxixLabel = UILabel(frame: CGRectMake(15*ratio, 30.5*ratio + CGFloat(index)*CGFloat(16*ratio), 50*ratio, 9*ratio))
            yAxixLabel.text = String(format: "%.0f%", arguments: [(120-CGFloat(index)*20)])
            
            yAxixLabel.textAlignment = NSTextAlignment.Left
            yAxixLabel.textColor = UIColor.todaitGray()
            yAxixLabel.font = UIFont(name: "AppleSDGothicNeo-Ultralight", size: 7*ratio)
            
            trendDashView.addSubview(yAxixLabel)
            
            
            var count = CGFloat(task.dayList.count)
       
            
            if index == 1 {
                
                let line = UIView(frame:CGRectMake(28*ratio, 35*ratio + CGFloat(index)*CGFloat(16*ratio) , 278*ratio, 2))
                line.backgroundColor = UIColor.todaitBackgroundGray()
                trendDashView.addSubview(line)
                
            }else{
                
                let line = UIView(frame:CGRectMake(28*ratio, 35*ratio + CGFloat(index)*CGFloat(16*ratio) , 278*ratio, 1))
                line.backgroundColor = UIColor.todaitBackgroundGray()
                trendDashView.addSubview(line)
            }
            
            
        }
        
    }
    
    func getYAxisValue(maxValue:CGFloat)->[String]{
        
        
        return ["20%","40%","60%","80%","100%","120%"]
    }
    
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        todaitNavBar.todaitDelegate = self
        todaitNavBar.backButton.hidden = false
        todaitNavBar.shadowImage = UIImage()
        self.titleLabel.text = task.categoryId.name + " - " + task.name
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
