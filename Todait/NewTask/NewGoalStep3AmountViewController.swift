//
//  NewGoalStep3AmountViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 7. 31..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit



enum WeekDay: Int{
    
    case Sun = 1
    case Mon = 2
    case TUE = 4
    case Wed = 8
    case Thu = 16
    case Fri = 32
    case Sat = 64
    
}

enum ChartStatus: Int{
    
    case On
    case Off
    case Max
    
}




class NewGoalStep3AmountViewController: BasicViewController,TodaitNavigationDelegate,ThumbChartDelegate{

    var baseView:UIView!
    var startLabel:UILabel!
    var endLabel:UILabel!
    var infoLabel:UILabel!
    
    var nextButton:UIButton!
    
    var everydayButton:ColorButton!
    var weekdayButton:ColorButton!
    var weekendButton:ColorButton!
    
    var amountLabels:[ColorLabel] = []
    var weekButtons:[ColorButton] = []
    var weekCharts:[ThumbChartBox] = []
    

    
    
    let weekValue = [1,2,4,8,16,32,64]
    var selectedWeekDays:Int = 0
    
    var maxValue:CGFloat! = 0
    
    var startDate:NSDate!
    var dayAmount:CGFloat! = 0
    var totalAmount:CGFloat! = 0
    var titleString:String! = ""
    var unitString:String! = ""
    
    var maxChangeTimer:NSTimer! 
    var isThumbed:Bool! = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupAmount()
        
        
        view.backgroundColor = UIColor.todaitBackgroundGray()
        addBaseView()
        addDateView()
        addDateButton()
        addAmountLabels()
        addChartView()
        addWeekButtons()
        addInfoLabel()
        
