//
//  NewTaskViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 1..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit
import CoreData

class NewTaskViewController: BasicViewController,UITextFieldDelegate,TodaitNavigationDelegate,CategoryDelegate{
    
    var taskTableView: UITableView!

    var scrollView: UIScrollView!
    
    var categoryCircle: UIView!
    var categoryLabel: UILabel!
    var categoryButton: UIButton!
    
    var infoLabel: UILabel!
    var taskTextField: UITextField!
    var unitSegment: UISegmentedControl!
    var rangeSegment: UISegmentedControl!
    
    var totalTextField: UITextField!
    var startRangeTextField: UITextField!
    var endRangeTextField: UITextField!
    var dayTextField: UITextField!
    
    var saveButton: UIButton!
    var investButton: UIButton!
    
    
    var currentTextField: UITextField!
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.colorWithHexString("#EFEFEF")
        
        addTaskTableView()
        addScrollView()
        addCategoryView()
        addInfoLabel()
        addTaskTextField()
        addUnitSegment()
        addRangeSegment()
        addTextField()
        addInvestButton()
        
        
        //saveNewTask()
    }
    
    func addTaskTableView(){
    
    }
    
    func addScrollView(){
        scrollView = UIScrollView(frame: CGRectMake(0, navigationHeight*ratio, width, height-64*ratio))
        scrollView.contentSize = CGSizeMake(width, height-navigationHeight*ratio)
        view.addSubview(scrollView)
        
        
        var tapgesture = UITapGestureRecognizer()
        tapgesture.addTarget(self, action: "tap")
        scrollView.addGestureRecognizer(tapgesture)
    }
    
    func tap(){
        
        taskTextField.resignFirstResponder()
        totalTextField.resignFirstResponder()
        startRangeTextField.resignFirstResponder()
        endRangeTextField.resignFirstResponder()
        dayTextField.resignFirstResponder()
        
    }
    
    func addCategoryView(){
        addCategoryCircle()
        addCategoryLabel()
        addCategoryButton()
    }
    
    func addCategoryCircle(){
        categoryCircle = UIView(frame: CGRectMake(15*ratio, 78.5*ratio, 15*ratio, 15*ratio))
        categoryCircle.backgroundColor = UIColor.colorWithHexString("#969696")
        categoryCircle.clipsToBounds = true
        categoryCircle.layer.cornerRadius = 7.5*ratio
        scrollView.addSubview(categoryCircle)
    }
    
    func addCategoryLabel(){
        categoryLabel = UILabel(frame: CGRectMake(40*ratio, 71*ratio, 200*ratio, 30*ratio))
        categoryLabel.text = "영어"
        categoryLabel.textColor = UIColor.colorWithHexString("#969696")
        categoryLabel.font = UIFont(name: "AvenirNext-Regular", size: 14*ratio)
        categoryLabel.textAlignment = NSTextAlignment.Left
        scrollView.addSubview(categoryLabel)
    }
    
    func addCategoryButton(){
        categoryButton = UIButton(frame: CGRectMake(275*ratio, 74*ratio, 24*ratio, 24*ratio))
        categoryButton.setBackgroundImage(UIImage(named: "setting@2x.png"), forState: UIControlState.Normal)
        categoryButton.addTarget(self, action: Selector("categorySetting"), forControlEvents: UIControlEvents.TouchDown)
        scrollView.addSubview(categoryButton)
    }
    
    func categorySetting(){
        
        var categoryVC = CategoryViewController()
        categoryVC.delegate = self
        self.navigationController?.pushViewController(categoryVC, animated: true)
    }
    
    func categoryEdited(color:UIColor,title:String) {
        categoryCircle.backgroundColor = color
        categoryLabel.text = title
    }
    
    func categoryEdited(){
        
    }
    
    func addInfoLabel(){
        infoLabel = UILabel(frame: CGRectMake(15*ratio, 5*ratio, 290*ratio,20*ratio))
        infoLabel.font = UIFont(name: "AvenirNext-Regular", size: 14*ratio)
        infoLabel.text = "새로운 목표를 계획해보아요:)"
        infoLabel.textColor = UIColor.colorWithHexString("#969696")
        scrollView.addSubview(infoLabel)
    }
    
    func addTaskTextField(){
        taskTextField = UITextField(frame: CGRectMake(15*ratio, 31*ratio, 290*ratio, 30*ratio))
        taskTextField.placeholder = "목표를 입력하세요"
        taskTextField.font = UIFont(name: "AvenirNext-Regular", size: 14*ratio)
        taskTextField.textColor = UIColor.colorWithHexString("#969696")
        taskTextField.returnKeyType = UIReturnKeyType.Next
        taskTextField.becomeFirstResponder()
        taskTextField.backgroundColor = UIColor.whiteColor()
        currentTextField = taskTextField
        
        scrollView.addSubview(taskTextField)
        
    }
    
    func addUnitSegment(){
        unitSegment = UISegmentedControl(items: ["개","문제","쪽"])
        unitSegment.frame = CGRectMake(15*ratio, 111*ratio, 290*ratio, 35*ratio)
        unitSegment.selectedSegmentIndex = 0
        unitSegment.tintColor = UIColor.colorWithHexString("#8550AA")
        unitSegment.setTitleTextAttributes([NSFontAttributeName:UIFont(name: "AvenirNext-Regular", size: 14*ratio)!], forState: UIControlState.Normal)
        scrollView.addSubview(unitSegment)
    }
    
    func addRangeSegment(){
        
        rangeSegment = UISegmentedControl(items: ["전체","범위","하루"])
        rangeSegment.frame = CGRectMake(15*ratio, 156*ratio, 290*ratio, 35*ratio)
        rangeSegment.selectedSegmentIndex = 0
        rangeSegment.tintColor = UIColor.colorWithHexString("#8550AA")
        rangeSegment.setTitleTextAttributes([NSFontAttributeName:UIFont(name: "AvenirNext-Regular", size: 14*ratio)!], forState: UIControlState.Normal)
        rangeSegment.addTarget(self, action: Selector("rangeSegmentClk:"), forControlEvents: UIControlEvents.AllEvents)
        scrollView.addSubview(rangeSegment)
        
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
    
    func addTextField(){
        addTotalTextField()
        addStartRangeTextField()
        addEndRangeTextField()
        addDayTextField()
    }
    
    func addTotalTextField(){
        totalTextField = UITextField(frame: CGRectMake(15*ratio, 205*ratio, 290*ratio, 30*ratio))
        totalTextField.textAlignment = NSTextAlignment.Left
        totalTextField.placeholder = "분량을 입력하세요"
        totalTextField.font = UIFont(name: "AvenirNext-Regular", size: 16*ratio)
        totalTextField.textColor = UIColor.colorWithHexString("#969696")
        totalTextField.keyboardType = UIKeyboardType.NumberPad
        totalTextField.backgroundColor = UIColor.whiteColor()
        scrollView.addSubview(totalTextField)
    }
    
    func addStartRangeTextField(){
        startRangeTextField = UITextField(frame: CGRectMake(15*ratio, 205*ratio, 130*ratio, 30*ratio))
        startRangeTextField.textAlignment = NSTextAlignment.Left
        startRangeTextField.placeholder = "시작"
        startRangeTextField.font = UIFont(name: "AvenirNext-Regular", size: 16*ratio)
        startRangeTextField.textColor = UIColor.colorWithHexString("#969696")
        startRangeTextField.hidden = true
        startRangeTextField.keyboardType = UIKeyboardType.NumberPad
        startRangeTextField.backgroundColor = UIColor.whiteColor()
        scrollView.addSubview(startRangeTextField)
    }
    
    func addEndRangeTextField(){
        endRangeTextField = UITextField(frame: CGRectMake(175*ratio, 205*ratio, 130*ratio, 30*ratio))
        endRangeTextField.textAlignment = NSTextAlignment.Left
        endRangeTextField.placeholder = "종료"
        endRangeTextField.font = UIFont(name: "AvenirNext-Regular", size: 16*ratio)
        endRangeTextField.textColor = UIColor.colorWithHexString("#969696")
        endRangeTextField.hidden = true
        endRangeTextField.keyboardType = UIKeyboardType.NumberPad
        endRangeTextField.backgroundColor = UIColor.whiteColor()
        scrollView.addSubview(endRangeTextField)
    }
    
    func addDayTextField(){
        dayTextField = UITextField(frame: CGRectMake(15*ratio, 205*ratio, 290*ratio, 30*ratio))
        dayTextField.textAlignment = NSTextAlignment.Left
        dayTextField.placeholder = "분량을 입력하세요"
        dayTextField.font = UIFont(name: "AvenirNext-Regular", size: 16*ratio)
        dayTextField.textColor = UIColor.colorWithHexString("#969696")
        dayTextField.hidden = true
        dayTextField.keyboardType = UIKeyboardType.NumberPad
        dayTextField.backgroundColor = UIColor.whiteColor()
        scrollView.addSubview(dayTextField)
    }
    
    func addInvestButton(){
        investButton = UIButton(frame: CGRectMake(175*ratio, 245*ratio, 130*ratio, 60*ratio))
        investButton.backgroundColor = UIColor.whiteColor()
        investButton.setTitle("목표투자시간", forState: UIControlState.Normal)
        investButton.addTarget(self, action: Selector("showInvestVC"), forControlEvents: UIControlEvents.TouchUpInside)
        scrollView.addSubview(investButton)
    }
    
    func showInvestVC(){
        
        let investVC = InvestViewController()
        investVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        
        self.navigationController?.presentViewController(investVC, animated: true, completion: { () -> Void in
            
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        todaitNavBar.todaitDelegate = self
        todaitNavBar.backButton.hidden = false
        self.titleLabel.text = "새로운 목표"
        
        addSaveButton()
    }
    
    func addSaveButton(){
        saveButton = UIButton(frame: CGRectMake(288*ratio,30*ratio,24*ratio,24*ratio))
        saveButton.setBackgroundImage(UIImage(named: "newPlus.png"), forState: UIControlState.Normal)
        saveButton.addTarget(self, action: Selector("saveNewTask"), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(saveButton)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    
    func saveNewTask(){
        let entityDescription = NSEntityDescription.entityForName("Task", inManagedObjectContext:managedObjectContext!)
        
        let task = Task(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
        task.name = taskTextField.text
        task.created_at = NSDate()
        task.start_date = NSDate()
        task.end_date = NSDate(timeIntervalSinceNow: 10500)
        task.unit = unitSegment.titleForSegmentAtIndex(unitSegment.selectedSegmentIndex)!
        
        var error: NSError?
        managedObjectContext?.save(&error)
        
        if let err = error {
            //에러처리
        }else{
            NSLog("Task 저장성공",1)
        }
        
        
        
    }
    
    
    func backButtonClk() {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
