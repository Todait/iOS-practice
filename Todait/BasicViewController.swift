//
//  BasicViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 1..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit



@IBDesignable class BasicViewController: GAITrackedViewController,UIGestureRecognizerDelegate {
    
    let defaults : NSUserDefaults! = NSUserDefaults.standardUserDefaults()
    let navigationHeight : CGFloat = 64.0
    
    @IBInspectable var todaitNavBar : TodaitNavigationBar! {
        didSet {
            
            if let check = todaitNavBar{
                return
            }
            
            self.navigationController?.setNavigationBarHidden(true, animated: false)
            todaitNavBar = TodaitNavigationBar(frame: CGRectMake(0, 0, width, navigationHeight))
            view.addSubview(todaitNavBar)
        }
    }
    
    @IBInspectable var navBarColor : UIColor! = UIColor.todaitGreen() {
        
        didSet {
            todaitNavBar.setBackgroundImage(UIImage.colorImage(navBarColor,frame:CGRectMake(0,0,width,64)), forBarMetrics: UIBarMetrics.Default)
        }
        
    }
    
    var titleLabel : UILabel!
    var ratio : CGFloat!
    var width : CGFloat!
    var height : CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScreen()
    
    }
    
    func setupScreen(){
        let screenRect = UIScreen.mainScreen().bounds
        let screenWidth = screenRect.size.width
        ratio = screenWidth/320
        width = screenWidth
        height = screenRect.size.height
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //__weak id weakSelf = self;
        self.navigationController?.interactivePopGestureRecognizer.delegate = self
        styleNavBar()
        addTitleLabel()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func setNavigationBarColor(color:UIColor){
        
        todaitNavBar.setBackgroundImage(UIImage.colorImage(color,frame:CGRectMake(0,0,width,navigationHeight)), forBarMetrics: UIBarMetrics.Default)
    }
    
    func styleNavBar(){
        
        if let check = todaitNavBar{
            return
        }
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        todaitNavBar = TodaitNavigationBar(frame: CGRectMake(0, 0, width, navigationHeight))
        view.addSubview(todaitNavBar)
    }
    
    func addTitleLabel(){
        
        if let check = titleLabel{
            return
        }
        
        
        titleLabel = UILabel(frame: CGRectMake(30*ratio, 32, 260*ratio, 24))
        titleLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 18)
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textAlignment = NSTextAlignment.Center
        view.addSubview(titleLabel)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
