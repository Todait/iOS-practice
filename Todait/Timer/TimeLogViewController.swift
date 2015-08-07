//
//  TimeLogViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 29..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

protocol TimeLogDelegate : NSObjectProtocol {
    func recordTimeLog(time:NSTimeInterval)
}

class TimeLogViewController: BasicViewController,UIPickerViewDataSource,UIPickerViewDelegate{
    
    var filterView:UIImageView!
    var backgroundView:UIView!
    var confirmButton:UIButton!
    var delegate:TimeLogDelegate!
    
    var hourPicker:UIPickerView!
    var minutePicker:UIPickerView!
    var secondPicker:UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addFilterView()
        addbackgroundView()
        addInfoView()
        addconfirmButton()
        
        
        addPickerViews()
        
    }
    
    func addFilterView(){
        
        filterView = UIImageView(frame: view.frame)
        filterView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        view.addSubview(filterView)
        
    }
    
    func addbackgroundView(){
        
        backgroundView = UIView(frame: CGRectMake(13.5*ratio, height, 294*ratio,275*ratio))
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
        infoLabel.text = "공부한 시간을 입력해주세요"
        backgroundView.addSubview(infoLabel)
        
        
        let whiteView = UIView(frame: CGRectMake(0, 33*ratio, 294*ratio, 191*ratio))
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
    
    
    
    func getTimeLog()->NSTimeInterval{
        
        var hour = hourPicker.selectedRowInComponent(0) * 3600
        var minute = minutePicker.selectedRowInComponent(0) * 60
        var second = secondPicker.selectedRowInComponent(0)
        
        return NSTimeInterval(hour + minute + second)
    }
    
    
    func addconfirmButton(){
        confirmButton = UIButton(frame: CGRectMake(0, 232*ratio, 294*ratio, 43*ratio))
        confirmButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        confirmButton.setTitle("확인", forState: UIControlState.Normal)
        confirmButton.setBackgroundImage(UIImage.colorImage(UIColor.todaitGreen(), frame: CGRectMake(0, 0, 294*ratio, 43*ratio)), forState: UIControlState.Normal)
        confirmButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo", size: 15*ratio)
        confirmButton.addTarget(self, action: Selector("confirmButtonClk"), forControlEvents: UIControlEvents.TouchUpInside)
        backgroundView.addSubview(confirmButton)
    }
    
    func confirmButtonClk(){
        if self.delegate.respondsToSelector("recordTimeLog:"){
            
            
            let time = getTimeLog()
            self.delegate.recordTimeLog(time)
            
            closeButtonClk()
        }
    }
    
    
    func addPickerViews(){
        
        hourPicker = UIPickerView(frame: CGRectMake(22.5*ratio, 33*ratio, 62*ratio, 160*ratio))
        hourPicker.delegate = self
        backgroundView.addSubview(hourPicker)
        
        let hourLabel = UILabel(frame: CGRectMake(22.5*ratio, 195*ratio, 62*ratio, 12*ratio))
        hourLabel.text = "시간"
        hourLabel.textColor = UIColor.todaitGray()
        hourLabel.textAlignment = NSTextAlignment.Center
        hourLabel.font = UIFont(name: "AppleSDGothicNeo-Light", size: 10*ratio)
        backgroundView.addSubview(hourLabel)
        
        minutePicker = UIPickerView(frame:CGRectMake(115*ratio, 33*ratio, 62*ratio, 160*ratio))
        minutePicker.delegate = self
        backgroundView.addSubview(minutePicker)
        
        let minuteLabel = UILabel(frame: CGRectMake(115*ratio, 195*ratio, 62*ratio, 12*ratio))
        minuteLabel.text = "분"
        minuteLabel.textAlignment = NSTextAlignment.Center
        minuteLabel.textColor = UIColor.todaitGray()
        minuteLabel.font = UIFont(name: "AppleSDGothicNeo-Light", size: 10*ratio)
        backgroundView.addSubview(minuteLabel)
        
        
        secondPicker = UIPickerView(frame:CGRectMake(207*ratio, 33*ratio, 62*ratio, 160*ratio))
        secondPicker.delegate = self
        backgroundView.addSubview(secondPicker)
        
        let secondLabel = UILabel(frame: CGRectMake(207*ratio, 195*ratio, 62*ratio, 12*ratio))
        secondLabel.text = "초"
        secondLabel.textAlignment = NSTextAlignment.Center
        secondLabel.textColor = UIColor.todaitGray()
        secondLabel.font = UIFont(name: "AppleSDGothicNeo-Light", size: 10*ratio)
        backgroundView.addSubview(secondLabel)
        
        
        
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
        
        
        var background = UIView(frame: CGRectMake(0, 0, 60*ratio, 52.5*ratio))
        
        
        var parastyle = NSMutableParagraphStyle()
        parastyle.alignment = NSTextAlignment.Center
        
        var font:UIFont! = UIFont(name: "AppleSDGothicNeo-Ultralight", size: 32*ratio)
        
        var attributes = [NSFontAttributeName:font , NSForegroundColorAttributeName:UIColor.todaitGray(),NSParagraphStyleAttributeName:parastyle]
        
        var attributeString = NSMutableAttributedString(string:"\(row)", attributes:attributes)
        
        
        var label = UILabel(frame: CGRectMake(0, 8*ratio, 60*ratio, 40*ratio))
        label.attributedText = attributeString
        background.addSubview(label)
        
        return background
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == hourPicker {
            return 24
        }else if pickerView == minutePicker {
            return 60
        }else if pickerView == secondPicker {
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
        
        if touchPoint.y < height - 275*ratio {
            closeButtonClk()
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        todaitNavBar.hidden = true
        
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut , animations: { () -> Void in
            self.backgroundView.transform = CGAffineTransformMakeTranslation(0, -275*self.ratio)
            
            }) { (Bool) -> Void in
                
        }
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
}