//
//  MainViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 1..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit
import CoreData
import Photos
import Alamofire

class MainViewController: BasicViewController,UITableViewDataSource,UITableViewDelegate,TaskTableViewCellDelegate,UpdateDelegate,touchDelegate,CategoryUpdateDelegate{
    
    var parallelView: ParallelHeaderView!
    var mainTableView: UITableView!
    var createTaskButton: UIButton!
    var settingButton: UIButton!
    var listButton: UIButton!
    
    var timer: NSTimer!
    
    var remainingTime: NSTimeInterval! = 24*60*60
    
    var homeButton: UIButton!
    var calendarButton: UIButton!
    var timeTableButton: UIButton!
    var statisticsButton: UIButton!
    var photoButton: UIButton!
    var profileButton: UIButton!
    
    let headerHeight: CGFloat = 212
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var timeChart:TimeChart!
    var timeValue:[CGFloat] = []
    
    var isShowAllCategory:Bool = true
    var category:Category!
    var dayData:[Day] = []
    var taskData:[Task] = []
    
    var taskTestCount:NSTimeInterval = 0
    
    
    
    var tabbarView:UIView!
    var logoImageView:UIImageView!
    
    var mainCategoryVC:MainCategoryViewController!
    var mainCategoryCollectionVC:MainCategoryCollectionViewController!

    var isDeleteAnimation:Bool = false
    
    func needToUpdate(){
        
        loadTaskData()
        loadDayData()
        mainTableView.reloadData()
        
        updateMainPhoto()
        updateText()
    }
    
    func updateMainPhoto(){
        
        let localIdentifier = defaults.objectForKey("mainPhoto")
        
        if let check = localIdentifier {
            
            let assetResult = PHAsset.fetchAssetsWithLocalIdentifiers([localIdentifier!], options: nil)
            let imageManager = PHCachingImageManager()
            
            
            if assetResult.count != 0 {
                assetResult.enumerateObjectsUsingBlock { (object, Int, Bool) -> Void in
                    
                    
                    let asset:PHAsset = object as! PHAsset
                    
                    
                    imageManager.requestImageForAsset(asset, targetSize: CGSizeMake(self.width,250*self.ratio), contentMode: PHImageContentMode.AspectFill, options: nil) {(image, info) -> Void in
                        self.parallelView.backgroundImageView.image = image
                    }
                    
                }
            }
        }
    }
    
    func updateText(){
        
        let dateForm = NSDateFormatter()
        dateForm.dateFormat = "yyyy.MM.dd"
        
        var todayDate:NSDate = getDateFromDateNumber(getTodayDateNumber())
        parallelView.dateLabel.text = dateForm.stringFromDate(todayDate)
        parallelView.studyTimeLabel.text = getTotalTimeStringOfToday()
        parallelView.completionRateLabel.text = getTotalPercentStringOfToday()
    }
    
    func updateAllCategory(){
        
        if let check = self.title {
            self.titleLabel.text = "Todait"

        }
        
        if let check = timeChart {
            timeChart.chartColor = UIColor.todaitGreen()
            timeChart.updateChart(timeValue)
            parallelView.backgroundColor = UIColor.todaitGreen()
        }
        
        if let check = createTaskButton {
            let backgroundImage = UIImage.colorImage(UIColor.todaitGreen(), frame: CGRectMake(0, 0, 50*ratio, 50*ratio))
            createTaskButton.setBackgroundImage(backgroundImage, forState: UIControlState.Normal);
        }
    
        
        isShowAllCategory = true
       
        loadTaskData()
        loadDayData()
        
        if let check = mainTableView {
            mainTableView.reloadData()
        }
        
        if let check = parallelView {
            updateText()
        }
       
        
    }
    
    func updateCategory(category:Category,from:String){
        
        loadTaskData()
        loadDayData()
        
        if let check = mainTableView {
            mainTableView.reloadData()
        }
        
        if let check = parallelView {
            updateText()
        }
        
        if from == "NewTaskVC" {
            
            showCompleteAddPopup()
        }
    }
    
