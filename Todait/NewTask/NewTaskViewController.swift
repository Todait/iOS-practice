//
//  NewTaskViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 1..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit
import CoreData


protocol CategoryUpdateDelegate : NSObjectProtocol{
    func updateCategory(category:Category,from:String)
}


enum OptionStatus {
    
    case none
    case everyDay
    case alarm
    case review
    case reRead
    
}



class NewTaskViewController: BasicViewController,TodaitNavigationDelegate{
    
    
    var mainColor: UIColor!
    
    var categoryInfoLabel: UILabel!
    var categoryCircle: UIView!
    var categoryLabel: UILabel!
    var categoryButton: UIButton!
    
    
    var taskTextField: UITextField!
    var unitTextField: UITextField!
    var unitView: UnitInputView!
    
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
    

    
    var aimAmount:Int! = 0
    var startRangeAmount:Int! = 0
    var endRangeAmount:Int! = 0
    var dayAmount:Int! = 0
    
    
    
    var category:Category!
    var delegate: CategoryUpdateDelegate!
    
    
    var timeTaskButton:UIButton!
    var amountTaskButton:UIButton!
    
    
    
    
    var taskView:UIView!
    
    var timerTaskVC:TimerTaskViewController!
    var timeTaskVC:TimeTaskViewController!
    var amountTaskVC:AmountTaskViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.colorWithHexString("#EFEFEF")
        
