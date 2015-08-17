//
//  UserSortViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 7. 23..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit
import CoreData

class UserSortViewController: BasicTableViewController,TodaitNavigationDelegate{
 
    
   
    var taskData:[Task]! = []
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sectionTitles = ["Task"]
        loadTaskData()
        
        tableView.contentInset = UIEdgeInsetsMake(-58, 0, 0, 0)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.registerClass(TaskTableViewCell.self, forCellReuseIdentifier: "mainCell")
        tableView.registerClass(TimerTaskTableViewCell.self, forCellReuseIdentifier: "timerCell")
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "emptyCell")
        tableView.sectionFooterHeight = 0
        tableView.sectionHeaderHeight = 0
        tableView.editing = true
        
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return nil
        
    }
    
    func loadTaskData(){
        let entityDescription = NSEntityDescription.entityForName("Task",inManagedObjectContext:managedObjectContext!)
        
        let request = NSFetchRequest()
        request.entity = entityDescription
        request.sortDescriptors = [NSSortDescriptor(key: "priority", ascending: true)]
        
        var error: NSError?
        taskData = managedObjectContext?.executeFetchRequest(request, error: &error) as! [Task]
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskData.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let task:Task! = taskData[indexPath.row]
        let day:Day? = task.getDay(getTodayDateNumber())
        
        
        
        if task.taskType == "Timer" {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("timerCell", forIndexPath: indexPath) as! TimerTaskTableViewCell
            
            
            for temp in cell.contentView.subviews{
                temp.removeFromSuperview()
            }
            //cell.delegate = self
            cell.indexPath = indexPath
            cell.percentLayer.strokeEnd = 0
            cell.percentLayer.strokeColor = UIColor.todaitLightGray().CGColor
            cell.percentLayer.lineWidth = 2
            cell.percentLabel.textColor = UIColor.todaitDarkGray()
            cell.colorBoxView.backgroundColor = task.getColor()
            cell.percentLabel.hidden = false
            
            cell.timerButton.hidden = true
            
            if let day = day {
                
                cell.titleLabel.text = task.name
                cell.contentsTextView.setupText(NSTimeInterval(day.doneSecond.integerValue))
                cell.percentLabel.text = String(format: "%lu%@", Int(day.doneAmount.floatValue/day.expectAmount.floatValue * 100),"%")
                cell.percentLayer.strokeColor = UIColor.todaitRed().CGColor
                cell.percentLayer.strokeEnd = CGFloat(day.doneAmount.floatValue/day.expectAmount.floatValue)
                cell.percentLabel.textColor = UIColor.todaitRed()
                
            }
            
            var line = UIView(frame: CGRectMake(0, 57.5, 320*ratio, 0.5))
            line.backgroundColor = UIColor.todaitDarkGray().colorWithAlphaComponent(0.3)
            cell.contentView.addSubview(line)
            
            return cell
            
        }else{
            
            let cell = tableView.dequeueReusableCellWithIdentifier("mainCell", forIndexPath: indexPath) as! TaskTableViewCell
            
            
            for temp in cell.contentView.subviews{
                temp.removeFromSuperview()
            }
            
            cell.indexPath = indexPath
            cell.percentLayer.strokeEnd = 0
            cell.percentLayer.strokeColor = UIColor.todaitLightGray().CGColor
            cell.percentLayer.lineWidth = 2
            cell.percentLabel.textColor = UIColor.todaitDarkGray()
            cell.colorBoxView.backgroundColor = task.getColor()
            cell.percentLabel.hidden = false
            cell.timerButton.hidden = true
            
            
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
            
            var line = UIView(frame: CGRectMake(0, 57.5, 320*ratio, 0.5))
            line.backgroundColor = UIColor.todaitDarkGray().colorWithAlphaComponent(0.3)
            cell.contentView.addSubview(line)
            
            
            return cell
        }
        
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 58
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        
        
        var sourceTask:Task = taskData[sourceIndexPath.row]
        var destTask:Task = taskData[destinationIndexPath.row]
        
        if sourceIndexPath.row - destinationIndexPath.row > 0{
            
            let srcPriority = sourceTask.priority
            sourceTask.priority = destTask.priority
            
            for index in destinationIndexPath.row...sourceIndexPath.row {
                
                var src = taskData[index]
                var dest = taskData[index+1]
                
                if index == sourceIndexPath.row-1{
                    src.priority = srcPriority
                }else{
                    src.priority = dest.priority
                }
                
                if index == sourceIndexPath.row - 1{
                    break
                }
            }
        }else{
            let srcPriority = sourceTask.priority
            sourceTask.priority = destTask.priority
            
            for var index = destinationIndexPath.row ; index > sourceIndexPath.row ; index-- {
                
                var src = taskData[index]
                var dest = taskData[index-1]
                
                if index == sourceIndexPath.row+1{
                    src.priority = srcPriority
                }else{
                    src.priority = dest.priority
                }
                
            }
        }
        
        
        var error:NSError?
        managedObjectContext?.save(&error)
        
        if error != nil {
            print(11)
        }
        
        print(sourceTask.priority)
        print("\n")
        print(destTask.priority)
        
        loadTaskData()
        
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        todaitNavBar.todaitDelegate = self
        todaitNavBar.backButton.hidden = false
        self.titleLabel.text = "사용자 정렬 설정"
        
        self.screenName = "Custom Sort Activity"
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func backButtonClk() {
        self.navigationController?.popViewControllerAnimated(true)
    }

    
}
