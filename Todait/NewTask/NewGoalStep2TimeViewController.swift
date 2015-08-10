//
//  NewGoalStep2TimeViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 7. 31..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit
import CoreData 

class NewGoalStep2TimeViewController: BasicViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,PeriodDelegate,UnitInputViewDelegate,CategoryDelegate,TodaitNavigationDelegate,ValidationDelegate,KeyboardHelpDelegate{
    
    
    private enum Status{
        case Goal
        case Total
        case Start
        case End
        case Unit
        case None
    }
    
    
    var mainColor: UIColor!
    
    var categoryButton: UIButton!
    
    
    var goalTextField: UITextField!
    var unitTextField: UITextField!
    var unitView: UnitInputView!
    
    
    var totalAmountField: UITextField!
    var startAmountField: UITextField!
    var endAmountField: UITextField!
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
    
    var option:OptionStatus = OptionStatus.None
    var isTotal:Bool! = true
    var rangeList:[[String:String]] = []
    
    
    
    
    
    var totalAmount:Int!
    var startRangeAmount:Int!
    var endRangeAmount:Int!
    var dayAmount:Int!
    
    
    var nextButton:UIButton!
    var category:Category!
    
    var keyboardHelpView:KeyboardHelpView!
    private var status:Status! = Status.None
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.todaitBackgroundGray()
        
        
        loadDefaultCategory()
        setupTimeTaskViewController()
        
