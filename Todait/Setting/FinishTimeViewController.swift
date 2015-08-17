//
//  FinishTimeViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 4..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit
import CoreData

class FinishTimeViewController: BasicViewController,TodaitNavigationDelegate {

    
    var datePicker: UIDatePicker!
    var doneButton: UIButton!
    var blurEffectView: UIVisualEffectView!
    var finishDateComponents: NSDateComponents!
    
    var infoLabel: UILabel!
    
    
    
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBlurBackground()
        setupFinishDateComponents()
        addInfoLabel()
        addDatePickerView()
        addDoneButton()
    }
    
    func setupBlurBackground(){
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.frame
        blurEffectView.alpha = 0.9
        view.addSubview(blurEffectView)
    }
    
    func setupFinishDateComponents(){
        
        let hour: Int = defaults.integerForKey("finishHourOfDay")
        let minute: Int = defaults.integerForKey("finishMinuteOfDay")
        
        finishDateComponents = NSDateComponents()
        finishDateComponents.minute = minute
        finishDateComponents.hour = hour
        
        
    }
    
    func addInfoLabel(){
        infoLabel = UILabel(frame: CGRectMake(30*ratio,100*ratio, 260*ratio, 80*ratio))
        infoLabel.text = "마무리 시간"
        infoLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 30*ratio)
        infoLabel.textColor = UIColor.colorWithHexString("#00D2B1")
        infoLabel.textAlignment = NSTextAlignment.Center
        view.addSubview(infoLabel)
        
    }

    func addDatePickerView(){
        datePicker = UIDatePicker(frame: CGRectMake(0, 0, width, 250*ratio))
        datePicker.center = view.center
        datePicker.datePickerMode = UIDatePickerMode.Time
        datePicker.date = NSCalendar.currentCalendar().dateFromComponents(finishDateComponents)!
        view.addSubview(datePicker)
    }
    
    func addDoneButton(){
        doneButton = UIButton(frame: CGRectMake(0, height-50*ratio, width, 50*ratio))
        doneButton.setTitle("완료", forState: UIControlState.Normal)
        doneButton.setBackgroundImage(UIImage.colorImage(UIColor.colorWithHexString("#00D2B1"), frame: CGRectMake(0, 0, width, 50*ratio)), forState:UIControlState.Normal)
        doneButton.addTarget(self, action: Selector("doneButtonClk"), forControlEvents: UIControlEvents.TouchUpInside)
        doneButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 20*ratio)
        
        view.addSubview(doneButton)
    }
    
    func doneButtonClk(){
        
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let dateComponents: NSDateComponents = calendar.components(NSCalendarUnit.CalendarUnitHour|NSCalendarUnit.CalendarUnitMinute, fromDate: datePicker.date)
    
        
        defaults.setInteger(dateComponents.hour, forKey:"finishHourOfDay")
        defaults.setInteger(dateComponents.minute, forKey:"finishMinuteOfDay")
        
        
        checkFinishDays()
        
        
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
    
    func checkFinishDays(){
        
        
        let todayDateNumber = getTodayDateNumber()
        
        let dayDescription = NSEntityDescription.entityForName("Day", inManagedObjectContext:managedObjectContext!)
        
        let predicate:NSPredicate = NSPredicate(format: "date > %@",todayDateNumber)
        let request = NSFetchRequest()
        
        request.entity = dayDescription
        request.predicate = predicate
        
        var error: NSError?
        let days:[Day] = managedObjectContext?.executeFetchRequest(request, error: &error) as! [Day]
        
        
        if days.count == 0 {
            NSLog("삭제할 Day가 없습니다")
            return
        }
        
        for deleteDay in days {
            managedObjectContext?.deleteObject(deleteDay)
        }
        
        
        
        managedObjectContext?.save(&error)
        
        
        if let err = error {
            //에러처리
            NSLog("에러발생")
        }else{
            NSLog("삭제성공",1)
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        todaitNavBar.hidden = true
        todaitNavBar.todaitDelegate = self
        todaitNavBar.backButton.hidden = false
    
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.dismissViewControllerAnimated(false, completion: { () -> Void in
            
        })
    }
    
    func backButtonClk() {
        self.navigationController?.popViewControllerAnimated(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
