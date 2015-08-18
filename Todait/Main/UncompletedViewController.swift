//
//  UnCompletedViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 8. 6..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit
import RealmSwift

class UncompletedViewController: BasicViewController,TodaitNavigationDelegate,UITableViewDelegate,UITableViewDataSource{
   
    var tableView:UITableView!
    var uncompletedTaskDateResults:Results<TaskDate>?
    //let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUncompletedTaskData()
        addTableView()
        
    }
    
    func loadUncompletedTaskData(){
        
        
        
        uncompletedTaskDateResults = realm.objects(TaskDate).filter("state == 0")
        
    
    }

    
    
    func addTableView(){
        
        
        tableView = UITableView(frame: CGRectMake(0,navigationHeight,width,height - navigationHeight), style: UITableViewStyle.Grouped)
        tableView.registerClass(TaskTableViewCell.self, forCellReuseIdentifier: "taskCell")
        tableView.contentInset = UIEdgeInsetsMake(-56, 0, 0, 0)
        tableView.sectionFooterHeight = 0.0
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
    
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 58
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return uncompletedTaskDateResults!.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
     
        
        let detailVC = DetailViewController()
        detailVC.task = uncompletedTaskDateResults![indexPath.row].task
        self.navigationController?.pushViewController(detailVC, animated: true)
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.setSelected(false, animated: false)
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("taskCell", forIndexPath: indexPath) as! TaskTableViewCell
        
        
        for temp in cell.contentView.subviews{
            temp.removeFromSuperview()
        }
        
        
        if let task = uncompletedTaskDateResults![indexPath.row].task{
            
            let totalDoneAmount = task.getTotalDoneAmount()
            let totalDoneTime = task.getTotalDoneTime()
            let amount = task.amount
            
            let backView = UIView()
            backView.backgroundColor = UIColor.todaitWhiteGray()
            cell.selectedBackgroundView = backView
            
            
            
            cell.indexPath = indexPath
            cell.percentLayer.strokeEnd = 0
            cell.percentLayer.strokeColor = UIColor.todaitLightGray().CGColor
            cell.percentLayer.lineWidth = 2
            cell.percentLabel.textColor = UIColor.todaitDarkGray()
            cell.colorBoxView.backgroundColor = task.getColor()
            cell.percentLabel.hidden = false
            cell.timerButton.userInteractionEnabled = false
            
            
            cell.titleLabel.text = task.name
            cell.titleLabel.text = task.name + " | " + getTimeStringFromSeconds(NSTimeInterval(totalDoneTime))
            
            cell.contentsTextView.setupText(totalDoneAmount, total: amount, unit: task.unit)
            
            
            cell.percentLabel.text = String(format: "%lu%@", Int(totalDoneAmount/amount * 100),"%")
            
            cell.percentLayer.strokeColor = UIColor.todaitRed().CGColor
            cell.percentLayer.strokeEnd = CGFloat(totalDoneAmount/amount)
            cell.percentLabel.textColor = UIColor.todaitRed()
            
        }
        
        
        var line = UIView(frame: CGRectMake(0, 57.5, 320*ratio, 0.5))
        line.backgroundColor = UIColor.todaitDarkGray().colorWithAlphaComponent(0.3)
        cell.contentView.addSubview(line)
        
        
        return cell
        
        
        
    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setNavigationBarColor(UIColor.todaitRed())
        todaitNavBar.todaitDelegate = self
        todaitNavBar.backButton.hidden = false
        self.titleLabel.text = "미완료 목표"
        
        self.screenName = "Uncompleted Activity"
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    func backButtonClk() {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
