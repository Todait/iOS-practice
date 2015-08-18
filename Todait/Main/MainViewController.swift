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
import RealmSwift

class MainViewController: BasicViewController,UITableViewDataSource,UITableViewDelegate,TaskTableViewCellDelegate,UpdateDelegate,touchDelegate{
    
    var parallelView: ParallelHeaderView!
    var mainTableView: UITableView!
    
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
    
    //let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var timeChart:TimeChart!
    var timeValue:[CGFloat] = []
    
    var isShowAllCategory:Bool = true
    var category:Category!
    
    
    
    var dayResults:Results<Day>?
    var uncompletedTaskDateResults:Results<TaskDate>?
    
    var taskTestCount:NSTimeInterval = 0
    
    
    
    var tabbarView:UIView!
    var logoImageView:UIImageView!
    
    var mainCategoryVC:MainCategoryViewController!
    var mainCategoryCollectionVC:MainCategoryCollectionViewController!

    var isDeleteAnimation:Bool = false
    
    
    
    func needToUpdate(){
        
        
        loadUncompletedTaskDate()
        loadDay()
        
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
        
        //requestDayToServer()
        
        //createTestData()
        //createTestDataRealm()
        addParallelView()
        addMainTableView()
        
        calculateRemainingTime()
        setupCoreDataInit()
        
        
        loadUncompletedTaskDate()
        loadDay()
        mainTableView.reloadData()
        
        addListView()
    
    }
    
    func requestDayToServer(){
        
        
        
        var params:[String:AnyObject] = [:]
        params["sync_at"] = defaults.objectForKey("sync_at")
        
        var manager = Alamofire.Manager.sharedInstance
        manager.session.configuration.HTTPAdditionalHeaders = ["Content-Type":"application/json","Accept" : "application/vnd.todait.v1+json","X-User-Email":defaults.objectForKey("email")!,"X-User-Token":defaults.objectForKey("token")!]
        
        
        Alamofire.request(.GET, SERVER_URL + SYNCHRONIZE , parameters: params).responseJSON(options: nil) {
            (request, response , object , error) -> Void in
            
            print(JSON(object!))
            
            
            self.realmManager.synchronize(JSON(object!))
            
        }
        
    }
    
    
    
    func createTestDataRealm(){
        
        for index in 0...9{
            
            let category = Category()
            category.name = String.categoryTestNameAtIndex(index)
            category.color = String.categoryColorStringAtIndex(index)
            category.id = NSUUID().UUIDString
            category.priority = index
            category.categoryType = "study"
            
            realm.write {
                
                self.createTask(category)
                self.realm.add(category)
            }
            
            //createTask(category)
        }
    }
    
    func createTask(category:Category){
        
        
        for index in 0...19{
            let task = Task()
            
            task.name = String.categoryTestNameAtIndex(Int(rand()%20))
            task.priority = Int(NSDate().timeIntervalSince1970) + index
            task.unit = "회"
            task.id = NSUUID().UUIDString
            task.taskType = String.taskTestTaskType(Int(rand()%4))
            task.category = category
            task.amount = Int(rand()%250)
            
            
            category.tasks.append(task)
            
            createTaskDate(task)
            
            self.realm.add(task)
        }
        
    }
    
    func createTaskDate(task:Task){
        
        
        for index in 0...8 {
            
            let taskDate = TaskDate()
            taskDate.id = NSUUID().UUIDString
            taskDate.startDate = 20150801
            taskDate.endDate = 2015 * 10000 + Int(8) * 100 + Int(rand()%18 + 1)
            taskDate.task = task
            taskDate.state = Int(rand()%2)
            task.taskDates.append(taskDate)
            
            
            createWeek(taskDate)
            
            
            
            for var date = taskDate.startDate ; date < taskDate.endDate + 1 ; date++ {
                
                let day = Day()
            
                day.id = NSUUID().UUIDString
                day.doneAmount = 0
                day.doneSecond = 0
                day.date = date
                day.expectAmount = Int(rand()%10) + 1
                day.taskDate = taskDate
                taskDate.days.append(day)
                realm.add(day)
                
            }
            
            
            self.realm.add(taskDate)
            
        }
    }
    
