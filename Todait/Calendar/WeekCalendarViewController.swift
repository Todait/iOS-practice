//
//  WeekCalendarViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 24..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit




class WeekCalendarViewController: BasicViewController,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{

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
        
        weekView = UICollectionView(frame: CGRectMake(0, 0, width, 48*ratio), collectionViewLayout:layout)
      
        weekView.registerClass(WeekCalendarCell.self, forCellWithReuseIdentifier: "weekCell")
        weekView.backgroundColor = UIColor.clearColor()
        weekView.delegate = self
        weekView.dataSource = self
        weekView.pagingEnabled = true
        weekView.showsHorizontalScrollIndicator = false
        weekView.contentOffset = CGPointMake(500*width, weekView.contentOffset.y)
        
        view.addSubview(weekView)
        
    }
    
    func setSelectedDateNumber(dateNumber:NSNumber){
       
        
        self.dateNumber = dateNumber
        
        
        var newDate = getDateFromDateNumber(self.dateNumber)
        var oldDate = getFirstDateOfWeek(getCurrentDate(selectedIndex))
        
        var scrollCount = getNumberOfWeekViewScrollCount(oldDate, to: newDate)
        
        
        var newIndexPath = NSIndexPath(forRow: selectedIndex.row + Int(scrollCount), inSection: 0)
        weekView.scrollToItemAtIndexPath(newIndexPath, atScrollPosition: UICollectionViewScrollPosition.Right, animated: false)
        
        
        
        if let check = weekView.cellForItemAtIndexPath(selectedIndex) as? WeekCalendarCell {
            
            var cell = weekView.cellForItemAtIndexPath(selectedIndex) as! WeekCalendarCell
            
            for index in 0...6 {
                var button = cell.buttons[index]
                if button.dateNumber == dateNumber {
                    button.backgroundColor = UIColor.todaitWhiteGray()
                }else{
                    button.backgroundColor = UIColor.whiteColor()
                }
                button.updateChart(CGFloat(rand()%100)/100)
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
        return 1000
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
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("weekCell", forIndexPath: indexPath) as! WeekCalendarCell
        
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
            let button = cell.buttons[index]
            button.delegate = self.delegate
            button.dateNumber = getDateNumberFromDate(currentDate)
            button.setTitle(dateForm.stringFromDate(currentDate), forState: UIControlState.Normal)
            
            if dateNumber == button.dateNumber {
                button.backgroundColor = UIColor.todaitWhiteGray()
            }else{
                button.backgroundColor = UIColor.whiteColor()
            }
            button.updateChart(CGFloat(rand()%100)/100)
        }
        
        
        
        return cell
        
    }
    
    func getCurrentDate(indexPath:NSIndexPath)->NSDate{
        
        var adjustDate = getAdjustDate(NSDate())
        NSLog("Week %@",adjustDate.addWeek(Int(indexPath.row - 500)))
        return adjustDate.addWeek(Int(indexPath.row - 500))
    }
    
    func getAdjustDate(date:NSDate)->NSDate{
        
        return getDateFromDateNumber(getDateNumberFromDate(date))
    }
    
    
    func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        
        return false
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake(width, 48*ratio)
        
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
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        NSLog("위크크크 %f %f",scrollView.contentOffset.x,scrollView.contentOffset.y)
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
