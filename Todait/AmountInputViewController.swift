//
//  AmountInputViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 26..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class AmountInputViewController: BasicViewController,UIPickerViewDataSource,UIPickerViewDelegate{
   
    var filterView:UIImageView!
    var boxView:UIView!
    
    var pickerView:UIPickerView!
    var cancelButton:UIButton!
    var saveButton:UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clearColor()
        addFilterView()
        addBoxView()
        
    }
    
    func addFilterView(){
        
        filterView = UIImageView(frame: view.frame)
        filterView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        view.addSubview(filterView)
    }
    
    func addBoxView(){
        
        boxView = UIView(frame: CGRectMake(0, height, width, 275*ratio))
        boxView.backgroundColor = UIColor.clearColor()
        view.addSubview(boxView)
        
        addBackgroundView()
        addPickerView()
        addButtons()
    }
    
    func addBackgroundView(){
        
        var grayHeaderView = UIView(frame:CGRectMake(15*ratio, 0,290*ratio,35*ratio))
        grayHeaderView.backgroundColor = UIColor.todaitLightGray()
        boxView.addSubview(grayHeaderView)
        
        var whiteBodyView = UIView(frame: CGRectMake(15*ratio, 35*ratio, 290*ratio, 192*ratio))
        whiteBodyView.backgroundColor = UIColor.whiteColor()
        boxView.addSubview(whiteBodyView)
        
    }
    
    func addPickerView(){
        pickerView = UIPickerView(frame: CGRectMake(89*ratio, 35*ratio, 60*ratio, 157*ratio))
        pickerView.delegate = self
        pickerView.dataSource = self
        boxView.addSubview(pickerView)
        
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 50
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 55*ratio
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return "12"
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func addButtons(){
        cancelButton = UIButton(frame: CGRectMake(15*ratio,232*ratio, 145*ratio, 43*ratio))
        cancelButton.setTitle("취소", forState: UIControlState.Normal)
        cancelButton.setBackgroundImage(UIImage.colorImage(UIColor.todaitGray(), frame: CGRectMake(0, 0, 145*ratio, 43*ratio)), forState: UIControlState.Normal)
        cancelButton.setBackgroundImage(UIImage.colorImage(UIColor.todaitGray(), frame: CGRectMake(0, 0, 145*ratio, 43*ratio)), forState: UIControlState.Highlighted)
        boxView.addSubview(cancelButton)
        
        
        
        saveButton = UIButton(frame: CGRectMake(160*ratio,232*ratio, 145*ratio, 43*ratio))
        saveButton.setTitle("저장", forState: UIControlState.Normal)
        saveButton.setBackgroundImage(UIImage.colorImage(UIColor.todaitGreen(), frame: CGRectMake(0, 0, 145*ratio, 43*ratio)), forState: UIControlState.Normal)
        //saveButton.setBackgroundImage(UIImage.colorImage(UIColor.todaitGray(), frame: CGRectMake(0, 0, 145*ratio, 43*ratio), forState: UIControlState.Highlighted))
        boxView.addSubview(saveButton)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        todaitNavBar.hidden = true
        
        UIView.animateWithDuration(0.3, delay: 0, options:.CurveEaseInOut, animations: { () -> Void in
            self.boxView.transform = CGAffineTransformMakeTranslation(0, -275*self.ratio)
        }) { (Bool) -> Void in
            
        }
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)
        
        self.dismissViewControllerAnimated(false, completion: { () -> Void in
            
        })
        
    }
    
}
