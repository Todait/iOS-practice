//
//  AlarmViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 7. 20..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class AlarmViewController: BasicViewController,UIPickerViewDataSource,UIPickerViewDelegate{
    
    var filterView:UIImageView!
    var backgroundView:UIView!
    var resetButton:UIButton!
    var confirmButton:UIButton!
    var delegate:TimeLogDelegate!
    
    var hourPicker:UIPickerView!
    var minutePicker:UIPickerView!
    
    var pmLabel:UILabel!
    var amLabel:UILabel!
    
    var repeatButton:UIButton!
    
    
    var alarmButton:UIButton!
    var alarmLabel:UILabel!
    var isAlarmOn:Bool! = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addFilterView()
        addBackgroundView()
        addInfoView()
        addconfirmButton()
        addPickerViews()
        addRepeatButton()
        addAlarmButton()
        
        setPickerDate(NSDate())
        setAlarmOn(isAlarmOn)
        
    }
    
    func addFilterView(){
        
        filterView = UIImageView(frame: view.frame)
        filterView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        view.addSubview(filterView)
        
    }
    
    func addBackgroundView(){
        
        backgroundView = UIView(frame: CGRectMake(13.5*ratio, height, 294*ratio,325*ratio))
        backgroundView.backgroundColor = UIColor.clearColor()
        view.addSubview(backgroundView)
        
        
    }
    
    func addInfoView(){
        
        let grayView = UIView(frame: CGRectMake(0, 0, 294*ratio,33*ratio))
        grayView.backgroundColor = UIColor.colorWithHexString("#949494")
        backgroundView.addSubview(grayView)
        
        let infoLabel = UILabel(frame: CGRectMake(13*ratio, 0, 200*ratio, 33*ratio))
        infoLabel.textAlignment = NSTextAlignment.Left
        infoLabel.textColor = UIColor.whiteColor()
        infoLabel.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 12.5*ratio)
        infoLabel.text = "알람 시간"
        backgroundView.addSubview(infoLabel)
        
        
        let whiteView = UIView(frame: CGRectMake(0, 33*ratio, 294*ratio, 241*ratio))
        whiteView.backgroundColor = UIColor.whiteColor()
        backgroundView.addSubview(whiteView)
        
    }
    
    
    func closeButtonClk(){
        
        UIView.animateWithDuration(0.4, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            self.backgroundView.transform = CGAffineTransformMakeTranslation(0, 0)
            }, completion: { (Bool) -> Void in
                
                self.dismissViewControllerAnimated(false, completion: { () -> Void in
                    
                })
        })
    }
    
    
    func resetButtonClk(){
        
    }
    
    func getTimeLog()->NSTimeInterval{
        
        var hour = hourPicker.selectedRowInComponent(0) * 3600
        var minute = minutePicker.selectedRowInComponent(0) * 60
        
        return NSTimeInterval(hour + minute)
    }
    
    
    func addconfirmButton(){
        confirmButton = UIButton(frame: CGRectMake(0, 282*ratio, 294*ratio, 43*ratio))
        confirmButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        confirmButton.setTitle("확인", forState: UIControlState.Normal)
        confirmButton.setBackgroundImage(UIImage.colorImage(UIColor.todaitGreen(), frame: CGRectMake(0, 0, 294*ratio, 43*ratio)), forState: UIControlState.Normal)
        confirmButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo", size: 15*ratio)
        confirmButton.addTarget(self, action: Selector("confirmButtonClk"), forControlEvents: UIControlEvents.TouchUpInside)
        backgroundView.addSubview(confirmButton)
    }
    
    func confirmButtonClk(){
        
        closeButtonClk()

        
        /*
        if self.delegate.respondsToSelector("saveTimeLog:"){
            
            
            let time = getTimeLog()
            self.delegate.saveTimeLog(time)
            
            closeButtonClk()
        }
        */
    }
    
    
    func addPickerViews(){
        
        hourPicker = UIPickerView(frame: CGRectMake(22.5*ratio, 44*ratio, 62*ratio, 162*ratio))
        hourPicker.delegate = self
        backgroundView.addSubview(hourPicker)
        
        let hourLabel = UILabel(frame: CGRectMake(65*ratio, 118*ratio, 60*ratio, 12*ratio))
        hourLabel.text = "시"
        hourLabel.textColor = UIColor.todaitGray()
        hourLabel.textAlignment = NSTextAlignment.Center
        hourLabel.font = UIFont(name: "AppleSDGothicNeo-Light", size: 10*ratio)
        backgroundView.addSubview(hourLabel)
        
        minutePicker = UIPickerView(frame:CGRectMake(115*ratio, 44*ratio, 62*ratio, 162*ratio))
        minutePicker.delegate = self
        backgroundView.addSubview(minutePicker)
        
        let minuteLabel = UILabel(frame: CGRectMake(171*ratio, 118*ratio, 60*ratio, 12*ratio))
        minuteLabel.text = "분"
        minuteLabel.textAlignment = NSTextAlignment.Center
        minuteLabel.textColor = UIColor.todaitGray()
        minuteLabel.font = UIFont(name: "AppleSDGothicNeo-Light", size: 10*ratio)
        backgroundView.addSubview(minuteLabel)
        
        addPmLabel()
        addAmLabel()
        
    }
    
    func addPmLabel(){
        pmLabel = UILabel(frame: CGRectMake(232*ratio, 90*ratio, 60*ratio, 30*ratio))
        pmLabel.font = UIFont(name: "AppleSDGothicNeo-Ultralight", size: 26*ratio)
        pmLabel.text = "pm"
        pmLabel.textAlignment = NSTextAlignment.Left
        pmLabel.textColor = UIColor.todaitDarkGray()
        backgroundView.addSubview(pmLabel)
    }
    
    func addAmLabel(){
        amLabel = UILabel(frame: CGRectMake(232*ratio, 124*ratio, 60*ratio, 30*ratio))
        amLabel.font = UIFont(name: "AppleSDGothicNeo-Ultralight", size: 26*ratio)
        amLabel.text = "am"
        amLabel.textAlignment = NSTextAlignment.Left
        amLabel.textColor = UIColor.todaitLightGray()
        backgroundView.addSubview(amLabel)
    }
    
    func addRepeatButton(){
        
        repeatButton = UIButton(frame: CGRectMake(0, 220*ratio, 183*ratio, 55*ratio))
        repeatButton.backgroundColor = UIColor.todaitLightGray()
        backgroundView.addSubview(repeatButton)
        
    }
    
    func addAlarmButton(){
        
        alarmButton = UIButton(frame: CGRectMake(183*ratio,220*ratio, 112*ratio, 55*ratio))
        alarmButton.addTarget(self, action: Selector("alarmButtonClk"), forControlEvents: UIControlEvents.TouchDown)
        backgroundView.addSubview(alarmButton)
        
        
        let alarmInfoLabel = UILabel(frame: CGRectMake(10*ratio, 9*ratio, 92*ratio, 10*ratio))
        alarmInfoLabel.textColor = UIColor.whiteColor()
        alarmInfoLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 10*ratio)
        alarmInfoLabel.text = "알람"
        alarmInfoLabel.textAlignment = NSTextAlignment.Center
        alarmButton.addSubview(alarmInfoLabel)
        
        
        alarmLabel = UILabel(frame: CGRectMake(10*ratio, 26*ratio, 92*ratio, 25*ratio))
        alarmLabel.textColor = UIColor.whiteColor()
        alarmLabel.font = UIFont(name: "AppleSDGothicNeo-Light", size: 22.5*ratio)
        alarmLabel.text = "OFF"
        alarmLabel.textAlignment = NSTextAlignment.Center
        alarmButton.addSubview(alarmLabel)
        
    }
    
    func alarmButtonClk(){
        
        if isAlarmOn == true {
            isAlarmOn = false
        }else{
            isAlarmOn = true
        }
        
        setAlarmOn(isAlarmOn)
        
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
        
        
        var background = UIView(frame: CGRectMake(0, 0, 60*ratio, 52.5*ratio))
        
        var parastyle = NSMutableParagraphStyle()
        parastyle.alignment = NSTextAlignment.Center
        
        var font:UIFont! = UIFont(name: "AppleSDGothicNeo-Ultralight", size: 32*ratio)
        
        var attributes = [NSFontAttributeName:font , NSForegroundColorAttributeName:UIColor.todaitDarkGray(),NSParagraphStyleAttributeName:parastyle]
        
        var attributeString = NSMutableAttributedString(string:"\(row)", attributes:attributes)
        var label = UILabel(frame: CGRectMake(0, 8*ratio, 60*ratio, 40*ratio))
        label.attributedText = attributeString
        background.addSubview(label)
        
        return background
    }
    
    func setPickerDate(date:NSDate){
        
        var comp = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitHour|NSCalendarUnit.CalendarUnitMinute, fromDate: date)
        
        
        hourPicker.selectRow(comp.hour, inComponent: 0, animated: true)
        minutePicker.selectRow(comp.minute, inComponent: 0, animated: true)
        
        setAmPmLabelColor(comp.hour)
        
    }
    
    func setAlarmOn(alarm:Bool){
        
        if alarm == true {
            alarmLabel.text = "ON"
            alarmButton.setBackgroundImage(UIImage.colorImage(UIColor.todaitGreen(), frame: CGRectMake(0, 0, 111*ratio, 54*ratio)), forState: UIControlState.Normal)
            alarmButton.setBackgroundImage(UIImage.colorImage(UIColor.todaitGray(), frame: CGRectMake(0, 0, 111*ratio, 54*ratio)), forState: UIControlState.Highlighted)
            
        }else{
            alarmLabel.text = "OFF"
            alarmButton.setBackgroundImage(UIImage.colorImage(UIColor.todaitGray(), frame: CGRectMake(0, 0, 111*ratio, 54*ratio)), forState: UIControlState.Normal)
            alarmButton.setBackgroundImage(UIImage.colorImage(UIColor.todaitGreen(), frame: CGRectMake(0, 0, 111*ratio, 54*ratio)), forState: UIControlState.Highlighted)
        }
        
    }
    
    func setAmPmLabelColor(hour:Int){
        
        if hour < 13 {
            amLabel.textColor = UIColor.todaitDarkGray()
            pmLabel.textColor = UIColor.todaitLightGray()
        }else{
            pmLabel.textColor = UIColor.todaitDarkGray()
            amLabel.textColor = UIColor.todaitLightGray()
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == hourPicker {
            
            setAmPmLabelColor(row)
            
        }
        
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == hourPicker {
            return 24
        }else if pickerView == minutePicker {
            return 60
        }
        
        return 0
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 52.5*ratio
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
       
        let touch: AnyObject? = (touches as NSSet).anyObject()
        let touchPoint:CGPoint! = touch?.locationInView(view)
        
        if touchPoint.y < height - 325*ratio {
            closeButtonClk()
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        todaitNavBar.hidden = true
        
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut , animations: { () -> Void in
            self.backgroundView.transform = CGAffineTransformMakeTranslation(0, -325*self.ratio)
            
            }) { (Bool) -> Void in
                
        }
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
}