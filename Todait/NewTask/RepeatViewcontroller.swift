//
//  RepeatViewcontroller.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 24..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

protocol RepeatViewDelegate:NSObjectProtocol{
    
}

class RepeatViewcontroller: BasicViewController {
   
    
    var mainColor:UIColor!
    var count:Int! = 0
    var delegate:RepeatViewDelegate!
    
    private var blurEffectView:UIVisualEffectView!
    private var infoLabel:UILabel!
    private var doneButton:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clearColor()
        
        setupBlurBackground()
        addInfoLabel()
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
        infoLabel.text = "반복 횟수"
        infoLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 30*ratio)
        infoLabel.textColor = mainColor
        infoLabel.textAlignment = NSTextAlignment.Center
        view.addSubview(infoLabel)
        
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
        
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        todaitNavBar.hidden = true

        
    }

    
}
