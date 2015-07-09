//
//  PeriodViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 8..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

protocol PeriodDelegate :NSObjectProtocol {
    func updatePeriodStartDate(date:NSDate)
    func updatePeriodEndDate(date:NSDate)
    func updatePeriodDay(day:String)
}


class PeriodViewController: BasicViewController {

    @IBOutlet weak var periodSegmentedControl: UISegmentedControl!
    @IBOutlet weak var periodDatePicker: UIDatePicker!
    
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var periodDayLabel: UILabel!
    @IBOutlet weak var periodLabel: UILabel!
    
    var startDate: NSDate!
    var endDate: NSDate!
    var delegate: PeriodDelegate!
    var mainColor: UIColor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDetailDesign()
        setupDate()
        calculateDate()
        
        
        completeButton.backgroundColor = mainColor
    }
    
    func setupDetailDesign(){
        periodSegmentedControl.setTitleTextAttributes([NSFontAttributeName:UIFont(name: "AvenirNext-Regular", size: 16*ratio)!], forState: UIControlState.Normal)
        periodSegmentedControl.tintColor = mainColor
    }
    
    func setupDate(){
        periodDatePicker.date = startDate
        
    }
    
    func calculateDate(){
        
        let day = getDay()
        let dateform = NSDateFormatter()
        dateform.dateFormat = "M월 d일"
        periodLabel.text = "\(dateform.stringFromDate(startDate))~\(dateform.stringFromDate(endDate))"
        periodLabel.textColor = mainColor
        periodDayLabel.text = "\(day)일"
        periodDayLabel.textColor = mainColor
        
        
    }
    
    func getDay() -> Int{
        let time = endDate.timeIntervalSinceDate(startDate)
        let day = Int(time / (24*60*60)+1)
        return day
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        todaitNavBar.hidden = true
        
    }
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func periodSelectClk(sender: AnyObject) {
        
        
        let day = getDay()
        
        updatePeriodDay("\(day)일")
        updatePeriodStartDate(startDate)
        updatePeriodEndDate(endDate)
        
        
        dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
        
    }
    
    func updatePeriodStartDate(date:NSDate){
        if self.delegate.respondsToSelector("updatePeriodStartDate:"){
            self.delegate.updatePeriodStartDate(date)
        }
    }
    
    func updatePeriodEndDate(date:NSDate){
        
        if self.delegate.respondsToSelector("updatePeriodEndDate:"){
            self.delegate.updatePeriodEndDate(date)
        }
    }
    
    func updatePeriodDay(day:String){
        
        if self.delegate.respondsToSelector("updatePeriodDay:"){
            self.delegate.updatePeriodDay(day)
        }
        
    }
    
    @IBAction func datePickerChanged(sender: UIDatePicker) {
        
        if periodSegmentedControl.selectedSegmentIndex == 0 {
            startDate = periodDatePicker.date
        }else if periodSegmentedControl.selectedSegmentIndex == 1{
            
            
            let pickerDate = periodDatePicker.date
            
            if pickerDate.timeIntervalSinceDate(startDate) >= 0{
                endDate = periodDatePicker.date
            }
        }
        
        if periodSegmentedControl.selectedSegmentIndex == 0 {
            periodDatePicker.setDate(startDate, animated: true)
        }else if periodSegmentedControl.selectedSegmentIndex == 1 {
            periodDatePicker.setDate(endDate, animated: true)
        }
        
        calculateDate()
    }
    
    @IBAction func segmentSelected(sender: UISegmentedControl) {
        
        
        if sender.selectedSegmentIndex == 0 {
            periodDatePicker.setDate(startDate, animated: true)
        }else if sender.selectedSegmentIndex == 1 {
            periodDatePicker.setDate(endDate, animated: true)
        }
        
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
