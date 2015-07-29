//
//  NewTaskViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 1..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit
import CoreData


/*
protocol CategoryUpdateDelegate : NSObjectProtocol{
    func updateCategory(category:Category,from:String)
}
*/


class NewTaskViewControllerOld: BasicViewController,UITextFieldDelegate,TodaitNavigationDelegate,CategoryDelegate,UITableViewDelegate,UITableViewDataSource,settingTimeDelegate,PeriodDelegate,InvestDelegate,UnitInputViewDelegate,RepeatViewDelegate{
    
    
    var mainColor: UIColor!
    var taskTableView: UITableView!
    var categoryInfoLabel: UILabel!
    var categoryCircle: UIView!
    var categoryLabel: UILabel!
    var categoryButton: UIButton!
    
    
    var taskTextField: UITextField!
    var unitSegment: UISegmentedControl!
    var unitTextField: UITextField!
    var unitView: UnitInputView!
    
    var rangeSegment: UISegmentedControl!
    var rangeSelectedIndex:Int = 0
    
    
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
    
    var aimAmount:Int! = 0
    var startRangeAmount:Int! = 0
    var endRangeAmount:Int! = 0
    var dayAmount:Int! = 0
    
    
    
    var category:Category!
    var delegate: CategoryUpdateDelegate!
    var showInvest:Int = 0
    var investData:[Int]! = [3600,3600,3600,3600,3600,3600,3600]
    var investLabel:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.colorWithHexString("#EFEFEF")
        setupTaskViewController()
        addTaskTableView()
        addUnitView()
        
        
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
    
    func registerForKeyboardNotification(){
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWasShown:"), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillBeHidden:"), name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func keyboardWasShown(aNotification:NSNotification){
        
        var info:[NSObject:AnyObject] = aNotification.userInfo!
        var kbSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)!.CGRectValue().size as CGSize
        
        var contentInsets = UIEdgeInsetsMake(0, 0, kbSize.height, 0)
        taskTableView.contentInset = contentInsets
        taskTableView.scrollIndicatorInsets = contentInsets
        
        var aRect = self.view.frame
        aRect.size.height = aRect.size.height - kbSize.height
        
        if (!CGRectContainsPoint(aRect, currentTextField.frame.origin)) {
            
            taskTableView.scrollRectToVisible(currentTextField.frame, animated: true)
            
        }
        
