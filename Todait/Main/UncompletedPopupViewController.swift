//
//  UncompletedPopupViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 8. 10..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class UncompletedPopupViewController: BasicViewController,UITableViewDelegate,UITableViewDataSource{
    
    
    var filterView:UIImageView!
    var categoryView:UIView!
    
    var confirmButton:UIButton!
    var infoLabel:UILabel!
    
    var tableView:UITableView!
    
    var selectedIndex:Int! = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addFilterView()
        addInfoView()
        addTableView()
        addConfirmButton()
        
    }
    
    
    
    func addFilterView(){
        
        filterView = UIImageView(frame: view.frame)
        filterView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        view.addSubview(filterView)
        
    }
    
    
    func addInfoView(){
        
        addGrayView()
        addInfoLabel()
        addWhiteView()
        
    }
    
    
    func closeButtonClk(){
        
        UIView.animateWithDuration(0.4, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            self.categoryView.transform = CGAffineTransformMakeTranslation(0, 0)
            }, completion: { (Bool) -> Void in
                
                self.dismissViewControllerAnimated(false, completion: { () -> Void in
                    
                })
        })
    }
    
    
    func addGrayView(){
        let grayView = UIView(frame: CGRectMake(0, 0, 294*ratio,33*ratio))
        grayView.backgroundColor = UIColor.colorWithHexString("#949494")
        categoryView.addSubview(grayView)
    }
    
    func addInfoLabel(){
        infoLabel = UILabel(frame: CGRectMake(13*ratio, 0, 200*ratio, 33*ratio))
        infoLabel.textAlignment = NSTextAlignment.Left
        infoLabel.textColor = UIColor.whiteColor()
        infoLabel.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 12.5*ratio)
        infoLabel.text = "미완료 목표 보기"
        categoryView.addSubview(infoLabel)
    }
    
    func addWhiteView(){
        let whiteView = UIView(frame: CGRectMake(0, 33*ratio, 294*ratio, 191*ratio))
        whiteView.backgroundColor = UIColor.whiteColor()
        categoryView.addSubview(whiteView)
    }
    
    
    
    
    
    
    func addTableView(){
        
        tableView = UITableView(frame: CGRectMake(0, 33*ratio, 294*ratio, 192*ratio))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.registerClass(CategorySettingTableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.addSubview(tableView)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        selectedIndex = indexPath.row
        
        tableView.reloadData()
        
        confirmButtonClk()
        
        return false
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CategorySettingTableViewCell
        
        let titleLabel = UILabel(frame:CGRectMake(17*ratio,15*ratio,260*ratio,16*ratio))
        titleLabel.textColor = UIColor.todaitDarkGray()
        titleLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 14*ratio)
        titleLabel.textAlignment = NSTextAlignment.Left
        cell.contentView.addSubview(titleLabel)
        
        
        let contentsLabel = UILabel(frame:CGRectMake(17*ratio, 40*ratio,230*ratio,32*ratio))
        contentsLabel.textAlignment = NSTextAlignment.Left
        contentsLabel.font = UIFont(name: "AppleSDGothicNeo-Light", size:12*ratio)
        
        cell.contentView.addSubview(contentsLabel)
        
        
        
        
        if indexPath.row == 0 {
            titleLabel.text = "표시 함"
            contentsLabel.text = "목표 달성 전에 기간이 끝날 목표를 메인에서 보여줍니다."
        }else{
            titleLabel.text = "표시 안함"
            contentsLabel.text = "목표 기간이 지난 목표는 사라집니다.\n현재 화면에서 '표시 함'을 선택하시면 다시 보여집니다."
            
        }
        
        
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return 64*ratio
        }
        
        
        return 48*ratio
    }
    
    func addConfirmButton(){
        
        confirmButton = UIButton(frame: CGRectMake(0, 232*ratio, 294*ratio, 43*ratio))
        confirmButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        confirmButton.setTitle("확인", forState: UIControlState.Normal)
        confirmButton.setBackgroundImage(UIImage.colorImage(UIColor.todaitGreen(), frame: CGRectMake(0, 0, 294*ratio, 43*ratio)), forState: UIControlState.Normal)
        confirmButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo", size: 15*ratio)
        confirmButton.addTarget(self, action: Selector("confirmButtonClk"), forControlEvents: UIControlEvents.TouchUpInside)
        categoryView.addSubview(confirmButton)
    }
    
    func confirmButtonClk(){
        
        
        
        closeButtonClk()
        
    }
    
    
    
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        let touch: AnyObject? = (touches as NSSet).anyObject()
        let touchPoint:CGPoint! = touch?.locationInView(view)
        
        if touchPoint.y < height - 286*ratio {
            closeButtonClk()
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        todaitNavBar.hidden = true
        
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut , animations: { () -> Void in
            self.categoryView.transform = CGAffineTransformMakeTranslation(0, -275*self.ratio)
            
            }) { (Bool) -> Void in
                
        }
        
        
        registerForKeyboardNotification()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        resignForKeyboardNotification()
    }
    
    func resignForKeyboardNotification(){
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    
    func registerForKeyboardNotification(){
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWasShown:"), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillBeHidden:"), name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func keyboardWasShown(aNotification:NSNotification){
        
        var info:[NSObject:AnyObject] = aNotification.userInfo!
        var kbSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)!.CGRectValue().size as CGSize
        
        
        
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            
            self.categoryView.transform = CGAffineTransformMakeTranslation(0, -self.categoryView.frame.size.height - kbSize.height)
            
            }, completion: nil)
        
    }
    
    func keyboardWillBeHidden(aNotification:NSNotification){
        
        
        
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            
            self.categoryView.transform = CGAffineTransformMakeTranslation(0, 0)
            
            }, completion: nil)
    }
    
}
