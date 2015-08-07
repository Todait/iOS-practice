//
//  NewGoalStep2AmountViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 7. 31..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit
import CoreData



class NewGoalStep2AmountViewController: BasicViewController,TodaitNavigationDelegate,CategoryDelegate,UITextFieldDelegate,ValidationDelegate,KeyboardHelpDelegate{
   
    
    private enum Status{
        case Goal
        case Date
        case Total
        case Unit
        case Day
        case None
    }
    
    
    
    var category:Category!
    var nextButton:UIButton!
    
    var goalView:UIView!
    var goalTextField:UITextField!
    
    
    var dataView:UIView!
    var startDateLabel:UILabel!
    var totalAmountField:UITextField!
    var dayAmountField:UITextField!
   
    var categoryButton:UIButton!
    
    
    var mainDate:NSDate! = NSDate()
    var datePickerView : UIView!
    var datePicker:UIDatePicker!
    
    var unitView:UIView!
    var unitImageView:UIImageView!
    var unitTextField:UITextField!
    
    
    var keyboardHelpView:KeyboardHelpView!
    
    var currentTextField:UITextField!
    
    private var status:Status!
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.todaitBackgroundGray()
        
        loadDefaultCategory()
        
        addGoalView()
        addDataView()
        addUnitView()
        
        
        addKeyboardHelpView()
        addDatePickerView()
        
        
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
    
    func addGoalView(){
        
        goalView = UIView(frame: CGRectMake(2*ratio, 64 + 2*ratio, 316*ratio, 43*ratio))
        goalView.backgroundColor = UIColor.whiteColor()
        goalView.layer.cornerRadius = 1
        goalView.clipsToBounds = true
        view.addSubview(goalView)
        
        addGoalTextField()
        addCategoryButton()
    }
    
    func addGoalTextField(){
        
        goalTextField = UITextField(frame: CGRectMake(20*ratio, 15.5*ratio, 255*ratio, 12*ratio))
        goalTextField.placeholder = "이곳에 목표를 입력해주세요"
        goalTextField.textAlignment = NSTextAlignment.Left
        goalTextField.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12*ratio)
        goalTextField.textColor = UIColor.todaitGray()
        goalTextField.returnKeyType = UIReturnKeyType.Next
        goalTextField.backgroundColor = UIColor.whiteColor()
        goalTextField.delegate = self
        //goalTextField.addTarget(self, action: Selector("updateAllEvents:"), forControlEvents: UIControlEvents.AllEvents)
        //goalTextField.text = aimString
        goalTextField.tintColor = UIColor.todaitGreen()
        //goalTextField.delegate = self
        
        currentTextField = goalTextField
        currentTextField.becomeFirstResponder()
        status = Status.Goal
        goalView.addSubview(goalTextField)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        currentTextField = textField
        rightButtonClk()
        
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        
        if status == Status.Date {
            hideDatePicker()
        }
        
        currentTextField.textColor = UIColor.todaitGray()
        currentTextField = textField
        currentTextField.textColor = UIColor.todaitRed()
        startDateLabel.textColor = UIColor.todaitGray()
        goalTextField.textColor = UIColor.todaitGray()
        unitTextField.textColor = UIColor.todaitGray()
        