        setEveryday()
        // Do any additional setup after loading the view.
    }
    
    func setupAmount(){
        
        
    }
    
    func addBaseView(){
        
        baseView = UIView(frame: CGRectMake(2*ratio, 64 + 2*ratio, 316*ratio, 344*ratio))
        baseView.backgroundColor = UIColor.whiteColor()
        view.addSubview(baseView)
    }
    
    func addDateView(){
        
        let dateInfoLabel = UILabel(frame:CGRectMake(18*ratio, 0 , 45*ratio, 55*ratio))
        dateInfoLabel.text = "기간"
        dateInfoLabel.textColor = UIColor.todaitDarkGray()
        dateInfoLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 10*ratio)
        baseView.addSubview(dateInfoLabel)
        
        
        let dateForm = NSDateFormatter()
        dateForm.dateFormat = "yyyy.MM.dd (E)"
        
        
        startLabel = UILabel(frame: CGRectMake(59*ratio, 0, 109*ratio, 55*ratio))
        startLabel.text = dateForm.stringFromDate(startDate)
        startLabel.textColor = UIColor.todaitGray()
        startLabel.textAlignment = NSTextAlignment.Right
        startLabel.font = UIFont(name: "AppleSDGothicNeo-Ultralight", size: 14*ratio)
        baseView.addSubview(startLabel)
        
        
        let dashLabel = UILabel(frame:CGRectMake(168*ratio, 0 , 12*ratio, 55*ratio))
        dashLabel.text = "-"
        dashLabel.textColor = UIColor.todaitGray()
        dashLabel.textAlignment = NSTextAlignment.Center
        dashLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 10*ratio)
        baseView.addSubview(dashLabel)
        
        endLabel = UILabel(frame: CGRectMake(180*ratio, 0, 109*ratio, 55*ratio))
        endLabel.text = "2015.08.12 (화)"
        endLabel.textColor = UIColor.todaitDarkGray()
        endLabel.textAlignment = NSTextAlignment.Left
        endLabel.font = UIFont(name: "AppleSDGothicNeo-Light", size: 16*ratio)
        baseView.addSubview(endLabel)
        
        
        let line = UIView(frame: CGRectMake(3*ratio,54*ratio,310*ratio,1))
        line.backgroundColor = UIColor.todaitBackgroundGray()
        baseView.addSubview(line)
        
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
    
    func addChartView(){
        
        for var index = 0 ; index < 7 ; index++ {
            
            let thumbChartBox = ThumbChartBox(frame:CGRectMake(14*ratio + CGFloat(index)*45*ratio,113*ratio,20*ratio,160*ratio))
            thumbChartBox.frontOnColor = UIColor.todaitGreen()
            thumbChartBox.frontOffColor = UIColor.todaitLightGray()
            thumbChartBox.maxColor = UIColor.colorWithHexString("#95CCC4")
            
            thumbChartBox.maxValue = CGFloat(totalAmount)
            thumbChartBox.currentValue = CGFloat(dayAmount)
            thumbChartBox.setStroke()
            thumbChartBox.delegate = self
            
            baseView.addSubview(thumbChartBox)
            weekCharts.append(thumbChartBox)
        
        }
    }
    
    func addWeekButtons(){
        
        
        let weekTitle = ["SUN","MON","TUE","WED","THU","FRI","SAT"]
        
        
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
        infoLabel.text = "시간 변경시 막대를 움직이거나 분량을 터치하세요"
        infoLabel.textAlignment = NSTextAlignment.Center
        infoLabel.textColor = UIColor.todaitGray()
        infoLabel.font = UIFont(name: "AppleSDGothicNeo-Light", size: 8*ratio)
        baseView.addSubview(infoLabel)
        
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
    
    
    
    func dayOnAtIndex(index:Int,on:Bool){
        
        
        
        
        let weekButton = weekButtons[index]
        let thumbChart = weekCharts[index]
        let amountLabel = amountLabels[index]
        
        
        amountLabel.setLabelOn(on)
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
    
    
    func thumbTouchBegan(){
        
    }
    
    func thumbTouchMoved(){
        
        needToChartUpdate()
        
    }
    
    func thumbTouchEnd(){
        
        
        
        if let timer = maxChangeTimer {
            if maxChangeTimer.valid == true {
                maxChangeTimer.invalidate()
            }
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
            let label = amountLabels[index]
            let data = data[index]
            label.text = String(format: "%.0f개", arguments: [data])
            
            
            sumData = sumData + data
        
            if maxData < data {
                maxData = data
            }
            
            
            switch status {
            case .On: chart.setChartOn(true)
            case .Off: chart.setChartOn(false)
            case .Max: chart.setChartMax()
            default: return
            }
            
        }
        
        maxValue = 2*sumData/7
        
        for var index = 0 ; index < 7 ; index++ {
            let chart = weekCharts[index]
            chart.setMaxValue(maxValue)
       
        }
        
        
        
        var isAllOff:Bool = false
        var currentZero:Bool = true
        
        for var index = 0 ; index < 7 ; index++ {
            if mask[index] == true {
                isAllOff = true
            }
            
            if data[index] > 0 {
                currentZero = false
            }
        }
        
        
        if isAllOff == false || currentZero == true {
            endLabel.text = "-"
            return
        }
        
        
        
        var startOfWeek = getDayOfWeek(getDateFromDateNumber(getTodayDateNumber()))
        var tempSum:CGFloat! = totalAmount
        var day = 0
        
        for ; tempSum > 0 ; day++ {
            
            let arrayIndex = (day + startOfWeek - 1)%7
            
            if mask[arrayIndex] == true {
                tempSum = tempSum - data[arrayIndex]
            }else{
                
            }
        }
        
        
        let dateForm = NSDateFormatter()
        dateForm.dateFormat = "yyyy.MM.dd (E)"
        
        endLabel.text = dateForm.stringFromDate(startDate.addDay(day))
        
        
        /*
        if isThumbed == true {
            
            if let timer = maxChangeTimer {
                
                if timer.valid == false {
                    maxChangeTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("changeMaxTime"), userInfo: nil, repeats: true)
                }
                
                
            }else {
                maxChangeTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("changeMaxTime"), userInfo: nil, repeats: true)
                
            }
        }
        */
        
    }
    
    func dateCalulate(data:[CGFloat],mask:[Bool])->[ChartStatus]{
        
        var startOfWeek = getDayOfWeek(getDateFromDateNumber(getTodayDateNumber()))
        var tempSum:CGFloat! = totalAmount
        
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
    
    func changeMaxTime(){
        
        
    }
    
    func getDayOfWeek(date:NSDate)->Int{
        
        let dayOfWeek = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitWeekday, fromDate:date)
        
        return dayOfWeek.weekday
    }
    
    func refreshButtons(){
        
        weekendButton.setButtonOn(selectedWeekDays == 65)
        weekdayButton.setButtonOn(selectedWeekDays == 62)
        everydayButton.setButtonOn(selectedWeekDays == 127)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        titleLabel.text = titleString
        
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
        
        let step4VC = NewGoalStep4ViewController()
        step4VC.titleString = titleString
        
        self.navigationController?.pushViewController(step4VC, animated: true)
        
    }
    
    func backButtonClk(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
