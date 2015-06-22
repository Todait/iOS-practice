
//
//  BasicTableViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 18..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class BasicTableViewController: BasicViewController,UITableViewDataSource,UITableViewDelegate{
    var tableView:UITableView!
    
    var sectionTitles:[String] = []
    var cellTitles:[[String]] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTableView()
        
        
    }
    
    
    func addTableView(){
        
        
        tableView = UITableView(frame: CGRectMake(0,navigationHeight*ratio,width,height - navigationHeight), style: UITableViewStyle.Grouped)
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "basic")
        tableView.contentInset = UIEdgeInsetsMake(-15*ratio, 0, 0, 0)
        tableView.sectionFooterHeight = 0.0
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return sectionTitles.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        
        
        return cellTitles[section].count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 35*ratio
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45*ratio
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("basic", forIndexPath: indexPath) as! UITableViewCell
        
        for view in cell.contentView.subviews{
            view.removeFromSuperview()
        }
        
        let titleLabel = UILabel(frame: CGRectMake(15*ratio, 0*ratio, 270*ratio, 35*ratio))
        titleLabel.textAlignment = NSTextAlignment.Left
        titleLabel.textColor = UIColor.colorWithHexString("#606060")
        titleLabel.font = UIFont(name: "AvenirNext-Regular", size: 11*ratio)
        titleLabel.text = cellTitles[indexPath.section][indexPath.row]
        cell.contentView.addSubview(titleLabel)
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
      
        let headerView = UIView()
        
        let sectionTitleLabel = UILabel(frame: CGRectMake(15*ratio,23*ratio, 250*ratio, 13*ratio))
        sectionTitleLabel.text = sectionTitles[section]
        sectionTitleLabel.textAlignment = NSTextAlignment.Left
        sectionTitleLabel.font = UIFont(name: "AvenirNext-Regular", size: 11*ratio)
        sectionTitleLabel.textColor = UIColor.colorWithHexString("#595959")
        
        headerView.addSubview(sectionTitleLabel)
        
        return headerView
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
}