        switch currentTextField {
        case totalAmountField: status = Status.Total ; keyboardHelpView.setStatus(KeyboardHelpStatus.Center)
        case unitTextField: status = Status.Unit ; keyboardHelpView.setStatus(KeyboardHelpStatus.End)
        case goalTextField: status = Status.Goal ; keyboardHelpView.setStatus(KeyboardHelpStatus.Start)
        case dayAmountField: status = Status.Day ; keyboardHelpView.setStatus(KeyboardHelpStatus.Center)
        default : status = Status.Goal ; keyboardHelpView.setStatus(KeyboardHelpStatus.Center)
        }
        
    }
    
    func addCategoryButton(){
        
        categoryButton = UIButton(frame: CGRectMake(275*ratio,7*ratio, 29*ratio, 29*ratio))
        categoryButton.setImage(UIImage(named: "category@3x.png"), forState: UIControlState.Normal)
        categoryButton.layer.cornerRadius = 15*ratio
        categoryButton.layer.borderWidth = 1
        categoryButton.layer.borderColor = UIColor.todaitGray().CGColor
        categoryButton.clipsToBounds = true
        categoryButton.addTarget(self, action: Selector("showCategorySettingVC"), forControlEvents: UIControlEvents.TouchUpInside)
        goalView.addSubview(categoryButton)
        
        categoryEdited(category)
        
    }
    
    func showCategorySettingVC(){
        
        var categoryVC = CategorySettingViewController()
        //categoryVC.delegate = self
        categoryVC.selectedCategory = category
        categoryVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        categoryVC.delegate = self
        
        self.navigationController?.presentViewController(categoryVC, animated: false, completion: { () -> Void in
            
        })
        
    }
    
    func categoryEdited(editedCategory:Category) {
        
        
        categoryButton.layer.borderColor = UIColor.clearColor().CGColor
        categoryButton.setImage(UIImage.maskColor("category@3x.png", color: UIColor.whiteColor()), forState: UIControlState.Normal)
        
        categoryButton.setBackgroundImage(UIImage.maskColor("circle@3x.png", color: UIColor.colorWithHexString(editedCategory.color)), forState: UIControlState.Normal)
        categoryButton.setBackgroundImage(UIImage.maskColor("circle@3x.png", color: UIColor.todaitLightGray()), forState: UIControlState.Highlighted)
        
        self.category = editedCategory
    }
    
    
    func addDataView(){
        
        dataView = UIView(frame: CGRectMake(2*ratio, 64 + 47*ratio, 316*ratio, 163*ratio))
        dataView.backgroundColor = UIColor.whiteColor()
        dataView.layer.cornerRadius = 1
        dataView.clipsToBounds = true
        view.addSubview(dataView)
        
        
        addStartView()
        addTotalView()
        adddayView()
        
        
        let line = UIView(frame: CGRectMake(0*ratio, 162*ratio, 320*ratio, 1))
        line.backgroundColor = UIColor.todaitGray()
        dataView.addSubview(line)
        
    }
    
    func addStartView(){
        
        let startLabel = UILabel(frame: CGRectMake(17*ratio, 30*ratio, 60*ratio, 12*ratio))
        startLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 10*ratio)
        startLabel.text = "시작"
        startLabel.textAlignment = NSTextAlignment.Left
        startLabel.textColor = UIColor.todaitDarkGray()
        dataView.addSubview(startLabel)
        
        let dateForm = NSDateFormatter()
        dateForm.dateFormat = "yyyy.MM.dd (E)"
        
        
        startDateLabel = UILabel(frame: CGRectMake(0, 20*ratio, 260*ratio, 30*ratio))
        startDateLabel.textAlignment = NSTextAlignment.Right
        startDateLabel.textColor = UIColor.todaitDarkGray()
        startDateLabel.text = dateForm.stringFromDate(getDateFromDateNumber(getTodayDateNumber()))
        startDateLabel.font = UIFont(name: "AppleSDGothicNeo-Ultralight", size: 15*ratio)
        startDateLabel.setKern(2)
        dataView.addSubview(startDateLabel)
        
        
        let dateButton = UIButton(frame: CGRectMake(20*ratio, 20*ratio, 280*ratio, 30*ratio))
        dateButton.addTarget(self, action: Selector("showDatePicker"), forControlEvents: UIControlEvents.TouchDown)
        dateButton.backgroundColor = UIColor.clearColor()
        dataView.addSubview(dateButton)
        
        
        let endInfoLabel = UILabel(frame: CGRectMake(267*ratio,31*ratio,40*ratio,12*ratio))
        endInfoLabel.text = "부터"
        endInfoLabel.textAlignment = NSTextAlignment.Left
        endInfoLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 10*ratio)
        endInfoLabel.textColor = UIColor.todaitGray()
        dataView.addSubview(endInfoLabel)
        
        
        let line = UIView(frame: CGRectMake(17*ratio, 49*ratio, 275*ratio, 1))
        line.backgroundColor = UIColor.todaitGray()
        dataView.addSubview(line)
        
    }
    
    func addUnitView(){
        
        unitView = UIView(frame: CGRectMake(211*ratio, 68*ratio, 90*ratio, 33*ratio))
        unitView.backgroundColor = UIColor.todaitBackgroundGray()
        dataView.addSubview(unitView)
        
        unitTextField = UITextField(frame: CGRectMake(5*ratio, 5*ratio, 80*ratio, 23*ratio))
        unitTextField.backgroundColor = UIColor.todaitWhiteGray()
        //unitTextField.attributedPlaceholder = NSAttributedString.getAttributedString("단위선택", font: UIFont(name: "AppleSDGothicNeo-Medium", size: 10*ratio)!, color: UIColor.todaitGray())
        unitTextField.placeholder = "단위선택"
        unitTextField.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 10*ratio)
        unitTextField.textColor = UIColor.todaitGray()
        unitTextField.delegate = self
        unitView.addSubview(unitTextField)
        
        
    }
    
    func addKeyboardHelpView(){
        
        keyboardHelpView = KeyboardHelpView(frame: CGRectMake(0, height , width, 38*ratio + 185*ratio))
        keyboardHelpView.backgroundColor = UIColor.whiteColor()
        keyboardHelpView.leftImageName = "bt_keybord_left@3x.png"
        keyboardHelpView.rightImageName = "bt_keybord_right@3x.png"
        keyboardHelpView.delegate = self
        keyboardHelpView.setStatus(KeyboardHelpStatus.Center)
        
        view.addSubview(keyboardHelpView)
        
        
        let line = UIView(frame: CGRectMake(0, 38*ratio-1, width, 1))
        line.backgroundColor = UIColor.colorWithHexString("#d1d5da")
        keyboardHelpView.addSubview(line)
        
    }
    
    func leftButtonClk(){
        
        
        switch status as Status {
        case .Date: status = .Goal ; hideDatePicker(); goalTextField.becomeFirstResponder() ; keyboardHelpView.setStatus(KeyboardHelpStatus.Start)
        case .Total: goalTextField.becomeFirstResponder() ; status = .Goal
        case .Day: totalAmountField.becomeFirstResponder() ; status = .Total
        case .Unit: dayAmountField.becomeFirstResponder() ; status = .Day  ; keyboardHelpView.setStatus(KeyboardHelpStatus.Center)
        default: status = .None ; confirmButtonClk()
        }
        
    }
    
    
    
    func rightButtonClk(){
        
        switch status as Status {
        case .Goal: totalAmountField.becomeFirstResponder() ; status = .Total ; keyboardHelpView.setStatus(KeyboardHelpStatus.Center)
        case .Total: dayAmountField.becomeFirstResponder() ; status = .Day
        case .Day: unitTextField.becomeFirstResponder() ; status = .Unit ;  keyboardHelpView.setStatus(KeyboardHelpStatus.End)
        default: status = .None ; confirmButtonClk()
        }
        
    }
    
    
    func showDatePicker(){
        
        var needToAnimate:Bool = false
        
        if status == Status.None {
            needToAnimate = true
        }
        
        status = Status.Date
        currentTextField.textColor = UIColor.todaitGray()
        currentTextField.resignFirstResponder()
        startDateLabel.textColor = UIColor.todaitLightRed()
        
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            self.datePickerView.transform = CGAffineTransformMakeTranslation(0, -185*self.ratio - 38*self.ratio)
            self.keyboardHelpView.transform = CGAffineTransformMakeTranslation(0, -185*self.ratio - 38*self.ratio)
            
        }) { (Bool) -> Void in
            
        }
        
    }
    
    func hideDatePicker(){
        
        startDateLabel.textColor = UIColor.todaitDarkGray()
        
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            
            self.datePickerView.transform = CGAffineTransformMakeTranslation(0, 0*self.ratio)
             self.keyboardHelpView.transform = CGAffineTransformMakeTranslation(0, 0)
            
            }) { (Bool) -> Void in
                
        }
    }
    
    
    func addTotalView(){
        
        let totalLabel = UILabel(frame: CGRectMake(17*ratio, 68*ratio, 60*ratio, 33*ratio))
        totalLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 10*ratio)
        totalLabel.text = "전체분량"
        totalLabel.textAlignment = NSTextAlignment.Left
        totalLabel.textColor = UIColor.todaitDarkGray()
        dataView.addSubview(totalLabel)
        
        
        let line = UIView(frame: CGRectMake(17*ratio, 101*ratio, 177*ratio, 1))
        line.backgroundColor = UIColor.todaitGray()
        dataView.addSubview(line)
        
        
        totalAmountField = UITextField(frame: CGRectMake(63*ratio, 70*ratio , 117*ratio, 30*ratio))
        totalAmountField.keyboardType = UIKeyboardType.NumberPad
        totalAmountField.textAlignment = NSTextAlignment.Right
        totalAmountField.font = UIFont(name: "AppleSDGothicNeo-Ultralight", size: 14*ratio)
        totalAmountField.textColor = UIColor.todaitDarkGray()
        totalAmountField.attributedPlaceholder = NSAttributedString.getAttributedString("0", font: UIFont(name: "AppleSDGothicNeo-Ultralight", size: 14*ratio)!, color: UIColor.todaitGray())
        totalAmountField.delegate = self
        dataView.addSubview(totalAmountField)
        
    }
    
    
    
    func adddayView(){
        
        let dayLabel = UILabel(frame: CGRectMake(17*ratio, 129*ratio, 60*ratio, 12*ratio))
        dayLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 10*ratio)
        dayLabel.text = "하루분량"
        dayLabel.textAlignment = NSTextAlignment.Left
        dayLabel.textColor = UIColor.todaitDarkGray()
        dataView.addSubview(dayLabel)
        
        let line = UIView(frame: CGRectMake(17*ratio, 149*ratio, 177*ratio, 1))
        line.backgroundColor = UIColor.todaitGray()
        dataView.addSubview(line)
        
        
        dayAmountField = UITextField(frame: CGRectMake(63*ratio, 120*ratio , 117*ratio, 30*ratio))
        dayAmountField.keyboardType = UIKeyboardType.NumberPad
        dayAmountField.textAlignment = NSTextAlignment.Right
        dayAmountField.font = UIFont(name: "AppleSDGothicNeo-Ultralight", size: 14*ratio)
        dayAmountField.textColor = UIColor.todaitDarkGray()
        dayAmountField.attributedPlaceholder = NSAttributedString.getAttributedString("0", font: UIFont(name: "AppleSDGothicNeo-Ultralight", size: 14*ratio)!, color: UIColor.todaitGray())
        dayAmountField.delegate = self
        dataView.addSubview(dayAmountField)
    }
    
    
    
    func addDatePickerView(){
        
        
        
        datePickerView = UIView(frame: CGRectMake(0, height + 38*ratio, width, 185*ratio))
        
        
        datePicker = UIDatePicker(frame: CGRectMake(0, 0, width, 185*ratio))
        datePicker.datePickerMode = UIDatePickerMode.Date
        datePicker.date = mainDate
        datePicker.backgroundColor = UIColor.whiteColor()
        datePicker.addTarget(self, action: Selector("datePickerChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        datePickerView.addSubview(datePicker)
        view.addSubview(datePickerView)
        
        
        
        let confirmButton = UIButton(frame:CGRectMake(0,185*ratio,width,44*ratio))
        confirmButton.setTitle("확인", forState: UIControlState.Normal)
        confirmButton.setTitleColor(UIColor.todaitGray(), forState: UIControlState.Normal)
        confirmButton.setTitleColor(UIColor.todaitDarkGray(), forState: UIControlState.Highlighted)
        confirmButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 15*ratio)
        confirmButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        confirmButton.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        confirmButton.addTarget(self, action: Selector("confirmButtonClk"), forControlEvents: UIControlEvents.TouchUpInside)
        //datePickerView.addSubview(confirmButton)
        
    }
    
    func confirmButtonClk(){
        
        currentTextField.textColor = UIColor.todaitGray()
        currentTextField.resignFirstResponder()
        hideDatePicker()
        status = Status.None
    }
    
    func datePickerChanged(picker:UIDatePicker){
        
        let dateForm = NSDateFormatter()
        dateForm.dateFormat = "yyyy.MM.dd (E)"
        startDateLabel.text = dateForm.stringFromDate(picker.date)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        titleLabel.text = "공부량 계산"
        
        todaitNavBar.todaitDelegate = self
        todaitNavBar.backButton.hidden = false
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
            
            self.keyboardHelpView.transform = CGAffineTransformMakeTranslation(0, -kbSize.height - 38*self.ratio)
            
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
    
    
    func backButtonClk() {
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
        validator.registerField(totalAmountField, rules: [MinLengthRule(length: 1, message: "전체분량을 입력해주세요.")])
        validator.registerField(unitTextField, rules: [MinLengthRule(length: 1, message: "단위를 입력해주세요.")])
        validator.validate(self)
        
        
    }
    
    
    func showNextStep(){
        let step3AmountVC = NewGoalStep3AmountViewController()
        step3AmountVC.startDate = datePicker.date
        step3AmountVC.titleString = goalTextField.text
        step3AmountVC.unitString = unitTextField.text
        
        if let totalAmount = totalAmountField.text.toInt() {
            step3AmountVC.totalAmount = CGFloat(totalAmount)
        }else{
            step3AmountVC.totalAmount = 0
            
            let alert = UIAlertView(title: "Invalid", message: "전체분량을 입력해주세요.", delegate: nil, cancelButtonTitle: "Cancel")
            alert.show()
            return
        }
        
        if let dayAmount = dayAmountField.text.toInt() {
            step3AmountVC.dayAmount = CGFloat(dayAmount)
            step3AmountVC.maxValue = CGFloat(dayAmount) * 2
        }else{
            step3AmountVC.dayAmount = 0
            step3AmountVC.maxValue = step3AmountVC.totalAmount
        }
        
        self.navigationController?.pushViewController(step3AmountVC, animated: true)
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

    
}
