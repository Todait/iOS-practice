//
//  WeekCalendarViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 24..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit
import CoreData




class DetailWeekCalendarViewController: BasicViewController,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    
    var weekView:UICollectionView!
    var selectedIndex:NSIndexPath! = NSIndexPath(forRow: 0, inSection: 0)
    var delegate:CalendarDelegate?
    var dateNumber:NSNumber!
    
    var task:Task!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRatio()
        
        
        addweekView()
        
        //self.collectionView?.setCollectionViewLayout(flowLayout, animated: false)
        //self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Do any additional setup after loading the view.
    }
    
    func setupRatio(){
        let screenRect = UIScreen.mainScreen().bounds
        let screenWidth = screenRect.size.width
        ratio = screenWidth/320
    }
    
    
    func addweekView(){
        
        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        weekView = UICollectionView(frame: CGRectMake(0, 0, width, 49*ratio), collectionViewLayout:layout)
        
        weekView.registerClass(DetailWeekCalendarCell.self, forCellWithReuseIdentifier: "weekCell")
        weekView.backgroundColor = UIColor.clearColor()
        weekView.delegate = self
        weekView.dataSource = self
        weekView.pagingEnabled = true
        weekView.showsHorizontalScrollIndicator = false
        weekView.contentOffset = CGPointMake(100*width, weekView.contentOffset.y)
        
        view.addSubview(weekView)
        
    }
    
    
    
    
    func setSelectedDateNumber(dateNumber:NSNumber){
        
        
        self.dateNumber = dateNumber
        
        
        var newDate = getDateFromDateNumber(self.dateNumber)
        var oldDate = getFirstDateOfWeek(getCurrentDate(selectedIndex))
        
        var scrollCount = getNumberOfWeekViewScrollCount(oldDate, to: newDate)
        
        
        var newIndexPath = NSIndexPath(forRow: selectedIndex.row + Int(scrollCount), inSection: 0)
        weekView.scrollToItemAtIndexPath(newIndexPath, atScrollPosition: UICollectionViewScrollPosition.Right, animated: false)
        
        let todayDateNumber:NSNumber! = getTodayDateNumber()
        
        if let cell = weekView.cellForItemAtIndexPath(selectedIndex) as? DetailWeekCalendarCell {
            
            for index in 0...6 {
                
                var button = cell.buttons[index]
                
                if button.dateNumber == dateNumber {
                    button.backgroundColor = UIColor.todaitBlue().colorWithAlphaComponent(0.05)
                }else{
                    button.backgroundColor = UIColor.whiteColor()
                }
            }
        }
    }
    
    func getNumberOfWeekViewScrollCount(from:NSDate,to:NSDate)->NSNumber{
        
        var firstDateOfFrom = getFirstDateOfWeek(from)
        var firstDateOfTo = getFirstDateOfWeek(to)
        
        return Int(firstDateOfTo.timeIntervalSinceDate(firstDateOfFrom) / (7*24*60*60))
    }
    
    func getFirstDateOfWeek(date:NSDate)->NSDate{
        
        var adjustDate = getDateFromDateNumber(getDateNumberFromDate(date))
        
        let firstDayOfMonthComp = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitYear|NSCalendarUnit.CalendarUnitMonth|NSCalendarUnit.CalendarUnitDay|NSCalendarUnit.CalendarUnitWeekday|NSCalendarUnit.CalendarUnitHour|NSCalendarUnit.CalendarUnitWeekOfMonth, fromDate:date)
        
        var firstDate:NSDate = NSCalendar.currentCalendar().dateFromComponents(firstDayOfMonthComp)!
        
        
        let weekDayComp = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitWeekday, fromDate: firstDate)
        let firstOfWeek = weekDayComp.weekday
        
        
        firstDate = firstDate.addDay(1-firstOfWeek)
        
        return firstDate
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 200
    }
    
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row != selectedIndex.row {
            
            if let delegate = delegate {
                if delegate.respondsToSelector("updateDate:from:"){
                    
                    var newDate = getCurrentDate(selectedIndex)
                    dateNumber = getDateNumberFromDate(newDate)
                    delegate.updateDate(newDate,from:"Week")
                }
            }
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("weekCell", forIndexPath: indexPath) as! DetailWeekCalendarCell
        
        var monthDate = getCurrentDate(indexPath)
        
        var date = getFirstDateOfWeek(getCurrentDate(indexPath))
        var dateForm = NSDateFormatter()
        var currentDate = date
        
        selectedIndex = indexPath
        
        dateForm.dateFormat = "d"
        
        var monthForm = NSDateFormatter()
        monthForm.dateFormat = "M"
        var month = monthForm.stringFromDate(monthDate)
        
        
        for var index = 0 ; index < 7 ; index++ {
            
            currentDate = date.addDay(index)
            let currentDateNumber = getDateNumberFromDate(currentDate)
            let button = cell.buttons[index]
            button.delegate = self.delegate
            button.dateNumber = currentDateNumber
            
            let label = cell.dayLabels[index]
            label.text = dateForm.stringFromDate(currentDate)
            
            
            
            let todayDateNumber:NSNumber! = getTodayDateNumber()
            
            
            if let currentDay = task.getDay(currentDateNumber) {
                

                if currentDay.expectAmount <= currentDay.doneAmount {
                    
                    button.setDateStatus(DateStatus.Completed)
                    button.expectLabel.text = "\(currentDay.doneAmount)"
                    
                    if currentDateNumber == getTodayDateNumber() {
                        button.setDateStatus(DateStatus.Complete)
                    }
                    
                }else{
                     button.setDateStatus(DateStatus.UnCompleted)
                    button.expectLabel.text = "\(currentDay.expectAmount)"
                    
                    if currentDateNumber == getTodayDateNumber() {
                        button.setDateStatus(DateStatus.Progressing)
                    }
                    
                }
                
                
                if currentDateNumber > getTodayDateNumber() {
                    
                    button.expectLabel.textColor = UIColor.todaitDarkGray()
                    button.setDateStatus(DateStatus.UnStart)
                    
                }else{
                    button.expectLabel.textColor = UIColor.whiteColor()
                }
                
            }else{
                
                button.expectLabel.textColor = UIColor.whiteColor()
                button.expectLabel.text = ""
                button.setDateStatus(DateStatus.None)
            }
            
            
            if button.dateNumber == dateNumber {
                button.backgroundColor = UIColor.todaitBlue().colorWithAlphaComponent(0.05)
            }else{
                button.backgroundColor = UIColor.whiteColor()
            }
        }
        
        return cell
    }
    
    func getCurrentDate(indexPath:NSIndexPath)->NSDate{
        
        var adjustDate = getAdjustDate(NSDate())
        
        return adjustDate.addWeek(Int(indexPath.row - 100))
    }
    
    func getAdjustDate(date:NSDate)->NSDate{
        
        return getDateFromDateNumber(getDateNumberFromDate(date))
    }
    
    
    func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        
        return false
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake(width, 49*ratio)
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        return 0*ratio
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSizeZero
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeZero
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        todaitNavBar.hidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