        initCellSubViews()
        addUnitView()
        addTimeTaskTableView()
        addKeyboardHelpView()
        
        
    }
    
    func loadDefaultCategory(){
        
        let entityDescription = NSEntityDescription.entityForName("Category",inManagedObjectContext:managedObjectContext!)
        let request = NSFetchRequest()
        
        request.entity = entityDescription
        
        var error: NSError?
        
        var categoryData = managedObjectContext?.executeFetchRequest(request, error: &error) as? [Category]
        
        if let categoryData = categoryData {
            category = categoryData.first
        }
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.todaitNavBar.hidden = false
        self.titleLabel.text = "기간 계산"
        self.todaitNavBar.backButton.hidden = false
        self.todaitNavBar.todaitDelegate = self
        
        addNextButton()
        registerForKeyboardNotification()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        resignForKeyboardNotification()
    }
    
    func resignForKeyboardNotification(){
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    
    func registerForKeyboardNotification(){
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWasShown:"), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillBeHidden:"), name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func keyboardWasShown(aNotification:NSNotification){
        
        var info:[NSObject:AnyObject] = aNotification.userInfo!
        var kbSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)!.CGRectValue().size as CGSize
        
        
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            
            if self.status != Status.None {
                self.keyboardHelpView.transform = CGAffineTransformMakeTranslation(0, -kbSize.height - 38*self.ratio)
            }
            
            }) { (Bool) -> Void in
                
        }
        
    }
    
    func keyboardWillBeHidden(aNotification:NSNotification){
        
        var contentInsets = UIEdgeInsetsZero
        
        
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            
            self.keyboardHelpView.transform = CGAffineTransformMakeTranslation(0,0)
            
            }) { (Bool) -> Void in
                
        }
        
    }
    
    
    func backButtonClk(){
        self.navigationController?.popViewControllerAnimated(true)
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
        
        
        let validator = Validator()
        validator.registerField(goalTextField, rules:[MinLengthRule(length: 1, message: "목표를 입력해주세요.")])
        validator.registerField(unitTextField, rules: [MinLengthRule(length: 1, message: "단위를 입력해주세요.")])
        
        if isTotal == true {
            validator.registerField(totalAmountField, rules: [MinLengthRule(length: 1, message: "전체분량을 입력해주세요.")])
        }else{
            validator.registerField(startAmountField, rules: [MinLengthRule(length: 1, message: "시작범위를 입력해주세요.")])
            validator.registerField(endAmountField, rules: [MinLengthRule(length: 1, message: "종료범위를 입력해주세요.")])
        }
        
        
        validator.validate(self)
        
    }
    
    
    func showNextStep(){
        let step3TimeVC = NewGoalStep3TimeViewController()
        step3TimeVC.startDate = periodStartDate
        step3TimeVC.endDate = periodEndDate
        step3TimeVC.titleString = goalTextField.text
        step3TimeVC.unitString = unitTextField.text
        
        
        if let totalAmount = totalAmountField.text.toInt() {
            
            step3TimeVC.totalAmount = CGFloat(totalAmount)
            
        }else{
            step3TimeVC.totalAmount = 0
            
            let alert = UIAlertView(title: "Invalid", message: "전체분량을 입력해주세요.", delegate: nil, cancelButtonTitle: "Cancel")
            alert.show()
            return
        }

        self.navigationController?.pushViewController(step3TimeVC, animated: true)
    
    }
    
    func validationSuccessful(){
        showNextStep()
    }
    
    func validationFailed(errors: [UITextField:ValidationError]){
        
        
        for ( textField , error) in errors {
            
            let alert = UIAlertView(title: "Invalid", message: error.errorMessage, delegate: nil, cancelButtonTitle: "Cancel")
            
            alert.show()
            
            return
        }
    }
    
    
    func setupTimeTaskViewController(){
        startDate = NSDate()
        periodStartDate = NSDate()
        periodEndDate = NSDate(timeIntervalSinceNow: 24*60*60 * 29)
        
        dateForm = NSDateFormatter()
        dateForm.dateFormat = "a h시 m분"
        
    }
    
    func initCellSubViews(){
        goalTextField = UITextField(frame: CGRectMake(20*ratio, 19*ratio, 255*ratio, 12*ratio))
        goalTextField.placeholder = "이곳에 목표를 입력해주세요"
        goalTextField.textAlignment = NSTextAlignment.Left
        goalTextField.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12*ratio)
        goalTextField.textColor = UIColor.colorWithHexString("#969696")
        goalTextField.returnKeyType = UIReturnKeyType.Next
        goalTextField.backgroundColor = UIColor.whiteColor()
        goalTextField.addTarget(self, action: Selector("updateAllEvents:"), forControlEvents: UIControlEvents.AllEvents)
        goalTextField.text = aimString
        goalTextField.tintColor = mainColor
        goalTextField.delegate = self
        status = Status.Goal
        
        currentTextField = goalTextField
        
        
        
        
        categoryButton = UIButton(frame: CGRectMake(280*ratio,7*ratio, 29*ratio, 29*ratio))
        categoryButton.setImage(UIImage(named: "category@3x.png"), forState: UIControlState.Normal)
        categoryButton.layer.cornerRadius = 15*ratio
        categoryButton.layer.borderWidth = 1
        categoryButton.layer.borderColor = UIColor.todaitGray().CGColor
        categoryButton.clipsToBounds = true
        categoryButton.addTarget(self, action: Selector("showCategorySettingVC"), forControlEvents: UIControlEvents.TouchUpInside)
       
        categoryEdited(category)
        
        
        
        periodDayLabel = UILabel(frame: CGRectMake(272*ratio, 30*ratio, 33*ratio, 16*ratio))
        periodDayLabel.text = periodDayString
        periodDayLabel.textAlignment = NSTextAlignment.Left
        periodDayLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 10*ratio)
        periodDayLabel.textColor = UIColor.todaitDarkGray().colorWithAlphaComponent(0.7)
        
        
        totalButton = UIButton(frame: CGRectMake(19*ratio, 23*ratio, 89*ratio, 32*ratio))
        totalButton.setTitle("전체", forState: UIControlState.Normal)
        totalButton.setTitleColor(UIColor.todaitDarkGray(), forState: UIControlState.Normal)
        totalButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 10*ratio)
        totalButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        totalButton.layer.borderColor = UIColor.colorWithHexString("#B2B2B2").CGColor
        totalButton.layer.borderWidth = 0.5*ratio
        totalButton.addTarget(self, action: Selector("totalButtonClk"), forControlEvents: UIControlEvents.TouchUpInside)
        
        rangeButton = UIButton(frame: CGRectMake(108*ratio, 23*ratio, 89*ratio, 32*ratio))
        rangeButton.setTitle("범위", forState: UIControlState.Normal)
        rangeButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 10*ratio)
        rangeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        rangeButton.addTarget(self, action: Selector("rangeButtonClk"), forControlEvents: UIControlEvents.TouchUpInside)
        
        setAmountButtonHighlight(totalButton, highlight: isTotal)
        setAmountButtonHighlight(rangeButton, highlight: !isTotal)
        
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
        
        
        
        
        
        totalAmountField = UITextField(frame: CGRectMake(75*ratio, 21*ratio, 235*ratio, 16*ratio))
        totalAmountField.textAlignment = NSTextAlignment.Left
        totalAmountField.placeholder = "분량을 입력하세요"
        totalAmountField.tintColor = mainColor
        totalAmountField.font = UIFont(name: "AppleSDGothicNeo-Ultralight", size: 14*ratio)
        totalAmountField.textColor = UIColor.colorWithHexString("#969696")
        totalAmountField.keyboardType = UIKeyboardType.NumberPad
        totalAmountField.returnKeyType = UIReturnKeyType.Done
        totalAmountField.backgroundColor = UIColor.whiteColor()
        totalAmountField.addTarget(self, action: Selector("updateAmountAllEvents:"), forControlEvents: UIControlEvents.AllEvents)
        totalAmountField.delegate = self
        
        
        
        
        
        
        startAmountField = UITextField(frame:CGRectMake(15*ratio, 20*ratio, 140*ratio, 17*ratio))
        startAmountField.placeholder = "시작"
        startAmountField.textAlignment = NSTextAlignment.Center
        startAmountField.font = UIFont(name: "AppleSDGothicNeo-Ultralight", size: 15*ratio)
        startAmountField.textColor = UIColor.todaitDarkGray()
        startAmountField.keyboardType = UIKeyboardType.NumberPad
        startAmountField.addTarget(self, action: Selector("updateStartAmount:"), forControlEvents: UIControlEvents.AllEvents)
        startAmountField.delegate = self
        
        
        endAmountField = UITextField(frame:CGRectMake(165*ratio, 20*ratio, 140*ratio, 17*ratio))
        endAmountField.placeholder = "종료"
        endAmountField.textAlignment = NSTextAlignment.Center
        endAmountField.font = UIFont(name: "AppleSDGothicNeo-Ultralight", size: 15*ratio)
        endAmountField.textColor = UIColor.todaitDarkGray()
        endAmountField.addTarget(self, action: Selector("updateEndAmount:"), forControlEvents: UIControlEvents.AllEvents)
        endAmountField.keyboardType = UIKeyboardType.NumberPad
        endAmountField.delegate = self
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
        timeTaskTableView = UITableView(frame: CGRectMake(2*ratio,navigationHeight + 2*ratio,316*ratio,view.frame.size.height - navigationHeight - 2*ratio), style: UITableViewStyle.Grouped)
        timeTaskTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        timeTaskTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        timeTaskTableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0)
        timeTaskTableView.delegate = self
        timeTaskTableView.dataSource = self
        timeTaskTableView.sectionHeaderHeight = 0
        timeTaskTableView.sectionFooterHeight = 2
        timeTaskTableView.pagingEnabled = false
        timeTaskTableView.bounces = false
        timeTaskTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        timeTaskTableView.backgroundColor = UIColor.todaitBackgroundGray()
        view.addSubview(timeTaskTableView)
    }
    
    
    func addKeyboardHelpView(){
        
        keyboardHelpView = KeyboardHelpView(frame: CGRectMake(0, height , width, 38*ratio + 185*ratio))
        keyboardHelpView.backgroundColor = UIColor.whiteColor()
        keyboardHelpView.leftImageName = "bt_keybord_left@3x.png"
        keyboardHelpView.rightImageName = "bt_keybord_right@3x.png"
        keyboardHelpView.setStatus(KeyboardHelpStatus.Center)
        keyboardHelpView.delegate = self
        view.addSubview(keyboardHelpView)
        
        
        let line = UIView(frame: CGRectMake(0, 38*ratio-1, width, 1))
        line.backgroundColor = UIColor.colorWithHexString("#d1d5da")
        keyboardHelpView.addSubview(line)
        
    }
    
    
    
    
    func leftButtonClk(){
        
        if isTotal == true {
            
            switch status as Status {
            
            case .Total: goalTextField.becomeFirstResponder() ; status = .Goal ; keyboardHelpView.setStatus(KeyboardHelpStatus.Start)
            case .Unit: totalAmountField.becomeFirstResponder() ; status = .Total ; keyboardHelpView.setStatus(KeyboardHelpStatus.Center)
            default: status = .None ; confirmButtonClk()
                
            }
            
        }else{
            
            switch status as Status {
            case .Start: goalTextField.becomeFirstResponder() ; status = .Goal ; keyboardHelpView.setStatus(KeyboardHelpStatus.Start)
            case .End: startAmountField.becomeFirstResponder() ; status = .Start ; keyboardHelpView.setStatus(KeyboardHelpStatus.Center)
            case .Unit: endAmountField.becomeFirstResponder() ; status = .End ; keyboardHelpView.setStatus(KeyboardHelpStatus.Center)
            default: status = .None ; confirmButtonClk()
            }
            
        }
    }
    
    
    func rightButtonClk(){
        
        if isTotal == true {
            
            switch status as Status {
            case .Goal: totalAmountField.becomeFirstResponder() ; status = .Total ; keyboardHelpView.setStatus(KeyboardHelpStatus.Center)
            case .Total: unitTextField.becomeFirstResponder() ; status = .Unit ; keyboardHelpView.setStatus(KeyboardHelpStatus.End)
            default: status = .None ; confirmButtonClk()
            }
            
        }else{
            
            switch status as Status {
            case .Goal: startAmountField.becomeFirstResponder() ; status = .Start ; keyboardHelpView.setStatus(KeyboardHelpStatus.Center)
            case .Start: endAmountField.becomeFirstResponder() ; status = .End ; keyboardHelpView.setStatus(KeyboardHelpStatus.Center)
            case .End: unitTextField.becomeFirstResponder() ; status = .Unit ; keyboardHelpView.setStatus(KeyboardHelpStatus.End)
            default: status = .None ; confirmButtonClk()
            }
            
        }
    }
    
    
    func confirmButtonClk(){
        
        status = Status.None
        currentTextField.textColor = UIColor.todaitGray()
        currentTextField.resignFirstResponder()
        
        
    }
    
    
    

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        
        
        for view in cell.contentView.subviews{
            view.removeFromSuperview()
        }
        
        cell.contentView.clipsToBounds = true
        cell.contentView.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
        
        if indexPath.row == 0 && indexPath.section == 0 {
            
            addGoalTextField(cell)
            addCategoryButton(cell)
            
        }else if(indexPath.row == 0 && indexPath.section == 1){
            
            addAimDateSubView(cell)
            
        }else if(indexPath.row == 1 && indexPath.section == 1){
            
            
            addAmountButton(cell)
            
        }else if indexPath.row == 2 && indexPath.section == 1 {
            
            
            if isTotal == true {
                addTotalAmountField(cell)
            }else{
                addRangeTextField(cell,indexPath:indexPath)
            }
            
        }
        return cell
    }
    
    
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        if indexPath.row == 0 && indexPath.section == 1 {
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
        return 2
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        
        if indexPath.row == 0 && indexPath.section == 3 {
            return 120*ratio
        }else if indexPath.row == 0 && indexPath.section == 1 {
            return 53*ratio
        }else if indexPath.row == 1 && indexPath.section == 1 {
            return 53*ratio
        }else if indexPath.row == 0 && indexPath.section == 0 {
            return 43*ratio
        }
        
        
        return 54*ratio
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        switch section {
        case 0: return 1
        case 1: return 3
        default: return 0
            
        }
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    
    func resignAllTextResponder(){
        
        unitTextField.resignFirstResponder()
        goalTextField.resignFirstResponder()
        
        totalAmountField.resignFirstResponder()
        startAmountField.resignFirstResponder()
        endAmountField.resignFirstResponder()
        dayTextField.resignFirstResponder()
        
    }
    
    
    
    func addGoalTextField(cell:UITableViewCell){
        
        
        cell.contentView.addSubview(goalTextField)
            }
    
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        goalTextField.textColor = UIColor.todaitGray()
        unitTextField.textColor = UIColor.todaitGray()
        startAmountField.textColor = UIColor.todaitGray()
        endAmountField.textColor = UIColor.todaitGray()
        totalAmountField.textColor = UIColor.todaitGray()
        
        currentTextField = textField
        currentTextField.textColor = UIColor.todaitRed()
        
        
        
        
        switch currentTextField {
        case totalAmountField: status = Status.Total ; keyboardHelpView.setStatus(KeyboardHelpStatus.Center)
        case unitTextField: status = Status.Unit ; keyboardHelpView.setStatus(KeyboardHelpStatus.End)
        case goalTextField: status = Status.Goal ; keyboardHelpView.setStatus(KeyboardHelpStatus.Start)
        case startAmountField: status = Status.Start ; keyboardHelpView.setStatus(KeyboardHelpStatus.Center)
        case endAmountField: status = Status.End ; keyboardHelpView.setStatus(KeyboardHelpStatus.Center)
        default : status = Status.None
        }
        
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        
        currentTextField = textField
        currentTextField.textColor = UIColor.todaitRed()
        
        /*
        if currentTextField == unitTextField {
            unitView.hidden = false
        }else{
            unitView.hidden = true
        }
        */
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        /*
        if textField == goalTextField {
            
            unitView.hidden = false
            currentTextField = unitTextField
            
        }else if textField == unitTextField {
            
            unitView.hidden = true
            
        }
        */

        currentTextField.becomeFirstResponder()
        
        return false
    }
    
    func updateAllEvents(textField:UITextField){
        aimString = textField.text
    }
    
    func addCategoryButton(cell:UITableViewCell){
        
        cell.contentView.addSubview(categoryButton)
        
    }
    
    
    
    func showCategorySettingVC(){
        
        var categoryVC = CategorySettingViewController()
        categoryVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        categoryVC.delegate = self
        categoryVC.selectedCategory = category
        
        self.navigationController?.presentViewController(categoryVC, animated: false, completion: { () -> Void in
            
        })
        
        
    }
    
    func categoryEdited(editedCategory:Category){
        
        categoryButton.layer.borderColor = UIColor.clearColor().CGColor
        categoryButton.setImage(UIImage.maskColor("category@3x.png", color: UIColor.whiteColor()), forState: UIControlState.Normal)
        categoryButton.setBackgroundImage(UIImage.maskColor("circle@3x.png", color: UIColor.colorWithHexString(editedCategory.color)), forState: UIControlState.Normal)
        categoryButton.setBackgroundImage(UIImage.maskColor("circle@3x.png", color: UIColor.todaitLightGray()), forState: UIControlState.Highlighted)
        self.category = editedCategory
        
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
        
        
        let infoLabel = UILabel(frame: CGRectMake(20*ratio, 21*ratio, 200*ratio, 16*ratio))
        infoLabel.text = "범위"
        infoLabel.textAlignment = NSTextAlignment.Left
        infoLabel.textColor = UIColor.todaitDarkGray()
        infoLabel.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 10*ratio)
        cell.contentView.addSubview(infoLabel)
        cell.contentView.addSubview(startAmountField)
        
        
        let middleBox = UIView(frame: CGRectMake(158*ratio, 29.5*ratio, 4*ratio, 1*ratio))
        middleBox.backgroundColor = UIColor.todaitDarkGray()
        cell.contentView.addSubview(middleBox)
        
        
        cell.contentView.addSubview(endAmountField)
        
        
        if let value = startRangeAmount {
            startAmountField.text = "\(value)"
        }
        
        if let value = endRangeAmount {
            endAmountField.text = "\(value)"
        }
        
        
        var line = UIView(frame:CGRectMake(20*ratio, 43*ratio, 272*ratio, 0.5*ratio))
        line.backgroundColor = UIColor.todaitDarkGray().colorWithAlphaComponent(0.3)
        cell.contentView.addSubview(line)
        
        
        
    }
    
    
    func updateStartAmount(textField:UITextField){
        startRangeAmount = textField.text.toInt()
    }
    
    
    func updateEndAmount(textField:UITextField){
        endRangeAmount = textField.text.toInt()
    }
    
    
    func addAimDateSubView(cell:UITableViewCell){
        
        
        let infoLabel = UILabel(frame: CGRectMake(20*ratio, 30*ratio, 200*ratio, 16*ratio))
        infoLabel.text = "기간"
        infoLabel.textAlignment = NSTextAlignment.Left
        infoLabel.textColor = UIColor.todaitDarkGray()
        infoLabel.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 10*ratio)
        cell.contentView.addSubview(infoLabel)
        
        
        
        
        let periodStartLabel = UILabel(frame:CGRectMake(15*ratio, 28*ratio, 137*ratio, 20*ratio))
        periodStartLabel.text = getDateString(getDateNumberFromDate(periodStartDate))
        periodStartLabel.textAlignment = NSTextAlignment.Right
        periodStartLabel.font = UIFont(name: "AppleSDGothicNeo-Ultralight", size: 15*ratio)
        periodStartLabel.textColor = UIColor.todaitDarkGray()
        periodStartLabel.setKern(2)
        cell.contentView.addSubview(periodStartLabel)
        
        
        let middleBox = UIView(frame: CGRectMake(158*ratio, 37.5*ratio, 4*ratio, 1*ratio))
        middleBox.backgroundColor = UIColor.todaitDarkGray()
        cell.contentView.addSubview(middleBox)
        
        
        let periodEndLabel = UILabel(frame:CGRectMake(168*ratio, 28*ratio, 140*ratio, 20*ratio))
        periodEndLabel.text = getDateString(getDateNumberFromDate(periodEndDate))
        periodEndLabel.textAlignment = NSTextAlignment.Left
        periodEndLabel.font = UIFont(name: "AppleSDGothicNeo-Ultralight", size: 15*ratio)
        periodEndLabel.textColor = UIColor.todaitDarkGray()
        periodEndLabel.setKern(2)
        cell.contentView.addSubview(periodEndLabel)
        
        
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
        
        
        cell.addSubview(totalButton)
        cell.addSubview(rangeButton)
        
        
        
        setAmountButtonHighlight(totalButton, highlight: isTotal)
        setAmountButtonHighlight(rangeButton, highlight: !isTotal)
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
    
    func addreviewTimeSubView(cell:UITableViewCell){
        
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
    
    
    func addTotalAmountField(cell:UITableViewCell){
        
        
        let infoLabel = UILabel(frame: CGRectMake(20*ratio, 21*ratio, 200*ratio, 16*ratio))
        infoLabel.text = "전체"
        infoLabel.textAlignment = NSTextAlignment.Left
        infoLabel.textColor = UIColor.todaitDarkGray()
        infoLabel.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 10*ratio)
        cell.contentView.addSubview(infoLabel)
        
        
        
        
        
        
        if let totalAmount = totalAmount  {
            totalAmountField.text = "\(totalAmount)"
        }
        
        cell.contentView.addSubview(totalAmountField)
        
        var line = UIView(frame:CGRectMake(20*ratio, 43*ratio, 272*ratio, 0.5*ratio))
        line.backgroundColor = UIColor.todaitDarkGray().colorWithAlphaComponent(0.3)
        cell.contentView.addSubview(line)
    }
    
    func updateAmountAllEvents(textField:UITextField){
        
        switch textField {
        case totalAmountField : totalAmount = textField.text.toInt()
        case startAmountField : startRangeAmount = textField.text.toInt()
        case endAmountField : endRangeAmount = textField.text.toInt()
        case dayTextField : dayAmount = textField.text.toInt()
        default: textField.text = ""
        }
        
    }
    
    
    
    func addStartAmountField(cell:UITableViewCell){
        startAmountField = UITextField(frame: CGRectMake(15*ratio, 9.5*ratio, 130*ratio, 30*ratio))
        startAmountField.textAlignment = NSTextAlignment.Left
        startAmountField.placeholder = "시작"
        startAmountField.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14*ratio)
        startAmountField.textColor = UIColor.colorWithHexString("#969696")
        startAmountField.tintColor = mainColor
        startAmountField.hidden = true
        startAmountField.keyboardType = UIKeyboardType.NumberPad
        startAmountField.backgroundColor = UIColor.whiteColor()
        startAmountField.addTarget(self, action: Selector("updateAmountAllEvents:"), forControlEvents: UIControlEvents.AllEvents)
        startAmountField.delegate = self
        
        if startRangeAmount != 0 {
            startAmountField.text = "\(startRangeAmount)"
        }
        
        cell.contentView.addSubview(startAmountField)
    }
    
    
    func addEndAmountField(cell:UITableViewCell){
        endAmountField = UITextField(frame: CGRectMake(175*ratio, 9.5*ratio, 130*ratio, 30*ratio))
        endAmountField.textAlignment = NSTextAlignment.Left
        endAmountField.placeholder = "종료"
        endAmountField.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14*ratio)
        endAmountField.textColor = UIColor.colorWithHexString("#969696")
        endAmountField.tintColor = mainColor
        endAmountField.hidden = true
        endAmountField.keyboardType = UIKeyboardType.NumberPad
        endAmountField.backgroundColor = UIColor.whiteColor()
        endAmountField.addTarget(self, action: Selector("updateAmountAllEvents:"), forControlEvents: UIControlEvents.AllEvents)
        endAmountField.delegate = self
        
        if endRangeAmount != 0 {
            endAmountField.text = "\(endRangeAmount)"
        }
        
        cell.contentView.addSubview(endAmountField)
    }
    
    func addDayTextField(cell:UITableViewCell){
        dayTextField = UITextField(frame: CGRectMake(15*ratio, 9.5*ratio, 290*ratio, 30*ratio))
        dayTextField.textAlignment = NSTextAlignment.Left
        dayTextField.placeholder = "분량을 입력하세요"
        dayTextField.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 10*ratio)
        dayTextField.textColor = UIColor.colorWithHexString("#969696")
        dayTextField.tintColor = mainColor
        dayTextField.hidden = true
        dayTextField.keyboardType = UIKeyboardType.NumberPad
        dayTextField.backgroundColor = UIColor.whiteColor()
        dayTextField.addTarget(self, action: Selector("updateAmountAllEvents:"), forControlEvents: UIControlEvents.AllEvents)
        dayTextField.delegate = self
        
        if let value = dayAmount{
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
    
    
}