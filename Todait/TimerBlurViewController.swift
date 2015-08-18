//
//  FinishTimeViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 4..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

protocol settingTimeDelegate:NSObjectProtocol {
    func settingTime(date:NSDate)
}

class TimerBlurViewController: BasicViewController,TodaitNavigationDelegate {
    
    
    var datePicker: UIDatePicker!
    var doneButton: UIButton!
    var blurEffectView: UIVisualEffectView!
    var delegate:settingTimeDelegate?
    
    var timerDate: NSDate!
    
    var infoLabel: UILabel!
    var mainColor: UIColor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBlurBackground()
        
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
    
    func addInfoLabel(){
        infoLabel = UILabel(frame: CGRectMake(30*ratio,100*ratio, 260*ratio, 80*ratio))
        infoLabel.text = "시작 시간"
        infoLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 30*ratio)
        infoLabel.textColor = mainColor
        infoLabel.textAlignment = NSTextAlignment.Center
        view.addSubview(infoLabel)
        
    }
    
    func addDatePickerView(){
        datePicker = UIDatePicker(frame: CGRectMake(0, 0, width, 250*ratio))
        datePicker.center = view.center
        datePicker.datePickerMode = UIDatePickerMode.Time
        datePicker.date = timerDate
        view.addSubview(datePicker)
    }
    
    func addDoneButton(){
        doneButton = UIButton(frame: CGRectMake(0, height-50*ratio, width, 50*ratio))
        doneButton.setTitle("완료", forState: UIControlState.Normal)
        doneButton.setBackgroundImage(UIImage.colorImage(mainColor, frame: CGRectMake(0, 0, width, 50*ratio)), forState:UIControlState.Normal)
        doneButton.addTarget(self, action: Selector("doneButtonClk"), forControlEvents: UIControlEvents.TouchUpInside)
        doneButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 20*ratio)
        
        view.addSubview(doneButton)
    }
    
    func doneButtonClk(){
        
        timerDate = datePicker.date
        settingTime()
        
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
    
    func settingTime(){
        
        if let delegate = delegate {
            if delegate.respondsToSelector("settingTime:"){
                delegate.settingTime(timerDate)
            }
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
