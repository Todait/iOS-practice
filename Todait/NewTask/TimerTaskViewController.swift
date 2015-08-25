//
//  TimerTaskViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 7. 20..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

class TimerTaskViewController: BasicViewController,UITextFieldDelegate,CategoryDelegate,ValidationDelegate,KeyboardHelpDelegate,AlarmDelegate{
    var mainColor: UIColor!
    
    var categoryButton: UIButton!
    
    var completeButton: UIButton!

    var currentTextField: UITextField!
    
    var dateForm: NSDateFormatter!
    var startDate: NSDate!
    
    
    //let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var aimString:String! = ""
    var unitString:String! = ""
    

    var isTotal:Bool! = true
    
    var aimAmount:Int! = 0
    var startRangeAmount:Int! = 0
    var endRangeAmount:Int! = 0
    var dayAmount:Int! = 0
    var category:Category?
    
    
    var goalView:UIView!
    var goalTextField:UITextField!
    
    
    var optionView:UIView!
    var alarmOption:OptionButton!
    var isAlarmOn:Bool = false
    var alarmTime:NSDate?
    
    
    var closeButton:UIButton!
    var keyboardHelpView:KeyboardHelpView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.todaitBackgroundGray()
        loadDefaultCategory()
        
        addGoalView()
        addOptionView()
        
        setupTimeTaskViewController()
        //addTimeTaskTableView()
        
