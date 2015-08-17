//
//  UnCompletedViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 8. 6..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class UncompletedViewController: BasicViewController,TodaitNavigationDelegate,UITableViewDelegate,UITableViewDataSource{
   
    var tableView:UITableView!
    var uncompletedTaskData:[Task] = []
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUncompletedTaskData()
        addTableView()
        
    }
    
    func loadUncompletedTaskData(){
        let entityDescription = NSEntityDescription.entityForName("Task",inManagedObjectContext:managedObjectContext!)
        
        let request = NSFetchRequest()
        request.entity = entityDescription
        
        
        
        let predicate = NSPredicate(format: "completed == %@" , false)
        request.predicate = predicate
        
        var error: NSError?
        var allTasks = managedObjectContext?.executeFetchRequest(request, error: &error) as! [Task]
        
        var todayDateNumber = getTodayDateNumber()
        uncompletedTaskData = allTasks.filter({(task:Task?) -> (Bool) in
            
            if let task = task {
                if task.amount.integerValue > task.getTotalDoneAmount().integerValue && task.endDate < todayDateNumber {
                    return true
                }
            }
            
            return false
        })
        
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
        return uncompletedTaskData.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
     
        
        let detailVC = DetailViewController()
        detailVC.task = uncompletedTaskData[indexPath.row]
        self.navigationController?.pushViewController(detailVC, animated: true)
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.setSelected(false, animated: false)
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("taskCell", forIndexPath: indexPath) as! TaskTableViewCell
        
        
        for temp in cell.contentView.subviews{
            temp.removeFromSuperview()
        }
        
        var task = uncompletedTaskData[indexPath.row]
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
        cell.titleLabel.text = task.name + " | " + getTimeStringFromSeconds(NSTimeInterval(totalDoneTime.integerValue))
        
        cell.contentsTextView.setupText(totalDoneAmount.integerValue, total: amount.integerValue, unit: task.unit)
        
        
        cell.percentLabel.text = String(format: "%lu%@", Int(totalDoneAmount.floatValue/amount.floatValue * 100),"%")
        
        cell.percentLayer.strokeColor = UIColor.todaitRed().CGColor
        cell.percentLayer.strokeEnd = CGFloat(totalDoneAmount.floatValue/amount.floatValue)
        cell.percentLabel.textColor = UIColor.todaitRed()
        
        
        /*
        if let day = day {
            
            //cell.contentsLabel.text = day.getProgressString()
            cell.titleLabel.text = task.name + " | " + getTimeStringFromSeconds(NSTimeInterval(day.doneSecond.integerValue))
            cell.contentsTextView.setupText(day.doneAmount.integerValue, total: day.expectAmount.integerValue, unit: task.unit)
            cell.percentLabel.text = String(format: "%lu%@", Int(day.doneAmount.floatValue/day.expectAmount.floatValue * 100),"%")
            cell.percentLayer.strokeColor = UIColor.todaitRed().CGColor
            cell.percentLayer.strokeEnd = CGFloat(day.doneAmount.floatValue/day.expectAmount.floatValue)
            cell.percentLabel.textColor = UIColor.todaitRed()
            //cell.colorBoxView.backgroundColor = UIColor.colorWithHexString(task.category_id.color)
            
        }else{
            
            cell.titleLabel.text = task.name + " | "
        }
        */
        
        
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
