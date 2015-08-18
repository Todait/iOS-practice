//
//  NewGoalStep3TimeViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 8. 5..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class NewGoalStep3TimeViewController: BasicViewController,ThumbChartDelegate ,TodaitNavigationDelegate{
   
    
    
    
    var maxTime:CGFloat! = 3600
    
    var amountView:UIView!
    var baseView:UIView!
    var startLabel:UILabel!
    var endLabel:UILabel!
    var infoLabel:UILabel!
    
    var nextButton:UIButton!
    
    var everydayButton:ColorButton!
    var weekdayButton:ColorButton!
    var weekendButton:ColorButton!
    
    
    var timeTask = TimeTask.sharedInstance
    
    let weekTitle = ["SUN","MON","TUE","WED","THU","FRI","SAT"]
    let weekValue = [1,2,4,8,16,32,64]
    var selectedWeekDays:Int = 0
    
    
    var weekLabels:[ColorLabel] = []
    var timeLabels:[ColorLabel] = []
    var amountLabels:[ColorLabel] = []
    var weekButtons:[ColorButton] = []
    var weekCharts:[ThumbChartBox] = []
    
    
    var isThumbed:Bool! = false
    var maxChangeTimer:NSTimer?
    var maxChangeTimeCount:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.todaitBackgroundGray()
        
        addBaseView()
        
        addAmountView()
        
        addDateButton()
        addTimeLabels()
        addChartView()
        addWeekButtons()
        addInfoLabel()
        setEveryday()
        
    }
 
    
    func addBaseView(){
        
        baseView = UIView(frame: CGRectMake(2*ratio, 64 + 2*ratio, 316*ratio, 344*ratio))
        baseView.backgroundColor = UIColor.whiteColor()
        view.addSubview(baseView)
    }
    
    func addAmountView(){
        
        for var index = 0 ; index < 7 ; index++ {
            
            let weekLabel = ColorLabel(frame:CGRectMake(1*ratio + CGFloat(index)*45*ratio,9*ratio,44*ratio,19*ratio))
            weekLabel.textAlignment = NSTextAlignment.Center
            weekLabel.font = UIFont(name: "AppleSDGothicNeo-Light", size: 8*ratio)
            weekLabel.text = weekTitle[index]
            baseView.addSubview(weekLabel)
            
            weekLabels.append(weekLabel)
            
            switch index as Int {
            case 0:weekLabel.textOnColor = UIColor.todaitRed() ; weekLabel.textOffColor = UIColor.todaitLightRed()
            case 6:weekLabel.textOnColor = UIColor.todaitBlue() ; weekLabel.textOffColor = UIColor.todaitLightBlue()
            default: weekLabel.textOnColor = UIColor.todaitGray() ; weekLabel.textOffColor = UIColor.todaitBackgroundGray()
            }
            
            weekLabel.setLabelOn(true)
        }
        
        
        for var index = 0 ; index < 7 ; index++ {
            
            
            let amountLabel = ColorLabel(frame:CGRectMake(1*ratio + CGFloat(index)*45*ratio,28*ratio,44*ratio,30*ratio))
            amountLabel.textAlignment = NSTextAlignment.Center
            amountLabel.font = UIFont(name: "AppleSDGothicNeo-Light", size: 14*ratio)
            amountLabel.adjustsFontSizeToFitWidth = true
            amountLabel.text = "10개"
            baseView.addSubview(amountLabel)
            
            amountLabels.append(amountLabel)
            
            switch index as Int {
            case 0:amountLabel.textOnColor = UIColor.todaitRed() ; amountLabel.textOffColor = UIColor.todaitLightRed()
            case 6:amountLabel.textOnColor = UIColor.todaitBlue() ; amountLabel.textOffColor = UIColor.todaitLightBlue()
            default: amountLabel.textOnColor = UIColor.todaitGray() ; amountLabel.textOffColor = UIColor.todaitBackgroundGray()
            }
            
            amountLabel.setLabelOn(true)
            
        }
        
    }
    
    func addDateButton(){
        
        everydayButton = ColorButton(frame:CGRectMake(16*ratio, 66*ratio, 30*ratio, 17*ratio))
        everydayButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Light", size: 8*ratio)
        everydayButton.setTitle("매일", forState: UIControlState.Normal)
        everydayButton.layer.cornerRadius = 5
        everydayButton.clipsToBounds = true
        everydayButton.normalTitleColor = UIColor.todaitDarkGray()
        everydayButton.highlightedTitleColor = UIColor.whiteColor()
        everydayButton.normalBackgroundColor = UIColor.todaitBackgroundGray()
        everydayButton.highlightedBackgroundColor = UIColor.todaitGreen()
        everydayButton.addTarget(self, action: Selector("setEveryday"), forControlEvents: UIControlEvents.TouchDown)
        everydayButton.setButtonOn(false)
        baseView.addSubview(everydayButton)
        
        
        weekdayButton = ColorButton(frame:CGRectMake(54*ratio, 66*ratio, 30*ratio, 17*ratio))
        weekdayButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Light", size: 8*ratio)
        weekdayButton.setTitle("주중", forState: UIControlState.Normal)
        weekdayButton.layer.cornerRadius = 5
        weekdayButton.clipsToBounds = true
        weekdayButton.normalTitleColor = UIColor.todaitDarkGray()
        weekdayButton.highlightedTitleColor = UIColor.whiteColor()
        weekdayButton.normalBackgroundColor = UIColor.todaitBackgroundGray()
        weekdayButton.highlightedBackgroundColor = UIColor.todaitGreen()
        weekdayButton.addTarget(self, action: Selector("setWeekday"), forControlEvents: UIControlEvents.TouchDown)
        weekdayButton.setButtonOn(false)
        baseView.addSubview(weekdayButton)
        
        
        
        weekendButton = ColorButton(frame:CGRectMake(92*ratio, 66*ratio, 30*ratio, 16*ratio))
        weekendButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Light", size: 8*ratio)
        weekendButton.setTitle("주말", forState: UIControlState.Normal)
        weekendButton.layer.cornerRadius = 5
        weekendButton.clipsToBounds = true
        weekendButton.normalTitleColor = UIColor.todaitDarkGray()
        weekendButton.highlightedTitleColor = UIColor.whiteColor()
        weekendButton.normalBackgroundColor = UIColor.todaitBackgroundGray()
        weekendButton.highlightedBackgroundColor = UIColor.todaitGreen()
        weekendButton.setButtonOn(false)
        weekendButton.addTarget(self, action: Selector("setWeekend"), forControlEvents: UIControlEvents.TouchDown)
        baseView.addSubview(weekendButton)
        
    }
    
    /*
    func addAmountLabels(){
        
        for var index = 0 ; index < 7 ; index++ {
            
            let amountLabel = ColorLabel(frame:CGRectMake(1*ratio + CGFloat(index)*45*ratio,90*ratio,44*ratio,22*ratio))
            amountLabel.textAlignment = NSTextAlignment.Center
            amountLabel.textOnColor = UIColor.todaitGray()
            amountLabel.textOffColor = UIColor.todaitBackgroundGray()
            amountLabel.font = UIFont(name: "AppleSDGothicNeo-Light", size: 8*ratio)
            amountLabel.text = "\(dayAmount)개"
            baseView.addSubview(amountLabel)
            
            amountLabels.append(amountLabel)
        }
        
    }
    */
    
    func addTimeLabels(){
        
        for var index = 0 ; index < 7 ; index++ {
            
            let timeLabel = ColorLabel(frame:CGRectMake(1*ratio + CGFloat(index)*45*ratio,90*ratio,44*ratio,22*ratio))
            timeLabel.textAlignment = NSTextAlignment.Center
            timeLabel.textOnColor = UIColor.todaitGray()
            timeLabel.textOffColor = UIColor.todaitBackgroundGray()
            timeLabel.font = UIFont(name: "AppleSDGothicNeo-Light", size: 8*ratio)
            timeLabel.text = "1:00"
            baseView.addSubview(timeLabel)
            
            timeLabels.append(timeLabel)
        }
        
    }
    
    func addChartView(){
        
        for var index = 0 ; index < 7 ; index++ {
            
            let thumbChartBox = ThumbChartBox(frame:CGRectMake(14*ratio + CGFloat(index)*45*ratio,113*ratio,20*ratio,160*ratio))
            thumbChartBox.frontOnColor = UIColor.todaitGreen()
            thumbChartBox.frontOffColor = UIColor.todaitLightGray()
            thumbChartBox.maxColor = UIColor.colorWithHexString("#95CCC4")
            
            thumbChartBox.maxValue = CGFloat(maxTime)
            thumbChartBox.currentValue = CGFloat(3600)
            thumbChartBox.setStroke()
            thumbChartBox.delegate = self
            
            baseView.addSubview(thumbChartBox)
            weekCharts.append(thumbChartBox)
            
        }
    }
    
    func addWeekButtons(){
        
        
        
        
        
        for var index = 0 ; index < 7 ; index++ {
            
            let weekButton = ColorButton(frame:CGRectMake(1*ratio + CGFloat(index)*45*ratio,280*ratio,44*ratio,19*ratio))
            weekButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 8*ratio)
            weekButton.setTitle(weekTitle[index], forState: UIControlState.Normal)
            //weekButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            //weekButton.setBackgroundImage(UIImage.colorImage(UIColor.todaitGreen(), frame: CGRectMake(0,0,44*ratio,19*ratio)), forState: UIControlState.Normal)
            weekButton.tag = index
            weekButton.addTarget(self, action: Selector("weekButtonClk:"), forControlEvents: UIControlEvents.TouchDown)
            
            
            if index == 0 { weekButton.normalTitleColor = UIColor.todaitRed()}
            else if index == 6 { weekButton.normalTitleColor = UIColor.todaitBlue()}
            else{ weekButton.normalTitleColor = UIColor.todaitGray()}
            
            
            weekButton.normalBackgroundColor = UIColor.whiteColor()
            weekButton.highlightedTitleColor = UIColor.whiteColor()
            weekButton.highlightedBackgroundColor = UIColor.todaitGreen()
            
            
            baseView.addSubview(weekButton)
            weekButtons.append(weekButton)
        }
        
    }
    
    func weekButtonClk(button:ColorButton){
        
        button.setButtonOn(!button.buttonOn)
        dayOnAtIndex(button.tag, on: button.buttonOn)
        refreshButtons()
        needToChartUpdate()
        
    }
    
    
    func addInfoLabel(){
        
        infoLabel = UILabel(frame:CGRectMake(20*ratio,311*ratio,276*ratio,18*ratio))
        infoLabel.text = "시간 변경시 막대를 움직이거나 시간을 터치하세요"
        infoLabel.textAlignment = NSTextAlignment.Center
        infoLabel.textColor = UIColor.todaitGray()
        infoLabel.font = UIFont(name: "AppleSDGothicNeo-Light", size: 8*ratio)
        baseView.addSubview(infoLabel)
        
    }
    
    
    func dayOnAtIndex(index:Int,on:Bool){
        
        
        
        
        let weekButton = weekButtons[index]
        let thumbChart = weekCharts[index]
        let timeLabel = timeLabels[index]
        let weekLabel = weekLabels[index]
        let amountLabel = amountLabels[index]
        
        
        amountLabel.setLabelOn(on)
        weekLabel.setLabelOn(on)
        timeLabel.setLabelOn(on)
        weekButton.setButtonOn(on)
        thumbChart.setChartOn(on)
        
        
        if on == true {
            selectedWeekDays = selectedWeekDays | weekValue[index]
        }else{
            
            if selectedWeekDays & weekValue[index] > 0 {
                selectedWeekDays = selectedWeekDays - weekValue[index]
            }
        }
    }
    
    func setEveryday(){
        
        everydayButton.buttonOn = !everydayButton.buttonOn
        
        
        for var index = 0 ; index < 7 ; index++ {
            
            let button = weekButtons[index]
            dayOnAtIndex(index, on: everydayButton.buttonOn)
            
        }
        
        refreshButtons()
        needToChartUpdate()
    }
    
    func setWeekday(){
        
        weekdayButton.buttonOn = !weekdayButton.buttonOn
        
        for var index = 0 ; index < 7 ; index++ {
            
            let button = weekButtons[index]
            switch index {
            case 1,2,3,4,5: dayOnAtIndex(index, on: weekdayButton.buttonOn)
            default: dayOnAtIndex(index, on: false)
            }
            
        }
        
        refreshButtons()
        needToChartUpdate()
    }
    
    func setWeekend(){
        
        weekendButton.buttonOn = !weekendButton.buttonOn
        
        for var index = 0 ; index < 7 ; index++ {
            
            switch index {
            case 0,6: dayOnAtIndex(index, on: weekendButton.buttonOn)
            default: dayOnAtIndex(index, on: false)
            }
            
        }
        
        refreshButtons()
        needToChartUpdate()
    }
    
    func refreshButtons(){
        
        weekendButton.setButtonOn(selectedWeekDays == 65)
        weekdayButton.setButtonOn(selectedWeekDays == 62)
        everydayButton.setButtonOn(selectedWeekDays == 127)
        
    }
    
    func thumbTouchBegan(){
        
        isThumbed = true
        
    }
    
    func thumbTouchMoved(){
        
        needToChartUpdate()
        
    }
    func thumbTouchEnd(){
        
        isThumbed = false
        
        
        if let timer = maxChangeTimer {
            
            if timer.valid == true {
                endTimer()
            }
            
        }
        
        adjustChart()
        
    }
    
    func adjustChart(){
        
        for var index = 0 ; index < 7 ; index++ {
            let chart = weekCharts[index]
            let label = weekLabels[index]
            
            
            
            var minute = Int(chart.currentValue/600)
            var second = Int(chart.currentValue%600)
            if second > 300 {
                minute = minute + 1
            }
            
            let data = CGFloat(Int(minute)*600)
            chart.currentValue = data
            
            label.text = getTimeStringOfHourMinuteFromSeconds(NSTimeInterval(data))

            
            print("\(Int(chart.currentValue/3600))시간 \(Int((chart.currentValue%3600)/60))분 \n")

            
            UIView.animateWithDuration(0.7, animations: { () -> Void in
                chart.setStroke()
            })
        }
    }
    
    func needToChartUpdate(){
        
        var data:[CGFloat] = []
        var mask:[Bool] = []
        
        for var index = 0 ; index < 7 ; index++ {
            let chart = weekCharts[index]
            mask.append(chart.chartOn)
            data.append(chart.currentValue)
        }
        
        var chartStatus:[ChartStatus] = dateCalulate(data, mask: mask)
        
        var sumData:CGFloat = 0
        var maxData:CGFloat = 0
        
        for var index = 0 ; index < 7 ; index++ {
            
            let status = chartStatus[index]
            let chart = weekCharts[index]
            let button = weekButtons[index]
            let label = timeLabels[index]
            
            var minute = Int(chart.currentValue/600)
            var second = Int(chart.currentValue%600)
            
            if second > 300 {
                minute = minute + 1
            }
            
            let data = CGFloat(Int(minute)*600)
            
            
            //chart.currentValue = data
            label.text = getTimeStringOfHourMinuteFromSeconds(NSTimeInterval(data))
            
            sumData = sumData + CGFloat(data)
            
            if maxData < CGFloat(data) {
                maxData = CGFloat(data)
            }
            
            
            switch status {
            case .On: chart.setChartOn(true)
            case .Off: chart.setChartOn(false)
            default: chart.setChartOn(true)

            }
            
        }
        
        
        if isThumbed == true {
            
            if let timer = maxChangeTimer {
                
                if timer.valid == false {
                    maxChangeTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("changeMaxTime"), userInfo: nil, repeats: true)
                }
                
                
            }else {
                
                maxChangeTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("changeMaxTime"), userInfo: nil, repeats: true)
                
            }
        }
        
        
        
        for var index = 0 ; index < 7 ; index++ {
            
            let chart = weekCharts[index]
            maxTime = maxData
            chart.setMaxValue(maxTime)
            
        }
        
        
        
        
        
        
        calculateAmountLabels()
    }

    
    
    func dateCalulate(data:[CGFloat],mask:[Bool])->[ChartStatus]{
        
        var startOfWeek = getDayOfWeek(getDateFromDateNumber(getTodayDateNumber()))
        var tempSum:CGFloat! = CGFloat(timeTask.getAmount())
        
        var calculateData:[ChartStatus] = [ChartStatus](count:7, repeatedValue:ChartStatus.Off)
        
        for var index = 0 ; index < 7 ; index++ {
            
            let arrayIndex = (index + startOfWeek - 1)%7
            
            if mask[arrayIndex] == true {
                
                if tempSum - data[arrayIndex] >= 0{
                    calculateData[arrayIndex] = ChartStatus.On
                }else{
                    
                    if tempSum > 0 {
                        calculateData[arrayIndex] = ChartStatus.On
                    }else{
                        calculateData[arrayIndex] = ChartStatus.Max
                    }
                }
                
                tempSum = tempSum - data[arrayIndex]
                
            }else{
                
                calculateData[arrayIndex] = ChartStatus.Off
            }
        }
        
        return calculateData
    }
    
    
    func getDayOfWeek(date:NSDate)->Int{
        
        let dayOfWeek = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitWeekday, fromDate:date)
        
        return dayOfWeek.weekday
    }

    
    
    
    func calculateAmountLabels(){
        
        var startOfWeek = getDayOfWeek(timeTask.startDate!)
        var tempSum:CGFloat! = CGFloat(timeTask.getAmount())
        var day = 0
        
        var diff = Int(timeTask.endDate!.timeIntervalSinceDate(timeTask.startDate!) / (24*60*60))
        
        var times:[CGFloat] = [CGFloat](count: 7, repeatedValue: 0)
        
        
        for ; day < diff ; day++ {
            
            let dayOfWeek = (day + startOfWeek - 1)%7
            
            let chart:ThumbChartBox = weekCharts[dayOfWeek]
            let button:ColorButton = weekButtons[dayOfWeek]
            
            if button.buttonOn == true {
                times[dayOfWeek] = times[dayOfWeek] + chart.currentValue
            }
        }

        var sum:CGFloat! = 0
        
        for var dayOfWeek = 0 ; dayOfWeek < 7 ; dayOfWeek++ {
            sum = sum + times[dayOfWeek]
        }
        
        var totalMinute = sum / 60
        var amountPerMinute = CGFloat(timeTask.getAmount()) / totalMinute
        
        
        for var index = 0 ; index < 7 ; index++ {
            
            let label = amountLabels[index]
            
            if amountPerMinute < 1 {
                label.text = "1개"
            }else{
                let chart:ThumbChartBox = weekCharts[index]
                label.text = String(format: "%.0f개", arguments: [(chart.currentValue / 60) * amountPerMinute])
            }
        }
        
    }
    
    
    
    func endTimer(){
        
        
        if let timer = maxChangeTimer {
            timer.invalidate()
        }
        
        maxChangeTimeCount = 0
    }
    
    func changeMaxTime(){
        
        var needChange:Bool = false
        
        for var index = 0 ; index < 7 ; index++ {
            let chart = weekCharts[index]
            
            if chart.currentValue >= maxTime && chart.isThumbed == true {
                needChange = true
            }
            
        }
        
        
        
        if needChange == true {
            
            maxChangeTimeCount = maxChangeTimeCount + 1
            var addUnit:CGFloat = 600
            
            if maxChangeTimeCount > 30 {
                addUnit = 1800
            }
            
            if maxTime + addUnit > 24 * 60 * 60 {
                addUnit = 24 * 60 * 60 - maxTime
            }
            
            for var index = 0 ; index < 7 ; index++ {
                
                let chart = weekCharts[index]
                let label = timeLabels[index]
                let data = Int(chart.currentValue/600)*600
                
                if chart.isThumbed == true && chart.currentValue == maxTime{
                    chart.currentValue = maxTime + addUnit
                }
                
                label.text = getTimeStringOfHourMinuteFromSeconds(NSTimeInterval(data))
                
                chart.setMaxValue(maxTime + addUnit)
            }
            
            maxTime = maxTime + addUnit
            
        }else{
            endTimer()
        }
    }
    
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let goal = timeTask.goal {
            titleLabel.text = goal
        }
        
        
        todaitNavBar.todaitDelegate = self
        todaitNavBar.backButton.hidden = false
        
        addNextButton()
    }
    
    func addNextButton(){
        
        if nextButton != nil {
            return
        }
        
        nextButton = UIButton(frame: CGRectMake(255*ratio, 32, 50*ratio, 20))
        nextButton.setTitle("Next", forState: UIControlState.Normal)
        nextButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 18)
        nextButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        nextButton.addTarget(self, action: Selector("nextButtonClk"), forControlEvents: UIControlEvents.TouchUpInside)
        nextButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        view.addSubview(nextButton)
    }
    
    func nextButtonClk(){
        
        if isValidWeekTimes() == true {
            
            for var index = 0 ; index < 7 ; index++ {
                
                let chart = weekCharts[index]
                timeTask.weekTimes[index] = Int(chart.currentValue)
            }
            
            
            
            let step4VC = NewGoalStep4TimeViewController()
            self.navigationController?.pushViewController(step4VC, animated: true)
        
        }
    }
    
    func isValidWeekTimes()->Bool{
        
        for var index = 0 ; index < 7 ; index++ {
            
            let chart = weekCharts[index]
            let button = weekButtons[index]
            
            if button.buttonOn == true && chart.currentValue > 0 {
                return true
            }
        }
        
        return false
    }
    
    func backButtonClk(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
}
