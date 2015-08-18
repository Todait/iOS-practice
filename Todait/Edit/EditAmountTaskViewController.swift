//
//  NewGoalStep2TimeViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 7. 31..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit
import CoreData

class EditAmountTaskViewController: BasicViewController,UITextFieldDelegate,UnitInputViewDelegate,CategoryDelegate,TodaitNavigationDelegate,ValidationDelegate,KeyboardHelpDelegate,CountDelegate,AlarmDelegate{
    
    
    var editedTask:Task!
    var category:Category!
    
    
    private enum Status{
        case Goal
        case Total
        case Start
        case End
        case Unit
        case None
    }
    
    
    var categoryButton: UIButton!
    
    var goalView:UIView!
    var goalTextField: UITextField!
    var unitTextField: PaddingTextField!
    var unitView: UnitInputView!
    
    
    var dataView:UIView!
    var totalAmountField: UITextField!
    var startAmountField: UITextField!
    var endAmountField: UITextField!
    
    var saveButton: UIButton!
    var currentTextField: UITextField!
    
    var startDateLabel: UILabel!
    
    var dateForm: NSDateFormatter!
    var startDate: NSDate!
    
    var periodStartDate:NSDate!
    var periodEndDate:NSDate!
    var periodStartLabel:UILabel!
    var periodEndLabel:UILabel!
    var periodDayLabel:UILabel!
    var periodDayString:String = "30일"
    
    //let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var aimString:String! = ""
    var unitString:String! = ""
    
    
    var totalButton:UIButton!
    var rangeButton:UIButton!
    var unitButton:UIButton!
    
    
    var infoLabel:UILabel!
    var middleBox:UIView!
    
    
    var isTotal:Bool! = true
    var rangeList:[[String:String]] = []
    
    
    var detailView:UIButton!
    
    var optionView:UIView!
    var alarmOption:OptionButton!
    var repeatOption:OptionButton!
    var reviewOption:OptionButton!
    
    var options:[Int] = [1,2,4]
    var eventOption = 0
    var repeatCount:Int! = 0
    var reviewCount:Int! = 0
    
    
    
    
    var totalAmount:Int! = 0
    var startAmount:Int! = 0
    var endAmount:Int! = 0
    
    
    var doneButton:UIButton!
    var deleteButton:UIButton!
    
    var keyboardHelpView:KeyboardHelpView!
    private var status:Status! = Status.None
    
    var isAlarmOn:Bool! = false
    var alarmTime:NSDate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        view.backgroundColor = UIColor.todaitBackgroundGray()
        
        
        loadDefaultCategory()
        setupTimeTaskViewController()
        
        addGoalView()
        addDataView()
        addDetailView()
        addOptionView()
        
        
        addUnitView()
        addKeyboardHelpView()
        addDeleteButton()
        
