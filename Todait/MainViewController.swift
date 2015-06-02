//
//  MainViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 1..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class MainViewController: BasicViewController,UITableViewDataSource,UITableViewDelegate,AimTableViewCellDelegate{

    var parallelView : ParallelHeaderView!
    var mainTableView : UITableView!
    var createAimButton : UIButton!
    var settingButton : UIButton!
    var timer : NSTimer!
    
    var remainingTime : NSTimeInterval! = 24*60*60
    
    let headerHeight : CGFloat = 220
    let metaData:[String] = ["영어공부","수학공부","프로그래밍","회화공부","운동"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addParallelView()
        addMainTableView()
        addAimButton()
        
        
        setupTimer()
        timerStart()
        
        calculateRemainingTime()
    }
    
    
    func addParallelView(){
        parallelView = ParallelHeaderView(frame: CGRectMake(0, 0, width, headerHeight))
        parallelView.backgroundColor = UIColor.colorWithHexString("#27DB9F")
    }
    
    func addMainTableView(){
        
        mainTableView = UITableView(frame: CGRectMake(0,navigationHeight,width,height - navigationHeight), style: UITableViewStyle.Grouped)
        mainTableView.registerClass(AimTableViewCell.self, forCellReuseIdentifier: "cell")
        mainTableView.contentInset = UIEdgeInsetsMake(-20*ratio, 0, 0, 0)
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.contentOffset.y = 0
        view.addSubview(mainTableView)
        
    }
    
    func addAimButton(){
        
        
        let backgroundImage = UIImage.colorImage(UIColor.colorWithHexString("#F24545"), frame: CGRectMake(0, 0, 50*ratio, 50*ratio))
        
        createAimButton = UIButton(frame: CGRectMake(240*ratio,height-100*ratio, 50*ratio, 50*ratio))
        createAimButton.setBackgroundImage(backgroundImage, forState: UIControlState.Normal);
        createAimButton.setTitle("+", forState: UIControlState.Normal)
        createAimButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        createAimButton.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 25*ratio)
        createAimButton.clipsToBounds = true
        createAimButton.layer.cornerRadius = 25*ratio
        createAimButton.addTarget(self, action: Selector("showNewAimVC"), forControlEvents: UIControlEvents.TouchUpInside)
        
        view.addSubview(createAimButton)
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
    
    func getTimeStringFromSeconds(seconds : NSTimeInterval ) -> String {
        
        
        let remainder : Int = Int(seconds % 3600 )
        let hour : Int = Int(seconds / 3600)
        let minute : Int = Int(remainder / 60)
        let second : Int = Int(remainder % 60)
        
        return String(format:  "%02lu:%02lu:%02lu", arguments: [hour,minute,second])
    }
    
    func calculateRemainingTime(){
        
        var calendar : NSCalendar! = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        calendar.locale = NSLocale.currentLocale()
        
        var nowDateComp = calendar.components(NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitHour | NSCalendarUnit.CalendarUnitMinute | NSCalendarUnit.CalendarUnitSecond, fromDate: NSDate())
        
        remainingTime = calculateSecondsFromNowToLimit(nowDateComp)
    }
    
    
    func calculateSecondsFromNowToLimit(nowDateComp : NSDateComponents) -> NSTimeInterval{
        
        let limitHour = 27
        let limitMinute = 30
        
        return 3600 * (27-NSTimeInterval(nowDateComp.hour)) + 60 * (30-NSTimeInterval(nowDateComp.minute)) - (NSTimeInterval(nowDateComp.second))
    }
    
    func isTodayEndTimeDefault() -> Int{
        
        if (defaults.integerForKey("todayEndTime") == 0){
            return 240000
        }else{
            return defaults.integerForKey("todayEndTime")
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        addSettingBtn()
        titleLabel.text = "Todait"
        mainTableView.contentOffset.y = 0
        parallelView.scrollViewDidScroll(mainTableView)
    }
    
    func addSettingBtn(){
        settingButton = UIButton(frame: CGRectMake(288*ratio, 30*ratio, 24*ratio, 24*ratio))
        settingButton.setImage(UIImage(named: "setting@2x.png"), forState: UIControlState.Normal)
        settingButton.addTarget(self, action: Selector("setting"), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(settingButton)
    }
    
    func setting(){
        
        self.navigationController?.pushViewController(SettingViewController(), animated: true)
    }
    
    

    func showNewAimVC(){
        self.navigationController?.pushViewController(NewAimViewController(), animated: true)
    }

    
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return parallelView
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! AimTableViewCell
        cell.delegate = self
        cell.indexPath = indexPath
        
        let aimLibrary = AimLibrary().library[indexPath.row]
        let current = aimLibrary["current"] as! NSInteger!
        let aim = aimLibrary["aim"] as! NSInteger!
        let percent : CGFloat = CGFloat(current)/CGFloat(aim)
        let unit = aimLibrary["unit"] as! String!
        
        
        cell.titleLabel.text = aimLibrary["title"] as! String!
        cell.contentsLabel.text = "\(current) / \(aim) \(aim)\(unit)"
        cell.percentLabel.text = String(format: "%lu%@", Int(percent*100),"%")
        cell.percentLayer.strokeColor = UIColor.orangeColor().CGColor
        cell.percentLayer.strokeEnd = percent
        
        
        if indexPath.row % 3 == 0 {
            cell.colorBoxView.backgroundColor = UIColor.colorWithHexString("#1E56A4")
        }
        
        return cell
    }
    
    func timerButtonClk(indexPath:NSIndexPath) {
        
        self.navigationController?.pushViewController(TimerViewController(),animated: true)
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50*ratio
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
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return false
    }
    
    func max<T : Comparable>(x: T, y:T) ->T{
        if x > y {
            return x
        }else{
            return y
        }
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
