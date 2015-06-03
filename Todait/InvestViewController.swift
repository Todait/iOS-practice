//
//  InvestViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 3..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class InvestViewController: BasicViewController,UITableViewDelegate,UITableViewDataSource{

    
    var blurEffectView: UIVisualEffectView!
    var investTableView: UITableView!
    var whiteView: UIView!
    var totalTimeLabel: UILabel!
    
    var completeButton: UIButton!
    let weekNameData:[String] = ["일","월","화","수","목","금","토"]
    var weekCountData:[String] = ["2","4","6","8","10","12","14"]
    
    var investAddButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupBlurBackground()
        addWhiteBackground()
        addInfoTitleView()
        addInfoContentsView()
        addInvestTableView()
        //addInvestAddButton()
        addCompleteButton()
        
    }
    
    func setupBlurBackground(){
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.frame
        blurEffectView.alpha = 0.9
        view.addSubview(blurEffectView)
    }
    
    func addWhiteBackground(){
        whiteView = UIView(frame: CGRectMake(0, 200*ratio, width, height-250*ratio))
        whiteView.backgroundColor = UIColor.whiteColor()
        view.addSubview(whiteView)
    }
    
    func addInfoTitleView(){
        
        
        addInvestGrayBackgroundView()
        addInvestTitleInfoLabel()
        addInvestTotalTimeLabel()
        addInvestGrayViewUnderLine()
    }
    
    func addInvestGrayBackgroundView(){
        let grayView = UIView(frame: CGRectMake(0, 0, width, 49*ratio))
        grayView.backgroundColor = UIColor.colorWithHexString("#EFEFEF")
        whiteView.addSubview(grayView)
    }
    
    func addInvestTitleInfoLabel(){
        let investTitleInfoLabel = UILabel(frame: CGRectMake(15*ratio,9.5*ratio, 200*ratio, 30*ratio))
        investTitleInfoLabel.text = "목표 투자시간"
        investTitleInfoLabel.textAlignment = NSTextAlignment.Left
        investTitleInfoLabel.textColor = UIColor.colorWithHexString("#5A5A5A")
        investTitleInfoLabel.font = UIFont(name: "AvenirNext-Regular", size: 14*ratio)
        whiteView.addSubview(investTitleInfoLabel)
    }
    
    func addInvestTotalTimeLabel(){
        totalTimeLabel = UILabel(frame: CGRectMake(160*ratio, 9.5*ratio, 145*ratio, 30*ratio))
        totalTimeLabel.textAlignment = NSTextAlignment.Right
        totalTimeLabel.text = "일주일 총 14시간 00분"
        totalTimeLabel.textColor = UIColor.colorWithHexString("#969696")
        totalTimeLabel.font = UIFont(name: "AvenirNext-Regular", size: 14*ratio)
        whiteView.addSubview(totalTimeLabel)
    }
    
    func addInvestGrayViewUnderLine(){
        let lineView = UIView(frame: CGRectMake(0, 48.75*ratio, width, 0.5*ratio))
        lineView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)
        whiteView.addSubview(lineView)
    }
    
    
    func addInfoContentsView(){
        
        addInvestWeekView()
        addInvestContentsInfoLabel()
    }
    
    func addInvestWeekView(){
        
        let dayWidth: CGFloat! = 290*ratio / 8
        
        
        for i in 0...6 {
            let dayLabel = UILabel(frame:CGRectMake(15*ratio + CGFloat(i) * dayWidth, 92*ratio, dayWidth, 10*ratio))
            
            
            
            dayLabel.textAlignment = NSTextAlignment.Center
            dayLabel.textColor = UIColor.colorWithHexString("#C9C9C9")
            dayLabel.font = UIFont(name: "AvenirNext-Regular", size: 10*ratio)
            whiteView.addSubview(dayLabel)
            
            
            let countLabel = UILabel(frame: CGRectMake(15*ratio + CGFloat(i) * dayWidth, 107*ratio, dayWidth, 10*ratio))
            countLabel.textAlignment = NSTextAlignment.Center
            countLabel.textColor = UIColor.colorWithHexString("#969696")
            countLabel.font = UIFont(name: "AvenirNext-Regular",size: 10*ratio)
            whiteView.addSubview(countLabel)
            
            if i != 7 {
                dayLabel.text = weekNameData[i]
                countLabel.text = weekCountData[i]
            }
            
        }
        
    }
    
    func addInvestContentsInfoLabel(){
        let investContentsInfoLabel = UILabel(frame: CGRectMake(15*ratio, 59*ratio, 290*ratio, 25*ratio))
        investContentsInfoLabel.text = "요일별 투자시간의 비율에 따라 적정 분량을 나눠줍니다"
        investContentsInfoLabel.font = UIFont(name: "AvenirNext-Regular", size: 10*ratio)
        investContentsInfoLabel.textColor = UIColor.colorWithHexString("#969696")
        investContentsInfoLabel.textAlignment = NSTextAlignment.Center
        whiteView.addSubview(investContentsInfoLabel)
    }
    
    
    func addInvestTableView(){
        
        investTableView = UITableView(frame: CGRectMake(0,320*ratio,width,height-370*ratio), style: UITableViewStyle.Grouped)
        investTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        investTableView.contentInset = UIEdgeInsetsMake(-25*ratio, 0, 0, 0)
        investTableView.delegate = self
        investTableView.dataSource = self
        investTableView.contentOffset.y = 0
        investTableView.backgroundColor = UIColor.colorWithHexString("#FEFEFE")
        investTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        view.addSubview(investTableView)
    }
    
    func addCompleteButton(){
        completeButton = UIButton(frame: CGRectMake(0, height-50*ratio, width, 50*ratio))
        completeButton.backgroundColor = UIColor.colorWithHexString("#27DB9F")
        completeButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        completeButton.setTitle("확인", forState: UIControlState.Normal)
        completeButton.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 20*ratio)
        completeButton.addTarget(self, action: Selector("completeButtonClk"), forControlEvents:UIControlEvents.TouchUpInside)
        view.addSubview(completeButton)
    }
    
    func completeButtonClk(){
        dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0*ratio
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80*ratio
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        
        cell.backgroundColor = UIColor.whiteColor()
        
        for view in cell.contentView.subviews{
            view.removeFromSuperview()
        }
        
        
        if indexPath.row == tableView.numberOfRowsInSection(0)-1 {
           investAddButton = UIButton(frame: CGRectMake(135*ratio, 100*ratio, 50*ratio, 50*ratio))
           investAddButton.setTitle("+", forState: UIControlState.Normal)
           investAddButton.setBackgroundImage(UIImage.colorImage(UIColor.purpleColor(), frame: CGRectMake(0, 0, 50*ratio, 50*ratio)), forState: UIControlState.Normal)
           investAddButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
           investAddButton.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 25*ratio)
           investAddButton.layer.cornerRadius = 25*ratio
           investAddButton.clipsToBounds = true
            cell.contentView.addSubview(investAddButton)
        }
        
        
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        todaitNavBar.hidden = true
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        completeButtonClk()
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
