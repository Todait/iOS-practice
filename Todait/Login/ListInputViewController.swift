//
//  ListInputViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 7. 22..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

protocol ListInputDelegate : NSObjectProtocol {
    func selectedString(string:String)
}


class ListInputViewController: BasicViewController,UITableViewDelegate,UITableViewDataSource{
    
    var tableTitle:String! = ""
    
    var filterView:UIImageView!
    var tableView:UITableView!
    
    var dataSource:[String] = []
    
    var delegate:ListInputDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addFilterView()
    
    }
    
    func addFilterView(){
        
        filterView = UIImageView(frame: view.frame)
        filterView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        view.addSubview(filterView)
        
    }
    
    func addTableView(){
        
        tableView = UITableView(frame: CGRectMake(13*ratio, 90*ratio, 294*ratio, height - 150*ratio), style: UITableViewStyle.Plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.registerClass(CategorySettingTableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        
        for temp in cell.contentView.subviews {
            temp.removeFromSuperview()
        }
        
        
        let title:String = dataSource[indexPath.row]
        
        let titleLabel = UILabel(frame:CGRectMake(15*ratio,5*ratio,250*ratio,35*ratio))
        titleLabel.text = title
        titleLabel.font = UIFont(name:"AppleSDGothicNeo-Light",size:14*ratio)
        titleLabel.textColor = UIColor.todaitGray()
        titleLabel.textAlignment = NSTextAlignment.Left
        
        cell.contentView.addSubview(titleLabel)
        
        
        
        return cell
        
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
        
        if self.delegate.respondsToSelector("selectedString:"){
            
            self.delegate.selectedString(dataSource[indexPath.row])
            
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 45*ratio
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.todaitNavBar.hidden = true
        
        
    }
   
}
