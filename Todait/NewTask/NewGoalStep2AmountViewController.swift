//
//  NewGoalStep2AmountViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 7. 31..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

enum NewGoalStep2Status{
    case Goal
    case Date
    case Total
    case Unit
    case Day
    case None
}


class NewGoalStep2AmountViewController: BasicViewController,TodaitNavigationDelegate,CategoryDelegate,UITextFieldDelegate{
   
    
    var category:Category!
    var nextButton:UIButton!
    
    var goalView:UIView!
    var taskTextField:UITextField!
    
    
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
    
    
    var keyboardHelpView:UIView!
    
    var currentTextField:UITextField!
    var currentStatus:NewGoalStep2Status!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.todaitBackgroundGray()
        
        addGoalView()
        addDataView()
        addUnitView()
        
        
        addKeyboardHelpView()
        addDatePickerView()
        
        
    }
    
    func addGoalView(){
        
        goalView = UIView(frame: CGRectMake(2*ratio, 64 + 2*ratio, 316*ratio, 50*ratio))
        goalView.backgroundColor = UIColor.whiteColor()
        goalView.layer.cornerRadius = 1
        goalView.clipsToBounds = true
        view.addSubview(goalView)
        
        addTaskTextField()
        addCategoryButton()
    }
    
    func addTaskTextField(){
        
        taskTextField = UITextField(frame: CGRectMake(20*ratio, 10*ratio, 255*ratio, 30*ratio))
        taskTextField.placeholder = "이곳에 목표를 입력해주세요"
        taskTextField.textAlignment = NSTextAlignment.Left
        taskTextField.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 10*ratio)
        taskTextField.textColor = UIColor.todaitGray()
        taskTextField.returnKeyType = UIReturnKeyType.Next
        taskTextField.backgroundColor = UIColor.whiteColor()
        taskTextField.delegate = self
        //taskTextField.addTarget(self, action: Selector("updateAllEvents:"), forControlEvents: UIControlEvents.AllEvents)
        //taskTextField.text = aimString
        taskTextField.tintColor = UIColor.todaitGreen()
        //taskTextField.delegate = self
        
        currentTextField = taskTextField
        currentTextField.becomeFirstResponder()
        currentStatus = NewGoalStep2Status.Goal
        goalView.addSubview(taskTextField)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        currentTextField = textField
        rightButtonClk()
        
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        currentTextField.textColor = UIColor.todaitGray()
        currentTextField = textField
        currentTextField.textColor = UIColor.todaitRed()
        startDateLabel.textColor = UIColor.todaitGray()
        taskTextField.textColor = UIColor.todaitGray()
        unitTextField.textColor = UIColor.todaitGray()
        
        switch currentTextField {
        case totalAmountField: currentStatus = NewGoalStep2Status.Total
        case unitTextField: currentStatus = NewGoalStep2Status.Unit
        case taskTextField: currentStatus = NewGoalStep2Status.Goal
        case dayAmountField: currentStatus = NewGoalStep2Status.Day
        default : currentStatus = NewGoalStep2Status.Goal
        }
        
    }
    
    func addCategoryButton(){
        
        categoryButton = UIButton(frame: CGRectMake(275*ratio,10*ratio, 30*ratio, 30*ratio))
        categoryButton.setImage(UIImage(named: "category@3x.png"), forState: UIControlState.Normal)
        categoryButton.layer.cornerRadius = 15*ratio
        categoryButton.layer.borderWidth = 1
        categoryButton.layer.borderColor = UIColor.todaitGray().CGColor
        categoryButton.clipsToBounds = true
        categoryButton.addTarget(self, action: Selector("showCategorySettingVC"), forControlEvents: UIControlEvents.TouchUpInside)
        goalView.addSubview(categoryButton)
        
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
        categoryButton.backgroundColor = UIColor.colorWithHexString(editedCategory.color)
        
        self.category = editedCategory
    }
    
    
    func addDataView(){
        
        dataView = UIView(frame: CGRectMake(2*ratio, 64 + 54*ratio, 316*ratio, 163*ratio))
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
        
        keyboardHelpView = UIView(frame: CGRectMake(0, height , width, 38*ratio + 185*ratio))
        keyboardHelpView.backgroundColor = UIColor.whiteColor()
        keyboardHelpView.hidden = true
        
        
        let leftButton = UIButton(frame: CGRectMake(15*ratio, 0, 38*ratio, 38*ratio))
        leftButton.setImage(UIImage(named: "bt_keybord_left@3x.png"), forState: UIControlState.Normal)
        leftButton.addTarget(self, action: Selector("leftButtonClk"), forControlEvents: UIControlEvents.TouchDown)
        keyboardHelpView.addSubview(leftButton)
    
        let rightButton = UIButton(frame: CGRectMake(58*ratio, 0, 38*ratio, 38*ratio))
        rightButton.setImage(UIImage(named: "bt_keybord_right@3x.png"), forState: UIControlState.Normal)
        rightButton.addTarget(self, action: Selector("rightButtonClk"), forControlEvents: UIControlEvents.TouchDown)
        keyboardHelpView.addSubview(rightButton)
        
        
        let confirmButton = UIButton(frame: CGRectMake(246*ratio, 0 , 74*ratio, 38*ratio))
        confirmButton.setBackgroundImage(UIImage.colorImage(UIColor.todaitGreen(), frame: CGRectMake(0, 0, 74*ratio, 38*ratio)), forState: UIControlState.Normal)
        confirmButton.setBackgroundImage(UIImage.colorImage(UIColor.todaitDarkGreen(), frame: CGRectMake(0, 0, 74*ratio, 38*ratio)), forState: UIControlState.Highlighted)
        confirmButton.setTitle("확인", forState: UIControlState.Normal)
        confirmButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        confirmButton.addTarget(self, action: Selector("confirmButtonClk"), forControlEvents: UIControlEvents.TouchUpInside)
        confirmButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 15*ratio)
        
        keyboardHelpView.addSubview(confirmButton)
        
        view.addSubview(keyboardHelpView)
        
        
        let line = UIView(frame: CGRectMake(0, 38*ratio-1, width, 1))
        line.backgroundColor = UIColor.colorWithHexString("#d1d5da")
        keyboardHelpView.addSubview(line)
        
    }
    
    func leftButtonClk(){
        
        switch currentStatus as NewGoalStep2Status {
        case .Date: currentStatus = .Goal ; hideDatePicker(); taskTextField.becomeFirstResponder()
        case .Total: currentStatus = .Date ; showDatePicker()
        case .Day: totalAmountField.becomeFirstResponder() ; currentStatus = .Total
        case .Unit: dayAmountField.becomeFirstResponder() ; currentStatus = .Day
        default: currentStatus = .None ; confirmButtonClk()
        }
        
    }
    
    func rightButtonClk(){
        
        switch currentStatus as NewGoalStep2Status {
        case .Goal: currentStatus = .Date ; showDatePicker()
        case .Date: totalAmountField.becomeFirstResponder() ; currentStatus = .Total
        case .Total: dayAmountField.becomeFirstResponder() ; currentStatus = .Day
        case .Day: unitTextField.becomeFirstResponder() ; currentStatus = .Unit
        default: currentStatus = .None ; confirmButtonClk()
        }
        
    }
    
    
    func showDatePicker(){
        
        var needToAnimate:Bool = false
        
        if currentStatus == NewGoalStep2Status.None {
            needToAnimate = true
        }
        
        currentStatus = NewGoalStep2Status.Date
        currentTextField.textColor = UIColor.todaitGray()
        currentTextField.resignFirstResponder()
        startDateLabel.textColor = UIColor.todaitLightRed()
        
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            self.datePickerView.transform = CGAffineTransformMakeTranslation(0, -185*self.ratio - 38*self.ratio)
            
            if needToAnimate == true {
                self.keyboardHelpView.transform = CGAffineTransformMakeTranslation(0, -185*self.ratio - 38*self.ratio)
            }
            
        }) { (Bool) -> Void in
            
        }
        
    }
    
    func hideDatePicker(){
        
        startDateLabel.textColor = UIColor.todaitDarkGray()
        
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            
            self.datePickerView.transform = CGAffineTransformMakeTranslation(0, 0*self.ratio)
            
            if let status = self.currentStatus{
                
                if status == NewGoalStep2Status.None  {
                    self.keyboardHelpView.transform = CGAffineTransformMakeTranslation(0, 0)
                }
            }
            
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
        currentStatus = NewGoalStep2Status.None
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
        
        /*
        var contentInsets = UIEdgeInsetsMake(0, 0, kbSize.height, 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect = self.view.frame
        aRect.size.height = aRect.size.height - kbSize.height
        
        if (!CGRectContainsPoint(aRect, findButton.frame.origin)) {
            
            scrollView.scrollRectToVisible(findButton.frame, animated: true)
            
        }
        */
        
        
        self.keyboardHelpView.hidden = false
        
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            
            if self.currentStatus != NewGoalStep2Status.None {
                self.keyboardHelpView.transform = CGAffineTransformMakeTranslation(0, -kbSize.height - 38*self.ratio)
            }
            
            }) { (Bool) -> Void in
                
                self.keyboardHelpView.hidden = false
        }
        
    }
    
    func keyboardWillBeHidden(aNotification:NSNotification){
        
        var contentInsets = UIEdgeInsetsZero
        //scrollView.contentInset = contentInsets
        //scrollView.scrollIndicatorInsets = contentInsets
        
        
       
        
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            
            
            if self.currentStatus != NewGoalStep2Status.Date {
                self.keyboardHelpView.transform = CGAffineTransformMakeTranslation(0,0)
            }
            
            }) { (Bool) -> Void in
                
                if self.currentStatus != NewGoalStep2Status.Date {
                    self.keyboardHelpView.hidden = true
                }
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
        nextButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 18*ratio)
        nextButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        nextButton.addTarget(self, action: Selector("nextButtonClk"), forControlEvents: UIControlEvents.TouchUpInside)
        nextButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        view.addSubview(nextButton)
    }
    
    func nextButtonClk(){
        
        let step3AmountVC = NewGoalStep3AmountViewController()
        step3AmountVC.startDate = datePicker.date
        
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
        }else{
            step3AmountVC.dayAmount = 0
        }
        
        self.navigationController?.pushViewController(step3AmountVC, animated: true)
        
        
    }
    
}
