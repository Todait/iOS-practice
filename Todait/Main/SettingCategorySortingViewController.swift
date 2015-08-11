//
//  SettingCategorySortingViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 8. 6..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit
import CoreData

class SettingCategorySortingViewController: BasicViewController,UITableViewDataSource,UITableViewDelegate,TodaitNavigationDelegate,CategoryDelegate{
    
    var tableView:UITableView!
    
    var categoryData: [Category] = []
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var footerView:UIView!
    var addButton:UIButton!
    var deleteButton:UIButton!
    
    var cancelButton:UIButton!
    
    var isDeleteMode:Bool! = false
    var selectedIndex:Int = 0
    
    
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
        
        tableView.allowsMultipleSelectionDuringEditing = false
        tableView.editing = true
        
        view.addSubview(tableView)
        
        //tableView.setEditing(true, animated: true)
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
       tableView.setEditing(editing, animated: animated)
    }
    
    func showCategoryAddView(){
        
        var categoryVC = CategorySettingViewController()
        
        categoryVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        categoryVC.delegate = self
        
        self.navigationController?.presentViewController(categoryVC, animated: false, completion: { () -> Void in
            categoryVC.showAddCategoryView(false)
        })
        
        
    }
    
    
    func addFooterView(){
        
        footerView = UIView(frame: CGRectMake(0, height - 43, width, 43))
        footerView.backgroundColor = UIColor.todaitLightGray()
        view.addSubview(footerView)
        
        
        addButton = UIButton(frame: CGRectMake(0, 0, 65, 43))
        addButton.setBackgroundImage(UIImage(named: "bt_add@3x.png"), forState: UIControlState.Normal)
        addButton.addTarget(self, action: Selector("showCategoryAddView"), forControlEvents: UIControlEvents.TouchUpInside)
        footerView.addSubview(addButton)
        
        deleteButton = UIButton(frame: CGRectMake(width - 65, 0, 65, 43))
        deleteButton.setBackgroundImage(UIImage(named: "bt_delete@3x.png"), forState: UIControlState.Normal)
        deleteButton.addTarget(self, action: Selector("deleteButtonClk"), forControlEvents: UIControlEvents.TouchUpInside)
        footerView.addSubview(deleteButton)
    }
    
    func deleteButtonClk(){
        
        cancelButton.hidden = isDeleteMode
        isDeleteMode = !isDeleteMode
        tableView.allowsMultipleSelectionDuringEditing = isDeleteMode
        if isDeleteMode == true {
            deleteButton.setBackgroundImage(UIImage(named: "bt_delete_red@3x.png"), forState: UIControlState.Normal)
        }else{
            deleteButton.setBackgroundImage(UIImage(named: "bt_delete@3x.png"), forState: UIControlState.Normal)
            
            deleteSelected(true)
        }
        
        addButton.hidden = isDeleteMode
        
        tableView.setEditing(isDeleteMode, animated: true)
        
    }
    
    func cancelDelete(){
        
        cancelButton.hidden = isDeleteMode
        isDeleteMode = !isDeleteMode
        
        if isDeleteMode == true {
            deleteButton.setBackgroundImage(UIImage(named: "bt_delete_red@3x.png"), forState: UIControlState.Normal)
        }else{
            deleteButton.setBackgroundImage(UIImage(named: "bt_delete@3x.png"), forState: UIControlState.Normal)
            
            deleteSelected(false)
        }
        
        addButton.hidden = isDeleteMode
        
        tableView.setEditing(isDeleteMode, animated: true)
        cancelButton.hidden = true
        
    }
    
    
    func deleteSelected(delete:Bool){
        
        if delete == true {
            
            
            var selectedCells = tableView.indexPathsForSelectedRows() as? [NSIndexPath]
            
            
            if let selectedCells = selectedCells {
                
                
                
                var sortedCells = selectedCells.sorted({$1.row < $0.row})
                
                for path in sortedCells {
                    
                    let indexPath = path
                    let category = categoryData[indexPath.row]
                    managedObjectContext?.deleteObject(category)
                    categoryData.removeAtIndex(indexPath.row)
                    
                }
                
                
                var error:NSError?
                managedObjectContext?.save(&error)
                
                if error == nil {
                    NSLog("Task 삭제완료",0)
                    
                    NSNotificationCenter.defaultCenter().postNotificationName("categoryDataChanged", object: nil)
                    
                    tableView.beginUpdates()
                    tableView.deleteRowsAtIndexPaths(sortedCells, withRowAnimation: UITableViewRowAnimation.Automatic)
                    tableView.endUpdates()
                }
                
            }

        }
    }
    
    
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        
        
        
        
        
        return UITableViewCellEditingStyle.None
    }
    
    
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return !isDeleteMode
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {

        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if !isDeleteMode {
            selectedIndex = indexPath.row
            
            let category = categoryData[indexPath.row]
            
            let categoryEditVC = CategoryEditViewController()
            categoryEditVC.editedCategory = category
            categoryEditVC.delegate = self
            categoryEditVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
            
            self.navigationController?.presentViewController(categoryEditVC, animated: false, completion: { () -> Void in
                
            })
        }
        
    }
    
    
    func categoryEdited(editedCategory: Category) {
        loadCategoryData()
        
        if !categoryData.isEmpty {
            tableView.beginUpdates()
            tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: selectedIndex, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
            tableView.endUpdates()
        }else{
            tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    
    
    
    
    
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
        cell.setEditing(isDeleteMode, animated: true)
        
        return cell
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        todaitNavBar.todaitDelegate = self
        todaitNavBar.backButton.hidden = false
        self.titleLabel.text = "카테고리 정렬 설정"
        
        self.screenName = "Category Sort Activity"
        
        UIView.appearance().tintColor = UIColor.todaitRed()
        
        addCancelButton()
    }
    
    
    
    func addCancelButton(){
        
        if cancelButton != nil {
            return
        }
        
        cancelButton = UIButton(frame: CGRectMake(245*ratio, 32, 60*ratio, 24))
        cancelButton.setTitle("Cancel", forState: UIControlState.Normal)
        cancelButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 18)
        cancelButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        cancelButton.addTarget(self, action: Selector("cancelButtonClk"), forControlEvents: UIControlEvents.TouchUpInside)
        cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        cancelButton.hidden = true
        view.addSubview(cancelButton)
    }
    
    func cancelButtonClk(){
        cancelDelete()
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIView.appearance().tintColor = UIColor.todaitGreen()
    }
    
    func backButtonClk() {
        self.navigationController?.popViewControllerAnimated(true)
    }

}
