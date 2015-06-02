//
//  TimerViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 2..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class TimerViewController: BasicViewController,TodaitNavigationDelegate {
    
    
    var timer : NSTimer!
    var backgroundImageView : UIImageView!
    var backgroundImage : UIImage!
    
    var mainTimerLabel : UILabel!
    var subTimerLabel : UILabel!
    var contentsLabel : UILabel!
    var timerButton : UIButton!
    
    
    var currentTime : NSTimeInterval! = 0
    var totalTime : NSTimeInterval! = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        setupBackgroundImage()
        addBackgroundImageView()
        addMainTimerLabel()
        addSubTimerLabel()
        addTimerButton()
        
        setupTimer()
        startTimer()
    }
    
    func setupBackgroundImage(){
        backgroundImage = UIImage(named:"track.jpg")
    }
    
    func addBackgroundImageView(){
        backgroundImageView = UIImageView(frame: view.frame)
        backgroundImageView.image = backgroundImage
        view.addSubview(backgroundImageView)
        
        addFilterImageView(backgroundImageView, alpha: 0.5)
    }
    
    func addFilterImageView(imageView:UIImageView,alpha:CGFloat){
        
        let filterView : UIImageView = UIImageView(frame: CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height))
        filterView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        imageView.addSubview(filterView)
    }
    
    func addMainTimerLabel(){
        mainTimerLabel = UILabel(frame:CGRectMake(0, 0,260*ratio, 100*ratio))
        mainTimerLabel.font = UIFont(name: "AvenirNext-Regular", size: 50*ratio)
        mainTimerLabel.text = "00:00:00"
        mainTimerLabel.textColor = UIColor.whiteColor()
        mainTimerLabel.textAlignment = NSTextAlignment.Center
        mainTimerLabel.sizeToFit()
        mainTimerLabel.center = view.center
        view.addSubview(mainTimerLabel)
        
    }
    
    func addSubTimerLabel(){
        subTimerLabel = UILabel(frame: CGRectMake(0,0,200*ratio, 30*ratio))
        subTimerLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        subTimerLabel.font = UIFont(name: "AvenirNext-Regular", size: 20*ratio)
        subTimerLabel.text = "00:00:00"
        subTimerLabel.textColor = UIColor.whiteColor()
        subTimerLabel.textAlignment = NSTextAlignment.Right
        view.addSubview(subTimerLabel)
        
        
        var subTopConstraint = NSLayoutConstraint(item: subTimerLabel, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: mainTimerLabel, attribute: NSLayoutAttribute.Top, multiplier: ratio, constant: -5)
        view.addConstraint(subTopConstraint)
        
        
        var subRightConstraint = NSLayoutConstraint(item: subTimerLabel, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: mainTimerLabel, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0)
        view.addConstraint(subRightConstraint)
        
    }
    
    func addTimerButton(){
        timerButton = UIButton(frame: CGRectMake(0, 0, 100*ratio, 100*ratio))
        timerButton.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.25)
        timerButton.clipsToBounds = true
        timerButton.layer.cornerRadius = 10*ratio
        timerButton.addTarget(self, action: Selector("timerButtonClk"), forControlEvents: UIControlEvents.TouchUpInside)
        timerButton.center = view.center
        view.addSubview(timerButton)
    }
    
    func timerButtonClk(){
        if timer.valid {
            stopTimer()
        }else{
            startTimer()
        }
    }
    
    func setupTimer(){
        currentTime = 0
        totalTime = 0
    }
    
    func startTimer(){
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("countDown"), userInfo: nil, repeats: true)
        countDown()
    }
    
    func countDown(){
        
        currentTime = currentTime + 1
        totalTime = totalTime + 1
        
        updateTimeLabel()
        
    }
    
    func stopTimer(){
        timer.invalidate()
    }
    
    func updateTimeLabel(){
        
        mainTimerLabel.text = getTimeStringFromSeconds(currentTime)
        subTimerLabel.text = getTimeStringFromSeconds(totalTime)
    }
    
    func getTimeStringFromSeconds(seconds : NSTimeInterval ) -> String {
        
        let hour : Int = Int(seconds / 3600)
        let minute : Int = Int((seconds % 3600 ) / 60)
        let second : Int = Int((seconds % 3600 ) % 60)
        
        return String(format:  "%02lu:%02lu:%02lu", arguments: [hour,minute,second])
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        todaitNavBar.todaitDelegate = self
        todaitNavBar.backButton.hidden = false
        
        self.titleLabel.text = "타이머"
        
        todaitNavBar.setBackgroundImage(UIImage.colorImage(UIColor.clearColor(),frame:todaitNavBar.frame), forBarMetrics: UIBarMetrics.Default)
        todaitNavBar.shadowImage = UIImage()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func backButtonClk() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
