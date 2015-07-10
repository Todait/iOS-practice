//
//  monthCalendarViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 24..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit




class MonthCalendarViewController: BasicViewController,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    
    var monthView:UICollectionView!
    var selectedIndex:NSIndexPath! = NSIndexPath(forRow: 0, inSection: 0)
    var delegate:CalendarDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRatio()
        addMonthView()
        
        
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
        monthView.contentOffset = CGPointMake(width * 500, monthView.contentOffset.y)
        
        view.addSubview(monthView)
        
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1000
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 42
    }
    
    
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        /*
        if indexPath.section != selectedIndex.section {
            if self.delegate.respondsToSelector("updateMonth:"){
                self.delegate.updateMonth(getCurrentDate(selectedIndex))
            }
        }
        */
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("monthCell", forIndexPath: indexPath) as! MonthCalendarCell
        
        var adjustIndexPath = getAdjustIndexPath(indexPath)
        cell.dayLabel.text = getDayOfIndexPath(adjustIndexPath)
        selectedIndex = indexPath
        
        
        
        if selectedIndex == indexPath {
            cell.backgroundColor = UIColor.todaitLightGray()
        }else{
            cell.backgroundColor = UIColor.whiteColor()
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
        
        return adjustDate.addMonth(Int(indexPath.section - 500))
    }
    
    func getAdjustDate(date:NSDate)->NSDate{
        
        return getDateFromDateNumber(getDateNumberFromDate(date))
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
        
        return CGSizeMake(width/7, 48*ratio)
        
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
