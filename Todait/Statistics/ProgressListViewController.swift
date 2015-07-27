//
//  ProgressListViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 18..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit
import CoreData

class ProgressListViewController: BasicTableViewController,TodaitNavigationDelegate{
    
    var titleString:String! = ""
    var mainColor:UIColor!
    var tasks:[Task]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerClass(TaskTableViewCell.self, forCellReuseIdentifier: "taskCell")
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("taskCell", forIndexPath: indexPath) as! TaskTableViewCell
        
        
        let task:Task! = tasks[indexPath.row]
        
        //cell.delegate = self
        cell.indexPath = indexPath
        cell.percentLayer.strokeEnd = CGFloat(task.getPercentOfDoneAmount())/100
        cell.percentLayer.strokeColor = mainColor.CGColor
        cell.percentLabel.textColor = UIColor.todaitLightGray()
        cell.percentLabel.textColor = mainColor
        
        
        NSLog("%f",CGFloat(task.getPercentOfDoneAmount()))
        
        
        cell.percentLabel.text = String(format:"%.0f%@",CGFloat(task.getPercentOfDoneAmount()),"%")
        cell.titleLabel.text = task.name
        
        //cell.contentsTextView.setupText(task.getTotalDoneAmount(), total: task.amount, unit: task.unit)
        
        //cell.contentsLabel.text = task.getDoneAmountString()
        
        /*
        if let isDayValid = day {
            
            cell.contentsLabel.text = day.getProgressString()
            cell.percentLabel.text = String(format: "%lu%@", Int(day.done_amount.floatValue/day.expect_amount.floatValue * 100),"%")
            cell.percentLayer.strokeColor = day.getColor().CGColor
            cell.percentLayer.strokeEnd = CGFloat(day.done_amount.floatValue/day.expect_amount.floatValue)
            cell.percentLabel.textColor = day.getColor()
            //cell.colorBoxView.backgroundColor = UIColor.colorWithHexString(task.category_id.color)
        }else{
            
            cell.contentsLabel.text = "공부 시작 전입니다"
        }
        
        */
        
        
        return cell
    }
    
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 49*ratio
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        todaitNavBar.todaitDelegate = self
        todaitNavBar.backButton.hidden = false
        
        self.titleLabel.text = titleString
        self.screenName = "Progress Activity"
        setNavigationBarColor(mainColor)
    }
    
    func backButtonClk(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
}
