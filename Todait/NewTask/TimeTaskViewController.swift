//
//  NewTimeTaskViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 7. 9..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class TimeTaskViewController: BasicViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,PeriodDelegate,UnitInputViewDelegate,CategoryDelegate{
    var mainColor: UIColor!
    
    var categoryButton: UIButton!
    
    
    var taskTextField: UITextField!
    var unitTextField: UITextField!
    var unitView: UnitInputView!
    
    
    var totalTextField: UITextField!
    var startRangeTextField: UITextField!
    var endRangeTextField: UITextField!
    var dayTextField: UITextField!
    
    var saveButton: UIButton!
    var investButton: UIButton!
    var currentTextField: UITextField!
    
    var startDateLabel: UILabel!
    
    var dateForm: NSDateFormatter!
    var startDate: NSDate!
    
    var periodStartDate:NSDate!
    var periodEndDate:NSDate!
    var periodDayLabel:UILabel!
    var periodDayString:String = "30일"
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var aimString:String! = ""
    var unitString:String! = ""
    
    
    var timeTaskTableView:UITableView!
    var totalButton:UIButton!
    var rangeButton:UIButton!
    var unitButton:UIButton!
    
    var option:OptionStatus = OptionStatus.everyDay
    var isTotal:Bool! = true
    var rangeList:[[String:String]] = []
    
    
    
    var aimAmount:Int! = 0
    var startRangeAmount:Int! = 0
    var endRangeAmount:Int! = 0
    var dayAmount:Int! = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTimeTaskViewController()
        
        addUnitView()
        addTimeTaskTableView()
        
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.todaitNavBar.hidden = true
        
    }
    
    func setupTimeTaskViewController(){
        startDate = NSDate()
        periodStartDate = NSDate()
        periodEndDate = NSDate(timeIntervalSinceNow: 24*60*60 * 29)
        
        dateForm = NSDateFormatter()
        dateForm.dateFormat = "a h시 m분"
        
    }
    
    
    func addUnitView(){
        
        unitView = UnitInputView(frame: CGRectMake(0, height, width, 40*ratio))
        unitView.backgroundColor = mainColor
        unitView.delegate = self
        unitView.hidden = true
        
        view.addSubview(unitView)
        
    }
    
    func updateUnit(unit:String){
        
        unitTextField.text = unit
        
    }
    
    func addTimeTaskTableView(){
        timeTaskTableView = UITableView(frame: CGRectMake(0,0,width,view.frame.size.height), style: UITableViewStyle.Plain)
        timeTaskTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        timeTaskTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        timeTaskTableView.contentInset = UIEdgeInsetsMake(0*ratio, 0, 0, 0)
        timeTaskTableView.delegate = self
        timeTaskTableView.dataSource = self
        timeTaskTableView.sectionHeaderHeight = 0
        timeTaskTableView.sectionFooterHeight = 0
        timeTaskTableView.pagingEnabled = false
        timeTaskTableView.bounces = false
        timeTaskTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        view.addSubview(timeTaskTableView)
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        
        
        for view in cell.contentView.subviews{
            view.removeFromSuperview()
        }
        
        cell.contentView.clipsToBounds = true
        cell.contentView.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
        
        if indexPath.row == 0 && indexPath.section == 0 {
            
            addTaskTextField(cell)
            addCategoryButton(cell)
            
        }else if(indexPath.row == 1 && indexPath.section == 0){
            
            addAimDateSubView(cell)
            
            //addRangeTextField(cell)
            
        }else if(indexPath.row == 2 && indexPath.section == 0){
            
            
            addAmountButton(cell)
            
        }else if indexPath.section == 1 {
            
            
            if isTotal == true {
                addTotalTextField(cell)
            }else{
                addRangeTextField(cell,indexPath:indexPath)
                //addRangeAmount(cell,indexPath.row)
            }
            
            
        }else if(indexPath.section == 2 ){
            
            addOptionView(cell)
        }
        
        
        return cell
    }
    
    
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        if indexPath.row == 1 && indexPath.section == 0 {
            showPeriodVC()
        }
        
        
        return false
    }
    
    func showPeriodVC(){
        
        //로딩전에 기간시간 추가
        let periodVC = PeriodViewController()
        
        periodVC.startDate = periodStartDate
        periodVC.endDate = periodEndDate
        periodVC.delegate = self
        periodVC.mainColor = mainColor
        periodVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        periodVC.delegate = self
        self.navigationController?.presentViewController(periodVC, animated: false, completion: { () -> Void in
            
        })
        
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        
        
        let line = UIView(frame: CGRectMake(0, 0, 320*ratio, 0.5*ratio))
        line.backgroundColor = UIColor.todaitDarkGray().colorWithAlphaComponent(0.3)
        headerView.addSubview(line)
        
        
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0*ratio
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        
        if indexPath.row == 2 && indexPath.section == 2 {
            return 120*ratio
        }else if indexPath.row == 1 && indexPath.section == 0 {
            return 53*ratio
        }else if indexPath.row == 2 && indexPath.section == 0 {
            return 60*ratio
        }else if indexPath.section == 2 {
            return 104*ratio
        }
        
        
        return 54*ratio
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        switch section {
        case 0: return 3
        case 1:
            if isTotal == true {
                return 1
            }else{
                return 1 + rangeList.count
            }
        case 2: return 1
        default: return 0
        }
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    
    func resignAllTextResponder(){
        
        unitTextField.resignFirstResponder()
        taskTextField.resignFirstResponder()
        totalTextField.resignFirstResponder()
        startRangeTextField.resignFirstResponder()
        endRangeTextField.resignFirstResponder()
        dayTextField.resignFirstResponder()
        
    }
    
    
    
    func addTaskTextField(cell:UITableViewCell){
        
        taskTextField = UITextField(frame: CGRectMake(20*ratio, 9.5*ratio, 255*ratio, 30*ratio))
        taskTextField.placeholder = "이곳에 목표를 입력해주세요"
        taskTextField.textAlignment = NSTextAlignment.Center
        taskTextField.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14*ratio)
        taskTextField.textColor = UIColor.colorWithHexString("#969696")
        taskTextField.returnKeyType = UIReturnKeyType.Next
        taskTextField.backgroundColor = UIColor.whiteColor()
        taskTextField.addTarget(self, action: Selector("updateAllEvents:"), forControlEvents: UIControlEvents.AllEvents)
        taskTextField.text = aimString
        taskTextField.tintColor = mainColor
        taskTextField.delegate = self
        currentTextField = taskTextField
        cell.contentView.addSubview(taskTextField)
        
        addLineView(cell)
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        currentTextField = textField
        
        if currentTextField == unitTextField {
            unitView.hidden = false
        }else{
            unitView.hidden = true
        }
        
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField == taskTextField {
            
            unitView.hidden = false
            currentTextField = unitTextField
            
        }else if textField == unitTextField {
            
            unitView.hidden = true
            
        }
        
        currentTextField.becomeFirstResponder()
        
        return false
    }
    
    func updateAllEvents(textField:UITextField){
        aimString = textField.text
    }
    
    func addCategoryButton(cell:UITableViewCell){
        
        categoryButton = UIButton(frame: CGRectMake(280*ratio,9.5*ratio, 30*ratio, 30*ratio))
        
        categoryButton.setImage(UIImage(named: "category@3x.png"), forState: UIControlState.Normal)
        categoryButton.layer.cornerRadius = 15*ratio
        categoryButton.layer.borderWidth = 1
        categoryButton.layer.borderColor = UIColor.todaitGray().CGColor
        categoryButton.clipsToBounds = true
        categoryButton.addTarget(self, action: Selector("showCategorySettingVC"), forControlEvents: UIControlEvents.TouchUpInside)
        cell.contentView.addSubview(categoryButton)
        
    }
    
    
    
    func showCategorySettingVC(){
        
        var categoryVC = CategorySettingViewController()
        categoryVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        categoryVC.delegate = self
        self.navigationController?.presentViewController(categoryVC, animated: false, completion: { () -> Void in
            
        })
        
        
    }
    
    func categoryEdited(editedCategory:Category){
        
    }
    
    
    func addLineView(cell: UITableViewCell){
        
        let lineView = UIView(frame: CGRectMake(1*ratio, 48.5*ratio,318*ratio, 0.5*ratio))
        lineView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15)
        cell.contentView.addSubview(lineView)
    }
    
   
    
    func updateUnitAllEvents(textField:UITextField){
        unitString = textField.text
    }
    
    
    func addRangeTextField(cell:UITableViewCell,indexPath:NSIndexPath){
        
        
        let periodStartTextField = UITextField(frame:CGRectMake(15*ratio, 28*ratio, 140*ratio, 20*ratio))
        periodStartTextField.placeholder = "시작"
        periodStartTextField.textAlignment = NSTextAlignment.Center
        periodStartTextField.font = UIFont(name: "AppleSDGothicNeo-Ultralight", size: 15*ratio)
        periodStartTextField.textColor = UIColor.todaitDarkGray()
        periodStartTextField.addTarget(self, action: Selector("updateStartTime:"), forControlEvents: UIControlEvents.AllEvents)
        periodStartTextField.tag = indexPath.row
        cell.contentView.addSubview(periodStartTextField)
        
        
        let middleBox = UIView(frame: CGRectMake(158*ratio, 37.5*ratio, 4*ratio, 1*ratio))
        middleBox.backgroundColor = UIColor.todaitDarkGray()
        cell.contentView.addSubview(middleBox)
        
        
        let periodEndTextField = UITextField(frame:CGRectMake(165*ratio, 28*ratio, 140*ratio, 20*ratio))
        periodEndTextField.placeholder = "종료"
        periodEndTextField.textAlignment = NSTextAlignment.Center
        periodEndTextField.font = UIFont(name: "AppleSDGothicNeo-Ultralight", size: 15*ratio)
        periodEndTextField.textColor = UIColor.todaitDarkGray()
        periodEndTextField.addTarget(self, action: Selector("updateEndTime:"), forControlEvents: UIControlEvents.AllEvents)
        periodEndTextField.tag = indexPath.row
        cell.contentView.addSubview(periodEndTextField)
        
        
        var line = UIView(frame:CGRectMake(20*ratio, 52*ratio, 272*ratio, 0.5*ratio))
        line.backgroundColor = UIColor.todaitDarkGray().colorWithAlphaComponent(0.3)
        cell.contentView.addSubview(line)
        
        
        
        if rangeList.count > 0 {
            
            var rangeData = rangeList[indexPath.row]
            
            periodStartTextField.text = rangeData["startTime"]
            periodEndTextField.text = rangeData["endTime"]
        }
    }
    
    func updateStartTime(textField:UITextField){
        let index = textField.tag
        
        /*
        if rangeList.count == index {
            
            var rangeData:[String:String] = [:]
            rangeData["startTime"] = textField.text
            rangeList.append(rangeData)
            
        }else{
            
            var rangeData = rangeList[index]
            rangeData["startTime"] = textField.text
            
        }
        */
    }
    
    func updateEndTime(textField:UITextField){
        let index = textField.tag
        
        /*
        if rangeList.count == index {
            var rangeData = rangeList[index]
            rangeData["endTime"] = textField.text
            
        }else{
            
            var rangeData:[String:String] = [:]
            rangeData["endTime"] = textField.text
            rangeList.append(rangeData)
            
        }
        */
    }
    
    func addAimDateSubView(cell:UITableViewCell){
        
        
        let infoLabel = UILabel(frame: CGRectMake(20*ratio, 30*ratio, 200*ratio, 16*ratio))
        infoLabel.text = "기간"
        infoLabel.textAlignment = NSTextAlignment.Left
        infoLabel.textColor = UIColor.todaitDarkGray()
        infoLabel.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 10*ratio)
        cell.contentView.addSubview(infoLabel)
        
        
        
        
        let periodStartLabel = UILabel(frame:CGRectMake(15*ratio, 28*ratio, 140*ratio, 20*ratio))
        periodStartLabel.text = getDateString(getDateNumberFromDate(periodStartDate))
        periodStartLabel.textAlignment = NSTextAlignment.Right
        periodStartLabel.font = UIFont(name: "AppleSDGothicNeo-Ultralight", size: 15*ratio)
        periodStartLabel.textColor = UIColor.todaitDarkGray()
        cell.contentView.addSubview(periodStartLabel)
        
        
        let middleBox = UIView(frame: CGRectMake(158*ratio, 37.5*ratio, 4*ratio, 1*ratio))
        middleBox.backgroundColor = UIColor.todaitDarkGray()
        cell.contentView.addSubview(middleBox)
        
        
        let periodEndLabel = UILabel(frame:CGRectMake(165*ratio, 28*ratio, 140*ratio, 20*ratio))
        periodEndLabel.text = getDateString(getDateNumberFromDate(periodEndDate))
        periodEndLabel.textAlignment = NSTextAlignment.Left
        periodEndLabel.font = UIFont(name: "AppleSDGothicNeo-Ultralight", size: 15*ratio)
        periodEndLabel.textColor = UIColor.todaitDarkGray()
        cell.contentView.addSubview(periodEndLabel)
        
        
        
        
        
        
        periodDayLabel = UILabel(frame: CGRectMake(272*ratio, 30*ratio, 33*ratio, 16*ratio))
        periodDayLabel.text = periodDayString
        periodDayLabel.textAlignment = NSTextAlignment.Left
        periodDayLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 10*ratio)
        periodDayLabel.textColor = UIColor.todaitDarkGray().colorWithAlphaComponent(0.7)
        cell.contentView.addSubview(periodDayLabel)
        
        var line = UIView(frame:CGRectMake(20*ratio, 52*ratio, 272*ratio, 0.5*ratio))
        line.backgroundColor = UIColor.todaitDarkGray().colorWithAlphaComponent(0.3)
        cell.contentView.addSubview(line)
    }
    
    func getDateString(dateNumber:NSNumber)->String{
        
        let date = getDateFromDateNumber(dateNumber)
        let dateForm = NSDateFormatter()
        dateForm.dateFormat = "yyyy.MM.dd"
        
        return dateForm.stringFromDate(date)
        
    }
    
    func addAmountButton(cell:UITableViewCell){
        
        
        
        totalButton = UIButton(frame: CGRectMake(19*ratio, 23*ratio, 89*ratio, 32*ratio))
        totalButton.setTitle("전체", forState: UIControlState.Normal)
        totalButton.setTitleColor(UIColor.todaitDarkGray(), forState: UIControlState.Normal)
        totalButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 10*ratio)
        totalButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        totalButton.layer.borderColor = UIColor.colorWithHexString("#B2B2B2").CGColor
        totalButton.layer.borderWidth = 0.5*ratio
        totalButton.addTarget(self, action: Selector("totalButtonClk"), forControlEvents: UIControlEvents.TouchUpInside)
        cell.addSubview(totalButton)
        
        
        
        rangeButton = UIButton(frame: CGRectMake(108*ratio, 23*ratio, 89*ratio, 32*ratio))
        
        rangeButton.setTitle("범위", forState: UIControlState.Normal)
        rangeButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 10*ratio)
        rangeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        rangeButton.addTarget(self, action: Selector("rangeButtonClk"), forControlEvents: UIControlEvents.TouchUpInside)
        cell.addSubview(rangeButton)
        
        
        
        setAmountButtonHighlight(totalButton, highlight: isTotal)
        setAmountButtonHighlight(rangeButton, highlight: !isTotal)
        
        /*
        
        unitButton = UIButton(frame: CGRectMake(206*ratio, 23*ratio, 89*ratio, 32*ratio))
        unitButton.setTitle("단위선택", forState: UIControlState.Normal)
        unitButton.setTitleColor(UIColor.todaitDarkGray(), forState: UIControlState.Normal)
        unitButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 10*ratio)
        unitButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        unitButton.layer.borderColor = UIColor.colorWithHexString("#B2B2B2").CGColor
        unitButton.layer.borderWidth = 0.5*ratio
        cell.contentView.addSubview(unitButton)
        
        */
        
        
        unitTextField = UITextField(frame: CGRectMake(206*ratio, 23*ratio, 89*ratio, 32*ratio))
        unitTextField.placeholder = "단위입력"
        unitTextField.tintColor = mainColor
        unitTextField.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 10*ratio)
        unitTextField.textColor = UIColor.colorWithHexString("#969696")
        unitTextField.returnKeyType = UIReturnKeyType.Next
        unitTextField.textAlignment = NSTextAlignment.Center
        unitTextField.backgroundColor = UIColor.whiteColor()
        unitTextField.text = unitString
        unitTextField.addTarget(self, action: Selector("updateUnitAllEvents:"), forControlEvents: UIControlEvents.AllEvents)
        unitTextField.delegate = self
        
        cell.contentView.addSubview(unitTextField)
        
        var line = UIView(frame:CGRectMake(206*ratio,54*ratio,89*ratio,0.5*ratio))
        line.backgroundColor = UIColor.todaitDarkGray().colorWithAlphaComponent(0.3)
        cell.contentView.addSubview(line)
        
    }
    
    func totalButtonClk(){
        
        isTotal = true
        
        timeTaskTableView.reloadData()
        
        setAmountButtonHighlight(totalButton, highlight: isTotal)
        setAmountButtonHighlight(rangeButton, highlight: !isTotal)
        
        
        
    }
    
    
    func rangeButtonClk(){
        
        isTotal = false
        timeTaskTableView.reloadData()
        setAmountButtonHighlight(totalButton, highlight: isTotal)
        setAmountButtonHighlight(rangeButton, highlight: !isTotal)
    }
    
    func setAmountButtonHighlight(button:UIButton, highlight:Bool){
        
        if highlight {
            button.setBackgroundImage(UIImage.colorImage(UIColor.todaitGreen(), frame: CGRectMake(0, 0, 89*ratio, 32*ratio)), forState: UIControlState.Normal)
            button.setBackgroundImage(UIImage.colorImage(UIColor.todaitDarkGreen(), frame: CGRectMake(0, 0, 89*ratio, 32*ratio)), forState: UIControlState.Highlighted)
            
            button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            button.layer.borderColor = UIColor.todaitGreen().CGColor
            button.layer.borderWidth = 0.5*ratio
        }else{
            
            button.setBackgroundImage(UIImage.colorImage(UIColor.whiteColor(), frame: CGRectMake(0, 0, 89*ratio, 32*ratio)), forState: UIControlState.Normal)
            button.setBackgroundImage(UIImage.colorImage(UIColor.todaitLightGray(), frame: CGRectMake(0, 0, 89*ratio, 32*ratio)), forState: UIControlState.Highlighted)
            button.setTitleColor(UIColor.todaitDarkGray(), forState: UIControlState.Normal)
            button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 10*ratio)
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
            button.layer.borderColor = UIColor.colorWithHexString("#B2B2B2").CGColor
            button.layer.borderWidth = 0.5*ratio
        }
        
    }
    
    
    
    func addOptionView(cell:UITableViewCell){
        
        addDayOptionView(cell)
        addAlarmOptionView(cell)
        addreviewOptionView(cell)
        addreReadOptionView(cell)
        
        
    }
    
    func addDayOptionView(cell:UITableViewCell){
        
        
        var dayOption = UIButton(frame:CGRectMake(2*ratio,12*ratio,157*ratio,52*ratio))
        dayOption.backgroundColor = UIColor.clearColor()
        dayOption.addTarget(self, action: Selector("dayOptionClk"), forControlEvents: UIControlEvents.TouchDown)
        cell.contentView.addSubview(dayOption)
        
        
        var iconImageView = UIImageView(frame: CGRectMake(20*ratio, 6*ratio, 40*ratio, 40*ratio))
        dayOption.addSubview(iconImageView)
        
        
        var titleLabel = UILabel(frame: CGRectMake(68*ratio, 15*ratio, 92*ratio, 22.5*ratio))
        titleLabel.text = "매일"
        titleLabel.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 12.5*ratio)
        dayOption.addSubview(titleLabel)
        
        
        if option == OptionStatus.everyDay {
            iconImageView.image = UIImage(named: "icon_week_wt@3x.png")
            titleLabel.textColor = UIColor.todaitGreen()
        }else{
            iconImageView.image = UIImage(named: "icon_week@3x.png")
            titleLabel.textColor = UIColor.todaitGray()
        }
        
    }
    
    func dayOptionClk(){
        
        option = OptionStatus.everyDay
        timeTaskTableView.reloadData()
        
    }
    
    func addAlarmOptionView(cell:UITableViewCell){
        
        
        var alarmOption = UIButton(frame:CGRectMake(161*ratio,12*ratio,157*ratio,52*ratio))
        alarmOption.backgroundColor = UIColor.clearColor()
        alarmOption.addTarget(self, action: Selector("alarmOptionClk"), forControlEvents: UIControlEvents.TouchDown)
        cell.contentView.addSubview(alarmOption)
        
        
        var iconImageView = UIImageView(frame: CGRectMake(10*ratio, 6*ratio, 40*ratio, 40*ratio))
        alarmOption.addSubview(iconImageView)
        
        
        var titleLabel = UILabel(frame: CGRectMake(63*ratio, 15*ratio, 92*ratio, 22.5*ratio))
        titleLabel.text = "알람 없음"
        titleLabel.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 12.5*ratio)
        alarmOption.addSubview(titleLabel)
        
        
        
        if option == OptionStatus.alarm {
            iconImageView.image = UIImage(named: "icon_alarm_wt@3x.png")
            titleLabel.textColor = UIColor.todaitGreen()
        }else{
            iconImageView.image = UIImage(named: "icon_alarm@3x.png")
            titleLabel.textColor = UIColor.todaitGray()
        }
    }
    
    func alarmOptionClk(){
        
        option = OptionStatus.alarm
        timeTaskTableView.reloadData()
        
    }
    
    func addreviewOptionView(cell:UITableViewCell){
        
        
        var reviewOption = UIButton(frame:CGRectMake(2*ratio,64*ratio,157*ratio,52*ratio))
        reviewOption.backgroundColor = UIColor.clearColor()
        reviewOption.addTarget(self, action: Selector("reviewOptionClk"), forControlEvents: UIControlEvents.TouchDown)
        cell.contentView.addSubview(reviewOption)
        
        
        var iconImageView = UIImageView(frame: CGRectMake(20*ratio, 6*ratio, 40*ratio, 40*ratio))
        reviewOption.addSubview(iconImageView)
        
        
        var titleLabel = UILabel(frame: CGRectMake(68*ratio, 15*ratio, 92*ratio, 22.5*ratio))
        titleLabel.text = "반복 없음"
        titleLabel.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 12.5*ratio)
        reviewOption.addSubview(titleLabel)
        
        
        if option == OptionStatus.review {
            iconImageView.image = UIImage(named: "icon_review_wt@3x.png")
            titleLabel.textColor = UIColor.todaitGreen()
        }else{
            iconImageView.image = UIImage(named: "icon_review@3x.png")
            titleLabel.textColor = UIColor.todaitGray()
        }
    }
    
    func reviewOptionClk(){
        
        option = OptionStatus.review
        timeTaskTableView.reloadData()
        
    }
    
    func addreReadOptionView(cell:UITableViewCell){
        
        var reReadOption = UIButton(frame:CGRectMake(161*ratio,64*ratio,157*ratio,52*ratio))
        reReadOption.backgroundColor = UIColor.clearColor()
        reReadOption.addTarget(self, action: Selector("reReadOptionClk"), forControlEvents: UIControlEvents.TouchDown)
        cell.contentView.addSubview(reReadOption)
        
        
        var iconImageView = UIImageView(frame: CGRectMake(10*ratio, 6*ratio, 40*ratio, 40*ratio))
        reReadOption.addSubview(iconImageView)
        
        
        var titleLabel = UILabel(frame: CGRectMake(63*ratio, 15*ratio, 92*ratio, 22.5*ratio))
        titleLabel.text = "회독 없음"
        titleLabel.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 12.5*ratio)
        reReadOption.addSubview(titleLabel)
        
        
        if option == OptionStatus.reRead {
            iconImageView.image = UIImage(named: "icon_reread_wt@3x.png")
            titleLabel.textColor = UIColor.todaitGreen()
        }else{
            iconImageView.image = UIImage(named: "icon_reread@3x.png")
            titleLabel.textColor = UIColor.todaitGray()
        }
        
    }
    
    func reReadOptionClk(){
        
        option = OptionStatus.reRead
        timeTaskTableView.reloadData()
        
    }
    
    func showreviewVC(){
        
        /*
        let reviewVC = reviewViewcontroller()
        reviewVC.mainColor = mainColor
        reviewVC.delegate = self
        reviewVC.count = 1
        reviewVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        
        self.navigationController?.presentViewController(reviewVC, animated: true, completion: { () -> Void in
        
        })
        */
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ShowPeriodView" {
            //로딩전에 기간시간 추가
            let periodVC = segue.destinationViewController as! PeriodViewController
            periodVC.startDate = periodStartDate
            periodVC.endDate = periodEndDate
            periodVC.delegate = self
            periodVC.mainColor = mainColor
        }
        
    }
    
    func updatePeriodEndDate(date: NSDate) {
        periodEndDate = date
    }
    
    func updatePeriodStartDate(date: NSDate) {
        periodStartDate = date
    }
    
    func updatePeriodDay(day: String) {
        periodDayLabel.text = day
        periodDayString = day
    }
    
    func settingTime(date:NSDate){
        startDate = date
        startDateLabel.text = dateForm.stringFromDate(startDate)
    }
    
    func addStartTimeSubView(cell:UITableViewCell){
        
        let infoLabel = UILabel(frame: CGRectMake(15*ratio, 9.5*ratio, 200*ratio, 30*ratio))
        infoLabel.text = "시작시간"
        infoLabel.textColor = UIColor.colorWithHexString("#969696")
        infoLabel.textAlignment = NSTextAlignment.Left
        infoLabel.font = UIFont(name: "AvenirNext-Regular", size: 14*ratio)
        cell.contentView.addSubview(infoLabel)
        
        startDateLabel = UILabel(frame: CGRectMake(160*ratio, 9.5*ratio, 145*ratio, 30*ratio))
        startDateLabel.text = dateForm.stringFromDate(NSDate())
        startDateLabel.textAlignment = NSTextAlignment.Right
        startDateLabel.font = UIFont(name: "AvenirNext-Medium", size: 16*ratio)
        startDateLabel.textColor = mainColor
        cell.contentView.addSubview(startDateLabel)
        
        addLineView(cell)
    }
    
    func addreviewTimeSubView(cell:UITableViewCell){
        
        let infoLabel = UILabel(frame: CGRectMake(15*ratio, 9.5*ratio, 200*ratio, 30*ratio))
        infoLabel.text = "반복"
        infoLabel.textColor = UIColor.colorWithHexString("#969696")
        infoLabel.textAlignment = NSTextAlignment.Left
        infoLabel.font = UIFont(name: "AvenirNext-Regular", size: 14*ratio)
        cell.contentView.addSubview(infoLabel)
        
        let dateLabel = UILabel(frame: CGRectMake(160*ratio, 9.5*ratio, 145*ratio, 30*ratio))
        dateLabel.text = "1회"
        dateLabel.textAlignment = NSTextAlignment.Right
        dateLabel.font = UIFont(name: "AvenirNext-Medium", size: 16*ratio)
        dateLabel.textColor = mainColor
        cell.contentView.addSubview(dateLabel)
    }
    
    func addInvestChartView(cell:UITableViewCell){
        /*
        investChart = InvestChartView(frame: CGRectMake(15*ratio, 15*ratio, 290*ratio, 110*ratio))
        investChart.mainColor = mainColor
        investChart.setupChart()
        
        cell.contentView.addSubview(investChart)
        */
    }
    
    
    func addTotalTextField(cell:UITableViewCell){
        
        
        let infoLabel = UILabel(frame: CGRectMake(20*ratio, 21*ratio, 200*ratio, 16*ratio))
        infoLabel.text = "전체"
        infoLabel.textAlignment = NSTextAlignment.Left
        infoLabel.textColor = UIColor.todaitDarkGray()
        infoLabel.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 10*ratio)
        cell.contentView.addSubview(infoLabel)
        
        
        
        
        totalTextField = UITextField(frame: CGRectMake(60*ratio, 21*ratio, 235*ratio, 16*ratio))
        totalTextField.textAlignment = NSTextAlignment.Right
        totalTextField.placeholder = "분량을 입력하세요"
        totalTextField.tintColor = mainColor
        totalTextField.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 10*ratio)
        totalTextField.textColor = UIColor.colorWithHexString("#969696")
        totalTextField.keyboardType = UIKeyboardType.NumberPad
        totalTextField.returnKeyType = UIReturnKeyType.Done
        totalTextField.backgroundColor = UIColor.whiteColor()
        totalTextField.addTarget(self, action: Selector("updateAmountAllEvents:"), forControlEvents: UIControlEvents.AllEvents)
        totalTextField.delegate = self
        
        if let aimAmount = aimAmount {
            totalTextField.text = "\(aimAmount)"
        }
        
        cell.contentView.addSubview(totalTextField)
        
        var line = UIView(frame:CGRectMake(20*ratio, 43*ratio, 272*ratio, 0.5*ratio))
        line.backgroundColor = UIColor.todaitDarkGray().colorWithAlphaComponent(0.3)
        cell.contentView.addSubview(line)
    }
    
    func updateAmountAllEvents(textField:UITextField){
        
        switch textField {
        case totalTextField : aimAmount = textField.text.toInt()
        case startRangeTextField : startRangeAmount = textField.text.toInt()
        case endRangeTextField : endRangeAmount = textField.text.toInt()
        case dayTextField : dayAmount = textField.text.toInt()
        default: textField.text = ""
        }
        
    }
    
    
    
    func addStartRangeTextField(cell:UITableViewCell){
        startRangeTextField = UITextField(frame: CGRectMake(15*ratio, 9.5*ratio, 130*ratio, 30*ratio))
        startRangeTextField.textAlignment = NSTextAlignment.Left
        startRangeTextField.placeholder = "시작"
        startRangeTextField.font = UIFont(name: "AvenirNext-Regular", size: 14*ratio)
        startRangeTextField.textColor = UIColor.colorWithHexString("#969696")
        startRangeTextField.tintColor = mainColor
        startRangeTextField.hidden = true
        startRangeTextField.keyboardType = UIKeyboardType.NumberPad
        startRangeTextField.backgroundColor = UIColor.whiteColor()
        startRangeTextField.addTarget(self, action: Selector("updateAmountAllEvents:"), forControlEvents: UIControlEvents.AllEvents)
        startRangeTextField.delegate = self
        
        if startRangeAmount != 0 {
            startRangeTextField.text = "\(startRangeAmount)"
        }
        
        cell.contentView.addSubview(startRangeTextField)
    }
    
    
    func addEndRangeTextField(cell:UITableViewCell){
        endRangeTextField = UITextField(frame: CGRectMake(175*ratio, 9.5*ratio, 130*ratio, 30*ratio))
        endRangeTextField.textAlignment = NSTextAlignment.Left
        endRangeTextField.placeholder = "종료"
        endRangeTextField.font = UIFont(name: "AvenirNext-Regular", size: 14*ratio)
        endRangeTextField.textColor = UIColor.colorWithHexString("#969696")
        endRangeTextField.tintColor = mainColor
        endRangeTextField.hidden = true
        endRangeTextField.keyboardType = UIKeyboardType.NumberPad
        endRangeTextField.backgroundColor = UIColor.whiteColor()
        endRangeTextField.addTarget(self, action: Selector("updateAmountAllEvents:"), forControlEvents: UIControlEvents.AllEvents)
        endRangeTextField.delegate = self
        
        if endRangeAmount != 0 {
            endRangeTextField.text = "\(endRangeAmount)"
        }
        
        cell.contentView.addSubview(endRangeTextField)
    }
    
    func addDayTextField(cell:UITableViewCell){
        dayTextField = UITextField(frame: CGRectMake(15*ratio, 9.5*ratio, 290*ratio, 30*ratio))
        dayTextField.textAlignment = NSTextAlignment.Left
        dayTextField.placeholder = "분량을 입력하세요"
        dayTextField.font = UIFont(name: "AvenirNext-Regular", size: 10*ratio)
        dayTextField.textColor = UIColor.colorWithHexString("#969696")
        dayTextField.tintColor = mainColor
        dayTextField.hidden = true
        dayTextField.keyboardType = UIKeyboardType.NumberPad
        dayTextField.backgroundColor = UIColor.whiteColor()
        dayTextField.addTarget(self, action: Selector("updateAmountAllEvents:"), forControlEvents: UIControlEvents.AllEvents)
        dayTextField.delegate = self
        
        if dayAmount != 0 {
            dayTextField.text = "\(dayAmount)"
        }
        
        cell.contentView.addSubview(dayTextField)
    }
    
    func addInvestButton(cell:UITableViewCell){
        investButton = UIButton(frame: CGRectMake(175*ratio, 9.5*ratio, 130*ratio, 30*ratio))
        investButton.backgroundColor = UIColor.whiteColor()
        investButton.setTitle("목표투자시간", forState: UIControlState.Normal)
        investButton.addTarget(self, action: Selector("showInvestVC"), forControlEvents: UIControlEvents.TouchUpInside)
        cell.contentView.addSubview(investButton)
    }
    
    
    func getTimeString(time:Int)->String{
        
        let hour = time.toHour()
        let minute = time.toMinute()
        
        if hour == 0 {
            return "주 \(minute)분"
        }else{
            if minute == 0 {
                return "주 \(hour)시간"
            }else{
                return "주 \(hour)시간 \(minute)분"
            }
        }
        
    }
    
    
}
