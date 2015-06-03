
//
//  NewCategoryViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 3..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

protocol CategoryDelegate : NSObjectProtocol {
    func categoryEdited(color:UIColor,title:String)
}


class CategoryViewController: BasicViewController,TodaitNavigationDelegate,UITableViewDelegate,UITableViewDataSource{
    
    
    var categoryTableView: UITableView!
    var addCategoryButton: UIButton!
    var delegate: CategoryDelegate!
    var selectedIndex: Int! = 0
    let headerHeight: CGFloat = 220
    let metaData: [String] = ["영어","수학","국어","회화","운동"]
    let colorData: [String] = ["#969696","27DB9F","F53436","FBEB56","5A5A5A"]
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    

    override func viewDidLoad() {
        super.viewDidLoad()
        addCategoryTableView()
    
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
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        todaitNavBar.todaitDelegate = self
        todaitNavBar.backButton.hidden = false
        addCategoryBtn()
        titleLabel.text = "Category"
    }
    
    func backButtonClk() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func addCategoryBtn(){
        addCategoryButton = UIButton(frame: CGRectMake(288*ratio, 30*ratio, 24*ratio, 24*ratio))
        addCategoryButton.setImage(UIImage(named: "setting@2x.png"), forState: UIControlState.Normal)
        addCategoryButton.addTarget(self, action: Selector("newCategory"), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(addCategoryButton)
    }
    
    func newCategory(){
        
        //self.navigationController?.pushViewController(InvestViewController(), animated: true)
    
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destination = segue.destinationViewController as! NewTaskViewController
        
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return metaData.count
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
        
        var categoryCircle = UIView(frame: CGRectMake(15*ratio, 17*ratio, 15*ratio, 15*ratio))
        categoryCircle.backgroundColor = UIColor.colorWithHexString(colorData[indexPath.row])
        categoryCircle.clipsToBounds = true
        categoryCircle.layer.cornerRadius = 7.5*ratio
        cell.contentView.addSubview(categoryCircle)
        
        
        var titleLabel = UILabel(frame:CGRectMake(40*ratio, 9.5*ratio, 250*ratio, 30*ratio))
        titleLabel.text = metaData[indexPath.row]
        titleLabel.font = UIFont(name: "AvenirNext-Regular", size: 14*ratio)
        titleLabel.textAlignment = NSTextAlignment.Left
        titleLabel.textColor = UIColor.colorWithHexString("#969696")
        cell.contentView.addSubview(titleLabel)
        
        if indexPath.row == selectedIndex {
            
            var checkImage = UIImageView(frame: CGRectMake(283*ratio, 13.5*ratio, 22*ratio, 22*ratio))
            checkImage.image = UIImage(named: "done@3x.png")
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
        tableView.reloadData()
        
        categoryEdited()
        
        return false
    }
    
    func categoryEdited(){
        
        if self.delegate.respondsToSelector("categoryEdited:title:") {
            self.delegate.categoryEdited(UIColor.colorWithHexString(colorData[selectedIndex]), title: metaData[selectedIndex])
        }
        
    }
    
    func max<T : Comparable>(x: T, y:T) ->T{
        if x > y {
            return x
        }else{
            return y
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
