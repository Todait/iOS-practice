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
    
    var filterView:UIImageView!
    
    var periodView:UIView!
    var periodDatePicker: UIDatePicker!
    
    var periodDayLabel: UILabel!
    var periodLabel: UILabel!
    
    var confirmButton: UIButton!
    
    var startDate: NSDate!
    var endDate: NSDate!
    var delegate: PeriodDelegate!
    var mainColor: UIColor!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addFilterView()
        addPeriodView()
        addPeriodControl()
        addPeriodPicker()
        addPeriodLabel()
        addPeriodDayLabel()
        addConfirmButton()
        
        setupDate()
        
        calculateDate()

        
        //completeButton.backgroundColor = mainColor
    }
    
    func addFilterView(){
        
        filterView = UIImageView(frame: view.frame)
        filterView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        view.addSubview(filterView)
        
    }
    
    func addPeriodView(){
        
        periodView = UIView(frame: CGRectMake(13*ratio, height, 294*ratio, 330*ratio))
        periodView.clipsToBounds = true
        view.addSubview(periodView)
        
        
        let grayView = UIView(frame: CGRectMake(0, 0, 294*ratio,33*ratio))
        grayView.backgroundColor = UIColor.colorWithHexString("#949494")
        periodView.addSubview(grayView)
        
        let infoLabel = UILabel(frame: CGRectMake(13*ratio, 0, 200*ratio, 33*ratio))
        infoLabel.textAlignment = NSTextAlignment.Left
        infoLabel.textColor = UIColor.whiteColor()
        infoLabel.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 12.5*ratio)
        infoLabel.text = "기간"
        periodView.addSubview(infoLabel)
        
        
        let whiteView = UIView(frame: CGRectMake(0, 33*ratio, 294*ratio, 240*ratio))
        whiteView.backgroundColor = UIColor.whiteColor()
        periodView.addSubview(whiteView)
        
    }
    
    
    
    func addPeriodControl(){
        
        //periodSegmentedControl = UISegmentedControl(items:["시작일","종료일"])
        //periodSegmentedControl.frame = CGRectMake(15*ratio, 55*ratio,264*ratio, 35*ratio)
        //periodView.addSubview(periodSegmentedControl)
        
    }
    
    func addPeriodPicker(){
        
        periodDatePicker = UIDatePicker(frame: CGRectMake(-13*ratio, 45*ratio, 294*ratio, 200*ratio))
        periodDatePicker.datePickerMode = UIDatePickerMode.Date
        periodView.addSubview(periodDatePicker)
        
    }
    
    func addPeriodLabel(){
        
        periodLabel = UILabel(frame: CGRectMake(10*ratio,6.5*ratio,274*ratio,20*ratio))
        periodLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12*ratio)
        periodLabel.textColor = UIColor.whiteColor()
        periodLabel.textAlignment = NSTextAlignment.Center
        periodView.addSubview(periodLabel)
        
    }
    
    func addPeriodDayLabel(){
        
        periodDayLabel = UILabel(frame: CGRectMake(15*ratio,235*ratio,274*ratio,20*ratio))
        periodDayLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 24*ratio)
        periodDayLabel.textAlignment = NSTextAlignment.Center
        periodDayLabel.textColor = UIColor.todaitDarkGray()
        periodView.addSubview(periodDayLabel)
        
        
    }
    
    func addConfirmButton(){
        confirmButton = UIButton(frame: CGRectMake(0*ratio, 285*ratio, 294*ratio, 43*ratio))
        confirmButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        confirmButton.setTitle("확인", forState: UIControlState.Normal)
        confirmButton.setBackgroundImage(UIImage.colorImage(UIColor.todaitGreen(), frame: CGRectMake(0, 0, 294*ratio, 43*ratio)), forState: UIControlState.Normal)
        confirmButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo", size: 15*ratio)
        confirmButton.addTarget(self, action: Selector("confirmButtonClk"), forControlEvents: UIControlEvents.TouchUpInside)
        periodView.addSubview(confirmButton)
    }
    
    func confirmButtonClk(){
        
        closeButtonClk()
    }
    
    
    func setupDate(){
        periodDatePicker.date = startDate
        
    }
    
    func calculateDate(){
        
        let day = getDay()
        let dateform = NSDateFormatter()
        dateform.dateFormat = "M월 d일"
        periodLabel.text = "\(dateform.stringFromDate(startDate))~\(dateform.stringFromDate(endDate))"
        periodDayLabel.text = "총 \(day)일"
        
    }
    
    func getDay() -> Int{
        let time = endDate.timeIntervalSinceDate(startDate)
        let day = Int(time / (24*60*60)+1)
        return day
    }
    
    func closeButtonClk(){
        
        UIView.animateWithDuration(0.4, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            self.periodView.transform = CGAffineTransformMakeTranslation(0, 0)
            }, completion: { (Bool) -> Void in
                
                self.dismissViewControllerAnimated(false, completion: { () -> Void in
                    
                })
        })
    }
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        closeButtonClk()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        todaitNavBar.hidden = true
        
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut , animations: { () -> Void in
            self.periodView.transform = CGAffineTransformMakeTranslation(0, -330*self.ratio)
            
            }) { (Bool) -> Void in
                
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
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
        /*
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
        */
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