        addKeyboardHelpView()
        
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
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.todaitNavBar.hidden = false
        self.titleLabel.text = "시간 측정"
        self.titleLabel.hidden = false
        addCloseButton()
        addCompleteButton()
    
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

    
    func addCompleteButton(){
        
        if completeButton != nil {
            return
        }
        
        completeButton = UIButton(frame: CGRectMake(255*ratio, 32, 50*ratio, 20))
        completeButton.setTitle("Done", forState: UIControlState.Normal)
        completeButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 18)
        completeButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        completeButton.addTarget(self, action: Selector("completeButtonClk"), forControlEvents: UIControlEvents.TouchUpInside)
        completeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        view.addSubview(completeButton)
        
    }
    
    
    func addCloseButton(){
        
        if closeButton != nil {
            return
        }
        
        closeButton = UIButton(frame: CGRectMake(2, 22, 44, 44))
        closeButton.setBackgroundImage(UIImage(named: "nav_bt_closed@3x.png"), forState: UIControlState.Normal)
        closeButton.addTarget(self, action: Selector("closeButtonClk"), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(closeButton)
    }
    
    func closeButtonClk(){
        
        if let currentTextField = currentTextField {
            currentTextField.resignFirstResponder()
        }
        
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
    
    func completeButtonClk(){
        
        
        let validator = Validator()
        validator.registerField(goalTextField, rules:[MinLengthRule(length: 1, message: "목표를 입력해주세요.")])
        validator.validate(self)
        
    }
    
    func validationSuccessful(){
        saveNewTask()
    }
    
    func validationFailed(errors: [UITextField:ValidationError]){
        
        
        for ( textField , error) in errors {
            
            let alert = UIAlertView(title: "Invalid", message: error.errorMessage, delegate: nil, cancelButtonTitle: "Cancel")
            
            alert.show()
            
            return
        }
    }
    
    
    func saveNewTask(){
        
        if InternetManager.sharedInstance.isInternetEnable() == true {
            
            var param:[String:AnyObject] = [:]
            var task:[String:AnyObject] = [:]
            task["name"] = goalTextField.text
            task["task_type"] = "time"
            task["repeat_count"] = 1
            task["notification_mode"] = isAlarmOn
            task["priority"] = 0
            task["task_dates_attributes"] = [["start_date":"\(getTodayDateNumber())","state":0]]
            
            if let category = category {
                task["category_id"] = category.serverId
            }
            
            if isAlarmOn == true {
                task["notification_time"] = alarmOption.optionText
            }
            
            param["today_date"] = getTodayDateNumber()
            param["task"] = task
            
            var params = makeBatchParams(CREATE_TASK, param)
            
            requestCreateTask(params)
            
        }else{
            
            
            let alert = UIAlertView(title: "Invalid", message: "인터넷 연결이 필요합니다.", delegate: nil, cancelButtonTitle: "Cancel")
            alert.show()
            
            ProgressManager.hide()
            
        }
        
        
        
    }
    
    
    func requestCreateTask(params:[String:AnyObject]){
        
        setUserHeader()
        
        Alamofire.request(.POST, SERVER_URL + BATCH , parameters: params).responseJSON(options: nil) {
            (request, response , object , error) -> Void in
            
            
            if let object = object {
                
                let jsons = JSON(object)
                
                let syncData = encodeData(jsons["results"][0]["body"])
                self.realmManager.synchronize(syncData)
                
                
                
                
                let taskData = encodeData(jsons["results"][1]["body"])
                
                
                let task:JSON? = taskData["task"]
                if let task = task {
                    
                    self.defaults.setObject(task["sync_at"].stringValue, forKey: "sync_at")
                    self.realmManager.synchronizeTask(task)
                }
                
                
                let day:JSON? = taskData["future_days"]
                if let day = day {
                    self.defaults.setObject(day["sync_at"].stringValue, forKey: "sync_at")
                    self.realmManager.synchronizeDays(day)
                }
                
            }
            
            if let currentTextField = currentTextField {
                currentTextField.resignFirstResponder()
            }
            
            ProgressManager.hide()
            
            self.navigationController?.dismissViewControllerAnimated(true, completion: { () -> Void in
                
            })
        }
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

    
    
    func setupTimeTaskViewController(){
        startDate = NSDate()
        
        dateForm = NSDateFormatter()
        dateForm.dateFormat = "a h시 m분"
        
    }
    
    
    
    func addGoalView(){
        
        goalView = UIView(frame: CGRectMake(2*ratio, 64 + 2*ratio, 316*ratio, 43*ratio))
        goalView.backgroundColor = UIColor.whiteColor()
        goalView.layer.cornerRadius = 1
        goalView.clipsToBounds = true
        view.addSubview(goalView)
        
        addgoalTextField()
        addCategoryButton()
    }
    
    
    func addgoalTextField(){
        
        goalTextField = UITextField(frame: CGRectMake(20*ratio, 10*ratio, 255*ratio, 23*ratio))
        goalTextField.placeholder = "이곳에 목표를 입력해주세요"
        goalTextField.textAlignment = NSTextAlignment.Left
        goalTextField.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12*ratio)
        goalTextField.textColor = UIColor.colorWithHexString("#969696")
        goalTextField.returnKeyType = UIReturnKeyType.Next
        goalTextField.backgroundColor = UIColor.whiteColor()
        //goalTextField.addTarget(self, action: Selector("updateAllEvents:"), forControlEvents: UIControlEvents.AllEvents)
        goalTextField.text = ""
        goalTextField.delegate = self
        goalTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        goalView.addSubview(goalTextField)
        
    }
    
    func addCategoryButton(){
        
        categoryButton = UIButton(frame: CGRectMake(275*ratio,7*ratio, 29*ratio, 29*ratio))
        categoryButton.setImage(UIImage(named: "category@3x.png"), forState: UIControlState.Normal)
        categoryButton.layer.cornerRadius = 14.5*ratio
        categoryButton.layer.borderWidth = 1
        categoryButton.layer.borderColor = UIColor.todaitGray().CGColor
        categoryButton.clipsToBounds = true
        categoryButton.addTarget(self, action: Selector("showCategorySettingVC"), forControlEvents: UIControlEvents.TouchUpInside)
        goalView.addSubview(categoryButton)
        
        if let category = category {
            categoryEdited(category)
        }
        
    }
    
    func showCategorySettingVC(){
        
        var categoryVC = CategorySettingViewController()
        //categoryVC.delegate = self
        
        if let category = category {
            categoryVC.selectedCategory = category
        }
        
        categoryVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        categoryVC.delegate = self
        
        self.navigationController?.presentViewController(categoryVC, animated: false, completion: { () -> Void in
            
        })
        
    }
    
    func categoryEdited(editedCategory:Category) {
        
        
        var color:UIColor!
        
        if let categoryColor = UIColor.colorWithHexString(editedCategory.color) {
            color = categoryColor
        }else{
            color = UIColor.todaitLightGray()
        }
        
        categoryButton.layer.borderColor = UIColor.clearColor().CGColor
        categoryButton.setImage(UIImage.maskColor("category@3x.png", color: UIColor.whiteColor()), forState: UIControlState.Normal)
        
        categoryButton.setBackgroundImage(UIImage.maskColor("circle@3x.png", color: color), forState: UIControlState.Normal)
        categoryButton.setBackgroundImage(UIImage.maskColor("circle@3x.png", color: UIColor.todaitLightGray()), forState: UIControlState.Highlighted)
        
        self.category = editedCategory
    }
    
    
    
    func addOptionView(){
        
        
        optionView = UIView(frame: CGRectMake(2*ratio, 64 + 47*ratio, 316*ratio, 55*ratio))
        optionView.backgroundColor = UIColor.whiteColor()
        view.addSubview(optionView)
        
        addAlarmOptionView()
        
    }
    
    func addAlarmOptionView(){
        
        
        alarmOption = OptionButton(frame:CGRectMake(2*ratio,0*ratio,157*ratio,55*ratio))
        alarmOption.backgroundColor = UIColor.clearColor()
        alarmOption.addTarget(self, action: Selector("alarmOptionClk"), forControlEvents: UIControlEvents.TouchDown)
        alarmOption.onImage = UIImage(named: "icon_alarm_wt@3x.png")
        alarmOption.offImage = UIImage(named: "icon_alarm@3x.png")
        alarmOption.onColor = UIColor.todaitGreen()
        alarmOption.offColor = UIColor.todaitGray()
        alarmOption.setText("알람없음")
        alarmOption.setButtonOn(false)
        optionView.addSubview(alarmOption)
        
        
        alarmOption.iconImageView.center = CGPointMake(37*ratio, 27.5*ratio)
        alarmOption.textLabel.frame = CGRectMake(63*ratio, 12*ratio, 92*ratio, 31*ratio)
        
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
            
            alarmOption.setText(String(format: "%0lu", arguments: [comp.hour]) + ":" + String(format: "%0lu", arguments: [comp.minute]))
            
            
        }else{
            alarmOption.setText("알람없음")
        }
        
        alarmOption.setButtonOn(isAlarmOn)
    }

    
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        
        currentTextField = textField
        currentTextField.textColor = UIColor.todaitRed()
        
        
        return true
    }
    
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        currentTextField = textField
        
        
        confirmButtonClk()
        
        return true
    }
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        currentTextField = textField
        
    }
    
    func addKeyboardHelpView(){
        
        keyboardHelpView = KeyboardHelpView(frame: CGRectMake(0, height , width, 38*ratio + 185*ratio))
        keyboardHelpView.backgroundColor = UIColor.whiteColor()
        keyboardHelpView.delegate = self
        keyboardHelpView.setStatus(KeyboardHelpStatus.Center)
        
        view.addSubview(keyboardHelpView)
        
        
        let line = UIView(frame: CGRectMake(0, 38*ratio-1, width, 1))
        line.backgroundColor = UIColor.colorWithHexString("#d1d5da")
        keyboardHelpView.addSubview(line)
        
    }
    
    
    func confirmButtonClk(){
        
        if let currentTextField = currentTextField {
            currentTextField.textColor = UIColor.todaitGray()
            currentTextField.resignFirstResponder()
        }
    }
    
    func leftButtonClk() {
        return
    }
    
    func rightButtonClk() {
        return
    }
    func resignAllTextResponder(){
        
        goalTextField.resignFirstResponder()
        
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
        
        if let category = category {
            categoryEdited(category)
        }
    }
    
    
    func addLineView(cell: UITableViewCell){
        
        let lineView = UIView(frame: CGRectMake(1*ratio, 48.5*ratio,318*ratio, 0.5*ratio))
        lineView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15)
        cell.contentView.addSubview(lineView)
    }
    
    
    
    func updateUnitAllEvents(textField:UITextField){
        unitString = textField.text
    }
    
    
    func getDateString(dateNumber:NSNumber)->String{
        
        let date = getDateFromDateNumber(dateNumber)
        let dateForm = NSDateFormatter()
        dateForm.dateFormat = "yyyy.MM.dd"
        
        return dateForm.stringFromDate(date)
        
    }
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        goalTextField.resignFirstResponder()
    }
    
    
    
}
