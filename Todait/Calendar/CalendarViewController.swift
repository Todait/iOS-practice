//
//  CalendarViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 3..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class CalendarViewController: BasicViewController,UITableViewDataSource,UITableViewDelegate {
    
    var calendarTableView: UITableView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addCalendarTableView()
        
    }
    
    func addCalendarTableView(){
        
        calendarTableView = UITableView(frame: CGRectMake(0,navigationHeight*ratio,width,300*ratio), style: UITableViewStyle.Grouped)
        calendarTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        calendarTableView.contentInset = UIEdgeInsetsMake(-20*ratio, 0, 0, 0)
        calendarTableView.delegate = self
        calendarTableView.dataSource = self
        calendarTableView.contentOffset.y = 0
        view.addSubview(calendarTableView)
        
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 300*ratio
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        
        
        for view in cell.contentView.subviews{
            view.removeFromSuperview()
        }
        
        for i in 0...42 {
            
            var dayButton = UIButton()
            dayButton.frame = calculateDayCellFrame(NSDate())
            dayButton.backgroundColor = UIColor.colorWithHexString("969696")
            cell.contentView.addSubview(dayButton)
            
        }
        
        
        
        
        return cell
    }
    
    func calculateDayCellFrame(date:NSDate)->CGRect {
        return CGRectMake(0, 0, 42, 42)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
