//
//  UserSortViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 7. 23..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit
import CoreData

class UserSortViewController: BasicTableViewController {
 
    
   
    var taskData:[Task]! = []
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sectionTitles = ["Task"]
        loadTaskData()
        
        tableView.registerClass(TaskTableViewCell.self, forCellReuseIdentifier: "taskCell")
        tableView.editing = true
        
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier("taskCell", forIndexPath: indexPath) as! TaskTableViewCell
        
        let task = taskData[indexPath.row] as Task
        
        cell.titleLabel.text = task.name
        cell.colorBoxView.backgroundColor = task.getColor()
        cell.timerButton.hidden = true
        cell.editing = true
        
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 58*ratio
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
    
    
}
