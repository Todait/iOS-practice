//
//  CategoryRearViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 16..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit
import CoreData

class CategoryRearViewController: BasicViewController,UITableViewDelegate,UITableViewDataSource{
   
    
    var categoryTableView:UITableView!
    var selectedIndexPath: NSIndexPath!
    let headerHeight: CGFloat = 220
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var categoryData: [Category] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.colorWithHexString("#333533")
        selectedIndexPath = NSIndexPath(forRow: 0, inSection: 0)
        
        loadCategoryData()
        addCategoryTableView()
    }
    
    
    func addCategoryTableView(){
        
        categoryTableView = UITableView(frame: CGRectMake(0,navigationHeight*ratio,width,350*ratio), style: UITableViewStyle.Plain)
        categoryTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "categoryCell")
        categoryTableView.contentInset = UIEdgeInsetsMake(0*ratio, 0, 0, 0)
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        categoryTableView.contentOffset.y = 0
        categoryTableView.sectionFooterHeight = 0
        categoryTableView.sectionHeaderHeight = 0
        categoryTableView.backgroundColor = UIColor.clearColor()
        categoryTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        view.addSubview(categoryTableView)
        
    }
    
    func loadCategoryData(){
        
        let entityDescription = NSEntityDescription.entityForName("Category",inManagedObjectContext:managedObjectContext!)
        
        let request = NSFetchRequest()
        request.entity = entityDescription
        
        var error: NSError?
        
        categoryData = managedObjectContext?.executeFetchRequest(request, error: &error) as! [Category]
        NSLog("Category results %@",categoryData)
    }
    
   
    
    /*
    
    func addCategoryBtn(){
        addCategoryButton = UIButton(frame: CGRectMake(288*ratio, 30*ratio, 24*ratio, 24*ratio))
        addCategoryButton.setImage(UIImage.maskColor("newPlus.png",color:UIColor.whiteColor()), forState: UIControlState.Normal)
        addCategoryButton.addTarget(self, action: Selector("newCategory"), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(addCategoryButton)
    }
    
    */

    
    /*
    func needToUpdate(){
        loadCategoryData()
        
        if categoryData.count != 0 {
            selectedIndex = categoryData.count - 1
            categoryEdited()
        }
        
        categoryTableView.reloadData()
    }
    */
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        }else{
            return categoryData.count
        }
        
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
        let headerView = UIView(frame: CGRectMake(0,0,width,15*ratio))
        headerView.backgroundColor = UIColor.colorWithHexString("#333533")
        if section == 0 {
            
            let titleLabel = UILabel(frame:CGRectMake(10*ratio,0,width,15*ratio))
            titleLabel.textAlignment = NSTextAlignment.Left
            titleLabel.text = "Category"
            titleLabel.textColor = UIColor.whiteColor()
            titleLabel.font = UIFont(name:"AvenirNext-Regular",size:12*ratio)
            headerView.addSubview(titleLabel)
            
        }
        
        return headerView
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("categoryCell", forIndexPath: indexPath) as! UITableViewCell
        cell.backgroundColor = UIColor.clearColor()
        
        for view in cell.contentView.subviews{
            view.removeFromSuperview()
        }
        
        
        var categoryBand = UIView(frame:CGRectMake(0,7*ratio,0*ratio,35*ratio))
        
        cell.contentView.addSubview(categoryBand)
        
        
        var titleLabel = UILabel(frame:CGRectMake(20*ratio, 9.5*ratio, 250*ratio, 30*ratio))
        
        titleLabel.font = UIFont(name: "AvenirNext-Regular", size: 14*ratio)
        titleLabel.textAlignment = NSTextAlignment.Left
        titleLabel.textColor = UIColor.whiteColor()
        cell.contentView.addSubview(titleLabel)
        
        
        
        if indexPath.section == 0 {
            
            categoryBand.backgroundColor = UIColor.todaitGreen()
            titleLabel.text = "Todait"
            
        }else {
            let category:Category = categoryData[indexPath.row]
            
            categoryBand.backgroundColor = UIColor.colorWithHexString(category.color)
            titleLabel.text = category.name
        }
        
        
        if indexPath == selectedIndexPath {
            
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                categoryBand.frame = CGRectMake(0,7*self.ratio,200*self.ratio,35*self.ratio)
            })
            
        }else{
            categoryBand.frame = CGRectMake(0,7*ratio,10*ratio,35*ratio)
        }

        
        
        
        
        
        return cell
    }
    
    func timerButtonClk(indexPath:NSIndexPath) {
        
        self.navigationController?.pushViewController(TimerViewController(),animated: true)
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return 15*ratio
        }
        
        
        return 0*ratio
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0*ratio
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 49*ratio
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        selectedIndexPath = indexPath
        
        
        if indexPath.section == 0 {
            let mainVC = revealViewController().frontViewController as! MainViewController
            if mainVC.respondsToSelector(Selector("showAllCategory")){
                mainVC.showAllCategory()
            }
        } else {
            let mainVC = revealViewController().frontViewController as! MainViewController
            
            
            if mainVC.respondsToSelector(Selector("showCategory:")){
                mainVC.showCategory(categoryData[selectedIndexPath.row])
            }
        }
        
        
        
        tableView.reloadData()
        
        
        return false
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        
        let category = categoryData[indexPath.row]
        managedObjectContext?.deleteObject(category)
        
        var error:NSError?
        managedObjectContext?.save(&error)
        
        if error == nil {
            NSLog("삭제완료",0)
            
            
            categoryData.removeAtIndex(indexPath.row)
            selectedIndexPath = NSIndexPath(forRow: 0, inSection: 0)
            
            tableView.beginUpdates()
            tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation:UITableViewRowAnimation.Automatic)
            tableView.endUpdates()
            
            
        }else {
            //삭제에러처리
            
        }
    }
    
    
    /*
    func categoryEdited(){
        
        if self.delegate.respondsToSelector("categoryEdited:") {
            self.delegate.categoryEdited(categoryData[selectedIndex])
        }
        
    }
    */
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        todaitNavBar.hidden = true
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
}