        if currentTextField == unitTextField {
            unitView.hidden = false
        }
        
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            self.unitView.transform = CGAffineTransformMakeTranslation(0, -kbSize.height-40*self.ratio)
            }, completion: nil)
        
    }
    
    func keyboardWillBeHidden(aNotification:NSNotification){
        
        var contentInsets = UIEdgeInsetsZero
        taskTableView.contentInset = contentInsets
        taskTableView.scrollIndicatorInsets = contentInsets
        
        
        
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            self.unitView.transform = CGAffineTransformMakeTranslation(0, 40*self.ratio)
        }) { (Bool) -> Void in
            self.unitView.hidden = true
        }
        
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
            rangeSegmentClk(rangeSegment)
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
            
        }else if(indexPath.row == 2+showInvest && indexPath.section == 2){
            showTimeBlurVC()
        }else if(indexPath.row == 0 && indexPath.section == 2){
            showPeriodVC()
        }else if(indexPath.row == 3 && indexPath.section == 2){
            showRepeatVC()
        }
        
        NSLog("%lu", showInvest)
        
        return false
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        
        let titleLabel = UILabel(frame: CGRectMake(15*ratio, 23*ratio, 200*ratio, 16*ratio))
        titleLabel.textColor = UIColor.colorWithHexString("#595959")
        titleLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14*ratio)
        
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
        categoryInfoLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14*ratio)
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
        categoryLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 16*ratio)
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
        
        
        mainColor = UIColor.colorWithHexString(editedCategory.color)
        
        category = editedCategory
        categoryLabel.text = editedCategory.name
        categoryLabel.sizeToFit()
        categoryCircle.frame = CGRectMake(width - 33*ratio - categoryLabel.frame.size.width, 20.5*ratio, 8*ratio, 8*ratio)
        categoryCircle.backgroundColor = mainColor
        
        
        setNavigationBarColor(mainColor)
        
        totalTextField.tintColor = mainColor
        startRangeTextField.tintColor = mainColor
        endRangeTextField.tintColor = mainColor
        dayTextField.tintColor = mainColor
        
        unitView.backgroundColor = mainColor
        
        
    }
    
    
    
    func addTaskTextField(cell:UITableViewCell){
        taskTextField = UITextField(frame: CGRectMake(15*ratio, 9.5*ratio, 290*ratio, 30*ratio))
        taskTextField.placeholder = "목표를 입력하세요"
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
            
            if rangeSelectedIndex == 0 {
                unitView.hidden = true
                currentTextField = totalTextField
                
            }else if rangeSelectedIndex == 1 {
                unitView.hidden = true
                currentTextField = startRangeTextField
            }else if rangeSelectedIndex == 2 {
                unitView.hidden = true
                currentTextField = dayTextField
            }
            
        }
        
        currentTextField.becomeFirstResponder()
        
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
        unitTextField.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14*ratio)
        unitTextField.textColor = UIColor.colorWithHexString("#969696")
        unitTextField.returnKeyType = UIReturnKeyType.Next
        unitTextField.backgroundColor = UIColor.whiteColor()
        unitTextField.text = unitString
        unitTextField.addTarget(self, action: Selector("updateUnitAllEvents:"), forControlEvents: UIControlEvents.AllEvents)
        unitTextField.delegate = self
        
        cell.contentView.addSubview(unitTextField)
    }
    
    func updateUnitAllEvents(textField:UITextField){
        unitString = textField.text
    }
    
    
    func addRangeSegment(cell:UITableViewCell){
        
        rangeSegment = UISegmentedControl(items: ["전체","범위","하루"])
        rangeSegment.frame = CGRectMake(-1*ratio, 7.5*ratio, 322*ratio, 34*ratio)
        rangeSegment.selectedSegmentIndex = rangeSelectedIndex
        rangeSegment.tintColor = mainColor
        rangeSegment.setTitleTextAttributes([NSFontAttributeName:UIFont(name: "AppleSDGothicNeo-Regular", size: 14*ratio)!], forState: UIControlState.Normal)
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
        infoLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14*ratio)
        cell.contentView.addSubview(infoLabel)
        
        
        periodDayLabel = UILabel(frame: CGRectMake(160*ratio, 9.5*ratio, 145*ratio, 30*ratio))
        periodDayLabel.text = periodDayString
        periodDayLabel.textAlignment = NSTextAlignment.Right
        periodDayLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 16*ratio)
        periodDayLabel.textColor = mainColor
        cell.contentView.addSubview(periodDayLabel)
        
        addLineView(cell)
    }
    
    func addInvestTimeSubView(cell:UITableViewCell){
        
        let infoLabel = UILabel(frame: CGRectMake(15*ratio, 9.5*ratio, 200*ratio, 30*ratio))
        infoLabel.text = "목표분배"
        infoLabel.textColor = UIColor.colorWithHexString("#969696")
        infoLabel.textAlignment = NSTextAlignment.Left
        infoLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14*ratio)
        cell.contentView.addSubview(infoLabel)
        
        
        investLabel = UILabel(frame: CGRectMake(160*ratio, 9.5*ratio, 145*ratio, 30*ratio))
        investLabel.text = "주 7시간"
        investLabel.textAlignment = NSTextAlignment.Right
        investLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 16*ratio)
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
    
    func showRepeatVC(){
        
        let repeatVC = RepeatViewcontroller()
        repeatVC.mainColor = mainColor
        repeatVC.delegate = self
        repeatVC.count = 1
        repeatVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext

        self.navigationController?.presentViewController(repeatVC, animated: true, completion: { () -> Void in
            
        })
        
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
        infoLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14*ratio)
        cell.contentView.addSubview(infoLabel)
        
        startDateLabel = UILabel(frame: CGRectMake(160*ratio, 9.5*ratio, 145*ratio, 30*ratio))
        startDateLabel.text = dateForm.stringFromDate(NSDate())
        startDateLabel.textAlignment = NSTextAlignment.Right
        startDateLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 16*ratio)
        startDateLabel.textColor = mainColor
        cell.contentView.addSubview(startDateLabel)
        
        addLineView(cell)
    }
    
    func addRepeatTimeSubView(cell:UITableViewCell){
        
        let infoLabel = UILabel(frame: CGRectMake(15*ratio, 9.5*ratio, 200*ratio, 30*ratio))
        infoLabel.text = "반복"
        infoLabel.textColor = UIColor.colorWithHexString("#969696")
        infoLabel.textAlignment = NSTextAlignment.Left
        infoLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14*ratio)
        cell.contentView.addSubview(infoLabel)
        
        let dateLabel = UILabel(frame: CGRectMake(160*ratio, 9.5*ratio, 145*ratio, 30*ratio))
        dateLabel.text = "1회"
        dateLabel.textAlignment = NSTextAlignment.Right
        dateLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 16*ratio)
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
        
        rangeSelectedIndex = segment.selectedSegmentIndex
        
        switch rangeSelectedIndex {
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
        totalTextField.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14*ratio)
        totalTextField.textColor = UIColor.colorWithHexString("#969696")
        totalTextField.keyboardType = UIKeyboardType.NumberPad
        totalTextField.returnKeyType = UIReturnKeyType.Done
        totalTextField.backgroundColor = UIColor.whiteColor()
        totalTextField.addTarget(self, action: Selector("updateAmountAllEvents:"), forControlEvents: UIControlEvents.AllEvents)
        totalTextField.delegate = self
        
        if aimAmount != 0 {
            totalTextField.text = "\(aimAmount)"
        }
        
        cell.contentView.addSubview(totalTextField)
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
        startRangeTextField.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14*ratio)
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
        endRangeTextField.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14*ratio)
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
        dayTextField.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14*ratio)
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
    
    func showInvestVC(){
        
        
        let investVC = InvestViewController()
        investVC.mainColor = mainColor
        investVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        investVC.delegate = self
        investVC.timeData = investData
        
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
        
        registerForKeyboardNotification()
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
        task.createdAt = NSDate()
        
        
        let dateForm = NSDateFormatter()
        dateForm.dateFormat = "yyyyMMdd"
        
        task.startDate = getDateNumberFromDate(periodStartDate)
        task.endDate = getDateNumberFromDate(periodEndDate)
        task.unit = unitTextField.text
        task.categoryId = category
        
        
        setupTextField()
        
        task.taskType = "timer"//rangeSegment.selectedSegmentIndex
        
        switch rangeSegment.selectedSegmentIndex {
        case 0:
            
            task.amount = totalTextField.text.toInt()!
            task.startPoint = 0
        case 1:
            task.amount = endRangeTextField.text.toInt()! - startRangeTextField.text.toInt()! + 1
            task.startPoint = startRangeTextField.text.toInt()! + 1
        case 2:
            task.amount = dayTextField.text.toInt()!
            task.startPoint = 0
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
        week.taskId = task
        
        
        week.sun = investData[0];
        week.mon = investData[1];
        week.tue = investData[2];
        week.wed = investData[3];
        week.thu = investData[4];
        week.fri = investData[5];
        week.sat = investData[6];
        
        
    
        
        var error: NSError?
        managedObjectContext?.save(&error)
        
    
    }
    
    func needToUpdate() {
       
       
        if self.delegate.respondsToSelector("updateCategory:from:"){
            self.delegate.updateCategory(category,from:"NewTaskVC")
        }
        
    }
    
    func setupTextField(){
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        resignForKeyboardNotification()
        
    }
    
    func resignForKeyboardNotification(){
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func backButtonClk() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
