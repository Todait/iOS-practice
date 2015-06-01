//
//  MainViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 1..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class MainViewController: BasicViewController,UITableViewDataSource,UITableViewDelegate  {

    var parallelView : ParallelHeaderView!
    var mainTableView : UITableView!
    var createAimButton : UIButton!
    var settingButton : UIButton!
    
    
    let headerHeight : CGFloat = 220
    let metaData:[String] = ["영어공부","수학공부","프로그래밍","회화공부","운동"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addParallelView()
        addMainTableView()
        addAimButton()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        addSettingBtn()
        titleLabel.text = "Todait"
        
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
    
    func addParallelView(){
        parallelView = ParallelHeaderView(frame: CGRectMake(0, 0, width, headerHeight))
        parallelView.backgroundColor = UIColor.colorWithHexString("#3CB2A2")
    }
    
    func addMainTableView(){
        
        mainTableView = UITableView(frame: CGRectMake(0,navigationHeight,width,height - navigationHeight), style: UITableViewStyle.Grouped)
        mainTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        mainTableView.contentInset = UIEdgeInsetsMake(-20*ratio, 0, 0, 0)
        mainTableView.delegate = self
        mainTableView.dataSource = self
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        
        
        var timerButton : UIButton = UIButton(frame: CGRectMake(20*ratio, 10*ratio, 30*ratio, 30*ratio))
        timerButton.backgroundColor = UIColor.clearColor()
        timerButton.clipsToBounds = true
        timerButton.layer.cornerRadius = 15*ratio
        timerButton.layer.borderWidth = 2*ratio
        timerButton.layer.borderColor = UIColor.colorWithHexString("#C9C9C9").CGColor
        cell.contentView.addSubview(timerButton)
        
        
        
        
        
        var title : UILabel = UILabel(frame: CGRectMake(60*ratio, 10*ratio, 200*ratio, 30*ratio))
        title.font = UIFont(name: "AvenirNext-Regular", size: 16*ratio)
        title.text = metaData[indexPath.row]
        title.textColor = UIColor.colorWithHexString("#969696")
        
        cell.contentView.addSubview(title)
        
        return cell
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
