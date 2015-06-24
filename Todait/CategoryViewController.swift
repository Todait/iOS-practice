
//
//  NewCategoryViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 3..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit
import CoreData

protocol CategoryDelegate : NSObjectProtocol {
    func categoryEdited(editedCategory:Category)
}


class CategoryViewController: BasicViewController,TodaitNavigationDelegate,UITableViewDelegate,UITableViewDataSource,UpdateDelegate{
    
    
    var category:Category!
    var categoryTableView: UITableView!
    var addCategoryButton: UIButton!
    var delegate: CategoryDelegate!
    var selectedIndex: Int! = 0
    let headerHeight: CGFloat = 220
    
    var categoryData: [Category] = []
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategoryData()
        setSelectedIndex()
        
        addCategoryTableView()
        
    }
    
    
    
    func loadCategoryData(){
        
        let entityDescription = NSEntityDescription.entityForName("Category",inManagedObjectContext:managedObjectContext!)
        
        let request = NSFetchRequest()
        request.entity = entityDescription
        
        var error: NSError?
        
        categoryData = managedObjectContext?.executeFetchRequest(request, error: &error) as! [Category]
        
        NSLog("Category results %@",categoryData)
    }
    
    func setSelectedIndex(){
        selectedIndex = find(categoryData,category)
    }
    
    func addCategoryTableView(){
        
        categoryTableView = UITableView(frame: CGRectMake(0,navigationHeight*ratio,width,height - navigationHeight*ratio), style: UITableViewStyle.Grouped)
        categoryTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        categoryTableView.contentInset = UIEdgeInsetsMake(-20*ratio, 0, 0, 0)
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        categoryTableView.contentOffset.y = 0
        view.addSubview(categoryTableView)
        
    }
    
    
    
    
    func needToUpdate(){
        loadCategoryData()
        
        if categoryData.count != 0 {
            selectedIndex = categoryData.count - 1
            categoryEdited()
        }
        
        categoryTableView.reloadData()
        showCompleteAddPopup()
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destination = segue.destinationViewController as! NewTaskViewController
        
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryData.count
    }
    /*
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return parallelView
    }
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        
        
        for view in cell.contentView.subviews{
            view.removeFromSuperview()
        }
        
        
        let category:Category = categoryData[indexPath.row]
        let categoryColor = UIColor.colorWithHexString(category.color)
        
        
        
        var categoryCircle = UIView(frame: CGRectMake(15*ratio, 14.5*ratio, 20*ratio, 20*ratio))
        categoryCircle.backgroundColor = categoryColor
        categoryCircle.clipsToBounds = true
        categoryCircle.layer.cornerRadius = 6*ratio
        cell.contentView.addSubview(categoryCircle)
        
        
        var titleLabel = UILabel(frame:CGRectMake(50*ratio, 9.5*ratio, 250*ratio, 30*ratio))
        titleLabel.text = category.name
        titleLabel.font = UIFont(name: "AvenirNext-Regular", size: 14*ratio)
        titleLabel.textAlignment = NSTextAlignment.Left
        titleLabel.textColor = UIColor.colorWithHexString("#969696")
        cell.contentView.addSubview(titleLabel)
        
        if indexPath.row == selectedIndex {
            
            var checkImage = UIImageView(frame: CGRectMake(283*ratio, 13.5*ratio, 22*ratio, 22*ratio))
            checkImage.image = UIImage.maskColor("done@3x.png", color:categoryColor)
            cell.contentView.addSubview(checkImage)
        }
        
        
        return cell
    }
    
    func timerButtonClk(indexPath:NSIndexPath) {
        
        self.navigationController?.pushViewController(TimerViewController(),animated: true)
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 22*ratio
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 49*ratio
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        selectedIndex = indexPath.row
        categoryEdited()
        
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
            selectedIndex = 0
            
            tableView.beginUpdates()
            tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: selectedIndex, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation:UITableViewRowAnimation.Automatic)
            tableView.endUpdates()
            
        }else {
            //삭제에러처리
            
        }
        
        
        
    }
    
    func categoryEdited(){
        
        if self.delegate.respondsToSelector("categoryEdited:") {
            
            let category = categoryData[selectedIndex]
            
            self.delegate.categoryEdited(category)
            
            setNavigationBarColor(UIColor.colorWithHexString(category.color))
        }
        
    }
    
    func max<T : Comparable>(x: T, y:T) ->T{
        if x > y {
            return x
        }else{
            return y
        }
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        todaitNavBar.todaitDelegate = self
        todaitNavBar.backButton.hidden = false
        addCategoryBtn()
        titleLabel.text = "Category"
        self.screenName = "Category Activity"
        
        todaitNavBar.setBackgroundImage(UIImage.colorImage(UIColor.colorWithHexString(category.color),frame:CGRectMake(0,0,width,navigationHeight)), forBarMetrics: UIBarMetrics.Default)
    }
    
    func backButtonClk() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func addCategoryBtn(){
        addCategoryButton = UIButton(frame: CGRectMake(288*ratio, 30, 24, 24))
        addCategoryButton.setImage(UIImage.maskColor("newPlus.png",color:UIColor.whiteColor()), forState: UIControlState.Normal)
        addCategoryButton.addTarget(self, action: Selector("newCategory"), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(addCategoryButton)
    }
    
    func newCategory(){
        
        let newCategoryVC = NewCategoryViewController()
        newCategoryVC.delegate = self
        newCategoryVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        
        self.navigationController?.presentViewController(newCategoryVC, animated: true, completion: { () -> Void in
            
        })
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func showCompleteAddPopup(){
        
        
        let popCircle = UIView(frame: CGRectMake(0, 0, 80*ratio, 80*ratio))
        popCircle.backgroundColor = UIColor.colorWithHexString(category.color)
        popCircle.center = view.center
        popCircle.clipsToBounds = true
        popCircle.layer.cornerRadius = 40*ratio
        
        view.addSubview(popCircle)
        
        
        let popUp = UILabel(frame: CGRectMake(0, 0, 80*ratio,80*ratio))
        popUp.backgroundColor = UIColor.clearColor()
        popUp.textColor = UIColor.whiteColor()
        popUp.textAlignment = NSTextAlignment.Center
        popUp.text = "추가되었다"
        popUp.font = UIFont(name: "AvenirNext-Regular", size: 4*ratio)
        popUp.center = view.center
        
        view.addSubview(popUp)
        
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            
            popCircle.transform = CGAffineTransformMakeScale(1.2, 1.2)
            popUp.font = UIFont(name: "AvenirNext-Regular", size: 16*self.ratio)
        
            }) { (Bool) -> Void in
            
                
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                
            }, completion: { (Bool) -> Void in
                
                popCircle.removeFromSuperview()
                popUp.removeFromSuperview()
            })
        }
        
    }
    
}
