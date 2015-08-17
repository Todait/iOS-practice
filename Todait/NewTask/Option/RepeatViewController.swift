//
//  RereadViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 8. 5..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class RereadViewController: BasicViewController,UIPickerViewDataSource,UIPickerViewDelegate{
    
    var filterView:UIImageView!
    var popupView:UIView!
    
    var confirmButton:UIButton!
    
    var delegate:CountDelegate!
    
    var countPicker:UIPickerView!
    
    
    var taskType:String! = ""
    var unit:String! = ""
    var count:Int! = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addFilterView()
        addResetView()
        addInfoView()
        
        addConfirmButton()
        addPickerViews()
        
        
        
    }
    
    func addFilterView(){
        
        filterView = UIImageView(frame: view.frame)
        filterView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        view.addSubview(filterView)
        
    }
    
    func addResetView(){
        
        popupView = UIView(frame: CGRectMake(13.5*ratio, height, 294*ratio,275*ratio))
        popupView.backgroundColor = UIColor.clearColor()
        view.addSubview(popupView)
        
        
    }
    
    func addInfoView(){
        
        let grayView = UIView(frame: CGRectMake(0, 0, 294*ratio,33*ratio))
        grayView.backgroundColor = UIColor.colorWithHexString("#949494")
        popupView.addSubview(grayView)
        
        let infoLabel = UILabel(frame: CGRectMake(13*ratio, 0, 200*ratio, 33*ratio))
        infoLabel.textAlignment = NSTextAlignment.Left
        infoLabel.textColor = UIColor.whiteColor()
        infoLabel.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 12.5*ratio)
        infoLabel.text = "회독"
        popupView.addSubview(infoLabel)
        
        
        let whiteView = UIView(frame: CGRectMake(0, 33*ratio, 294*ratio, 192*ratio))
        whiteView.backgroundColor = UIColor.whiteColor()
        popupView.addSubview(whiteView)
        
        
        
        
        
        
    }
    
    
    func closeButtonClk(){
        
        UIView.animateWithDuration(0.4, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            self.popupView.transform = CGAffineTransformMakeTranslation(0, 0)
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
    
    
    
    func addConfirmButton(){
        confirmButton = UIButton(frame: CGRectMake(0*ratio, 232*ratio, 294*ratio, 43*ratio))
        confirmButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        confirmButton.setTitle("확인", forState: UIControlState.Normal)
        confirmButton.setBackgroundImage(UIImage.colorImage(UIColor.todaitGreen(), frame: CGRectMake(0, 0, 294*ratio, 43*ratio)), forState: UIControlState.Normal)
        confirmButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo", size: 15*ratio)
        confirmButton.addTarget(self, action: Selector("confirmButtonClk"), forControlEvents: UIControlEvents.TouchUpInside)
        popupView.addSubview(confirmButton)
    }
    
    func confirmButtonClk(){
        
        if self.delegate.respondsToSelector("count:"){
            
            
            self.delegate.count(getCount())
            
            closeButtonClk()
        }
    }
    
    func getCount()->Int{
        
        //var hour = hourPicker.selectedRowInComponent(0) * 3600
        //var minute = minutePicker.selectedRowInComponent(0) * 60
        //var second = secondPicker.selectedRowInComponent(0)
        
        
        return countPicker.selectedRowInComponent(0)
    }
    
    
    func addPickerViews(){
        
        addCountPickerView()
    }
    
    func addCountPickerView(){
        
        
        countPicker = UIPickerView(frame: CGRectMake(89*ratio, 48*ratio, 62*ratio, 162*ratio))
        countPicker.delegate = self
        countPicker.selectRow(count, inComponent: 0, animated: false)
        popupView.addSubview(countPicker)
        
        let unitLabel = UILabel(frame: CGRectMake(185*ratio, 121*ratio, 62*ratio, 12*ratio))
        unitLabel.text = "회독"
        unitLabel.textColor = UIColor.todaitGray()
        unitLabel.textAlignment = NSTextAlignment.Left
        unitLabel.font = UIFont(name: "AppleSDGothicNeo-Light", size: 10*ratio)
        popupView.addSubview(unitLabel)
        
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
        
        if pickerView == countPicker {
            return 100
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
            self.popupView.transform = CGAffineTransformMakeTranslation(0, -275*self.ratio)
            
            }) { (Bool) -> Void in
                
        }
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
}