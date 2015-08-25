//
//  TaskTableViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 15..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit
import RealmSwift

class TaskTableViewController: UITableViewController,TaskTableViewCellDelegate{

    let defaults : NSUserDefaults! = NSUserDefaults.standardUserDefaults()
    var ratio : CGFloat! = 0
    var width: CGFloat! = 0
    var height: CGFloat! = 0
    
    var dayData:[Day] = []
    //var taskData:[Task] = []
    var taskResults:Results<Task>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        setupScreen()
        
        self.tableView.registerClass(TaskTableViewCell.self, forCellReuseIdentifier: "cell")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func setupScreen(){
        let screenRect = UIScreen.mainScreen().bounds
        let screenWidth = screenRect.size.width
        ratio = screenWidth/320
        width = screenWidth
        height = screenRect.size.height
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        
        if let taskResults = taskResults{
            return taskResults.count
        }
        
        return 0
    }

    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 50*ratio
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TaskTableViewCell
        cell.delegate = self
        cell.indexPath = indexPath
        
        
        let task:Task! = taskResults![indexPath.row]
        
        
        let day:Day! = task.getDay(getTodayDateNumber())
        
        
        cell.titleLabel.text = task.name
        
        if let isDayValid = day {
            
            cell.contentsTextView.setupText(day.doneAmount, total: day.expectAmount, unit: task.unit)
            cell.percentLabel.text = String(format: "%lu%@", Int(day.doneAmount/day.expectAmount),"%")
            cell.percentLayer.strokeColor = UIColor.colorWithHexString("#00D2B1").CGColor
            cell.percentLayer.strokeEnd = CGFloat(day.doneAmount/day.expectAmount)
            cell.colorBoxView.backgroundColor = task.getColor()
        }else{
            
            //cell.contentsLabel.text = "공부 시작 전입니다"
        }
        
        
        return cell
        
    }
    

    func timerButtonClk(indexPath:NSIndexPath) {
        //performSegueWithIdentifier("ShowTimerView", sender:indexPath)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