        totalUpdate()
        
    }
    
    func loadDefaultCategory(){
        
        var categoryResults = realm.objects(Category).filter("archived == false")
        if let category = categoryResults.first{
            self.category = category
        }
        
        /*
        let entityDescription = NSEntityDescription.entityForName("Category",inManagedObjectContext:managedObjectContext!)
        let request = NSFetchRequest()
        
        request.entity = entityDescription
        
        var error: NSError?
        
        var categoryData = managedObjectContext?.executeFetchRequest(request, error: &error) as? [Category]
        
        if let categoryData = categoryData {
            category = categoryData.first
        }
        */
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
        goalTextField.textColor = UIColor.colorWithHexString("#969696")
        goalTextField.returnKeyType = UIReturnKeyType.Next
        goalTextField.backgroundColor = UIColor.whiteColor()
        goalTextField.addTarget(self, action: Selector("updateAllEvents:"), forControlEvents: UIControlEvents.AllEvents)
        goalTextField.text = aimString
        goalTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        goalTextField.delegate = self
        goalView.addSubview(goalTextField)
        
        status = Status.Goal
        
        currentTextField = goalTextField
    }
    
    func addCategoryButton(){
        categoryButton = UIButton(frame: CGRectMake(280*ratio,7*ratio, 29*ratio, 29*ratio))
        categoryButton.setImage(UIImage(named: "category@3x.png"), forState: UIControlState.Normal)
        categoryButton.layer.cornerRadius = 14.5*ratio
        categoryButton.layer.borderWidth = 1
        categoryButton.layer.borderColor = UIColor.todaitGray().CGColor
        categoryButton.clipsToBounds = true
        categoryButton.addTarget(self, action: Selector("showCategorySettingVC"), forControlEvents: UIControlEvents.TouchUpInside)
        goalView.addSubview(categoryButton)
        
        categoryEdited(category)
    }
    
    func addDataView(){
        
        
        dataView = UIView(frame: CGRectMake(2*ratio, 64 + 47*ratio, 316*ratio, 162*ratio))
        dataView.backgroundColor = UIColor.whiteColor()
        view.addSubview(dataView)
        
        
        addDateView()
        addButtonView()
        addRangeView()
        
        
        
    }
    
    
    
    func addDateView(){
        
        let infoLabel = UILabel(frame: CGRectMake(18*ratio, 28*ratio, 200*ratio, 16*ratio))
        infoLabel.text = "기간"
        infoLabel.textAlignment = NSTextAlignment.Left
        infoLabel.textColor = UIColor.todaitDarkGray()
        infoLabel.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 10*ratio)
        dataView.addSubview(infoLabel)
        
        
        
        
        periodStartLabel = UILabel(frame:CGRectMake(15*ratio, 26*ratio, 137*ratio, 20*ratio))
        periodStartLabel.text = getDateString(getDateNumberFromDate(periodStartDate))
        periodStartLabel.textAlignment = NSTextAlignment.Right
        periodStartLabel.font = UIFont(name: "AppleSDGothicNeo-Ultralight", size: 15*ratio)
        periodStartLabel.textColor = UIColor.todaitDarkGray()
        periodStartLabel.setKern(2)
        dataView.addSubview(periodStartLabel)
        
        
        let dashLine = UIView(frame: CGRectMake(158*ratio, 35*ratio, 4*ratio, 1*ratio))
        dashLine.backgroundColor = UIColor.todaitDarkGray()
        dataView.addSubview(dashLine)
        
        
        periodEndLabel = UILabel(frame:CGRectMake(168*ratio, 26*ratio, 140*ratio, 20*ratio))
        periodEndLabel.text = getDateString(getDateNumberFromDate(periodEndDate))
        periodEndLabel.textAlignment = NSTextAlignment.Left
        periodEndLabel.font = UIFont(name: "AppleSDGothicNeo-Ultralight", size: 15*ratio)
        periodEndLabel.textColor = UIColor.todaitDarkGray()
        periodEndLabel.setKern(2)
        dataView.addSubview(periodEndLabel)
        
        
        var line = UIView(frame:CGRectMake(20*ratio, 55*ratio, 272*ratio, 0.5*ratio))
        line.backgroundColor = UIColor.todaitDarkGray().colorWithAlphaComponent(0.3)
        dataView.addSubview(line)

        
        periodDayLabel = UILabel(frame: CGRectMake(272*ratio, 28*ratio, 33*ratio, 16*ratio))
        periodDayLabel.text = periodDayString
        periodDayLabel.textAlignment = NSTextAlignment.Left
        periodDayLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 10*ratio)
        periodDayLabel.textColor = UIColor.todaitDarkGray().colorWithAlphaComponent(0.7)
        dataView.addSubview(periodDayLabel)
        
        
    }
    
    func addButtonView(){
        
        
        
        
        
        

        
        totalButton = UIButton(frame: CGRectMake(19*ratio, 73*ratio, 89*ratio, 32*ratio))
        totalButton.setTitle("전체", forState: UIControlState.Normal)
        totalButton.setTitleColor(UIColor.todaitDarkGray(), forState: UIControlState.Normal)
        totalButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 10*ratio)
        totalButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        totalButton.layer.borderColor = UIColor.colorWithHexString("#B2B2B2").CGColor
        totalButton.layer.borderWidth = 0.5*ratio
        totalButton.addTarget(self, action: Selector("totalButtonClk"), forControlEvents: UIControlEvents.TouchUpInside)
        dataView.addSubview(totalButton)
        
        rangeButton = UIButton(frame: CGRectMake(108*ratio, 73*ratio, 89*ratio, 32*ratio))
        rangeButton.setTitle("범위", forState: UIControlState.Normal)
        rangeButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 10*ratio)
        rangeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        rangeButton.addTarget(self, action: Selector("rangeButtonClk"), forControlEvents: UIControlEvents.TouchUpInside)
        dataView.addSubview(rangeButton)
        
        setAmountButtonHighlight(totalButton, highlight: isTotal)
        setAmountButtonHighlight(rangeButton, highlight: !isTotal)
        
        
        
        
        unitTextField = PaddingTextField(frame: CGRectMake(206*ratio, 73*ratio, 89*ratio, 32*ratio))
        unitTextField.padding = 5
        unitTextField.placeholder = "단위입력"
        unitTextField.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 10*ratio)
        unitTextField.textColor = UIColor.colorWithHexString("#969696")
        unitTextField.returnKeyType = UIReturnKeyType.Next
        unitTextField.textAlignment = NSTextAlignment.Left
        unitTextField.backgroundColor = UIColor.whiteColor()
        unitTextField.text = unitString
        unitTextField.addTarget(self, action: Selector("updateUnitAllEvents:"), forControlEvents: UIControlEvents.AllEvents)
        unitTextField.delegate = self
        unitTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        
        unitTextField.layer.borderColor = UIColor.colorWithHexString("#B2B2B2").CGColor
        unitTextField.layer.borderWidth = 0.5*ratio
        dataView.addSubview(unitTextField)
        
        
    }
    
    func addRangeView(){
        
        totalAmountField = UITextField(frame: CGRectMake(75*ratio, 121*ratio, 235*ratio, 16*ratio))
        totalAmountField.textAlignment = NSTextAlignment.Left
        totalAmountField.placeholder = "분량을 입력하세요"
        totalAmountField.font = UIFont(name: "AppleSDGothicNeo-Ultralight", size: 14*ratio)
        totalAmountField.textColor = UIColor.colorWithHexString("#969696")
        totalAmountField.keyboardType = UIKeyboardType.NumberPad
        totalAmountField.returnKeyType = UIReturnKeyType.Done
        totalAmountField.backgroundColor = UIColor.whiteColor()
        totalAmountField.addTarget(self, action: Selector("updateAmountAllEvents:"), forControlEvents: UIControlEvents.AllEvents)
        totalAmountField.delegate = self
        totalAmountField.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        totalAmountField.text = "\(totalAmount)"
        dataView.addSubview(totalAmountField)
        
        
        
        
        
        startAmountField = UITextField(frame:CGRectMake(15*ratio, 120*ratio, 140*ratio, 17*ratio))
        startAmountField.placeholder = "시작"
        startAmountField.textAlignment = NSTextAlignment.Center
        startAmountField.font = UIFont(name: "AppleSDGothicNeo-Ultralight", size: 15*ratio)
        startAmountField.textColor = UIColor.todaitDarkGray()
        startAmountField.keyboardType = UIKeyboardType.NumberPad
        startAmountField.addTarget(self, action: Selector("updateStartAmount:"), forControlEvents: UIControlEvents.AllEvents)
        startAmountField.delegate = self
        startAmountField.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        startAmountField.text = "\(startAmount)"
        dataView.addSubview(startAmountField)
        
        
        endAmountField = UITextField(frame:CGRectMake(165*ratio, 120*ratio, 140*ratio, 17*ratio))
        endAmountField.placeholder = "종료"
        endAmountField.textAlignment = NSTextAlignment.Center
        endAmountField.font = UIFont(name: "AppleSDGothicNeo-Ultralight", size: 15*ratio)
        endAmountField.textColor = UIColor.todaitDarkGray()
        endAmountField.addTarget(self, action: Selector("updateEndAmount:"), forControlEvents: UIControlEvents.AllEvents)
        endAmountField.keyboardType = UIKeyboardType.NumberPad
        endAmountField.delegate = self
        endAmountField.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        endAmountField.text = "\(endAmount)"
        dataView.addSubview(endAmountField)
        
        
        
        infoLabel = UILabel(frame: CGRectMake(20*ratio, 121*ratio, 200*ratio, 16*ratio))
        infoLabel.text = "범위"
        infoLabel.textAlignment = NSTextAlignment.Left
        infoLabel.textColor = UIColor.todaitDarkGray()
        infoLabel.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 10*ratio)
        dataView.addSubview(infoLabel)
        dataView.addSubview(startAmountField)
        
        
        middleBox = UIView(frame: CGRectMake(158*ratio, 126*ratio, 4*ratio, 1*ratio))
        middleBox.backgroundColor = UIColor.todaitDarkGray()
        dataView.addSubview(middleBox)
        
        
        
        var line = UIView(frame:CGRectMake(20*ratio, 143*ratio, 272*ratio, 0.5*ratio))
        line.backgroundColor = UIColor.todaitDarkGray().colorWithAlphaComponent(0.3)
        dataView.addSubview(line)
        
    }
    
    func addDetailView(){
    
        detailView = UIButton(frame: CGRectMake(2*ratio, 64 + 211*ratio, 316*ratio, 46*ratio))
        detailView.setBackgroundImage(UIImage.colorImage(UIColor.whiteColor(), frame: CGRectMake(0, 0, 316*ratio, 46*ratio)), forState: UIControlState.Normal)
        detailView.setBackgroundImage(UIImage.colorImage(UIColor.todaitBackgroundGray(), frame: CGRectMake(0, 0, 316*ratio, 46*ratio)), forState: UIControlState.Highlighted)
        view.addSubview(detailView)
        
        
        let weekImage = UIImageView(frame:CGRectMake(28*ratio, 12*ratio, 22*ratio, 22*ratio))
        weekImage.image = UIImage(named: "icon_week@3x.png")
        detailView.addSubview(weekImage)
        
        let detailLabel = UILabel(frame: CGRectMake(66*ratio,0,200*ratio,46*ratio))
        detailLabel.text = "요일별 상세설정"
        detailLabel.font = UIFont(name: "AppleSDGothicNeo-Ultralight", size: 12*ratio)
        detailLabel.textColor = UIColor.todaitGray()
        detailLabel.textAlignment = NSTextAlignment.Left
        detailView.addSubview(detailLabel)
        
        let detailImage = UIImageView(frame: CGRectMake(316*ratio - 23*ratio, 15*ratio, 8*ratio, 16*ratio))
        detailImage.image = UIImage.maskColor("bt_arrange_arrow@3x.png", color: UIColor.todaitGray())
        detailView.addSubview(detailImage)
        
        
        
    }
    
    
    func addOptionView(){
        
        
        optionView = UIView(frame: CGRectMake(2*ratio, 64 + 259*ratio, 316*ratio, 118*ratio))
        optionView.backgroundColor = UIColor.whiteColor()
        view.addSubview(optionView )
        
        addAlarmOptionView()
        addReviewOptionView()
        addRepeatOptionView()
        
        
    }
    
    func addAlarmOptionView(){
        
        
        alarmOption = OptionButton(frame:CGRectMake(2*ratio,59*ratio,157*ratio,47*ratio))
        alarmOption.backgroundColor = UIColor.clearColor()
        alarmOption.addTarget(self, action: Selector("alarmOptionClk"), forControlEvents: UIControlEvents.TouchDown)
        alarmOption.onImage = UIImage(named: "icon_alarm_wt@3x.png")
        alarmOption.offImage = UIImage(named: "icon_alarm@3x.png")
        alarmOption.onColor = UIColor.todaitGreen()
        alarmOption.offColor = UIColor.todaitGray()
        alarmOption.setText("알람없음")
        alarmOption.setButtonOn(false)
        optionView.addSubview(alarmOption)
        
        
    }
    
    func alarmOptionClk(){
        
        var alarmVC = AlarmViewController()
        alarmVC.delegate = self
        alarmVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        
        self.navigationController?.presentViewController(alarmVC, animated: false, completion: { () -> Void in
            
        })
    }
    
    
    func getAlarmStatus()->Bool{
        
        
        
        return isAlarmOn
    }
    
    func getAlarmTime() -> NSDate? {
        
        return alarmTime
        
    }
    
    func updateAlarmTime(date: NSDate) {
        alarmTime = date
    }
    
    func updateAlarmStatus(status: Bool) {
        
        
        isAlarmOn = status
        
        
        if isAlarmOn == true {
            
            var comp = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitHour|NSCalendarUnit.CalendarUnitMinute, fromDate: alarmTime!)
            
            alarmOption.setText("\(comp.hour):\(comp.minute)")
            //alarmOption.setText(dateForm.stringFromDate(alarmTime!))
            
        }else{
            alarmOption.setText("알람없음")
        }
        
        alarmOption.setButtonOn(isAlarmOn)
    }

    
    
    func addReviewOptionView(){
        
        
        
        
        reviewOption = OptionButton(frame:CGRectMake(2*ratio,12*ratio,157*ratio,47*ratio))
        
        reviewOption.backgroundColor = UIColor.clearColor()
        reviewOption.addTarget(self, action: Selector("reviewOptionClk"), forControlEvents: UIControlEvents.TouchDown)
        reviewOption.onImage = UIImage(named: "icon_review_wt@3x.png")
        reviewOption.offImage = UIImage(named: "icon_review@3x.png")
        reviewOption.onColor = UIColor.todaitGreen()
        reviewOption.offColor = UIColor.todaitGray()
        reviewOption.setText("복습 \(editedTask.reviewCount)회")
        eventOption = 1
        count(editedTask.reviewCount)
        optionView.addSubview(reviewOption)
        
    }
    
    func reviewOptionClk(){
        
        eventOption = 1
        
        var reviewOptionVC = ReviewViewController()
        reviewOptionVC.delegate = self
        reviewOptionVC.count = reviewCount
        reviewOptionVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        
        self.navigationController?.presentViewController(reviewOptionVC, animated: false, completion: { () -> Void in
            
        })
        
        
        
    }
    
    func addRepeatOptionView(){
        
        repeatOption = OptionButton(frame:CGRectMake(162*ratio,12*ratio,157*ratio,47*ratio))
        repeatOption.backgroundColor = UIColor.clearColor()
        repeatOption.addTarget(self, action: Selector("repeatOptionClk"), forControlEvents: UIControlEvents.TouchDown)
        repeatOption.onImage = UIImage(named: "icon_reread_wt@3x.png")
        repeatOption.offImage = UIImage(named: "icon_reread@3x.png")
        repeatOption.onColor = UIColor.todaitGreen()
        repeatOption.offColor = UIColor.todaitGray()
        repeatOption.setText("회독 \(editedTask.repeatCount)회")
        eventOption = 2
        count(editedTask.repeatCount)
        optionView.addSubview(repeatOption)
        
        
    }
    
    func repeatOptionClk(){
        
        
        eventOption = 2
        //option = OptionStatus.Reread
        
        var repeatOptionVC = RepeatViewController()
        repeatOptionVC.delegate = self
        repeatOptionVC.count = repeatCount
        repeatOptionVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        
        self.navigationController?.presentViewController(repeatOptionVC, animated: false, completion: { () -> Void in
            
        })
        
        
        
    }
    
    func count(count:Int){
        
        
        switch eventOption {
        case 1: reviewOption.setText("복습 \(count)회") ; reviewOption.setButtonOn(count != 0) ; reviewCount = count
        case 2: repeatOption.setText("회독 \(count)회") ; repeatOption.setButtonOn(count != 0) ; repeatCount = count
        default: eventOption = 0
        }
        
        
        
        eventOption = 0
    }
    
    
    
        
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.todaitNavBar.hidden = false
        self.titleLabel.text = "목표 수정"
        self.todaitNavBar.backButton.hidden = false
        self.todaitNavBar.todaitDelegate = self
        
        addDoneButton()
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
    
    func addDoneButton(){
        
        if doneButton != nil {
            return
        }
        
        doneButton = UIButton(frame: CGRectMake(255*ratio, 32, 50*ratio, 20))
        doneButton.setTitle("Done", forState: UIControlState.Normal)
        doneButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 18)
        doneButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        doneButton.addTarget(self, action: Selector("doneButtonClk"), forControlEvents: UIControlEvents.TouchUpInside)
        doneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        view.addSubview(doneButton)
    }
    
    func doneButtonClk(){
        
        
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
    
    
    
    func validationSuccessful(){
       
        
        if isAlarmOn == true {
            
            let notificationId = NSUUID().UUIDString
            //editedTask.notificationId = notificationId
            registerAlarm(notificationId)
            
        }
        
        realm.write{
            self.realm.add(self.editedTask,update:true)
        }
        
        self.navigationController?.popViewControllerAnimated(true)
        
        
    }
    
    func registerAlarm(notificationId:String){
        
        
        let notification = UILocalNotification()
        notification.alertBody = goalTextField.text
        notification.timeZone = NSTimeZone.systemTimeZone()
        notification.fireDate = alarmTime
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.hasAction = true
        notification.userInfo?.updateValue(notificationId, forKey: "notificationId")
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
        
    }
    
    func validationFailed(errors: [UITextField:ValidationError]){
        
        
        for ( textField , error) in errors {
            
            let alert = UIAlertView(title: "Invalid", message: error.errorMessage, delegate: nil, cancelButtonTitle: "Cancel")
            
            alert.show()
            
            return
        }
    }
    
    
    func setupTimeTaskViewController(){
        
        
        isTotal = editedTask.startPoint == 0
        
        if isTotal == true {
            totalAmount = editedTask.amount
        }else{
            startAmount = editedTask.startPoint
            endAmount = startAmount + editedTask.amount
        }
        
        
        startDate = NSDate()
        periodStartDate = NSDate()
        periodEndDate = NSDate(timeIntervalSinceNow: 24*60*60 * 29)
        
        
        aimString = editedTask.name
        unitString = editedTask.unit
        
        dateForm = NSDateFormatter()
        dateForm.dateFormat = "a h시 m분"
        
        
        
        
        /*
        if let notificationId = editedTask.notificationId {
            
            
            isAlarmOn = true
            
            
            var notifications = UIApplication().scheduledLocalNotifications
            
            for notification in notifications {
                
                let notification:UILocalNotification! = notification as! UILocalNotification
                
                let userInfo:[String:AnyObject?]! = notification.userInfo as! [String:AnyObject]
                
                let notiId:String = userInfo["notificationId"] as! String
                
                if notiId == notificationId {
                    alarmTime = notification.fireDate
                }
            }

        }
        */
        
    }
    
    
    
    func addUnitView(){
        
        unitView = UnitInputView(frame: CGRectMake(0, height, width, 40*ratio))
        unitView.delegate = self
        unitView.hidden = true
        
        view.addSubview(unitView)
        
    }
    
    func updateUnit(unit:String){
        
        unitTextField.text = unit
        
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
    
    
    
    
    
    
    func resignAllTextResponder(){
        
        unitTextField.resignFirstResponder()
        goalTextField.resignFirstResponder()
        
        totalAmountField.resignFirstResponder()
        startAmountField.resignFirstResponder()
        endAmountField.resignFirstResponder()
        
    }
    
    
    
    func addGoalTextField(cell:UITableViewCell){
        
        
        cell.contentView.addSubview(goalTextField)
    }
    
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        currentTextField.textColor = UIColor.todaitGray()
        currentTextField = textField
        currentTextField.textColor = UIColor.todaitRed()
        
        
        goalTextField.textColor = UIColor.todaitGray()
        unitTextField.textColor = UIColor.todaitGray()
        startAmountField.textColor = UIColor.todaitGray()
        endAmountField.textColor = UIColor.todaitGray()
        totalAmountField.textColor = UIColor.todaitGray()
        
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
        
        
        if let value = startAmount {
            startAmountField.text = "\(value)"
        }
        
        if let value = endAmount {
            endAmountField.text = "\(value)"
        }
        
        
        var line = UIView(frame:CGRectMake(20*ratio, 43*ratio, 272*ratio, 0.5*ratio))
        line.backgroundColor = UIColor.todaitDarkGray().colorWithAlphaComponent(0.3)
        cell.contentView.addSubview(line)
        
        
        
    }
    
    
    func updateStartAmount(textField:UITextField){
        startAmount = textField.text.toInt()
    }
    
    
    func updateEndAmount(textField:UITextField){
        endAmount = textField.text.toInt()
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
        
        setAmountButtonHighlight(totalButton, highlight: isTotal)
        setAmountButtonHighlight(rangeButton, highlight: !isTotal)
        
        totalUpdate()
        
    }
    
    
    func rangeButtonClk(){
        
        isTotal = false
        
        setAmountButtonHighlight(totalButton, highlight: isTotal)
        setAmountButtonHighlight(rangeButton, highlight: !isTotal)
        
        totalUpdate()
    }
    
    func addDeleteButton(){
        
        deleteButton = UIButton(frame:CGRectMake(3*ratio,height - 55*ratio, 314*ratio,52*ratio))
        deleteButton.setTitle("목표삭제", forState: UIControlState.Normal)
        deleteButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        deleteButton.setBackgroundImage(UIImage.colorImage(UIColor.todaitRed(), frame:CGRectMake(0,0,314*ratio,52*ratio)), forState: UIControlState.Normal)
        deleteButton.addTarget(self, action: Selector("deleteButtonClk"), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(deleteButton)
        
    }
    
    func deleteButtonClk(){
        
        editedTask.archived = true
        
        realm.write{
            self.realm.add(self.editedTask,update:true)
        }
        
        self.navigationController?.popToRootViewControllerAnimated(true)

        
        /*
        managedObjectContext?.deleteObject(editedTask)
        
        var error: NSError?
        managedObjectContext?.save(&error)
        
        if let err = error {
            //에러처리
        }else{
            
            self.navigationController?.popToRootViewControllerAnimated(true)
            
        }
        */
    }

    
    
    func totalUpdate(){
        
        totalAmountField.hidden = !isTotal
        startAmountField.hidden = isTotal
        endAmountField.hidden = isTotal
        middleBox.hidden = isTotal
        
        if isTotal == true {
            infoLabel.text = "전체"
        }else{
            infoLabel.text = "범위"
        }
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
    
    
    
    func updateAmountAllEvents(textField:UITextField){
        
        switch textField {
        case totalAmountField : totalAmount = textField.text.toInt()
        case startAmountField : startAmount = textField.text.toInt()
        case endAmountField : endAmount = textField.text.toInt()
        default: textField.text = ""
        }
        
    }
    
    
}