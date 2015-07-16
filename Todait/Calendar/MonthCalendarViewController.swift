//
//  monthCalendarViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 24..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

protocol CalendarDelegate: NSObjectProtocol {
    
    func updateDate(date:NSDate,from:String)
    
}

class MonthCalendarViewController: BasicViewController,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    
    var monthView:UICollectionView!
    var selectedIndex:NSIndexPath! = NSIndexPath(forRow: 0, inSection: 0)
    var delegate:CalendarDelegate!
    var dateNumber:NSNumber!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRatio()
        addMonthView()
        
        
    }
    
    func setSelectedDateNumber(dateNumber:NSNumber){
        self.dateNumber = dateNumber
    
        
        var toDate = getDateFromDateNumber(self.dateNumber)
        var fromDate = getOneDayOfMonth(getCurrentDate(selectedIndex))
        var scrollCount = getNumberOfWeekViewScrollCount(fromDate,to:toDate)
        var newIndexPath = NSIndexPath(forRow: selectedIndex.row + Int(scrollCount), inSection: 0)
        monthView.scrollToItemAtIndexPath(newIndexPath, atScrollPosition: UICollectionViewScrollPosition.Right, animated: false)
        
        
        
        
        
        if let check = monthView.cellForItemAtIndexPath(selectedIndex) as? MonthCalendarCell {
            var cell = monthView.cellForItemAtIndexPath(selectedIndex) as! MonthCalendarCell
            
            for index in 0...41 {
                
                var button = cell.buttons[index]
                if button.dateNumber == dateNumber {
                    button.backgroundColor = UIColor.todaitWhiteGray()
                }else{
                    button.backgroundColor = UIColor.whiteColor()
                }
            }
        }
    }
    
    
    func getNumberOfWeekViewScrollCount(from:NSDate,to:NSDate)->NSNumber{
        var fromDateNumber = getDateNumberFromDate(from)
        var toDateNumber = getDateNumberFromDate(to)
        
        var dateForm = NSDateFormatter()
        dateForm.dateFormat = "M"
        
        if  dateForm.stringFromDate(from) != dateForm.stringFromDate(to) {
            
            if toDateNumber.integerValue > fromDateNumber.integerValue {
                NSLog("return 1", 0)
                return 1
            }else if toDateNumber.integerValue < fromDateNumber.integerValue {
                NSLog("return -1", 0)
                return -1
            }
        }
        
        NSLog("return 0", 0)
        
        return 0
    }
    
    func setupRatio(){
        let screenRect = UIScreen.mainScreen().bounds
        let screenWidth = screenRect.size.width
        ratio = screenWidth/320
    }
    
    
    func addMonthView(){
        
        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        monthView = UICollectionView(frame: CGRectMake(0, 0, width, 48*6*ratio), collectionViewLayout:layout)
        
        monthView.registerClass(MonthCalendarCell.self, forCellWithReuseIdentifier: "monthCell")
        monthView.backgroundColor = UIColor.clearColor()
        monthView.delegate = self
        monthView.dataSource = self
        monthView.pagingEnabled = true
        monthView.showsHorizontalScrollIndicator = false
        monthView.contentInset = UIEdgeInsetsZero
        monthView.contentOffset = CGPointMake(width * 500, monthView.contentOffset.y)
        
        view.addSubview(monthView)
        
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1000
    }
    
    
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        
        if indexPath.row != selectedIndex.row {
            if self.delegate.respondsToSelector("updateDate:from:"){
                NSLog("Month Delegate", 1)
                
                var newDate = getOneDayOfMonth(getCurrentDate(selectedIndex))
                dateNumber = getDateNumberFromDate(newDate)
                self.delegate.updateDate(newDate,from:"Month")
            }
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        NSLog("Month cellforrow", 1)
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("monthCell", forIndexPath: indexPath) as! MonthCalendarCell
        
        var monthDate = getCurrentDate(indexPath)
        var date = getFirstDateOfMonth(getCurrentDate(indexPath))
        var dateForm = NSDateFormatter()
        var currentDate = date
        
        selectedIndex = indexPath
        
        dateForm.dateFormat = "d"
        
        var monthForm = NSDateFormatter()
        monthForm.dateFormat = "M"
        var month = monthForm.stringFromDate(monthDate)
        
        
        for var index = 0 ; index < 42 ; index++ {
            
            currentDate = date.addDay(index)
            let button = cell.buttons[index]
            button.delegate = self.delegate
            button.setTitle(dateForm.stringFromDate(currentDate), forState: UIControlState.Normal)
            button.dateNumber = getDateNumberFromDate(currentDate)
            
            
            if monthForm.stringFromDate(currentDate) == month {
                button.setTitleColor(UIColor.todaitGray(), forState: UIControlState.Normal)
            }else{
                button.setTitleColor(UIColor.todaitLightGray(), forState: UIControlState.Normal)
            }
            
            if dateNumber == button.dateNumber {
                button.backgroundColor = UIColor.todaitWhiteGray()
            }else{
                button.backgroundColor = UIColor.whiteColor()
            }
        }
        
        return cell
        
    }
    
    func getAdjustIndexPath(indexPath:NSIndexPath)->NSIndexPath {
        
        let row:Int = Int((indexPath.row)/6)
        let value = row + (indexPath.row%6) * 7
        
        return NSIndexPath(forRow: value, inSection: indexPath.section)
    }
    
    
    func getDayOfIndexPath(indexPath:NSIndexPath)->String{
        
        
        var date = getFirstDateOfMonth(getCurrentDate(indexPath))
        var currentDate = date.addDay(indexPath.row)
        
        var dateForm = NSDateFormatter()
        dateForm.dateFormat = "d"
        
        return dateForm.stringFromDate(currentDate)
        
    }
    
    func getCurrentDate(indexPath:NSIndexPath)->NSDate{
        
        var adjustDate = getAdjustDate(NSDate())
        
        return adjustDate.addMonth(Int(indexPath.row - 500))
    }
    
    func getAdjustDate(date:NSDate)->NSDate{
        
        return getDateFromDateNumber(getDateNumberFromDate(date))
    }
    
    
    func getOneDayOfMonth(date:NSDate)->NSDate{
        
        var adjustDate = getAdjustDate(date)
        
        let firstDayOfMonthComp = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitYear|NSCalendarUnit.CalendarUnitMonth|NSCalendarUnit.CalendarUnitDay|NSCalendarUnit.CalendarUnitWeekday|NSCalendarUnit.CalendarUnitHour, fromDate:adjustDate)
        firstDayOfMonthComp.day = 1
        firstDayOfMonthComp.hour = 5
        
        var firstDate:NSDate = NSCalendar.currentCalendar().dateFromComponents(firstDayOfMonthComp)!
        
        return firstDate
    }
    
    func getFirstDateOfMonth(date:NSDate)->NSDate{
        
        let firstDayOfMonthComp = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitYear|NSCalendarUnit.CalendarUnitMonth|NSCalendarUnit.CalendarUnitDay|NSCalendarUnit.CalendarUnitWeekday|NSCalendarUnit.CalendarUnitHour, fromDate:date)
        firstDayOfMonthComp.day = 1
        firstDayOfMonthComp.hour = 11
        firstDayOfMonthComp.minute = 59
        
        var firstDate:NSDate = NSCalendar.currentCalendar().dateFromComponents(firstDayOfMonthComp)!
        
        let weekDayComp = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitWeekday, fromDate: firstDate)
        let firstOfWeek = weekDayComp.weekday
        
        firstDate = firstDate.addDay(1-firstOfWeek)
        
        return firstDate
    }
    
    
    
    func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        collectionView.reloadItemsAtIndexPaths([selectedIndex])
        selectedIndex = indexPath
        collectionView.reloadItemsAtIndexPaths([indexPath])
        
        return false
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake(width,288*ratio)
    
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