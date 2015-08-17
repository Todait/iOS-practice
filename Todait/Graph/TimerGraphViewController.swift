//
//  TimerGraphViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 8. 7..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class TimerGraphViewController: BasicViewController,TodaitNavigationDelegate{
   
    var scrollView:UIScrollView!
    var mainColor:UIColor!
    var task:Task!
    
    
    var weekDashView:UIView!
    var weekDoneTimeLabel:UILabel!
    
    var focusDashView:UIView!
    var trendDashView:UIView!
    
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    
    
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.todaitBackgroundGray()
        addScrollView()
        
        addWeekDashView()
        addFocusDashView()
        addTrendDashView()
        
        
    }
    
    func addScrollView(){
        scrollView = UIScrollView(frame:view.frame)
        scrollView.contentSize = CGSizeMake(320*ratio,668*ratio)
        scrollView.contentInset = UIEdgeInsetsMake(-17*ratio,0,0,0)
        view.addSubview(scrollView)
        
    }
    
    
    func addWeekDashView(){
        
        weekDashView = UIView(frame:CGRectMake(118*ratio,64 + 5*ratio,198*ratio,175*ratio))
        weekDashView.clipsToBounds = true
        weekDashView.layer.cornerRadius = 4*ratio
        weekDashView.backgroundColor = UIColor.whiteColor()
        scrollView.addSubview(weekDashView)
        
        
        addWeekView()
        addWeekPeriodChart()
    }
    
    func addWeekView(){
        
        let weekInfoLabel = UILabel(frame:CGRectMake(15*ratio, 13*ratio, 165*ratio, 12*ratio))
        weekInfoLabel.text = "주간 진행도"
        weekInfoLabel.textColor = UIColor.todaitDarkGray()
        weekInfoLabel.textAlignment = NSTextAlignment.Center
        weekInfoLabel.font = UIFont(name:"AppleSDGothicNeo-SemiBold",size:10*ratio)
        weekDashView.addSubview(weekInfoLabel)
        
        
        let periodInfoLabel = UILabel(frame:CGRectMake(15*ratio, 36*ratio, 165*ratio, 17*ratio))
        periodInfoLabel.text = "시간"
        periodInfoLabel.textColor = UIColor.todaitDarkGray()
        periodInfoLabel.textAlignment = NSTextAlignment.Center
        periodInfoLabel.font = UIFont(name:"AppleSDGothicNeo-SemiBold",size:15*ratio)
        weekDashView.addSubview(periodInfoLabel)
        
        
        weekDoneTimeLabel = UILabel(frame: CGRectMake(15*ratio, 50*ratio, 165*ratio, 20*ratio))
        weekDoneTimeLabel.text = "0시간 50분/1시간 00분"
        weekDoneTimeLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 8*ratio)
        weekDoneTimeLabel.textColor = UIColor.todaitGray()
        weekDoneTimeLabel.textAlignment = NSTextAlignment.Center
        weekDashView.addSubview(weekDoneTimeLabel)
        
        
    }
    
    
    
    func addWeekPeriodChart(){
        
        let weekSecondProgressData = task.getWeekTimeProgressData(NSDate())
        
        var weekChart = WeekMaxChart(frame: CGRectMake(10*ratio, 69*ratio, 180*ratio, 74*ratio))
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
        
        
        
        var weekLabel = WeekLabel(frame: CGRectMake(10*ratio, 154*ratio, 180*ratio, 9*ratio))
        weekLabel.weekFont = UIFont(name: "AppleSDGothicNeo-Medium", size: 7*ratio)
        weekLabel.weekColor = UIColor.todaitGray()
        weekLabel.updateLabelText(task.getWeekDateNumberShortString(NSDate()))
        weekDashView.addSubview(weekLabel)
        
        
    }
    
    func getTimeWeekProgressString(doneSecond:Int,expectSecond:Int)->String{
        
        return getTimeString(doneSecond) + " / " + getTimeString(expectSecond)
    }
    
    
    
    func addFocusDashView(){
        focusDashView = UIView(frame:CGRectMake(4*ratio,64 + 5*ratio,110*ratio,175*ratio))
        focusDashView.backgroundColor = UIColor.whiteColor()
        focusDashView.layer.cornerRadius = 4*ratio
        focusDashView.clipsToBounds = true
        scrollView.addSubview(focusDashView)
        
        addBarDashTableView()
        
    }
    
    
    func addBarDashTableView(){
        
        
        var focus:CGFloat = CGFloat(task.getAverageFocusScore().floatValue)
        
        let titleLabel = UILabel(frame:CGRectMake(15*ratio, 14*ratio, 80*ratio, 12*ratio))
        titleLabel.text = "집중도"
        titleLabel.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 10*ratio)
        titleLabel.textColor = UIColor.todaitDarkGray()
        titleLabel.textAlignment = NSTextAlignment.Center
        focusDashView.addSubview(titleLabel)
        
        
        let focusLabel = UILabel(frame: CGRectMake(15*ratio, 50*ratio, 80*ratio, 63*ratio))
        focusLabel.text = String(format: "%.1f", focus)
        focusLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 53*ratio)
        focusLabel.textAlignment = NSTextAlignment.Center
        focusLabel.textColor = UIColor.todaitDarkGray()
        focusDashView.addSubview(focusLabel)
        
        
        
        for index in 0...4 {
            
            var imageView = UIImageView(frame: CGRectMake(15*ratio + 17*ratio * CGFloat(index), 120*ratio, 14*ratio, 14*ratio))
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
                maskLayer.frame = CGRectMake(15*ratio + 17*ratio * CGFloat(index), 120*ratio, 14*ratio, 14*ratio)
                maskLayer.mask = colorLayer
                
                focusDashView.layer.addSublayer(maskLayer)
                
            }else{
                
                var imageView = UIImageView(frame: CGRectMake(15*ratio + 17*ratio * CGFloat(index), 120*ratio, 14*ratio, 14*ratio))
                imageView.image = UIImage(named: "detail_diary_input_star@3x.png")
                focusDashView.addSubview(imageView)
            }
        }
    }
    
    
    
    func addTrendDashView(){
        trendDashView = UIView(frame:CGRectMake(4*ratio,64 + 184*ratio,312*ratio,160*ratio))
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
}