    func createWeek(taskDate:TaskDate){
        
        let week = Week()
        week.id = NSUUID().UUIDString
        week.mon = Int(rand()%10000)
        week.sun = Int(rand()%20000)
        week.wed = Int(rand()%20000)
        week.thu = Int(rand()%20000)
        week.tue = Int(rand()%20000)
        week.sat = Int(rand()%20000)
        week.fri = Int(rand()%10000)
        week.taskDate = taskDate
        taskDate.week = week
        self.realm.add(week)
        
        
    }
    
    
    
    func addParallelView(){
        parallelView = ParallelHeaderView(frame: CGRectMake(0, 0, width, headerHeight*ratio))
        parallelView.backgroundColor = UIColor.todaitRed()
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
        
        mainTableView.backgroundColor = UIColor.todaitBackgroundGray()
        mainTableView.bounces = false
        mainTableView.contentInset = UIEdgeInsetsMake(-20*ratio, 0, 0, 0)
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        mainTableView.sectionFooterHeight = 0
        mainTableView.sectionHeaderHeight = 0
        
        
        view.addSubview(mainTableView)
        
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
        
        
        var categoryResults = realm.objects(Category)
        
        if categoryResults.count == 0 {
            
            //makeDefaultCategory()
            setupInitValue()
            
        }
        
        /*
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
        */
        
    }
    
    func makeDefaultCategory(){
        
        let category = Category()
        category.name = "기본"
        category.color = String.categoryColorStringAtIndex(0)
        category.id = NSUUID().UUIDString
        
        realm.write {
            self.realm.add(category)
        }
        
    }
    
    
    func setupInitValue(){
        
        defaults.setInteger(1, forKey: "sortIndex")
        defaults.setInteger(1, forKey: "showIndex")
        
    }
    
    /*
    func loadDayResults(){
        
        
        
        let todayDateNumber = getTodayDateNumber()
        
        
        
        
        for task in taskData {
            
            let day:Day? = task.getDay(todayDateNumber)
            
            if let validDay = day {
                dayData.append(day!)
            }
        }
        
    }
    */
    
    func loadDay(){
        
        let sortIndex = defaults.integerForKey("sortIndex")
        
        var property:String?
        
        if sortIndex == 1{
            
        }else if sortIndex == 2 {
            property = "name"
        }else if sortIndex == 4 {
            property = "category"
        }else if sortIndex == 8 {
            property = "priority"
        }
        
        
        
        let todayDateNumber = getTodayDateNumber()
        let predicate = NSPredicate(format:"archived == false && date == %lu && taskDate.state == 1 ",todayDateNumber)
        
        dayResults = realm.objects(Day).filter(predicate)//.sorted("taskDate.task.name", ascending: true)
        
    }
    
