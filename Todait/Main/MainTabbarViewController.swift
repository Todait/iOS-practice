//
//  MainTabbarViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 7. 6..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit
import CoreData

class MainTabbarViewController: BasicViewController,UITabBarDelegate{
    
    var viewControllers:[BasicViewController] = []
    var tabButtons:[MainTabbarButton] = []
    var tabbarView:UIView!
    
    var tabbarWidth:CGFloat! = 0
    
    var currentView:UIView!
    
    private var mainButton:MainTabbarButton!
    private var timeTableButton:MainTabbarButton!
    private var newTaskButton:MainTabbarButton!
    private var statisticsButton:MainTabbarButton!
    private var profileButton:MainTabbarButton!
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var isShowAllCategory:Bool = true
    var category:Category!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRatio()
        setupCurrentView()
        setupViewControllers()
        addTabbarView()
        setupButtons()
        addShadow()
    }
    
    func setupRatio(){
        tabbarWidth = 320*ratio/5
    }
    
    
    func setupCurrentView(){
        
        currentView = UIView(frame: view.frame)
        view.addSubview(currentView)
        
        
    }
    
    func setupViewControllers(){
        
        setupMainViewController()
        setupTimeTableViewController()
        setupStatisticsViewController()
        setupProfileViewController()
        
        
        
        let vc = viewControllers[0]
        vc.view.frame = view.frame
        currentView.addSubview(vc.view)
        
    }
    
    func setupMainViewController(){
        
        var mainVC = self.storyboard?.instantiateViewControllerWithIdentifier("mainVC") as! MainViewController
        
        addChildViewController(mainVC)
        
        viewControllers.append(mainVC)
    }
    
    func setupTimeTableViewController(){
        viewControllers.append(TimeTableViewController())
    }
    
    func setupStatisticsViewController(){
        viewControllers.append(StatisticsViewController())
    }
    
    func setupProfileViewController(){
        viewControllers.append(ProfileViewController())
    }
    
    func addTabbarView(){
        
        tabbarView = UIView(frame: CGRectMake(0, height - 49*ratio, 320*ratio, 49*ratio))
        tabbarView.backgroundColor = UIColor.whiteColor()
        view.addSubview(tabbarView)
        

    }
    
    func setupButtons(){
        
        addMainButton()
        addTimeTableButton()
        addNewTaskButton()
        addStatisticsButton()
        addProfileButton()
    }
    
    func addMainButton(){
        mainButton = MainTabbarButton(frame: CGRectMake(0, 0, tabbarWidth, 49*ratio))
      
        mainButton.normalImage = UIImage.maskColor("01_main_basic_gray@3x_03.png", color: UIColor.todaitDarkGray())
        mainButton.highlightImage = UIImage.maskColor("01_main_basic_gray@3x_03.png", color: UIColor.whiteColor())
        
        mainButton.buttonLabel.text = "메인"
        mainButton.setupSelected(true)
        
        mainButton.addTarget(self, action: Selector("tabbarClk:"), forControlEvents: UIControlEvents.TouchDown)
        
        tabbarView.addSubview(mainButton)
        tabButtons.append(mainButton)
    }
    
    func addTimeTableButton(){
        
        timeTableButton = MainTabbarButton(frame: CGRectMake(tabbarWidth, 0, tabbarWidth, 49*ratio))
        
        timeTableButton.normalImage = UIImage.maskColor("01_main_basic_gray@3x_05.png", color: UIColor.todaitDarkGray())
        timeTableButton.highlightImage = UIImage.maskColor("01_main_basic_gray@3x_05.png", color: UIColor.whiteColor())
        timeTableButton.setupSelected(false)
        timeTableButton.buttonLabel.text = "시간표"
        timeTableButton.addTarget(self, action: Selector("tabbarClk:"), forControlEvents: UIControlEvents.TouchDown)
        
        tabbarView.addSubview(timeTableButton)
        tabButtons.append(timeTableButton)
    }
    
    func addNewTaskButton(){
        newTaskButton = MainTabbarButton(frame: CGRectMake(tabbarWidth*2, 0, tabbarWidth, 49*ratio))
        
        newTaskButton.iconImageView.frame = CGRectMake((tabbarWidth-29*ratio)/2, 10*ratio, 29*ratio, 29*ratio)
        newTaskButton.iconImageView.image = UIImage(named: "01_main_basic_gray@3x_12.png")
        newTaskButton.addTarget(self, action: Selector("showNewTaskVC"), forControlEvents: UIControlEvents.TouchUpInside)
        
        tabbarView.addSubview(newTaskButton)
    }
    
    func showNewTaskVC(){
        
        performSegueWithIdentifier("ShowNewTaskView", sender: self)
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //let destination = segue.destinationViewController as! NewTaskViewController
        
        
        if segue.identifier == "ShowNewTaskView" {
            let newTaskVC = segue.destinationViewController as! NewTaskViewController
            //newTaskVC.delegate = self
            newTaskVC.mainColor = UIColor.todaitGreen()
            newTaskVC.category = getDefaultCategory()
            
            
            
            if isShowAllCategory == true {
                newTaskVC.mainColor = UIColor.todaitGreen()
                newTaskVC.category = getDefaultCategory()
            }else {
                newTaskVC.mainColor = UIColor.colorWithHexString(category.color)
                newTaskVC.category = category
            }
            
        }
    }

    func getDefaultCategory()->Category{
        
        let entityDescription = NSEntityDescription.entityForName("Category",inManagedObjectContext:managedObjectContext!)
        
        let request = NSFetchRequest()
        request.entity = entityDescription
        
        var error: NSError?
        let categorys:[Category] = managedObjectContext?.executeFetchRequest(request, error: &error) as! [Category]
        
        if categorys.count != 0 {
            category = categorys.first
        }
        
        return category
    }
    
    
    func addStatisticsButton(){
        statisticsButton = MainTabbarButton(frame: CGRectMake(tabbarWidth*3, 0, tabbarWidth, 49*ratio))
        
        statisticsButton.normalImage = UIImage.maskColor("01_main_basic_gray@3x_07.png", color: UIColor.todaitDarkGray())
        statisticsButton.highlightImage = UIImage.maskColor("01_main_basic_gray@3x_07.png", color: UIColor.whiteColor())
        statisticsButton.setupSelected(false)
        statisticsButton.buttonLabel.text = "통계"
        statisticsButton.addTarget(self, action: Selector("tabbarClk:"), forControlEvents: UIControlEvents.TouchDown)
        
        tabbarView.addSubview(statisticsButton)
        tabButtons.append(statisticsButton)
    }
    
    func addProfileButton(){
        profileButton = MainTabbarButton(frame: CGRectMake(tabbarWidth*4, 0, tabbarWidth, 49*ratio))
        
        profileButton.normalImage = UIImage.maskColor("01_main_basic_gray@3x_09.png", color: UIColor.todaitDarkGray())
        profileButton.highlightImage = UIImage.maskColor("01_main_basic_gray@3x_09.png", color: UIColor.whiteColor())
        profileButton.setupSelected(false)
        
        profileButton.buttonLabel.text = "마이페이지"
        profileButton.addTarget(self, action: Selector("tabbarClk:"), forControlEvents: UIControlEvents.TouchDown)
        
        tabbarView.addSubview(profileButton)
        
        tabButtons.append(profileButton)
    }
    
    func tabbarClk(tabButton:MainTabbarButton){
        
        
        for var index=0 ; index<4 ; index++ {
            
            var item:MainTabbarButton = tabButtons[index]
            
            if item == tabButton {
                item.setupSelected(true)
                
                
                for temp in currentView.subviews {
                    temp.removeFromSuperview()
                }
                
                
                
                let vc = viewControllers[index]
                vc.view.frame = view.frame
                currentView.addSubview(vc.view)
                
            }else{
                item.setupSelected(false)
            }
        }
    }
    
    func addShadow(){
        var line = UIView(frame: CGRectMake(0, 0, 320*ratio, 0.5*ratio))
        line.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        tabbarView.addSubview(line)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        todaitNavBar.hidden = true
        titleLabel.hidden = true
        
    }
    
}
