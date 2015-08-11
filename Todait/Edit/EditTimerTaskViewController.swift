//
//  EditTimerTaskViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 7. 29..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class EditTimerTaskViewController: BasicViewController,UITextFieldDelegate,CategoryDelegate,TodaitNavigationDelegate,AlarmDelegate{
   
    var editedTask:Task!
    var category:Category!
    var delegate: CategoryUpdateDelegate!
    var mainColor: UIColor!
   
    
    
    var goalView:UIView!
    var goalTextField: UITextField!
    var categoryButton: UIButton!
    
    
    var optionView:UIView!
    var alarmOption:OptionButton!
    
    
    var aimString:String!
    
    var saveButton: UIButton!
    
    var currentTextField: UITextField!
    
    
    var dateForm: NSDateFormatter!
    
    
    
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    
    var options:[Int] = [1,2,4,8]
    var option:Int! = 0
    var isAlarmOn:Bool! = false
    var alarmTime:NSDate?
    var deleteButton:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.todaitBackgroundGray()
        
        
        loadDefaultCategory()
        setupTimeTaskViewController()
        
        addGoalView()
        addOptionView()
        
        addDeleteButton()
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
        goalTextField = UITextField(frame: CGRectMake(20*ratio, 19*ratio, 255*ratio, 12*ratio))
        goalTextField.placeholder = "이곳에 목표를 입력해주세요"
        goalTextField.textAlignment = NSTextAlignment.Left
        goalTextField.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12*ratio)
        goalTextField.textColor = UIColor.colorWithHexString("#969696")
        goalTextField.returnKeyType = UIReturnKeyType.Next
        goalTextField.backgroundColor = UIColor.whiteColor()
        goalTextField.addTarget(self, action: Selector("updateAllEvents:"), forControlEvents: UIControlEvents.AllEvents)
        goalTextField.text = aimString
        goalTextField.delegate = self
        goalView.addSubview(goalTextField)
        
        
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
    
    
    
    func addOptionView(){
        
        
        if let notificationId = editedTask.notificationId {
            
            isAlarmOn = true
            
            for notification in UIApplication().scheduledLocalNotifications {
                
                let notification:UILocalNotification! = notification as! UILocalNotification
                
                let userInfo:[String:AnyObject?]! = notification.userInfo as! [String:AnyObject]
                
                let notiId:String = userInfo["notificationId"] as! String
                
                if notiId == notificationId {
                    alarmTime = notification.fireDate
                }
            }
        }
        
        
        
        
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
            
            alarmOption.setText("\(comp.hour):\(comp.minute)")
            //alarmOption.setText(dateForm.stringFromDate(alarmTime!))
            
        }else{
            alarmOption.setText("알람없음")
        }
        
        alarmOption.setButtonOn(isAlarmOn)
    }

    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        todaitNavBar.todaitDelegate = self
        todaitNavBar.backButton.hidden = false
        
        self.titleLabel.text = "Edit"
        self.screenName = "Detail Activity"
        
        todaitNavBar.shadowImage = UIImage()
        
        addSaveButton()
        
    }
    
    
    
    func addSaveButton(){
        
        if saveButton != nil {
            return
        }
        
        saveButton = UIButton(frame: CGRectMake(288*ratio,32,22,16))
        saveButton.setImage(UIImage.maskColor("icon_check_wt@3x.png",color:UIColor.whiteColor()), forState: UIControlState.Normal)
        saveButton.addTarget(self, action: Selector("saveEditedTask"), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(saveButton)
    }
    
    func saveEditedTask(){
        
        
        
        
        
        editedTask.name = goalTextField.text
        editedTask.categoryId = category
        
        var error: NSError?
        managedObjectContext?.save(&error)
        
        if let err = error {
            //에러처리
        }else{
            
            
            backButtonClk()
        }
        
    }
    
    
    func backButtonClk() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    
    func setupTimeTaskViewController(){
        
        dateForm = NSDateFormatter()
        dateForm.dateFormat = "a h시 m분"
        
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
        
        managedObjectContext?.deleteObject(editedTask)
        
        var error: NSError?
        managedObjectContext?.save(&error)
        
        if let err = error {
            //에러처리
        }else{
            
            self.navigationController?.popToRootViewControllerAnimated(true)
        
        }
        
    }
    
    
    
    
    func addLineView(cell: UITableViewCell){
        
        let lineView = UIView(frame: CGRectMake(1*ratio, 48.5*ratio,318*ratio, 0.5*ratio))
        lineView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15)
        cell.contentView.addSubview(lineView)
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
