//
//  SettingCategorySortingViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 8. 6..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit
import CoreData

class SettingCategorySortingViewController: BasicViewController,UITableViewDataSource,UITableViewDelegate,TodaitNavigationDelegate{
    
    var tableView:UITableView!
    
    var categoryData: [Category] = []
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var footerView:UIView!
    var addButton:UIButton!
    var deleteButton:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategoryData()
        addTableView()
        addFooterView()
        
        
    }
    
    func loadCategoryData(){
        
        let entityDescription = NSEntityDescription.entityForName("Category",inManagedObjectContext:managedObjectContext!)
        
        let request = NSFetchRequest()
        request.entity = entityDescription
        
        var error: NSError?
        
        categoryData = managedObjectContext?.executeFetchRequest(request, error: &error) as! [Category]
        
    }
    
    
    func addTableView(){
        
        
        tableView = UITableView(frame: CGRectMake(0,navigationHeight,width,height - navigationHeight - 43), style: UITableViewStyle.Grouped)
        tableView.registerClass(SettingCategoryTableViewCell.self, forCellReuseIdentifier: "category")
        tableView.contentInset = UIEdgeInsetsMake(-56, 0, 0, 0)
        tableView.sectionFooterHeight = 0.0
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.allowsMultipleSelectionDuringEditing = true
        view.addSubview(tableView)
        
        tableView.setEditing(true, animated: true)
    }
    
    func addFooterView(){
        
        footerView = UIView(frame: CGRectMake(0, height - 43, width, 43))
        footerView.backgroundColor = UIColor.todaitLightGray()
        view.addSubview(footerView)
        
        
        addButton = UIButton(frame: CGRectMake(0, 0, 65, 43))
        addButton.setBackgroundImage(UIImage(named: "bt_add@3x.png"), forState: UIControlState.Normal)
        footerView.addSubview(addButton)
        
        deleteButton = UIButton(frame: CGRectMake(width - 65, 0, 65, 43))
        deleteButton.setBackgroundImage(UIImage(named: "bt_delete@3x.png"), forState: UIControlState.Normal)
        footerView.addSubview(deleteButton)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
        }
        
    }
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        
        
        return categoryData.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 56
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("category", forIndexPath: indexPath) as! SettingCategoryTableViewCell
        
        
        let category = categoryData[indexPath.row]
        
        cell.categoryButton.setBackgroundImage(UIImage.maskColor("circle@3x.png", color: UIColor.colorWithHexString(category.color)), forState: UIControlState.Normal)
        cell.titleLabel.text = category.name
        cell.setEditing(true, animated: true)
        
        return cell
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        todaitNavBar.todaitDelegate = self
        todaitNavBar.backButton.hidden = false
        self.titleLabel.text = "카테고리 정렬 설정"
        
        self.screenName = "Category Sort Activity"
        
        UIView.appearance().tintColor = UIColor.todaitRed()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIView.appearance().tintColor = UIColor.todaitGreen()
    }
    
    func backButtonClk() {
        self.navigationController?.popViewControllerAnimated(true)
    }

}