    func showCompleteAddPopup(){
        
        
        let popCircle = UIView(frame: CGRectMake(0, 0, 80*ratio, 80*ratio))
        popCircle.backgroundColor = UIColor.colorWithHexString(category.color)
        popCircle.center = view.center
        popCircle.clipsToBounds = true
        popCircle.layer.cornerRadius = 40*ratio
        
        view.addSubview(popCircle)
        
        
        let popUp = UILabel(frame: CGRectMake(0, 0, 80*ratio,80*ratio))
        popUp.backgroundColor = UIColor.clearColor()
        popUp.textColor = UIColor.whiteColor()
        popUp.textAlignment = NSTextAlignment.Center
        popUp.text = "추가되었다"
        popUp.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 4*ratio)
        popUp.center = view.center
        
        view.addSubview(popUp)
        
        
        UIView.animateWithDuration(0.4, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            popCircle.transform = CGAffineTransformMakeScale(1.2, 1.2)
            popUp.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 16*self.ratio)
            
            }) { (Bool) -> Void in
                
                
                UIView.animateWithDuration(1.1, animations: { () -> Void in
                    
                    }, completion: { (Bool) -> Void in
                        
                        popCircle.removeFromSuperview()
                        popUp.removeFromSuperview()
                })
                
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //createTestData()
        
        addParallelView()
        addMainTableView()
        
        
        
        calculateRemainingTime()
        setupCoreDataInit()
        
        loadTaskData()
        loadDayData()
        mainTableView.reloadData()
        
        
        addListView()
    
    }
    
    func createTestData(){
        
        let categoryED = NSEntityDescription.entityForName("Category", inManagedObjectContext:managedObjectContext!)
        
        
        
        for index in 0...9 {
            
            
            let name:String = String.categoryTestNameAtIndex(index)
            let color:String = String.categoryColorStringAtIndex(index)
            
            let category = Category(entity:categoryED!,insertIntoManagedObjectContext:managedObjectContext!)
            
            category.name = name
            category.color = color
            category.createdAt = NSDate()
            
            
            createTestTask(category)
        
        }
        
        var error: NSError?
        managedObjectContext?.save(&error)
    }
    
    func createTestTask(category:Category){
        
        let taskED = NSEntityDescription.entityForName("Task", inManagedObjectContext:managedObjectContext!)
        
        for index in 0...15 {
            
            let name:String = String.categoryTestNameAtIndex(Int(rand()%20))
            let color:String = String.categoryColorStringAtIndex(Int(rand()%20))
            
            
            let task = Task(entity:taskED!,insertIntoManagedObjectContext:managedObjectContext!)
            task.name = name
            task.createdAt = NSDate()
            task.priority = NSDate().timeIntervalSince1970 + taskTestCount
            task.unit = "회"
            task.taskType = String.taskTestTaskType(Int(rand()%4))
            task.startDate = 20150804
            task.endDate = 20150804
            task.categoryId = category
            createTestWeek(task)
            
            taskTestCount = taskTestCount + 1
        }
        
    }
    
    func createTestWeek(task:Task){
        
        let weekED = NSEntityDescription.entityForName("Week", inManagedObjectContext:managedObjectContext!)
        
        let week = Week(entity:weekED!,insertIntoManagedObjectContext:managedObjectContext!)
        
        week.taskId = task
        week.mon = Int(rand()%10000)
        week.sun = Int(rand()%20000)
        week.wed = Int(rand()%20000)
        week.thu = Int(rand()%20000)
        week.tue = Int(rand()%20000)
        week.sat = Int(rand()%20000)
        week.fri = Int(rand()%10000)
        
    }
    
    
    func addParallelView(){
        parallelView = ParallelHeaderView(frame: CGRectMake(0, 0, width, headerHeight*ratio))
        parallelView.backgroundColor = UIColor.colorWithHexString("#00D2B1")
        parallelView.backgroundImageView.clipsToBounds = true
        parallelView.backgroundImageView.contentMode = UIViewContentMode.ScaleAspectFill
       
        
        
    }
    
    func getPositionAtDate(date:NSDate)->CGFloat{
        
        
        let todayStartTime = getTodayStartTime()
        let diffTime = date.timeIntervalSinceDate(todayStartTime)
        
        return CGFloat(diffTime) * 290*ratio/(24*60*60)
    }
    
    func getTodayStartTime()->NSDate{
    
        let todayDate = NSDate()
        let dateComp = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitYear|NSCalendarUnit.CalendarUnitMonth|NSCalendarUnit.CalendarUnitDay|NSCalendarUnit.CalendarUnitWeekday|NSCalendarUnit.CalendarUnitSecond, fromDate:todayDate)
        dateComp.minute = defaults.integerForKey("finishMinuteOfDay")
        dateComp.hour = defaults.integerForKey("finishHourOfDay")
        dateComp.second = dateComp.second + 1
    
        return NSCalendar.currentCalendar().dateFromComponents(dateComp)!
    }
    
    
    
    func getMainAmountLogData()->[CGFloat]{
        
        
        
        let dayCount = dayData.count
        
        for index in 0 ... dayCount {
            
            if dayCount-1 == index {
                break
            }
            
        }
        
        return [1]
    }
    
    func touchBegin() {
        

        mainTableView.scrollEnabled = false
    }
    
    func touchEnd() {
        
        
        mainTableView.scrollEnabled = true
    }
    
    func addMainTableView(){
        
        mainTableView = UITableView(frame: CGRectMake(0,navigationHeight ,width,height - navigationHeight - 47*ratio), style: UITableViewStyle.Grouped)
        
        mainTableView.registerClass(TaskTableViewCell.self, forCellReuseIdentifier: "mainCell")
        mainTableView.registerClass(TimerTaskTableViewCell.self, forCellReuseIdentifier: "timerCell")
        mainTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "emptyCell")
        mainTableView.registerClass(UncompletedTableViewCell.self, forCellReuseIdentifier:"uncompletedCell")
        
        mainTableView.bounces = false
        mainTableView.contentInset = UIEdgeInsetsMake(-20*ratio, 0, 0, 0)
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.contentOffset.y = 0
        mainTableView.separatorStyle = UITableViewCellSeparatorStyle.None

        view.addSubview(mainTableView)
        
    }
    
    func addTaskButton(){
        
        
        let backgroundImage = UIImage.colorImage(UIColor.colorWithHexString("#00D2B1"), frame: CGRectMake(0, 0, 30*ratio, 30*ratio))
        
        createTaskButton = UIButton(frame: CGRectMake(145*ratio,height-39.5*ratio, 30*ratio, 30*ratio))
        createTaskButton.setBackgroundImage(backgroundImage, forState: UIControlState.Normal);
        createTaskButton.setTitle("+", forState: UIControlState.Normal)
        createTaskButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        createTaskButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 30*ratio)
        createTaskButton.clipsToBounds = true
        createTaskButton.layer.cornerRadius = 15*ratio
        createTaskButton.layer.borderColor = UIColor.whiteColor().CGColor
        createTaskButton.layer.borderWidth = 1*ratio
        createTaskButton.addTarget(self, action: Selector("showNewTaskVC"), forControlEvents: UIControlEvents.TouchUpInside)
        
        view.addSubview(createTaskButton)
    }
    
    
    func addTabbarView(){
        
        let tabbarView = UIView(frame: CGRectMake(0, height-47*ratio, width, 47*ratio))
        tabbarView.backgroundColor = UIColor.whiteColor()
        view.addSubview(tabbarView)
        
    }
    
    
    func addPhotoButton(){
        
        photoButton = UIButton(frame: CGRectMake(280*ratio, 100*ratio, 24*ratio, 24*ratio))
        photoButton.setBackgroundImage(UIImage(named: "ic_camera_button.png"), forState:UIControlState.Normal)
        photoButton.addTarget(self, action: Selector("showPhotoVC"), forControlEvents: UIControlEvents.TouchUpInside)
         view.addSubview(photoButton)
        
    }
    
    func showPhotoVC(){
        
        let mainPhotoVC = MainPhotoViewController()
        
        if isShowAllCategory == true {
            mainPhotoVC.mainColor = UIColor.todaitGreen()
        }else {
            mainPhotoVC.mainColor = UIColor.colorWithHexString(category.color)
        }
        
        
        self.navigationController?.pushViewController(mainPhotoVC, animated: true)
        
    }
    
    func setupTimer(){
        //currentTime = 0
        //totalTime = 0
    }
    
    func timerStart(){
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("countDown"), userInfo: nil, repeats: true)
        countDown()
    }
    
    func countDown(){
        
        if remainingTime > 0{
            remainingTime = remainingTime - 1
        }else{
            calculateRemainingTime()
        }
        
        updateTimeLabel()
        
    }
    
    func stopTimer(){
        timer.invalidate()
    }
    
    func updateTimeLabel(){
        parallelView.remainingTimeLabel.text = "오늘 남은 시간 \(getTimeStringFromSeconds(remainingTime))"
    }
    
    
    
    func calculateRemainingTime(){
        
        var calendar : NSCalendar! = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        calendar.locale = NSLocale.currentLocale()
        
        var nowDateComp = calendar.components(NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitHour | NSCalendarUnit.CalendarUnitMinute | NSCalendarUnit.CalendarUnitSecond, fromDate: NSDate())
        
        remainingTime = calculateSecondsFromNowToLimit(nowDateComp)
    }
    
    
    func calculateSecondsFromNowToLimit(nowDateComp : NSDateComponents) -> NSTimeInterval{
        
        var finishHour = defaults.integerForKey("finishHourOfDay")
        var finishMinute = defaults.integerForKey("finishMinuteOfDay")
        
        if finishHour < 12 || finishHour < nowDateComp.hour{
            finishHour = finishHour + 24
        }
        
        
        return 3600 * (NSTimeInterval(finishHour)-NSTimeInterval(nowDateComp.hour)) + 60 * (NSTimeInterval(finishMinute)-NSTimeInterval(nowDateComp.minute)) - (NSTimeInterval(nowDateComp.second))
    }
    
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String! {
        return getDeleteString()
    }
    
    func setupCoreDataInit(){
        
        let entityDescription = NSEntityDescription.entityForName("Category", inManagedObjectContext: managedObjectContext!)
        let request = NSFetchRequest()
        request.entity = entityDescription
        var error: NSError?
        var results = managedObjectContext?.executeFetchRequest(request, error: &error)
        
        if results?.count == 0 {
            //기본 카테고리를 생성한다.
            makeDefaultCategory()
            setupInitValue()
        }
        
        
    }
    
    func makeDefaultCategory(){
        
        let entityDescription = NSEntityDescription.entityForName("Category", inManagedObjectContext:managedObjectContext!)
        
        let category = Category(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
        category.name = "기본"
        category.createdAt = NSDate()
        category.color = "#FFFB887E"
        category.updatedAt = NSDate()
        
        var error: NSError?
        managedObjectContext?.save(&error)
        
        if let err = error {
            //에러처리
        }else{
            NSLog("Category Default 저장성공",1)
        }
        
    }
    
    func setupInitValue(){
        
        defaults.setInteger(1, forKey: "sortIndex")
        defaults.setInteger(1, forKey: "showIndex")
        
    }
    
    func loadDayData(){
        
        
        dayData.removeAll(keepCapacity: true)
        
        let todayDateNumber = getTodayDateNumber()
        for task in taskData {
            
            let day:Day? = task.getDay(todayDateNumber)
            
            if let validDay = day {
                dayData.append(day!)
            }
        }
        
    }
    
    
    func addListView(){
        
        /*
        mainCategoryVC = MainCategoryViewController()
        addChildViewController(mainCategoryVC)
        mainCategoryVC.view.hidden = true
        mainCategoryVC.view.frame = CGRectMake(235*ratio, 64, 85*ratio, height - 64 - 49*ratio)
        view.addSubview(mainCategoryVC.view)
        */
        
        mainCategoryCollectionVC = MainCategoryCollectionViewController()
        addChildViewController(mainCategoryCollectionVC)
        mainCategoryCollectionVC.view.hidden = true
        mainCategoryCollectionVC.view.frame = CGRectMake(0*ratio, 64, 320*ratio, 55*ratio)
        view.addSubview(mainCategoryCollectionVC.view)
        
    }
    
    
    func loadTaskData(){
        let entityDescription = NSEntityDescription.entityForName("Task",inManagedObjectContext:managedObjectContext!)
        
        let sortIndex = defaults.integerForKey("sortIndex")
        
        let request = NSFetchRequest()
        request.entity = entityDescription
        
        if sortIndex == 1{
            
        }else if sortIndex == 2 {
            request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        }else if sortIndex == 4 {
            request.sortDescriptors = [NSSortDescriptor(key: "categoryId", ascending: true)]
        }else if sortIndex == 8 {
            request.sortDescriptors = [NSSortDescriptor(key: "priority", ascending: true)]
        }
        
        let predicate = NSPredicate(format: "categoryId.hidden == %@",false)
        request.predicate = predicate
        
        var error: NSError?
        taskData = managedObjectContext?.executeFetchRequest(request, error: &error) as! [Task]
        
    }
    
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        addLogoImageView()
        
        
        timerStart()
        //titleLabel.text = "Todait"
        //mainTableView.contentOffset.y = 0
        //parallelView.scrollViewDidScroll(mainTableView)
        calculateRemainingTime()
        
        self.screenName = "Main Activity"
    
        if isShowAllCategory == true {
            updateAllCategory()
        }else{
            updateCategory(category,from:"MainVC")
            self.titleLabel.text = category.name
        }
        
        addListButton()
        addSettingButton()
        needToUpdate()
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("categoryDataMainUpdate"), name: "categoryDataMainUpdate", object: nil)
        
    }
    
    func categoryDataMainUpdate(){
        
        needToUpdate()
        
    }
    
    func addLogoImageView(){
        
        if let logoImageView = logoImageView {
            return
        }
        
        logoImageView = UIImageView(frame: CGRectMake(160*ratio - 27, 35, 54, 14))
        logoImageView.image = UIImage(named: "title_main@3x.png")
        logoImageView.userInteractionEnabled = true
        view.addSubview(logoImageView)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: Selector("saveImage:"))
        logoImageView.addGestureRecognizer(longPress)
    }
    
    
   
    func saveImage(gesture:UILongPressGestureRecognizer){
        
        let imageView = gesture.view as! UIImageView
        UIImageWriteToSavedPhotosAlbum(imageView.image!, nil, nil, nil)
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        stopTimer()
    }
    
    func addSettingButton(){
        settingButton = UIButton(frame: CGRectMake(258*ratio, 30, 24, 24))
        settingButton.setImage(UIImage(named: "setting@2x.png"), forState: UIControlState.Normal)
        settingButton.addTarget(self, action: Selector("showSetting"), forControlEvents: UIControlEvents.TouchUpInside)
        //view.addSubview(settingButton)
    }
    
    
    func showSetting(){
        
        let settingVC = SettingViewController()
        
        if isShowAllCategory == true {
            settingVC.mainColor = UIColor.todaitGreen()
        }else {
            settingVC.mainColor = UIColor.colorWithHexString(category.color)
        }
        
        self.navigationController?.pushViewController(settingVC, animated: true)
    }
    
    func showSortVC(){
        
        let sortVC = SettingMainSortingViewController()
        let navigationVC = UINavigationController(rootViewController: sortVC)
        
        self.navigationController?.presentViewController(navigationVC, animated: true, completion: { () -> Void in
            
        })
        
    }
    
    func addListButton(){
        
        
        if listButton == nil {
            
            listButton = UIButton(frame:CGRectMake(320*ratio - 44 ,20,44,44))
            listButton.setImage(UIImage(named: "bt_hamburger_h@3x.png"),forState: UIControlState.Normal)
            listButton.addTarget(self, action:Selector("showList"), forControlEvents: UIControlEvents.TouchUpInside)
            view.addSubview(listButton)
            
        }
    }
    
    func showList(){
        
        /*
        if mainCategoryVC.view.hidden == true {
            mainCategoryVC.view.hidden = false
        }else{
            mainCategoryVC.view.hidden = true
        }
        */
        if mainCategoryCollectionVC.view.hidden == true {
            
            listButton.setImage(UIImage(named: "bt_closed_h@3x.png"),forState: UIControlState.Normal)
            mainCategoryCollectionVC.view.hidden = false
            
        }else{
            
            listButton.setImage(UIImage(named: "bt_hamburger_h@3x.png"),forState: UIControlState.Normal)
            mainCategoryCollectionVC.view.hidden = true
        }
        
    }
    
    
    func showNewTaskVC(){
        
        performSegueWithIdentifier("ShowNewTaskView", sender: self)
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //let destination = segue.destinationViewController as! NewTaskViewController
        
        
        
        
        if segue.identifier == "ShowTimerView" {
            let timerVC = segue.destinationViewController as! TimerViewController
            let indexPath:NSIndexPath! = sender as! NSIndexPath
            
            let task:Task = taskData[indexPath.row]
            let day:Day! = task.getDay(getTodayDateNumber())
            timerVC.task = task
            timerVC.day = day
            
        }else if segue.identifier == "ShowNewTaskView" {
            let newTaskVC = segue.destinationViewController as! NewTaskViewController
            newTaskVC.delegate = self
            
            if isShowAllCategory == true {
                newTaskVC.mainColor = UIColor.todaitGreen()
                newTaskVC.category = getDefaultCategory()
            }else {
                newTaskVC.mainColor = UIColor.colorWithHexString(category.color)
                newTaskVC.category = category
            }
        }else if segue.identifier == "ShowDetailView" {
            
            let detailVC = segue.destinationViewController as! DetailViewController
            let indexPath:NSIndexPath = sender as! NSIndexPath
            
            detailVC.task = taskData[indexPath.row]
           
        }
    }
    
    func getDefaultCategory()->Category{
        
        let entityDescription = NSEntityDescription.entityForName("Category",inManagedObjectContext:managedObjectContext!)
        
        let request = NSFetchRequest()
        request.entity = entityDescription
        
        var error: NSError?
        let categorys:[Category] = managedObjectContext?.executeFetchRequest(request, error: &error) as! [Category]
        
        if categorys.count != 0 {
            category = categorys.first
        }
        
        return category
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        //0은 미완료 목표
        //1은 일반
        
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if section == 0 {
            return 1
        }
        
        
        
        if taskData.isEmpty && !isDeleteAnimation {
            return 1
        }
        
        
        return taskData.count
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return parallelView
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        if indexPath.section == 0 {
            
            
            let cell = tableView.dequeueReusableCellWithIdentifier("uncompletedCell", forIndexPath: indexPath) as! UncompletedTableViewCell
            
            cell.titleLabel.text = "민법해설 외 2개 목표 미완료"
            cell.contentsLabel.text = "미완료 목표 보기"
            
            return cell
            
        }
        
        
        
        
        if taskData.isEmpty && !isDeleteAnimation {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("emptyCell", forIndexPath: indexPath) as! UITableViewCell
            
            for temp in cell.contentView.subviews{
                temp.removeFromSuperview()
            }
            
            
            let emptyImageView = UIImageView(frame:CGRectMake(0,0,width,272*ratio))
            
            if height == 480 {
                emptyImageView.image = UIImage(named:"bg_nodata4s@3x.png")
            }else{
                emptyImageView.image = UIImage(named:"bg_nodata@3x.png")
            }
            
            cell.contentView.addSubview(emptyImageView)
            
            return cell
            
        }
        
        
        
        
        let task:Task! = taskData[indexPath.row]
        let day:Day? = task.getDay(getTodayDateNumber())
        
        
        
        if task.taskType == "Timer" {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("timerCell", forIndexPath: indexPath) as! TimerTaskTableViewCell
            
            
            for temp in cell.contentView.subviews{
                temp.removeFromSuperview()
            }
            cell.delegate = self
            cell.indexPath = indexPath
            cell.percentLayer.strokeEnd = 0
            cell.percentLayer.strokeColor = UIColor.todaitLightGray().CGColor
            cell.percentLayer.lineWidth = 2
            cell.percentLabel.textColor = UIColor.todaitDarkGray()
            cell.colorBoxView.backgroundColor = task.getColor()
            cell.percentLabel.hidden = false
            
            if let day = day {
                
                cell.titleLabel.text = task.name
                cell.contentsTextView.setupText(NSTimeInterval(day.doneSecond.integerValue))
                cell.percentLabel.text = String(format: "%lu%@", Int(day.doneAmount.floatValue/day.expectAmount.floatValue * 100),"%")
                cell.percentLayer.strokeColor = UIColor.todaitRed().CGColor
                cell.percentLayer.strokeEnd = CGFloat(day.doneAmount.floatValue/day.expectAmount.floatValue)
                cell.percentLabel.textColor = UIColor.todaitRed()
                
            }
            
            var line = UIView(frame: CGRectMake(0, 57.5, 320*ratio, 0.5))
            line.backgroundColor = UIColor.todaitDarkGray().colorWithAlphaComponent(0.3)
            cell.contentView.addSubview(line)
            
            return cell
            
        }else{
            
            let cell = tableView.dequeueReusableCellWithIdentifier("mainCell", forIndexPath: indexPath) as! TaskTableViewCell
            
            
            for temp in cell.contentView.subviews{
                temp.removeFromSuperview()
            }
            
            cell.delegate = self
            cell.indexPath = indexPath
            cell.percentLayer.strokeEnd = 0
            cell.percentLayer.strokeColor = UIColor.todaitLightGray().CGColor
            cell.percentLayer.lineWidth = 2
            cell.percentLabel.textColor = UIColor.todaitDarkGray()
            cell.colorBoxView.backgroundColor = task.getColor()
            cell.percentLabel.hidden = false
            
            
            
            if let day = day {
                
                //cell.contentsLabel.text = day.getProgressString()
                cell.titleLabel.text = task.name + " | " + getTimeStringFromSeconds(NSTimeInterval(day.doneSecond.integerValue))
                cell.contentsTextView.setupText(day.doneAmount.integerValue, total: day.expectAmount.integerValue, unit: task.unit)
                cell.percentLabel.text = String(format: "%lu%@", Int(day.doneAmount.floatValue/day.expectAmount.floatValue * 100),"%")
                cell.percentLayer.strokeColor = UIColor.todaitRed().CGColor
                cell.percentLayer.strokeEnd = CGFloat(day.doneAmount.floatValue/day.expectAmount.floatValue)
                cell.percentLabel.textColor = UIColor.todaitRed()
                //cell.colorBoxView.backgroundColor = UIColor.colorWithHexString(task.category_id.color)
                
            }else{
                
                cell.titleLabel.text = task.name + " | "
            }

            var line = UIView(frame: CGRectMake(0, 57.5, 320*ratio, 0.5))
            line.backgroundColor = UIColor.todaitDarkGray().colorWithAlphaComponent(0.3)
            cell.contentView.addSubview(line)
            
            
            return cell
        }
        
        
        
    }
    
    func timerButtonClk(indexPath:NSIndexPath) {
        performSegueWithIdentifier("ShowTimerView", sender:indexPath)
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight * ratio
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        
        if taskData.isEmpty && !isDeleteAnimation {
            
            return 272*ratio
            
        }
        
        
        return 58
    }
    
    // ScrollView
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        var newFrame = parallelView.frame
        if (scrollView.contentOffset.y > 0){
            parallelView.scrollViewDidScroll(scrollView)
        }else{
            scrollView.contentOffset.y = 0
        }
        
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        parallelView.scrollViewDidScroll(scrollView)
        calculateRemainingTime()
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        if taskData.isEmpty && !isDeleteAnimation {
            
        }else{
            performSegueWithIdentifier("ShowDetailView", sender:indexPath)
            
            tableView.reloadData()
            
            let cell = tableView.dequeueReusableCellWithIdentifier("mainCell", forIndexPath: indexPath)
                as! TaskTableViewCell
            
            
            cell.setSelected(false, animated: true)
        }
    }
    
    
    func Done(UITableViewRowAction!,
        NSIndexPath!) -> Void {
            
    }
    
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        
        let deleteButton = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: getDeleteString()) { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            
            self.tableView(tableView, commitEditingStyle: UITableViewCellEditingStyle.Delete, forRowAtIndexPath: indexPath)
        
        }
        
            
        
    
        deleteButton.backgroundColor = UIColor.todaitRed()
        
        return [deleteButton]
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        
        let category = taskData[indexPath.row]
        managedObjectContext?.deleteObject(category)
        
        var error:NSError?
        managedObjectContext?.save(&error)
        
        if error == nil {
            NSLog("Task 삭제완료",0)
            
            
            taskData.removeAtIndex(indexPath.row)
            
            isDeleteAnimation = true
            
            tableView.beginUpdates()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation:UITableViewRowAnimation.Automatic)
            tableView.endUpdates()
            
            isDeleteAnimation = false
            
            if taskData.isEmpty {
                tableView.reloadData()
            }
            
            
            loadTaskData()
            loadDayData()
            updateText()
            
        }else {
            //삭제에러처리
            
        }
    }
    
    func max<T : Comparable>(x: T, y:T) ->T{
        if x > y {
            return x
        }else{
            return y
        }
    }
    
    func getTotalTimeStringOfToday()->String{
        
        var totalSecond:Int = 0
        
        for dayItem in dayData{
            let day:Day! = dayItem
            totalSecond = totalSecond + Int(day.doneSecond)
            
        }
        
        return getTimeStringOfTwoArgumentsFromSeconds(NSTimeInterval(totalSecond))
        
    }
    
    func getTotalPercentStringOfToday()->String{
        
        var completeCount = 0
        
        
        for dayItem in dayData{
            let day:Day! = dayItem
            completeCount = completeCount + Int(day.doneAmount.floatValue/day.expectAmount.floatValue * 100)
        }
        
        if dayData.count == 0 {
            return "0%"
        }
        
        return "\(completeCount/dayData.count)%"
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
