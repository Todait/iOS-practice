//
//  SelectTaskViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 8. 4..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

protocol SelectTaskDelegate : NSObjectProtocol {
    
    func showTimerVC()
    func showTaskVC()
    
}


class SelectTaskViewController: BasicViewController {
   
    var filterView: UIImageView!
    var timerButton:UIButton!
    var taskButton:UIButton!
    var closeButton:UIButton!
    
    var delegate:SelectTaskDelegate?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        addFilterView()
        
        addTimerButton()
        addTaskButton()
        addCloseButton()
        
    }
    
    
    func addFilterView(){
        
        filterView = UIImageView(frame: view.frame)
        filterView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        view.addSubview(filterView)
        
    }
    
    func addTimerButton(){
        timerButton = UIButton(frame: CGRectMake(130*ratio, height - 200*ratio, 60*ratio, 60*ratio))
        timerButton.setImage(UIImage(named: "bt_main_stopwatch@3x.png"), forState: UIControlState.Normal)
        timerButton.addTarget(self, action: Selector("timerButtonClk"), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(timerButton)
    }
    
    func timerButtonClk(){
        
        if let delegate = delegate {
            if delegate.respondsToSelector("showTimerVC"){
                
                self.dismissViewControllerAnimated(false, completion: { () -> Void in
                    delegate.showTimerVC()
                })
            }
        }
    }
    
    func addTaskButton(){
        taskButton = UIButton(frame: CGRectMake(130*ratio, height - 127*ratio, 60*ratio, 60*ratio))
        taskButton.setImage(UIImage(named: "bt_main_detailgoal@3x.png"), forState: UIControlState.Normal)
        taskButton.addTarget(self, action: Selector("taskButtonClk"), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(taskButton)
    }
    
    func taskButtonClk(){
        
        if let delegate = delegate {
            if delegate.respondsToSelector("showTaskVC"){
                self.dismissViewControllerAnimated(false, completion: { () -> Void in
                    delegate.showTaskVC()
                })
            }
        }
    }
    
    func addCloseButton(){
        closeButton = UIButton(frame: CGRectMake(141*ratio, height - 42.5*ratio, 38*ratio, 38*ratio))
        closeButton.setImage(UIImage(named: "ic_main_add_closed@3x.png"), forState: UIControlState.Normal)
        closeButton.addTarget(self, action: Selector("closeButtonClk"), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(closeButton)
    }
    
    func closeButtonClk(){
        self.dismissViewControllerAnimated(false, completion: { () -> Void in
            
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        todaitNavBar.hidden = true
        
    }
    
}
