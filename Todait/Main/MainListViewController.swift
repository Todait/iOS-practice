//
//  MainListViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 7. 15..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit
import CoreData

class MainListViewController: BasicViewController,UITableViewDelegate,UITableViewDataSource{
    
    var listView:UIView!
    
    var studyView:UIView!
    var categoryView:UIView!
    var sortView:UIView!
    
    
    
    var studyButton:UIButton!
    var categoryButton:UIButton!
    var sortButton:UIButton!
    
    var categoryTableView:UITableView!
    
    var categoryData: [Category] = []
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        addShadowLayer()
        
        //view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.7)
        
        
        
        loadCategoryData()
        
        addStudyButton()
        addCategoryButton()
        addSortButton()
        addCategoryTableView()
        
    }
    
    func addShadowLayer(){
        
        let shadowLayer = CAGradientLayer()
        shadowLayer.colors = [UIColor.clearColor().CGColor,UIColor.blackColor().CGColor]
        shadowLayer.startPoint = CGPointMake(0, 0.5)
        shadowLayer.endPoint = CGPointMake(1.0, 0.5)
        shadowLayer.locations = [NSNumber(float: 0.5),NSNumber(float: 1.0)]
        shadowLayer.frame = view.frame
        
        self.view.layer.insertSublayer(shadowLayer, atIndex: 0)
        
    }
    
    func loadCategoryData(){
        
        let entityDescription = NSEntityDescription.entityForName("Category",inManagedObjectContext:managedObjectContext!)
        
        let request = NSFetchRequest()
        request.entity = entityDescription
        
        var error: NSError?
        
        categoryData = managedObjectContext?.executeFetchRequest(request, error: &error) as! [Category]
        
        NSLog("Category results %@",categoryData)
    }
    
    func addStudyButton(){
        
        studyView = UIView(frame: CGRectMake(330*ratio, 17.5*ratio, 100*ratio, 35*ratio))
        view.addSubview(studyView)
        
        
        let studyInfoLabel = UILabel(frame: CGRectMake(5*ratio, 0, 55*ratio, 35*ratio))
        studyInfoLabel.text = "공부방식"
        studyInfoLabel.textAlignment = NSTextAlignment.Left
        studyInfoLabel.textColor = UIColor.whiteColor()
        studyInfoLabel.font = UIFont(name: "AppleSDGothicNeo-Light", size: 12*ratio)
        
        studyView.addSubview(studyInfoLabel)
        
        studyButton = UIButton(frame: CGRectMake(52.5*ratio, 0*ratio, 35*ratio, 35*ratio))
        studyButton.setImage(UIImage(named: "category_goal@3x.png"), forState: UIControlState.Normal)
        studyButton.addTarget(self, action: Selector("studyButtonClk"), forControlEvents: UIControlEvents.TouchDown)
        studyView.addSubview(studyButton)
        
        
    }
    
    func studyButtonClk(){
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.categoryButton.alpha = 0
            self.sortButton.alpha = 0
            
        }) { (Bool) -> Void in
            
        }
        
    }
    
    func addCategoryButton(){
        
        categoryView = UIView(frame: CGRectMake(330*ratio, 73*ratio, 100*ratio, 35*ratio))
        view.addSubview(categoryView)
        
        
        let categoryInfoLabel = UILabel(frame: CGRectMake(5*ratio, 0, 55*ratio, 35*ratio))
        categoryInfoLabel.text = "카테고리"
        categoryInfoLabel.textAlignment = NSTextAlignment.Left
        categoryInfoLabel.textColor = UIColor.whiteColor()
        categoryInfoLabel.font = UIFont(name: "AppleSDGothicNeo-Light", size: 12*ratio)
        
        categoryView.addSubview(categoryInfoLabel)
        
        
        categoryButton = UIButton(frame: CGRectMake(52.5*ratio, 0*ratio, 35*ratio, 35*ratio))
        categoryButton.addTarget(self, action: Selector("categoryButtonClk"), forControlEvents: UIControlEvents.TouchDown)
        categoryButton.setImage(UIImage(named: "category_wt@3x.png"), forState: UIControlState.Normal)
        categoryView.addSubview(categoryButton)
    }
    
    func categoryButtonClk(){
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.studyButton.alpha = 0
            self.sortButton.alpha = 0
            self.categoryButton.transform = CGAffineTransformMakeTranslation(-50*self.ratio, -40*self.ratio)
            
            }) { (Bool) -> Void in
                
        }
        
    }
    
    func addSortButton(){
        
        sortView = UIView(frame: CGRectMake(330*ratio, 136*ratio, 100*ratio, 35*ratio))
        view.addSubview(sortView)
        
        
        let sortInfoLabel = UILabel(frame: CGRectMake(5*ratio, 0, 55*ratio, 35*ratio))
        sortInfoLabel.text = "정렬설정"
        sortInfoLabel.textAlignment = NSTextAlignment.Left
        sortInfoLabel.textColor = UIColor.whiteColor()
        sortInfoLabel.font = UIFont(name: "AppleSDGothicNeo-Light", size: 12*ratio)
        
        sortView.addSubview(sortInfoLabel)
        
        
        sortButton = UIButton(frame: CGRectMake(52.5*ratio, 0*ratio, 35*ratio, 35*ratio))
        sortButton.addTarget(self, action: Selector("sortButtonClk"), forControlEvents: UIControlEvents.TouchDown)
        sortButton.setImage(UIImage(named: "01_main_category_min@3x.png"), forState: UIControlState.Normal)
        sortView.addSubview(sortButton)
    }
    
    func sortButtonClk(){
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.studyButton.alpha = 0
            self.categoryButton.alpha = 0
            self.sortButton.transform = CGAffineTransformMakeTranslation(-50*self.ratio, -80*self.ratio)
            self.categoryTableView.transform = CGAffineTransformMakeTranslation(-50*self.ratio, 0)
            
            }) { (Bool) -> Void in
                
        }
    }
    
    func addCategoryTableView(){
        
        categoryTableView = UITableView(frame: CGRectMake(330*ratio,navigationHeight + 20*ratio ,width,height - navigationHeight - 49*ratio - 64 - 20*ratio), style: UITableViewStyle.Grouped)
        categoryTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        categoryTableView.contentInset = UIEdgeInsetsMake(-20*ratio, 0, 0, 0)
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        categoryTableView.contentOffset.y = 0
        categoryTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        categoryTableView.backgroundColor = UIColor.clearColor()
        
        view.addSubview(categoryTableView)
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryData.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 35*ratio
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        
        
        for view in cell.contentView.subviews{
            view.removeFromSuperview()
        }
        
        
        let category:Category = categoryData[indexPath.row]
        let categoryColor = UIColor.colorWithHexString(category.color)
        
        
        
        var categoryCircle = UIView(frame: CGRectMake(1*ratio, 1*ratio, 30*ratio, 30*ratio))
        categoryCircle.backgroundColor = categoryColor
        categoryCircle.clipsToBounds = true
        categoryCircle.layer.cornerRadius = 15*ratio
        cell.contentView.addSubview(categoryCircle)
        
        
        var titleLabel = UILabel(frame:CGRectMake(50*ratio, 9.5*ratio, 250*ratio, 30*ratio))
        titleLabel.text = category.name
        titleLabel.font = UIFont(name: "AvenirNext-Regular", size: 14*ratio)
        titleLabel.textAlignment = NSTextAlignment.Left
        titleLabel.textColor = UIColor.colorWithHexString("#969696")
        //cell.contentView.addSubview(titleLabel)
        
        cell.backgroundColor = UIColor.clearColor()
        cell.contentView.backgroundColor = UIColor.clearColor()
        
        return cell
        
    }
    
    func showListButtons(){
        UIView.animateWithDuration(0.6, animations: { () -> Void in
            
            self.studyView.transform = CGAffineTransformMakeTranslation(-100*self.ratio, 0)
            self.categoryView.transform = CGAffineTransformMakeTranslation(-100*self.ratio, 0)
            self.sortView.transform = CGAffineTransformMakeTranslation(-100*self.ratio, 0)
            
            }) { (Bool) -> Void in
                
        }
        
    }
    
    func hideListButtons(){
        UIView.animateWithDuration(1.2, animations: { () -> Void in
            
            self.studyView.transform = CGAffineTransformMakeTranslation(0*self.ratio, 0)
            self.categoryView.transform = CGAffineTransformMakeTranslation(0*self.ratio, 0)
            self.sortView.transform = CGAffineTransformMakeTranslation(0*self.ratio, 0)
            
            }) { (Bool) -> Void in
                
        }
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)
        
        UIView.animateWithDuration(1.2, animations: { () -> Void in
            
            self.studyButton.transform = CGAffineTransformMakeTranslation(0, self.studyButton.transform.ty)
            self.categoryButton.transform = CGAffineTransformMakeTranslation(0, self.categoryButton.transform.ty)
            self.sortButton.transform = CGAffineTransformMakeTranslation(0, self.sortButton.transform.ty)
            self.categoryTableView.transform = CGAffineTransformMakeTranslation(0, 0)
            }) { (Bool) -> Void in
                self.view.hidden = true
                self.hideListButtons()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        todaitNavBar.hidden = true
    }
    
}
