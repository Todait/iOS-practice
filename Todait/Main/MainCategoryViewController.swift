//
//  MainListViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 7. 15..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit
import CoreData









class MainCategoryViewController: BasicViewController,UITableViewDelegate,UITableViewDataSource{
    
    var listView:UIView!
    
    var studyView:UIView!
    var categoryView:UIView!
    var sortView:UIView!
    
    
    var filterView:UIVisualEffectView!
    
    var studyButton:UIButton!
    var categoryButton:UIButton!
    var sortButton:UIButton!
    
    var categoryTableView:UITableView!
    
    var categoryData: [Category] = []
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        addFilterView()
        addShadowLayer()
        
        view.backgroundColor = UIColor.clearColor()
        
        loadCategoryData()
        
        //addStudyButton()
        //addCategoryButton()
        //addSortButton()
        addCategoryTableView()
        
    }
    
    func addFilterView(){
        
        let effect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        filterView = UIVisualEffectView(effect: effect)
        filterView.frame = CGRectMake(0*ratio,0,85*ratio,height - 64 - 49*ratio)
        filterView.alpha = 0.8
        view.addSubview(filterView)
        
    }
    
    func addShadowLayer(){
        
        let shadowLayer = CAGradientLayer()
        shadowLayer.colors = [UIColor.clearColor().CGColor,UIColor.blackColor().CGColor]
        shadowLayer.startPoint = CGPointMake(0, 0.5)
        shadowLayer.endPoint = CGPointMake(1.0, 0.5)
        shadowLayer.locations = [NSNumber(float: 0.5),NSNumber(float: 1.0)]
        shadowLayer.frame = view.frame
        
        //self.view.layer.insertSublayer(shadowLayer, atIndex: 0)
        
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
        
        categoryTableView = UITableView(frame: CGRectMake(0*ratio,0 ,85*ratio,height - navigationHeight - 49*ratio ), style: UITableViewStyle.Grouped)
        categoryTableView.registerClass(MainCategoryTableViewCell.self, forCellReuseIdentifier: "mainCategoryCell")
        categoryTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        categoryTableView.contentInset = UIEdgeInsetsMake(-20*ratio, 0, 0, 0)
        categoryTableView.sectionFooterHeight = 0
        categoryTableView.sectionHeaderHeight = 0
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        categoryTableView.contentOffset.y = 0
        categoryTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        categoryTableView.backgroundColor = UIColor.clearColor()
        
        view.addSubview(categoryTableView)
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0: return 1
        case 1: return 1
        case 2: return categoryData.count
        default: return 1
            
        }
        
        
        
        return categoryData.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section < 2 {
            return 42*ratio
        }
        
        
        return 30*ratio
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        if indexPath.section < 2 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
            cell.backgroundColor = UIColor.clearColor()
            
            let backView = UIView()
            backView.backgroundColor = UIColor.colorWithHexString("#252525").colorWithAlphaComponent(0.7)
            cell.selectedBackgroundView = backView
            
            
            for temp in cell.contentView.subviews {
                temp.removeFromSuperview()
            }
            
            
            let sortInfoLabel = UILabel(frame: CGRectMake(38*ratio, 0, 47*ratio, 42*ratio))
           
            sortInfoLabel.textAlignment = NSTextAlignment.Left
            sortInfoLabel.textColor = UIColor.whiteColor()
            sortInfoLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 8*ratio)
            
            cell.contentView.addSubview(sortInfoLabel)
            
            
            let sortImageView = UIImageView(frame: CGRectMake(12*ratio, 12*ratio, 15*ratio, 15*ratio))
            sortImageView.contentMode = UIViewContentMode.ScaleAspectFill
            
            cell.contentView.addSubview(sortImageView)

            
            if indexPath.section == 0 {
                sortInfoLabel.text = "정렬설정"
                sortImageView.image = UIImage(named: "ic_arrange_arrange@3x.png")
            }else{
                sortInfoLabel.text = "카테고리"
                sortImageView.image = UIImage(named: "ic_arrange_folder@3x.png")
            }
            
            
            
            
            
            return cell
        }
        
        
        
        
        
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("mainCategoryCell", forIndexPath: indexPath) as! MainCategoryTableViewCell
        
        let category:Category = categoryData[indexPath.row]
        let categoryColor = UIColor.colorWithHexString(category.color)
        
        
        cell.mainColor = categoryColor
        cell.titleLabel.text = category.name
        cell.backgroundColor = UIColor.clearColor()
        cell.contentView.backgroundColor = UIColor.clearColor()
        
        cell.setCategorySelect(!category.hidden)
        
        
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        cell!.selected = true
        
        let category = categoryData[indexPath.row]
        category.hidden = !category.hidden
        
        var error: NSError?
        managedObjectContext?.save(&error)
        
        if error == nil {
            NSNotificationCenter.defaultCenter().postNotificationName("categoryDataMainUpdate", object: nil)
        }
        
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        cell!.selected = false
        
        cell!.contentView.backgroundColor = UIColor.clearColor()
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)
        
        self.view.hidden = true
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        todaitNavBar.hidden = true
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "categoryDataChanged", name: "categoryDataChanged", object: nil)
        
    }
    
    func categoryDataChanged(){
        
        loadCategoryData()
        categoryTableView.reloadData()
    }
    
}
