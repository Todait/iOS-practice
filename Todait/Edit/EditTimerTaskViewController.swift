//
//  EditTimerTaskViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 7. 29..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class EditTimerTaskViewController: BasicViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,CategoryDelegate,TodaitNavigationDelegate{
   
    var editedTask:Task!
    var category:Category!
    var delegate: CategoryUpdateDelegate!
    var mainColor: UIColor!
    var categoryButton: UIButton!
    
    
    var taskTextField: UITextField!
    var aimString:String!
    
    var saveButton: UIButton!
    
    var currentTextField: UITextField!
    
    
    var dateForm: NSDateFormatter!
    var startDate: NSDate!
    
    var periodDayString:String = "30일"
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    
    
    var timeTaskTableView:UITableView!
    
    var option:OptionStatus = OptionStatus.everyDay
    var deleteButton:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTimeTaskViewController()
        addTimeTaskTableView()
        addDeleteButton()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        todaitNavBar.todaitDelegate = self
        todaitNavBar.backButton.hidden = false
        
        self.titleLabel.text = "Edit"
        self.screenName = "Detail Activity"
        
        todaitNavBar.shadowImage = UIImage()
        
        addSaveButton()
        
    }
    
    
    
    func addSaveButton(){
        
        saveButton = UIButton(frame: CGRectMake(288*ratio,30,24,20))
        saveButton.setImage(UIImage.maskColor("icon_check_wt@3x.png",color:UIColor.whiteColor()), forState: UIControlState.Normal)
        saveButton.addTarget(self, action: Selector("saveEditedTask"), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(saveButton)
    }
    
    func saveEditedTask(){
        
        editedTask.name = taskTextField.text
        editedTask.categoryId = category
        
        var error: NSError?
        managedObjectContext?.save(&error)
        
        if let err = error {
            //에러처리
        }else{
            
            
            backButtonClk()
        }
        
    }
    
    
    func backButtonClk() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    
    func setupTimeTaskViewController(){
        startDate = NSDate()
        
        dateForm = NSDateFormatter()
        dateForm.dateFormat = "a h시 m분"
        
    }
    
    
    func addTimeTaskTableView(){
        timeTaskTableView = UITableView(frame: CGRectMake(0,navigationHeight,width,view.frame.size.height - navigationHeight), style: UITableViewStyle.Plain)
        timeTaskTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        timeTaskTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        timeTaskTableView.contentInset = UIEdgeInsetsMake(0*ratio, 0, 0, 0)
        timeTaskTableView.delegate = self
        timeTaskTableView.dataSource = self
        timeTaskTableView.sectionHeaderHeight = 0
        timeTaskTableView.sectionFooterHeight = 0
        timeTaskTableView.pagingEnabled = false
        timeTaskTableView.bounces = false
        timeTaskTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        view.addSubview(timeTaskTableView)
    }
    
    func addDeleteButton(){
        
        deleteButton = UIButton(frame:CGRectMake(3*ratio,height - 55*ratio, 314*ratio,52*ratio))
        deleteButton.setTitle("목표삭제", forState: UIControlState.Normal)
        deleteButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        deleteButton.setBackgroundImage(UIImage.colorImage(UIColor.todaitRed(), frame:CGRectMake(0,0,314*ratio,52*ratio)), forState: UIControlState.Normal)
        deleteButton.addTarget(self, action: Selector("deleteButtonClk"), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(deleteButton)
        
    }
    
    func deleteButtonClk(){
        
        managedObjectContext?.deleteObject(editedTask)
        
        var error: NSError?
        managedObjectContext?.save(&error)
        
        if let err = error {
            //에러처리
        }else{
            
            self.navigationController?.popToRootViewControllerAnimated(true)
        
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        
        
        for view in cell.contentView.subviews{
            view.removeFromSuperview()
        }
        
        cell.contentView.clipsToBounds = true
        cell.contentView.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
        
        if indexPath.row == 0 && indexPath.section == 0 {
            
            addTaskTextField(cell)
            addCategoryButton(cell)
            
        }else if(indexPath.section == 1){
            
            addOptionView(cell)
        }
        
        
        return cell
    }
    
    
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        
        return false
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        
        
        let line = UIView(frame: CGRectMake(0, 0, 320*ratio, 0.5*ratio))
        line.backgroundColor = UIColor.todaitDarkGray().colorWithAlphaComponent(0.3)
        headerView.addSubview(line)
        
        
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0*ratio
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        
        if indexPath.section == 0 {
            return 54*ratio
        }else if indexPath.section == 1 {
            return 52*ratio
        }
        
        
        return 54*ratio
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    
    func resignAllTextResponder(){
        
        taskTextField.resignFirstResponder()
        
    }
    
    
    
    func addTaskTextField(cell:UITableViewCell){
        
        taskTextField = UITextField(frame: CGRectMake(20*ratio, 9.5*ratio, 255*ratio, 30*ratio))
        taskTextField.placeholder = "이곳에 목표를 입력해주세요"
        taskTextField.textAlignment = NSTextAlignment.Center
        taskTextField.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14*ratio)
        taskTextField.textColor = UIColor.colorWithHexString("#969696")
        taskTextField.returnKeyType = UIReturnKeyType.Next
        taskTextField.backgroundColor = UIColor.whiteColor()
        taskTextField.addTarget(self, action: Selector("updateAllEvents:"), forControlEvents: UIControlEvents.AllEvents)
        taskTextField.text = editedTask.name
        taskTextField.tintColor = UIColor.todaitGreen()
        taskTextField.delegate = self
        currentTextField = taskTextField
        cell.contentView.addSubview(taskTextField)
        
        addLineView(cell)
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField == taskTextField {
            
            
        }
        
        currentTextField.becomeFirstResponder()
        
        return false
    }
    
    func updateAllEvents(textField:UITextField){
        aimString = textField.text
    }
    
    func addCategoryButton(cell:UITableViewCell){
        
        categoryButton = UIButton(frame: CGRectMake(280*ratio,9.5*ratio, 30*ratio, 30*ratio))

        
        categoryButton.layer.borderColor = UIColor.clearColor().CGColor
        categoryButton.setImage(UIImage.maskColor("category@3x.png", color: UIColor.whiteColor()), forState: UIControlState.Normal)
        categoryButton.backgroundColor = editedTask.getColor()
     
        categoryButton.layer.cornerRadius = 15*ratio
        categoryButton.layer.borderWidth = 1
        categoryButton.clipsToBounds = true
        categoryButton.addTarget(self, action: Selector("showCategorySettingVC"), forControlEvents: UIControlEvents.TouchUpInside)
        cell.contentView.addSubview(categoryButton)
        
    }
    
    func showCategorySettingVC(){
        
        var categoryVC = CategorySettingViewController()
        //categoryVC.delegate = self
        
        categoryVC.selectedCategory = category
        categoryVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        categoryVC.delegate = self
        self.navigationController?.presentViewController(categoryVC, animated: false, completion: { () -> Void in
            
        })
        
        
    }
    
    func categoryEdited(editedCategory:Category) {
        
        
        categoryButton.layer.borderColor = UIColor.clearColor().CGColor
        categoryButton.setImage(UIImage.maskColor("category@3x.png", color: UIColor.whiteColor()), forState: UIControlState.Normal)
        categoryButton.backgroundColor = UIColor.colorWithHexString(editedCategory.color)
        
        self.category = editedCategory
    }
    
    
    
    func addLineView(cell: UITableViewCell){
        
        let lineView = UIView(frame: CGRectMake(1*ratio, 48.5*ratio,318*ratio, 0.5*ratio))
        lineView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15)
        cell.contentView.addSubview(lineView)
    }
    
    
    
    
    func updateStartTime(textField:UITextField){
        let index = textField.tag
        
        /*
        if rangeList.count == index {
        
        var rangeData:[String:String] = [:]
        rangeData["startTime"] = textField.text
        rangeList.append(rangeData)
        
        }else{
        
        var rangeData = rangeList[index]
        rangeData["startTime"] = textField.text
        
        }
        */
    }
    
    func updateEndTime(textField:UITextField){
        let index = textField.tag
        
        /*
        if rangeList.count == index {
        var rangeData = rangeList[index]
        rangeData["endTime"] = textField.text
        
        }else{
        
        var rangeData:[String:String] = [:]
        rangeData["endTime"] = textField.text
        rangeList.append(rangeData)
        
        }
        */
    }
    
    
    func getDateString(dateNumber:NSNumber)->String{
        
        let date = getDateFromDateNumber(dateNumber)
        let dateForm = NSDateFormatter()
        dateForm.dateFormat = "yyyy.MM.dd"
        
        return dateForm.stringFromDate(date)
        
    }
    
    
    
    func addOptionView(cell:UITableViewCell){
        
        addAlarmOptionView(cell)
        
    }
    
    
    func dayOptionClk(){
        
        option = OptionStatus.everyDay
        timeTaskTableView.reloadData()
        
    }
    
    func addAlarmOptionView(cell:UITableViewCell){
        
        
        var alarmOption = UIButton(frame:CGRectMake(161*ratio,12*ratio,157*ratio,52*ratio))
        alarmOption.backgroundColor = UIColor.clearColor()
        alarmOption.addTarget(self, action: Selector("alarmOptionClk"), forControlEvents: UIControlEvents.TouchDown)
        cell.contentView.addSubview(alarmOption)
        
        
        var iconImageView = UIImageView(frame: CGRectMake(10*ratio, 6*ratio, 40*ratio, 40*ratio))
        alarmOption.addSubview(iconImageView)
        
        
        var titleLabel = UILabel(frame: CGRectMake(63*ratio, 15*ratio, 92*ratio, 22.5*ratio))
        titleLabel.text = "알람 없음"
        titleLabel.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 12.5*ratio)
        alarmOption.addSubview(titleLabel)
        
        
        
        if option == OptionStatus.alarm {
            iconImageView.image = UIImage(named: "icon_alarm_wt@3x.png")
            titleLabel.textColor = UIColor.todaitGreen()
        }else{
            iconImageView.image = UIImage(named: "icon_alarm@3x.png")
            titleLabel.textColor = UIColor.todaitGray()
        }
    }
    
    func alarmOptionClk(){
        
        
        showAlarmVC()
        
        option = OptionStatus.alarm
        timeTaskTableView.reloadData()
        
    }
    
    func showAlarmVC(){
        
        var alarmVC = AlarmViewController()
        //alarmVC.delegate = self
        alarmVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        
        self.navigationController?.presentViewController(alarmVC, animated: false, completion: { () -> Void in
            
        })
    }
    
    func addreviewOptionView(cell:UITableViewCell){
        
        
        var reviewOption = UIButton(frame:CGRectMake(2*ratio,64*ratio,157*ratio,52*ratio))
        reviewOption.backgroundColor = UIColor.clearColor()
        reviewOption.addTarget(self, action: Selector("reviewOptionClk"), forControlEvents: UIControlEvents.TouchDown)
        cell.contentView.addSubview(reviewOption)
        
        
        var iconImageView = UIImageView(frame: CGRectMake(20*ratio, 6*ratio, 40*ratio, 40*ratio))
        reviewOption.addSubview(iconImageView)
        
        
        var titleLabel = UILabel(frame: CGRectMake(68*ratio, 15*ratio, 92*ratio, 22.5*ratio))
        titleLabel.text = "반복 없음"
        titleLabel.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 12.5*ratio)
        reviewOption.addSubview(titleLabel)
        
        
        if option == OptionStatus.review {
            iconImageView.image = UIImage(named: "icon_review_wt@3x.png")
            titleLabel.textColor = UIColor.todaitGreen()
        }else{
            iconImageView.image = UIImage(named: "icon_review@3x.png")
            titleLabel.textColor = UIColor.todaitGray()
        }
    }
    
    func reviewOptionClk(){
        
        option = OptionStatus.review
        timeTaskTableView.reloadData()
        
    }
    
    func addreReadOptionView(cell:UITableViewCell){
        
        var reReadOption = UIButton(frame:CGRectMake(161*ratio,64*ratio,157*ratio,52*ratio))
        reReadOption.backgroundColor = UIColor.clearColor()
        reReadOption.addTarget(self, action: Selector("reReadOptionClk"), forControlEvents: UIControlEvents.TouchDown)
        cell.contentView.addSubview(reReadOption)
        
        
        var iconImageView = UIImageView(frame: CGRectMake(10*ratio, 6*ratio, 40*ratio, 40*ratio))
        reReadOption.addSubview(iconImageView)
        
        
        var titleLabel = UILabel(frame: CGRectMake(63*ratio, 15*ratio, 92*ratio, 22.5*ratio))
        titleLabel.text = "회독 없음"
        titleLabel.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 12.5*ratio)
        reReadOption.addSubview(titleLabel)
        
        
        if option == OptionStatus.reRead {
            iconImageView.image = UIImage(named: "icon_reread_wt@3x.png")
            titleLabel.textColor = UIColor.todaitGreen()
        }else{
            iconImageView.image = UIImage(named: "icon_reread@3x.png")
            titleLabel.textColor = UIColor.todaitGray()
        }
        
    }
    
    func reReadOptionClk(){
        
        option = OptionStatus.reRead
        timeTaskTableView.reloadData()
        
    }
    
    func showreviewVC(){
        
        /*
        let reviewVC = reviewViewcontroller()
        reviewVC.mainColor = mainColor
        reviewVC.delegate = self
        reviewVC.count = 1
        reviewVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        
        self.navigationController?.presentViewController(reviewVC, animated: true, completion: { () -> Void in
        
        })
        */
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      
    }
    
    func settingTime(date:NSDate){
        startDate = date
    }
    
    
    func addreviewTimeSubView(cell:UITableViewCell){
        
        let infoLabel = UILabel(frame: CGRectMake(15*ratio, 9.5*ratio, 200*ratio, 30*ratio))
        infoLabel.text = "반복"
        infoLabel.textColor = UIColor.colorWithHexString("#969696")
        infoLabel.textAlignment = NSTextAlignment.Left
        infoLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14*ratio)
        cell.contentView.addSubview(infoLabel)
        
        let dateLabel = UILabel(frame: CGRectMake(160*ratio, 9.5*ratio, 145*ratio, 30*ratio))
        dateLabel.text = "1회"
        dateLabel.textAlignment = NSTextAlignment.Right
        dateLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 16*ratio)
        dateLabel.textColor = mainColor
        cell.contentView.addSubview(dateLabel)
    }
    
    func addInvestChartView(cell:UITableViewCell){
        /*
        investChart = InvestChartView(frame: CGRectMake(15*ratio, 15*ratio, 290*ratio, 110*ratio))
        investChart.mainColor = mainColor
        investChart.setupChart()
        
        cell.contentView.addSubview(investChart)
        */
    }
    
    
    
    func getTimeString(time:Int)->String{
        
        let hour = time.toHour()
        let minute = time.toMinute()
        
        if hour == 0 {
            return "주 \(minute)분"
        }else{
            if minute == 0 {
                return "주 \(hour)시간"
            }else{
                return "주 \(hour)시간 \(minute)분"
            }
        }
        
    }
    
    
}
