//
//  TimeLogViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 29..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

protocol AmountLogDelegate : NSObjectProtocol {
    func saveAmountLog(amount:Int)
}

class AmountViewController: BasicViewController,UIPickerViewDataSource,UIPickerViewDelegate{
    
    var filterView:UIImageView!
    var resetView:UIView!
    var resetButton:UIButton!
    
    var cancelButton:UIButton!
    var confirmButton:UIButton!
    var delegate:AmountLogDelegate!
    
    var startPicker:UIPickerView!
    var endPicker:UIPickerView!
    var donePicker:UIPickerView!
    
    
    var taskType:String! = ""
    var unit:String! = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addFilterView()
        addResetView()
        addInfoView()
        
        addCancelButton()
        addConfirmButton()
        
        
        addPickerViews()
        
        
        
    }
    
    func addFilterView(){
        
        filterView = UIImageView(frame: view.frame)
        filterView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        view.addSubview(filterView)
        
    }
    
    func addResetView(){
        
        resetView = UIView(frame: CGRectMake(13.5*ratio, height, 294*ratio,275*ratio))
        resetView.backgroundColor = UIColor.clearColor()
        view.addSubview(resetView)
        
        
    }
    
    func addInfoView(){
        
        let grayView = UIView(frame: CGRectMake(0, 0, 294*ratio,33*ratio))
        grayView.backgroundColor = UIColor.colorWithHexString("#949494")
        resetView.addSubview(grayView)
        
        let infoLabel = UILabel(frame: CGRectMake(13*ratio, 0, 200*ratio, 33*ratio))
        infoLabel.textAlignment = NSTextAlignment.Left
        infoLabel.textColor = UIColor.whiteColor()
        infoLabel.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 12.5*ratio)
        infoLabel.text = "공부한 양을 입력해주세요"
        resetView.addSubview(infoLabel)
        
        
        let whiteView = UIView(frame: CGRectMake(0, 33*ratio, 294*ratio, 192*ratio))
        whiteView.backgroundColor = UIColor.whiteColor()
        resetView.addSubview(whiteView)
        
        
        
        
        
        
    }
    
    
    func closeButtonClk(){
        
        UIView.animateWithDuration(0.4, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            self.resetView.transform = CGAffineTransformMakeTranslation(0, 0)
            }, completion: { (Bool) -> Void in
                
                self.dismissViewControllerAnimated(false, completion: { () -> Void in
                    
                })
        })
    }
    
    
    func resetButtonClk(){
        
    }
    
    func getTimeLog()->NSTimeInterval{
        
        //var hour = hourPicker.selectedRowInComponent(0) * 3600
        //var minute = minutePicker.selectedRowInComponent(0) * 60
        //var second = secondPicker.selectedRowInComponent(0)
        return NSTimeInterval(1) //hour + minute + second)
    
    }
    
    
    func addCancelButton(){
        confirmButton = UIButton(frame: CGRectMake(0, 232*ratio, 147*ratio, 43*ratio))
        confirmButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        confirmButton.setTitle("취소", forState: UIControlState.Normal)
        confirmButton.setBackgroundImage(UIImage.colorImage(UIColor.todaitLightGray(), frame: CGRectMake(0, 0, 294*ratio, 43*ratio)), forState: UIControlState.Normal)
        confirmButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo", size: 15*ratio)
        confirmButton.addTarget(self, action: Selector("closeButtonClk"), forControlEvents: UIControlEvents.TouchUpInside)
        resetView.addSubview(confirmButton)
    }
    
    
    
    func addConfirmButton(){
        confirmButton = UIButton(frame: CGRectMake(147*ratio, 232*ratio, 147*ratio, 43*ratio))
        confirmButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        confirmButton.setTitle("확인", forState: UIControlState.Normal)
        confirmButton.setBackgroundImage(UIImage.colorImage(UIColor.todaitGreen(), frame: CGRectMake(0, 0, 294*ratio, 43*ratio)), forState: UIControlState.Normal)
        confirmButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo", size: 15*ratio)
        confirmButton.addTarget(self, action: Selector("confirmButtonClk"), forControlEvents: UIControlEvents.TouchUpInside)
        resetView.addSubview(confirmButton)
    }
    
    func confirmButtonClk(){
        
        if self.delegate.respondsToSelector("saveAmountLog:"){
            
            
            let time = getAmountLog()
            self.delegate.saveAmountLog(time)
            
            closeButtonClk()
        }
    }
    
    func getAmountLog()->Int{
        
        //var hour = hourPicker.selectedRowInComponent(0) * 3600
        //var minute = minutePicker.selectedRowInComponent(0) * 60
        //var second = secondPicker.selectedRowInComponent(0)
        
        
        return donePicker.selectedRowInComponent(0)
    }
    
    
    func addPickerViews(){
        
        if taskType == "timer" {
            addRangePickerViews()
        }else{
            addDonePickerViews()
        }
        
    }
    
    func addRangePickerViews(){
        
        startPicker = UIPickerView(frame: CGRectMake(35*ratio, 48*ratio, 62*ratio, 162*ratio))
        startPicker.delegate = self
        startPicker.selectRow(1, inComponent: 0, animated: false)
        resetView.addSubview(startPicker)
        
        
        let rangeView = UIView(frame: CGRectMake(124*ratio, 120*ratio, 9*ratio, 2*ratio))
        rangeView.backgroundColor = UIColor.todaitGray()
        resetView.addSubview(rangeView)
        
        
        endPicker = UIPickerView(frame:CGRectMake(156*ratio, 48*ratio, 62*ratio, 162*ratio))
        endPicker.delegate = self
        endPicker.selectRow(1, inComponent: 0, animated: false)
        resetView.addSubview(endPicker)
        
        
        let unitLabel = UILabel(frame: CGRectMake(240*ratio, 121*ratio, 62*ratio, 12*ratio))
        unitLabel.text = unit
        unitLabel.textColor = UIColor.todaitGray()
        unitLabel.textAlignment = NSTextAlignment.Left
        unitLabel.font = UIFont(name: "AppleSDGothicNeo-Light", size: 10*ratio)
        resetView.addSubview(unitLabel)
        
    }

    func addDonePickerViews(){
        
        
        donePicker = UIPickerView(frame: CGRectMake(89*ratio, 48*ratio, 62*ratio, 162*ratio))
        donePicker.delegate = self
        donePicker.selectRow(1, inComponent: 0, animated: false)
        resetView.addSubview(donePicker)
        let unitLabel = UILabel(frame: CGRectMake(185*ratio, 121*ratio, 62*ratio, 12*ratio))
        unitLabel.text = unit
        unitLabel.textColor = UIColor.todaitGray()
        unitLabel.textAlignment = NSTextAlignment.Left
        unitLabel.font = UIFont(name: "AppleSDGothicNeo-Light", size: 10*ratio)
        resetView.addSubview(unitLabel)
        
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
        
        
        if taskType == "timer" {
            if pickerView == startPicker {
                return 24
            }else if pickerView == endPicker {
                return 60
            }
        }else{
            if pickerView == donePicker {
                return 1000
            }
        }
        
        
        return 0
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 54*ratio
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        closeButtonClk()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        todaitNavBar.hidden = true
        
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut , animations: { () -> Void in
            self.resetView.transform = CGAffineTransformMakeTranslation(0, -275*self.ratio)
            
            }) { (Bool) -> Void in
                
        }
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
}