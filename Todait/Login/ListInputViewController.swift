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
    var buttonTitle:String! = ""
    
    var filterView:UIImageView!
    var tableView:UITableView!
    var cancelButton:UIButton!
    
    var dataSource:[String] = []
    
    var delegate:ListInputDelegate!
    
    var selectedIndex:Int! = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addFilterView()
        addTableView()
        addCancelButton()
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
        tableView.bounces = false
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)
    }
    
    func addCancelButton(){
        
        cancelButton = UIButton(frame:CGRectMake(13*ratio,height-43*ratio,294*ratio,43*ratio))
        cancelButton.setTitle(buttonTitle, forState: UIControlState.Normal)
        cancelButton.setBackgroundImage(UIImage.colorImage(UIColor.todaitGreen(), frame: CGRectMake(0, 0, 294*ratio, 43*ratio)), forState: UIControlState.Normal)
        cancelButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo", size: 15*ratio)
        cancelButton.addTarget(self, action: Selector("cancelButtonClk"), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(cancelButton)
        
    }
    
    func cancelButtonClk(){
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        
        for temp in cell.contentView.subviews {
            temp.removeFromSuperview()
        }
        
        
        let title:String = dataSource[indexPath.row]
        
        let titleLabel = UILabel(frame:CGRectMake(15,5,250*ratio,39))
        titleLabel.text = title
        titleLabel.font = UIFont(name:"AppleSDGothicNeo-Light",size:14*ratio)
        titleLabel.textColor = UIColor.todaitGray()
        titleLabel.textAlignment = NSTextAlignment.Left
        cell.contentView.addSubview(titleLabel)
        
        
        let line = UIView(frame:CGRectMake(0,48*ratio,294*ratio,1*ratio))
        line.backgroundColor = UIColor.todaitBackgroundGray()
        cell.contentView.addSubview(line)
        
        if selectedIndex == indexPath.row {
            
            let checkImage = UIImageView(frame:CGRectMake(294*ratio - 30, 15, 19, 19))
            checkImage.image = UIImage(named: "bt_check_green@3x.png")
            cell.contentView.addSubview(checkImage)
            
        }
            
        return cell
    
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 34*ratio
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.todaitGray()
        
        let titleLabel = UILabel(frame:CGRectMake(15*ratio,0,250*ratio,34*ratio))
        titleLabel.textAlignment = NSTextAlignment.Left
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.text = tableTitle
        
        headerView.addSubview(titleLabel)
        
        
        
        return headerView
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
        
        if self.delegate.respondsToSelector("selectedString:"){
            
            self.delegate.selectedString(dataSource[indexPath.row])
            
        }
        
        cancelButtonClk()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 49
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.todaitNavBar.hidden = true
        
        
    }
   
}