    func loadUncompletedTaskDate(){
        
        let uncomplete = NSPredicate(format:"archived == false && state == 0 ")
        uncompletedTaskDateResults = realm.objects(TaskDate).filter(uncomplete)
        
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
    
    /*
    func loadTaskData(){
    
        return
        
        taskData.removeAll(keepCapacity: true)
        
        let sortIndex = defaults.integerForKey("sortIndex")
        
        var property:String?
        
        if sortIndex == 1{
            
        }else if sortIndex == 2 {
            property = "name"
        }else if sortIndex == 4 {
            property = "category"
        }else if sortIndex == 8 {
            property = "priority"
        }
        
        
        let predicate = NSPredicate(format: "category.hidden == %@",false)
        
        taskResults = realm.objects(Task).filter(predicate)
        
        if let property = property {
            taskResults = taskResults!.sorted(property, ascending: true)
        }
        
        
        for task in taskResults!{
            
            
            if let day = task.getTodayDay() {
                taskData.append(task)
            }
            
        }
        
        
    }
    */
    /*
    func loadUncompletedTaskDate(){
        
        return
        
        let sortIndex = defaults.integerForKey("sortIndex")
        
        var property:String?
        
        if sortIndex == 1{
            
        }else if sortIndex == 2 {
            property = "name"
        }else if sortIndex == 4 {
            property = "category"
        }else if sortIndex == 8 {
            property = "priority"
        }
        
        
        let predicate = NSPredicate(format: "category.hidden == %@",false)
        
        var taskUncompletedResults = realm.objects(Task).filter(predicate)
        
        if let property = property {
            taskUncompletedResults = taskUncompletedResults.sorted(property, ascending: true)
        }
        
        
        for task in taskUncompletedResults{
            
            
            if let day = task.getTodayDay() {
                taskUncompletedResultsData.append(task)
            }
            
        }

        
        
    }
    */
    
    /*
    func loadUncompletedTaskDate(){
        let entityDescription = NSEntityDescription.entityForName("Task",inManagedObjectContext:managedObjectContext!)
        
        let request = NSFetchRequest()
        request.entity = entityDescription
        
       
        
        let predicate = NSPredicate(format: "completed == %@" , false)
        request.predicate = predicate
        
        var error: NSError?
        var allTasks = managedObjectContext?.executeFetchRequest(request, error: &error) as! [Task]
        
        var todayDateNumber = getTodayDateNumber()
        uncompletedTaskData = allTasks.filter({(task:Task?) -> (Bool) in
            
            if let task = task {
                if task.amount.integerValue > task.getTotalDoneAmount().integerValue && task.endDate < todayDateNumber {
                    return true
                }
            }
            
            return false
        })
        
    }
    */
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        addLogoImageView()
        
        
        timerStart()
        //titleLabel.text = "Todait"
        //mainTableView.contentOffset.y = 0
        //parallelView.scrollViewDidScroll(mainTableView)
        calculateRemainingTime()
        
        self.screenName = "Main Activity"
    
        
        
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
        
        if let settingButton = settingButton {
            return
        }
        
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
            listButton.setImage(UIImage(named: "nav_bt_hamburger@3x.png"),forState: UIControlState.Normal)
            listButton.addTarget(self, action:Selector("showList"), forControlEvents: UIControlEvents.TouchUpInside)
            view.addSubview(listButton)
            
        }
    }
    
    func showList(){
        
        //requestDayToServer()
        
        /*
        if mainCategoryVC.view.hidden == true {
            mainCategoryVC.view.hidden = false
        }else{
            mainCategoryVC.view.hidden = true
        }
        */
        if mainCategoryCollectionVC.view.hidden == true {
            
            listButton.setImage(UIImage(named: "nav_bt_closed@3x.png"),forState: UIControlState.Normal)
            mainCategoryCollectionVC.view.hidden = false
            
        }else{
            
            listButton.setImage(UIImage(named: "nav_bt_hamburger@3x.png"),forState: UIControlState.Normal)
            mainCategoryCollectionVC.view.hidden = true
        }
        
    }
    
    
    
    /*
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
    */
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        //0은 미완료 목표
        //1은 일반
        
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if section == 0 {
            
            if uncompletedTaskDateResults!.count != 0 {
                return 1
            }else{
                return 0
            }
        }
        
        
        if dayResults!.count == 0 && !isDeleteAnimation {
            return 1
        }
        
        
        
        return dayResults!.count
        
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            return parallelView
        }else{
            
            return nil
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        if indexPath.section == 0 {
            
            
            let cell = tableView.dequeueReusableCellWithIdentifier("uncompletedCell", forIndexPath: indexPath) as! UncompletedTableViewCell
            
            
            //let task = uncompletedTaskData[indexPath.row]
            
            if let taskDate = uncompletedTaskDateResults?[indexPath.row] {
                if uncompletedTaskDateResults!.count == 1 {
                    cell.titleLabel.text = taskDate.task!.name + " 목표 미완료"
                }else{
                    cell.titleLabel.text = taskDate.task!.name + " 외 \(uncompletedTaskDateResults!.count-1)개 목표 미완료"
                }
            }else {
                cell.titleLabel.text = "목표 미완료"
            }
            
            cell.contentsLabel.text = "미완료 목표 보기"
            
            return cell
            
        }
        
        
        
        
        if dayResults!.count == 0 && !isDeleteAnimation {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("emptyCell", forIndexPath: indexPath) as! UITableViewCell
            
            for temp in cell.contentView.subviews{
                temp.removeFromSuperview()
            }
            
            
            let emptyImageView = UIImageView(frame:CGRectMake(0,0,width,272*ratio))
            emptyImageView.contentMode = UIViewContentMode.ScaleAspectFill
            if height == 480 {
                emptyImageView.image = UIImage(named:"bg_nodata4s@3x.png")
            }else{
                emptyImageView.image = UIImage(named:"bg_nodata@3x.png")
            }
            
            cell.contentView.addSubview(emptyImageView)
            
            return cell
            
        }
        
        
        
        
        //let task:Task = taskData[indexPath.row]
        let day:Day! = dayResults![indexPath.row]
        let task:Task! = day!.taskDate?.task!
        
        
        if task.taskType == "timer" {
            
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
                cell.contentsTextView.setupText(NSTimeInterval(day.doneSecond))
                cell.percentLabel.text = String(format: "%lu%@", Int(Float(day.doneAmount)/Float(day.expectAmount)*100),"%")
                cell.percentLayer.strokeColor = UIColor.todaitRed().CGColor
                cell.percentLayer.strokeEnd = CGFloat(Float(day.doneAmount)/Float(day.expectAmount))
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
                cell.titleLabel.text = task.name + " | " + getTimeStringFromSeconds(NSTimeInterval(day.doneSecond))
                cell.contentsTextView.setupText(day.doneAmount, total: day.expectAmount, unit: task.unit)
                cell.percentLabel.text = String(format: "%lu%@", Int(Float(day.doneAmount)/Float(day.expectAmount)*100),"%")
                cell.percentLayer.strokeColor = UIColor.todaitRed().CGColor
                cell.percentLayer.strokeEnd = CGFloat(Float(day.doneAmount)/Float(day.expectAmount))
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
        
        let timerVC = TimerViewController()
        
        let day = dayResults![indexPath.row]
        let task = day.taskDate!.task
        
        //let day:Day! = task.getDay(getTodayDateNumber())
        timerVC.task = task
        timerVC.day = day
        self.navigationController?.pushViewController(timerVC, animated: true)
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            
            return headerHeight * ratio
            
        }else{
            return 0
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        
        if dayResults!.count == 0 && !isDeleteAnimation && indexPath.section == 1 {
            
            return 272*ratio
            
        }
        
        
        return 58
    }
    
    // ScrollView
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        
        var newFrame = parallelView.frame
        if (scrollView.contentOffset.y >= 0){
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
        
        if indexPath.section == 0 {
            
            showUncompletedVC()
            
        }else{
            
            if dayResults!.count == 0 && !isDeleteAnimation {
                
            }else{
                
                let day = dayResults![indexPath.row]
                
                let detailVC = DetailViewController()
                //detailVC.task = taskData[indexPath.row]
                detailVC.day = day
                detailVC.taskDate = day.taskDate
                detailVC.task = day.taskDate!.task
                
                
                self.navigationController?.pushViewController(detailVC, animated: true)
                
                
                
                tableView.reloadData()
                
                let cell = tableView.dequeueReusableCellWithIdentifier("mainCell", forIndexPath: indexPath)
                    as! TaskTableViewCell
                
                
                cell.setSelected(false, animated: true)
            }
            
        }
        
    }
    
    func showUncompletedVC(){
        
        self.navigationController?.pushViewController(UncompletedViewController(), animated: true)
        
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
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        if indexPath.row == 0 && indexPath.section == 0{
            return false
        }else if dayResults!.count == 0 {
            return false
        }
        
        
        return true
    }
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
        let day = dayResults![indexPath.row]
        
        
        realm.write {
            
            day.archived = true
            self.realm.add(day,update:true)
        }
        
        dayResults = dayResults?.filter("archived == false")
        
        //taskData.removeAtIndex(indexPath.row)
        
        isDeleteAnimation = true
        
        tableView.beginUpdates()
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation:UITableViewRowAnimation.Automatic)
        tableView.endUpdates()
        
        isDeleteAnimation = false
        
        if dayResults!.count == 0  {
            tableView.reloadData()
        }
        
        
        loadUncompletedTaskDate()
        loadDay()
        updateText()
        
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
        
        for dayItem in dayResults!{
            let day:Day! = dayItem
            totalSecond = totalSecond + Int(day.doneSecond)
            
        }
        
        return getTimeStringOfTwoArgumentsFromSeconds(NSTimeInterval(totalSecond))
        
    }
    
    func getTotalPercentStringOfToday()->String{
        
        var completeCount:Float = 0.0
        
        var count:Float = Float(dayResults!.count)
        /*
        for dayItem in dayData{
            let day:Day! = dayItem
            completeCount = completeCount + Int(day.doneAmount/day.expectAmount)
        }
        */
        
        for day in dayResults!{
            completeCount = completeCount + Float(day.doneAmount)/Float(day.expectAmount)
        }
        
        if dayResults!.count == 0 {
            return "0%"
        }
        
        return String(format:"%.0f",(completeCount/count)*100) + "%"
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
