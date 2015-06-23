//
//  NewTaskViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 1..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit
import CoreData


protocol CategoryUpdateDelegate {
    func updateCategory(category:Category)
}



class NewTaskViewController: BasicViewController,UITextFieldDelegate,TodaitNavigationDelegate,CategoryDelegate,UITableViewDelegate,UITableViewDataSource,settingTimeDelegate,PeriodDelegate,InvestDelegate{
    
    
    var mainColor: UIColor!
    var taskTableView: UITableView!
    var categoryInfoLabel: UILabel!
    var categoryCircle: UIView!
    var categoryLabel: UILabel!
    var categoryButton: UIButton!
    
    
    var taskTextField: UITextField!
    var unitSegment: UISegmentedControl!
    var unitTextField: UITextField!
    
    var rangeSegment: UISegmentedControl!
    
    
    
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
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var aimString:String! = ""
    var unitString:String! = ""
    var aimAmount:Int! = 0
    
    var category:Category!
    var delegate: CategoryUpdateDelegate!
    var showInvest:Int = 0
    var investData:[Int]! = [0,0,0,0,0,0,0]
    var investLabel:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.colorWithHexString("#EFEFEF")
        setupTaskViewController()
        addTaskTableView()
        //setupCategory()
        
        if delegate == nil {
            NSLog("delegate nil",0)
        }
    }
    
    func setupTaskViewController(){
        
        startDate = NSDate()
        periodStartDate = NSDate()
        periodEndDate = NSDate(timeIntervalSinceNow: 24*60*60 * 29)
        
        dateForm = NSDateFormatter()
        dateForm.dateFormat = "a h시 m분"
        
    }
    
    
    
    func addTaskTableView(){
        taskTableView = UITableView(frame: CGRectMake(0,navigationHeight*ratio,width,height-navigationHeight*ratio), style: UITableViewStyle.Grouped)
        taskTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        taskTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        taskTableView.contentInset = UIEdgeInsetsMake(-15*ratio, 0, 0, 0)
        taskTableView.delegate = self
        taskTableView.dataSource = self
        taskTableView.sectionFooterHeight = 0
        view.addSubview(taskTableView)
        
        
    }
    
    func setupCategory(){
        
        let entityDescription = NSEntityDescription.entityForName("Category",inManagedObjectContext:managedObjectContext!)
        
        let request = NSFetchRequest()
        request.entity = entityDescription
        
        var error: NSError?
        let categorys:[Category] = managedObjectContext?.executeFetchRequest(request, error: &error) as! [Category]
        
        if categorys.count != 0 {
            category = categorys.first
        }
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
        }else if(indexPath.row == 1 && indexPath.section == 0){
            addCategoryView(cell)
        }else if(indexPath.row == 0 && indexPath.section == 1){
            addUnitSegment(cell)
        }else if(indexPath.row == 1 && indexPath.section == 1){
            addRangeSegment(cell)
        }else if(indexPath.row == 2 && indexPath.section == 1){
            addRangeTextField(cell)
        }else if(indexPath.row == 0 && indexPath.section == 2){
            addAimDateSubView(cell)
        }else if(indexPath.row == 1 && indexPath.section == 2){
            addInvestTimeSubView(cell)
        }else if(indexPath.row == 2+showInvest && indexPath.section == 2){
            addStartTimeSubView(cell)
        }else if(indexPath.row == 3+showInvest && indexPath.section == 2){
            addRepeatTimeSubView(cell)
        }else if showInvest == 1 && indexPath.section == 2 && indexPath.row == 2 {
            addInvestChartView(cell)
        }
        
        
        return cell
    }
    
    
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        if indexPath.row == 1 && indexPath.section == 0 {
            categorySetting()
        }else if(indexPath.row == 1 && indexPath.section == 2){
            showInvestVC()
            
            /*
            
            if showInvest == 1 {
                showInvest = 0
                
                let cell:UITableViewCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 2))!
                for subView in cell.contentView.subviews{
                    subView.removeFromSuperview()
                }
                
                tableView.beginUpdates()
                tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow:2, inSection:2)], withRowAnimation: UITableViewRowAnimation.Automatic)
                tableView.endUpdates()
            }else{
                showInvest = 1
                tableView.beginUpdates()
                tableView.insertRowsAtIndexPaths([NSIndexPath(forRow:2, inSection:2)], withRowAnimation: UITableViewRowAnimation.Automatic)
                tableView.endUpdates()
            }
            
            */
            
        }else if(indexPath.row == 2+showInvest && indexPath.section == 2){
            showTimeBlurVC()
        }else if(indexPath.row == 0 && indexPath.section == 2){
            showPeriodVC()
        }
        
        NSLog("%lu", showInvest)
        
        return false
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        
        let titleLabel = UILabel(frame: CGRectMake(15*ratio, 23*ratio, 200*ratio, 16*ratio))
        titleLabel.textColor = UIColor.colorWithHexString("#595959")
        titleLabel.font = UIFont(name: "AvenirNext-Regular", size: 14*ratio)
        
        switch section {
        case 0:titleLabel.text = "목표"
        case 1:titleLabel.text = "분량"
        case 2:titleLabel.text = "분배"
        default:titleLabel.text = "없음"
        }
        
        
        headerView.addSubview(titleLabel)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector("resignAllTextResponder"))
        headerView.addGestureRecognizer(tapGesture)
        
        
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0*ratio
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45*ratio
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        
        if showInvest == 1 && indexPath.row == 2 && indexPath.section == 2 {
            return 120*ratio
        }
        
        return 49*ratio
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
    
        switch section {
        case 0: return 2
        case 1: return 3
        case 2: return 4+showInvest
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
    
    func addCategoryView(cell:UITableViewCell){
        addCategoryInfoLabel(cell)
        addCategoryLabel(cell)
        addCategoryCircle(cell)
        //addCategoryButton(cell)
    }
    
    func addCategoryInfoLabel(cell:UITableViewCell){
        categoryInfoLabel = UILabel(frame: CGRectMake(15*ratio, 9.5*ratio, 200*ratio, 30*ratio))
        categoryInfoLabel.text = "카테고리"
        categoryInfoLabel.textColor = UIColor.colorWithHexString("#969696")
        categoryInfoLabel.textAlignment = NSTextAlignment.Left
        categoryInfoLabel.font = UIFont(name: "AvenirNext-Regular", size: 14*ratio)
        cell.contentView.addSubview(categoryInfoLabel)
    }
    
    func addCategoryCircle(cell:UITableViewCell){
        categoryCircle = UIView(frame: CGRectMake(width - 33*ratio - categoryLabel.frame.size.width, 20.5*ratio, 8*ratio, 8*ratio))
        categoryCircle.backgroundColor = UIColor.colorWithHexString(category.color)
        categoryCircle.clipsToBounds = true
        categoryCircle.layer.cornerRadius = 4*ratio
        categoryCircle.setTranslatesAutoresizingMaskIntoConstraints(false)
        
    }
    
    func addCategoryLabel(cell:UITableViewCell){
        categoryLabel = UILabel(frame: CGRectMake(205*ratio, 9.5*ratio, 100*ratio, 30*ratio))
        categoryLabel.text = category.name
        categoryLabel.textColor = UIColor.colorWithHexString(category.color)
        categoryLabel.font = UIFont(name: "AvenirNext-Medium", size: 16*ratio)
        categoryLabel.textAlignment = NSTextAlignment.Right
        categoryLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        cell.contentView.addSubview(categoryLabel)
        
    }
    
    func categorySetting(){
        
        var categoryVC = CategoryViewController()
        categoryVC.delegate = self
        categoryVC.category = category
        
        self.navigationController?.pushViewController(categoryVC, animated: true)
    }
    
    func categoryEdited(editedCategory:Category) {
        category = editedCategory
        categoryLabel.text = category.name
        categoryLabel.sizeToFit()
        categoryCircle.frame = CGRectMake(width - 33*ratio - categoryLabel.frame.size.width, 20.5*ratio, 8*ratio, 8*ratio)
        categoryCircle.backgroundColor = UIColor.colorWithHexString(category.color)
        
        mainColor = UIColor.colorWithHexString(category.color)
        setNavigationBarColor(UIColor.colorWithHexString(category.color))
        
    }
    
    
    
    func addTaskTextField(cell:UITableViewCell){
        taskTextField = UITextField(frame: CGRectMake(15*ratio, 9.5*ratio, 290*ratio, 30*ratio))
        taskTextField.placeholder = "목표를 입력하세요"
        taskTextField.font = UIFont(name: "AvenirNext-Regular", size: 14*ratio)
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
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField == taskTextField {
            unitTextField.becomeFirstResponder()
        }else if textField == unitTextField {
            totalTextField.becomeFirstResponder()
        }
        
        return false
    }
    
    func updateAllEvents(textField:UITextField){
        aimString = textField.text
    }
    
    
    func addLineView(cell: UITableViewCell){
        
        let lineView = UIView(frame: CGRectMake(15*ratio, 48.5*ratio,290*ratio, 0.5*ratio))
        lineView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15)
        cell.contentView.addSubview(lineView)
    }
    
    func addUnitSegment(cell:UITableViewCell){
        
        
        unitTextField = UITextField(frame: CGRectMake(15*ratio, 9.5*ratio, 290*ratio, 30*ratio))
        unitTextField.placeholder = "단위를 입력하세요"
        unitTextField.tintColor = mainColor
        unitTextField.font = UIFont(name: "AvenirNext-Regular", size: 14*ratio)
        unitTextField.textColor = UIColor.colorWithHexString("#969696")
        unitTextField.returnKeyType = UIReturnKeyType.Next
        unitTextField.backgroundColor = UIColor.whiteColor()
        unitTextField.addTarget(self, action: Selector("unitTextFieldClk:"), forControlEvents: UIControlEvents.AllEvents)
        unitTextField.text = unitString
        unitTextField.addTarget(self, action: Selector("updateUnitAllEvents:"), forControlEvents: UIControlEvents.AllEvents)
        unitTextField.delegate = self
        currentTextField = unitTextField
        
        
        cell.contentView.addSubview(unitTextField)
    }
    
    func updateUnitAllEvents(textField:UITextField){
        unitString = textField.text
    }
    
    func unitTextFieldClk(textField:UITextField){
        
    }
    
    func addRangeSegment(cell:UITableViewCell){
        
        rangeSegment = UISegmentedControl(items: ["전체","범위","하루"])
        rangeSegment.frame = CGRectMake(-1*ratio, 7.5*ratio, 322*ratio, 34*ratio)
        rangeSegment.selectedSegmentIndex = 0
        rangeSegment.tintColor = mainColor
        rangeSegment.setTitleTextAttributes([NSFontAttributeName:UIFont(name: "AvenirNext-Regular", size: 14*ratio)!], forState: UIControlState.Normal)
        rangeSegment.addTarget(self, action: Selector("rangeSegmentClk:"), forControlEvents: UIControlEvents.AllEvents)
        cell.contentView.addSubview(rangeSegment)
        
    }
    
    func addRangeTextField(cell:UITableViewCell){
        addTotalTextField(cell)
        addStartRangeTextField(cell)    
        addEndRangeTextField(cell)
        addDayTextField(cell)
    }
    
    func addAimDateSubView(cell:UITableViewCell){
        
        let infoLabel = UILabel(frame: CGRectMake(15*ratio, 9.5*ratio, 200*ratio, 30*ratio))
        infoLabel.text = "기간설정"
        infoLabel.textAlignment = NSTextAlignment.Left
        infoLabel.textColor = UIColor.colorWithHexString("#969696")
        infoLabel.font = UIFont(name: "AvenirNext-Regular", size: 14*ratio)
        cell.contentView.addSubview(infoLabel)
        
        
        periodDayLabel = UILabel(frame: CGRectMake(160*ratio, 9.5*ratio, 145*ratio, 30*ratio))
        periodDayLabel.text = "30일"
        periodDayLabel.textAlignment = NSTextAlignment.Right
        periodDayLabel.font = UIFont(name: "AvenirNext-Medium", size: 16*ratio)
        periodDayLabel.textColor = mainColor
        cell.contentView.addSubview(periodDayLabel)
        
        addLineView(cell)
    }
    
    func addInvestTimeSubView(cell:UITableViewCell){
        
        let infoLabel = UILabel(frame: CGRectMake(15*ratio, 9.5*ratio, 200*ratio, 30*ratio))
        infoLabel.text = "목표분배"
        infoLabel.textColor = UIColor.colorWithHexString("#969696")
        infoLabel.textAlignment = NSTextAlignment.Left
        infoLabel.font = UIFont(name: "AvenirNext-Regular", size: 14*ratio)
        cell.contentView.addSubview(infoLabel)
        
        
        investLabel = UILabel(frame: CGRectMake(160*ratio, 9.5*ratio, 145*ratio, 30*ratio))
        investLabel.text = "주 8시간"
        investLabel.textAlignment = NSTextAlignment.Right
        investLabel.font = UIFont(name: "AvenirNext-Medium", size: 16*ratio)
        investLabel.textColor = mainColor
        cell.contentView.addSubview(investLabel)
        
        addLineView(cell)
    }
    
    func showTimeBlurVC(){
        
        let timerBlurVC = TimerBlurViewController()
        timerBlurVC.delegate = self
        timerBlurVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        timerBlurVC.timerDate = startDate
        timerBlurVC.mainColor = mainColor
        
        self.navigationController?.presentViewController(timerBlurVC, animated: true, completion: { () -> Void in
            
        })

        
    }
    
    func showPeriodVC(){
        
        performSegueWithIdentifier("ShowPeriodView", sender:self)
        
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
    
    func addRepeatTimeSubView(cell:UITableViewCell){
        
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
    
    
    func rangeSegmentClk(segment:UISegmentedControl){
        let selectedIndex = segment.selectedSegmentIndex
        
        switch selectedIndex {
            case 0:
                totalTextField.hidden = false
                startRangeTextField.hidden = true
                endRangeTextField.hidden = true
                dayTextField.hidden = true
            case 1:
                totalTextField.hidden = true
                startRangeTextField.hidden = false
                endRangeTextField.hidden = false
                dayTextField.hidden = true
            case 2:
                totalTextField.hidden = true
                startRangeTextField.hidden = true
                endRangeTextField.hidden = true
                dayTextField.hidden = false
            default:
                totalTextField.hidden = false
                startRangeTextField.hidden = true
                endRangeTextField.hidden = true
                dayTextField.hidden = true
        }
        
    }
    
    func addTotalTextField(cell:UITableViewCell){
        totalTextField = UITextField(frame: CGRectMake(15*ratio, 9.5*ratio, 290*ratio, 30*ratio))
        totalTextField.textAlignment = NSTextAlignment.Left
        totalTextField.placeholder = "분량을 입력하세요"
        totalTextField.tintColor = mainColor
        totalTextField.font = UIFont(name: "AvenirNext-Regular", size: 14*ratio)
        totalTextField.textColor = UIColor.colorWithHexString("#969696")
        totalTextField.keyboardType = UIKeyboardType.NumberPad
        totalTextField.returnKeyType = UIReturnKeyType.Done
        totalTextField.backgroundColor = UIColor.whiteColor()
        totalTextField.addTarget(self, action: Selector("updateAmountAllEvents:"), forControlEvents: UIControlEvents.AllEvents)
        
        if aimAmount != 0 {
            totalTextField.text = "\(aimAmount)"
        }
        
        cell.contentView.addSubview(totalTextField)
    }
    
    func updateAmountAllEvents(textField:UITextField){
        aimAmount = textField.text.toInt()
    }
    

    
    func addStartRangeTextField(cell:UITableViewCell){
        startRangeTextField = UITextField(frame: CGRectMake(15*ratio, 9.5*ratio, 130*ratio, 30*ratio))
        startRangeTextField.textAlignment = NSTextAlignment.Left
        startRangeTextField.placeholder = "시작"
        startRangeTextField.font = UIFont(name: "AvenirNext-Regular", size: 14*ratio)
        startRangeTextField.textColor = UIColor.colorWithHexString("#969696")
        startRangeTextField.hidden = true
        startRangeTextField.keyboardType = UIKeyboardType.NumberPad
        startRangeTextField.backgroundColor = UIColor.whiteColor()
        cell.contentView.addSubview(startRangeTextField)
    }
    
    func addEndRangeTextField(cell:UITableViewCell){
        endRangeTextField = UITextField(frame: CGRectMake(175*ratio, 9.5*ratio, 130*ratio, 30*ratio))
        endRangeTextField.textAlignment = NSTextAlignment.Left
        endRangeTextField.placeholder = "종료"
        endRangeTextField.font = UIFont(name: "AvenirNext-Regular", size: 14*ratio)
        endRangeTextField.textColor = UIColor.colorWithHexString("#969696")
        endRangeTextField.hidden = true
        endRangeTextField.keyboardType = UIKeyboardType.NumberPad
        endRangeTextField.backgroundColor = UIColor.whiteColor()
        cell.contentView.addSubview(endRangeTextField)
    }
    
    func addDayTextField(cell:UITableViewCell){
        dayTextField = UITextField(frame: CGRectMake(15*ratio, 9.5*ratio, 290*ratio, 30*ratio))
        dayTextField.textAlignment = NSTextAlignment.Left
        dayTextField.placeholder = "분량을 입력하세요"
        dayTextField.font = UIFont(name: "AvenirNext-Regular", size: 14*ratio)
        dayTextField.textColor = UIColor.colorWithHexString("#969696")
        dayTextField.hidden = true
        dayTextField.keyboardType = UIKeyboardType.NumberPad
        dayTextField.backgroundColor = UIColor.whiteColor()
        cell.contentView.addSubview(dayTextField)
    }
    
    func addInvestButton(cell:UITableViewCell){
        investButton = UIButton(frame: CGRectMake(175*ratio, 9.5*ratio, 130*ratio, 30*ratio))
        investButton.backgroundColor = UIColor.whiteColor()
        investButton.setTitle("목표투자시간", forState: UIControlState.Normal)
        investButton.addTarget(self, action: Selector("showInvestVC"), forControlEvents: UIControlEvents.TouchUpInside)
        cell.contentView.addSubview(investButton)
    }
    
    func showInvestVC(){
        
        
        let investVC = InvestViewController()
        investVC.mainColor = mainColor
        investVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        investVC.delegate = self
        
        self.navigationController?.presentViewController(investVC, animated: true, completion: { () -> Void in
            
            
        })
    }
    
    func updateInvestData(data:[Int]){
        investData = data
        
        var time = 0
        for index in 0...6{
            time = time + investData[index]
        }
        
        
        investLabel.text = getTimeString(time)
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
    
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        todaitNavBar.todaitDelegate = self
        todaitNavBar.backButton.hidden = false
        self.titleLabel.text = "새로운 목표"
        
        self.screenName = "Create Activity"
        
        addSaveButton()
        
        setNavigationBarColor(mainColor)
        taskTableView.reloadData()
    }
    
    
    
    func addSaveButton(){
        
        saveButton = UIButton(frame: CGRectMake(288*ratio,30,24,24))
        saveButton.setBackgroundImage(UIImage.maskColor("newPlus.png",color:UIColor.whiteColor()), forState: UIControlState.Normal)
        saveButton.addTarget(self, action: Selector("saveNewTask"), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(saveButton)
    }
    
    
    
    
    func saveNewTask(){
        
        let entityDescription = NSEntityDescription.entityForName("Task", inManagedObjectContext:managedObjectContext!)
        let task = Task(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
        
        task.name = taskTextField.text
        task.created_at = NSDate()
        
        
        let dateForm = NSDateFormatter()
        dateForm.dateFormat = "yyyyMMdd"
        
        task.start_date = getDateNumberFromDate(periodStartDate)
        task.end_date = getDateNumberFromDate(periodEndDate)
        task.unit = unitTextField.text
        task.category_id = category
        
        
        setupTextField()
        
        
        switch rangeSegment.selectedSegmentIndex {
        case 0:
            task.amount = totalTextField.text.toInt()!
            task.start_point = 0
        case 1:
            task.amount = endRangeTextField.text.toInt()! - startRangeTextField.text.toInt()! + 1
            task.start_point = startRangeTextField.text.toInt()! + 1
        case 2:
            task.amount = dayTextField.text.toInt()!
            task.start_point = 0
        default:
            task.amount = 0
        }
        
        
        saveNewWeek(task)
        
        var error: NSError?
        managedObjectContext?.save(&error)
        
        if let err = error {
            //에러처리
        }else{
            
            NSLog("Task 저장성공",1)
            needToUpdate()
            
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    
    func saveNewWeek(task:Task){
        
        let entityDescription = NSEntityDescription.entityForName("Week", inManagedObjectContext:managedObjectContext!)
        let week = Week(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
        week.task_id = task
        
        
        week.sun_minute = investData[0];
        week.mon_minute = investData[1];
        week.tue_minute = investData[2];
        week.wed_minute = investData[3];
        week.thu_minute = investData[4];
        week.fri_minute = investData[5];
        week.sat_minute = investData[6];
        
        
        week.updated_at = NSDate()
        week.created_at = NSDate()
    
        
        var error: NSError?
        managedObjectContext?.save(&error)
        
    
    }
    
    func needToUpdate() {
       
       
        self.delegate.updateCategory(category)
        
        /*
        if self.delegate.respondsToSelector("updateCategory:"){
            self.delegate.updateCategory(category4)
        }
        */
    }
    
    func setupTextField(){
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func backButtonClk() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