        addTimeTaskButton()
        addAmountTaskButton()
        addTaskView()
        setupTaskViewController()
        timeTaskButtonClk()
        
    }
    
    func addTimeTaskButton(){
        
        timeTaskButton = UIButton(frame: CGRectMake(0, navigationHeight, 160*ratio, 40*ratio))
        timeTaskButton.setTitle("시간", forState: UIControlState.Normal)
        timeTaskButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 12*ratio)
        timeTaskButton.setBackgroundImage(UIImage.colorImage(UIColor.whiteColor(), frame: CGRectMake(0, 0, 160*ratio, 40*ratio)), forState: UIControlState.Normal)
    
        timeTaskButton.setTitleColor(UIColor.todaitGreen(), forState: UIControlState.Normal)
        timeTaskButton.setTitleColor(UIColor.todaitDarkGreen(), forState: UIControlState.Highlighted)
        timeTaskButton.addTarget(self, action: Selector("timeTaskButtonClk"), forControlEvents: UIControlEvents.TouchUpInside)
        //view.addSubview(timeTaskButton)
    }
    
    func setButtonHighlight(button:UIButton, highlight:Bool){
        
        if !highlight {
            
            button.setBackgroundImage(UIImage.colorImage(UIColor.todaitGreen(), frame: CGRectMake(0, 0, 160*ratio, 40*ratio)), forState: UIControlState.Normal)
            button.setBackgroundImage(UIImage.colorImage(UIColor.todaitDarkGreen(), frame: CGRectMake(0, 0, 160*ratio, 40*ratio)), forState: UIControlState.Highlighted)
            
            button.setTitleColor(UIColor.whiteColor().colorWithAlphaComponent(0.5), forState: UIControlState.Normal)
            button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
            
        }else{
            button.setBackgroundImage(UIImage.colorImage(UIColor.whiteColor(), frame: CGRectMake(0, 0, 160*ratio, 40*ratio)), forState: UIControlState.Normal)
            button.setBackgroundImage(UIImage.colorImage(UIColor.todaitLightGray(), frame: CGRectMake(0, 0, 160*ratio, 40*ratio)), forState: UIControlState.Highlighted)
            
            button.setTitleColor(UIColor.todaitGreen(), forState: UIControlState.Normal)
            button.setTitleColor(UIColor.todaitDarkGreen(), forState: UIControlState.Highlighted)
        }
        
    }
    
    func timeTaskButtonClk(){
        
        setButtonHighlight(timeTaskButton, highlight: true)
        setButtonHighlight(amountTaskButton, highlight: false)
    
        clearTaskView()
        
        //taskView.addSubview(timeTaskVC.view)
        taskView.addSubview(timerTaskVC.view)
    }
    
    func addAmountTaskButton(){
        
        amountTaskButton = UIButton(frame: CGRectMake(160*ratio, navigationHeight, 160*ratio, 40*ratio))
        amountTaskButton.setTitle("분량", forState: UIControlState.Normal)
        amountTaskButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 12*ratio)
        
        amountTaskButton.setBackgroundImage(UIImage.colorImage(UIColor.todaitGreen(), frame: CGRectMake(0, 0, 160*ratio, 40*ratio)), forState: UIControlState.Normal)
        amountTaskButton.setBackgroundImage(UIImage.colorImage(UIColor.todaitDarkGreen(), frame: CGRectMake(0, 0, 160*ratio, 40*ratio)), forState: UIControlState.Highlighted)
        
        amountTaskButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        amountTaskButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        amountTaskButton.addTarget(self, action: Selector("amountTaskButtonClk"), forControlEvents: UIControlEvents.TouchUpInside)
        //view.addSubview(amountTaskButton)
    }
    func amountTaskButtonClk(){
        
        setButtonHighlight(timeTaskButton, highlight: false)
        setButtonHighlight(amountTaskButton, highlight: true)
        
        clearTaskView()
        taskView.addSubview(amountTaskVC.view)
        
    }
    
    func clearTaskView(){
        
        for temp in taskView.subviews{
            temp.removeFromSuperview()
        }
        
    }
    
    func addTaskView(){
        
        
        taskView = UIView(frame: CGRectMake(0, navigationHeight, 320*ratio, height - navigationHeight))
        view.addSubview(taskView)
        
    }
    
    func setupTaskViewController(){
        
        startDate = NSDate()
        periodStartDate = NSDate()
        periodEndDate = NSDate(timeIntervalSinceNow: 24*60*60 * 29)
        
        dateForm = NSDateFormatter()
        dateForm.dateFormat = "a h시 m분"
        
        
        setupTimerViewController()
        //setupTimeTaskViewController()
        //setupAmountTaskViewController()
    }
    
    func setupTimerViewController(){
        
        timerTaskVC = TimerTaskViewController()
        timerTaskVC.view.frame = CGRectMake(0, 0, 320*ratio, height - navigationHeight)
        addChildViewController(timerTaskVC)
        
    }
    
    func setupTimeTaskViewController(){
        timeTaskVC = TimeTaskViewController()
        timeTaskVC.view.frame = CGRectMake(0, 0, 320*ratio, height - navigationHeight - 40*ratio)
        addChildViewController(timeTaskVC)
    }
    
    func setupAmountTaskViewController(){
        amountTaskVC = AmountTaskViewController()
        amountTaskVC.view.frame = CGRectMake(0, 0, 320*ratio, height - navigationHeight - 40*ratio)
        addChildViewController(amountTaskVC)
        
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
    
    
    
    
    
    
    
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        todaitNavBar.todaitDelegate = self
        todaitNavBar.backButton.hidden = false
        self.titleLabel.text = "새로운 목표"
        
        self.screenName = "Create Activity"
        
        
        addSaveButton()
        /*
        setNavigationBarColor(mainColor)
        taskTableView.reloadData()
        */
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
        
        task.name = "스위프트" //taskTextField.text
        task.created_at = NSDate()
        
        
        let dateForm = NSDateFormatter()
        dateForm.dateFormat = "yyyyMMdd"
        
        task.start_date = getDateNumberFromDate(periodStartDate)
        task.end_date = getDateNumberFromDate(periodEndDate)
        task.unit = "개" //unitTextField.text
        task.category_id = category
        
        
        setupTextField()
        
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
        
        
        week.sun_minute = 1//investData[0];
        week.mon_minute = 2//investData[1];
        week.tue_minute = 5//investData[2];
        week.wed_minute = 6//investData[3];
        week.thu_minute = 7//investData[4];
        week.fri_minute = 1//investData[5];
        week.sat_minute = 2//investData[6];
        
        
        week.updated_at = NSDate()
        week.created_at = NSDate()
        
        
        
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
    }
    
    func backButtonClk() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
