//
//  TimeTableViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 5..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit
import CoreData

class TimeTableViewController: BasicViewController,TodaitNavigationDelegate{

    var timeTableView: UIScrollView!
    
    
    let TimeTableHeight:CGFloat = 55
    
    let HistoryViewOriginX:CGFloat = 50
    let HistoryViewWidth:CGFloat = 220
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var timeHistoryList:[TimeHistory] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addTimeTableView()
        addTimeTableSubViews()
        addGesture()
        
        loadTimeHistory()
        
    }
    

    func addTimeTableView(){
        
        timeTableView = UIScrollView(frame: CGRectMake(0, navigationHeight*ratio, width, height-navigationHeight*ratio))
        timeTableView.contentSize = CGSizeMake(width,27*TimeTableHeight*ratio)
        timeTableView.backgroundColor = UIColor.whiteColor()
        
        view.addSubview(timeTableView)
    }
    
    func addTimeTableSubViews(){
        
        let dateForm = NSDateFormatter()
        dateForm.dateFormat = "a H"
        
        let timeComp = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitHour, fromDate:NSDate())
        
        for i in 1...25 {
            
            timeComp.hour = i-1
            
            let timeLabel = UILabel(frame: CGRectMake(15*ratio, TimeTableHeight * CGFloat(i)*ratio,50*ratio,TimeTableHeight*ratio))
            timeLabel.text = dateForm.stringFromDate(NSCalendar.currentCalendar().dateFromComponents(timeComp)!)
            timeLabel.textAlignment = NSTextAlignment.Left
            timeLabel.textColor = UIColor.colorWithHexString("#969696")
            timeLabel.font = UIFont(name: "AvenirNext-Regular", size: 10*ratio)
            timeTableView.addSubview(timeLabel)
            
            
            let timeLineView = UIView(frame: CGRectMake(50*ratio, TimeTableHeight * CGFloat(i)*ratio, 220*ratio, 1*ratio))
            timeLineView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)
            timeTableView.addSubview(timeLineView)
        }
    }
    
    
    
    
    
    
    
    
    func addGesture(){
        
        let longGesture = UILongPressGestureRecognizer(target:self,action:"longPress")
        timeTableView.addGestureRecognizer(longGesture)
    }
    
    func longPress(){
        NSLog("longPress",0)
    }
    
    
    func loadTimeHistory(){
        
        let entityDescription = NSEntityDescription.entityForName("TimeHistory",inManagedObjectContext:managedObjectContext!)
        
        let request = NSFetchRequest()
        request.entity = entityDescription
        
        var error: NSError?
        timeHistoryList = managedObjectContext?.executeFetchRequest(request, error: &error) as! [TimeHistory]
        
        addHistoryView()
    }

    func addHistoryView(){
        
        for historyItem in timeHistoryList {
            
            let originX:CGFloat = HistoryViewOriginX*ratio
            let originY = getHistoryOriginY(historyItem)
            let width = HistoryViewWidth*ratio
            let height = getHistoryHeight(historyItem)
            let color = historyItem.getColor()
            
            let historyView = UIView(frame:CGRectMake(originX,originY,width,height))
            historyView.backgroundColor = color
            historyView.alpha = 0.5
            historyView.layer.cornerRadius = 4*ratio
            historyView.clipsToBounds = true
            
            timeTableView.addSubview(historyView)
            
        }
    }
    
    func getHistoryHeight(history:TimeHistory)->CGFloat{
        
        return CGFloat(history.getHistoryTime()) * TimeTableHeight * ratio / (60*60)
    }
    
    
    func getHistoryOriginY(history:TimeHistory)->CGFloat{
        
        let dateComps = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitHour|NSCalendarUnit.CalendarUnitMinute|NSCalendarUnit.CalendarUnitSecond, fromDate:history.started_at)
        
        
        return getHeightFromComps(dateComps)
    }
    
    func getHeightFromComps(comps:NSDateComponents)->CGFloat{
        
        if comps.hour == 0 && comps.minute == 0 {
            return 10*ratio
        }
        
        return getHeightFromHour(comps.hour) + getHeightFromMinute(comps.minute)
        
    }
    
    func getHeightFromHour(hour:Int)->CGFloat{
        
        return TimeTableHeight * ratio * CGFloat(hour)
    }
    
    func getHeightFromMinute(minute:Int)->CGFloat{
        
        return TimeTableHeight * ratio * CGFloat(minute) / 60
    }
    
    
 
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        NSLog("touchesBegan", 0)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        todaitNavBar.todaitDelegate = self
        todaitNavBar.backButton.hidden = false
        todaitNavBar.shadowImage = UIImage()
        self.titleLabel.text = "Time Table"
        
        self.screenName = "TimeTable Activity"
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func backButtonClk() {
        self.navigationController?.popViewControllerAnimated(true)
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
