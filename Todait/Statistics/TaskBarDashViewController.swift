//
//  BarDashViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 11..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class TaskBarDashViewController: UITableViewController {
    
    
    var dataSource:[[String:AnyObject]] = []
    var ratio:CGFloat!
    var mainColor:UIColor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.backgroundColor = UIColor.whiteColor()
        view.backgroundColor = UIColor.whiteColor()
        
        let screenRect = UIScreen.mainScreen().bounds
        let screenWidth = screenRect.size.width
        ratio = screenWidth/320
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        return dataSource.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell
        cell.backgroundColor = UIColor.whiteColor()
        
        let backgroundView = UIView(frame:CGRectMake(10*ratio,5*ratio,90*ratio,18*ratio))
        backgroundView.clipsToBounds = true
        backgroundView.layer.cornerRadius = 9*ratio
        backgroundView.backgroundColor = UIColor.todaitLightGray()
        cell.contentView.addSubview(backgroundView)
        
        
        
        let data = dataSource[indexPath.row]
        let category = data["category"] as! Category
        let value:CGFloat = data["value"] as! CGFloat
        let color = mainColor.colorWithAlphaComponent(1 - CGFloat(indexPath.row) * 0.15)
        
        
        
        
        let frontWidth = CGFloat(value)
        let frontView = UIView(frame:CGRectMake(0,0,0,18*ratio))
        frontView.backgroundColor = color
        frontView.layer.cornerRadius = 9*ratio
        frontView.clipsToBounds = true
        backgroundView.addSubview(frontView)
        
        UIView.animateWithDuration(1.5, animations: { () -> Void in
            frontView.frame = CGRectMake(0,0,frontWidth,18*self.ratio)
        })
        
        
        let titleLabel = UILabel(frame: CGRectMake(15*ratio, 5*ratio, 40*ratio, 18*ratio))
        titleLabel.text = category.name
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textAlignment = NSTextAlignment.Left
        titleLabel.font = UIFont(name: "AvenirNext-Regular", size: 8*ratio)
        cell.contentView.addSubview(titleLabel)
        
        
        let percentLabel = UILabel(frame:CGRectMake(109*ratio, 5*ratio, 20*ratio, 18*ratio))
        percentLabel.adjustsFontSizeToFitWidth = true
        percentLabel.text = String(format: "%.0f%",value)
        percentLabel.textColor = color
        percentLabel.font = UIFont(name: "AvenirNext-Regular", size: 8*ratio)
        cell.contentView.addSubview(percentLabel)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 30*ratio
    }
    
    
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        
        return false
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
