//
//  BasicViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 1..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class BasicViewController: UIViewController,UIGestureRecognizerDelegate {
    
    let defaults : NSUserDefaults! = NSUserDefaults.standardUserDefaults()
    let navigationHeight : CGFloat = 64.0
    
    var todaitNavBar : TodaitNavigationBar!
    var titleLabel : UILabel!
    var ratio : CGFloat!
    var width : CGFloat!
    var height : CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ratio = view.frame.size.width/320
        width = view.frame.size.width
        height = view.frame.size.height
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //__weak id weakSelf = self;
        //self.navigationController?.interactivePopGestureRecognizer.delegate = self
        self.navigationController?.interactivePopGestureRecognizer.delegate = self
        styleNavBar()
        addTitleLabel()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func styleNavBar(){
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        todaitNavBar = TodaitNavigationBar(frame: CGRectMake(0, 0, width, navigationHeight*ratio))
        view.addSubview(todaitNavBar)
    }
    
    func addTitleLabel(){
        titleLabel = UILabel(frame: CGRectMake(30*ratio, 30.5*ratio, 260*ratio, 24*ratio))
        titleLabel.font = UIFont(name: "AvenirNext-Medium", size: 20*ratio)
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textAlignment = NSTextAlignment.Center
        view.addSubview(titleLabel)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
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
