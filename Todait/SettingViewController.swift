//
//  SettingViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 1..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class SettingViewController: BasicTableViewController,UITableViewDelegate,TodaitNavigationDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
   
    
    var settingTableView : UITableView!
    
    
    var iconNames = [["ic_setting_main_image.png","ic_setting_daily_finish.png","ic_setting_alarm_on.png","ic_setting_stopwatch_screen_dim.png","ic_setting_stopwatch_screen_dim.png"],["ic_setting_version_info.png","ic_setting_item_blog.png","ic_instagram.png","ic_drawer_item_event.png","ic_setting_about_todait.png"],["ic_setting_kakao_yellow_id.png","ic_drawer_item_feedback.png","ic_setting_kakao.png"],["ic_setting_pro_code.png","ic_setting_backup.png","ic_setting_restore.png"]]
    
    
    var mainColor:UIColor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sectionTitles = ["설정","기타","추천하기","데이터"]
        cellTitles = [["메인 사진 설정","마무리 시간 설정","알림 설정","정렬 및 보기 설정","스톱워치 실행 시 화면 켜짐 유지"],["사용설명서","공식 블로그","투데잇 공식 인스타그램","이벤트","Todait 정보"],["투데잇과 카톡하기","피드백/별점남기기","카카오톡 추천"],["프로인증코드","데이터 백업하기","데이터 복구하기"]]
        
        
        view.backgroundColor = UIColor.whiteColor()
        //addSettingTableView()
        
    }
    
    func addSettingTableView(){
        
        settingTableView = UITableView(frame: CGRectMake(0,navigationHeight,width,height - navigationHeight), style: UITableViewStyle.Plain)
        settingTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        settingTableView.sectionFooterHeight = 0.0
        settingTableView.delegate = self
        settingTableView.dataSource = self
        view.addSubview(settingTableView)
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        if indexPath.section == 0 && indexPath.row == 0 {
            
            let photoVC = PhotoViewController()
            photoVC.mainColor = mainColor
            self.navigationController?.pushViewController(photoVC, animated: true)
            
            
            
            
            
        }else if indexPath.section == 1 && indexPath.row < 2 {
            self.navigationController?.pushViewController(WebViewController(), animated: true)
        }else if indexPath.section == 0 && indexPath.row == 1 {
            
            let finishTimeVC = FinishTimeViewController()
            finishTimeVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
            
            self.navigationController?.presentViewController(finishTimeVC, animated: false, completion: { () -> Void in
                
            })
            
        }else if indexPath.section == 2 && indexPath.row == 0 {
            
            //Todo 카카오톡 설치코드
            
            UIApplication.sharedApplication().openURL(NSURL(string:"http://goto.kakao.com/go/v/@%ED%88%AC%EB%8D%B0%EC%9E%87")!)
        }else if indexPath.section == 1 && indexPath.row == 2 {
            
            
            //Todo 인스타그램 설치코드
            
            UIApplication.sharedApplication().openURL(NSURL(string:"instagram://user?username=TODAIT_")!)
            
        }else if indexPath.section == 0 && indexPath.row == 3 {
            
            
            let sortVC = SortViewController()
            self.navigationController?.pushViewController(sortVC, animated: true)
            
        }else if indexPath.section == 1 && indexPath.row == 4 {
            
            //오픈소스 및 Todait정보
            
            let infoVC = InfoViewController()
            self.navigationController?.pushViewController(infoVC, animated: true)
        
        }else if indexPath.section == 0 && indexPath.row == 2 {
            
            requestAlarm()
            
            
        }else if indexPath.section == 0 && indexPath.row == 0 {
            
            let photoVC = PhotoViewController()
            photoVC.mainColor = mainColor
            self.navigationController?.pushViewController(photoVC, animated: true)
            
        }
        
        
        let cell:UITableViewCell! = tableView.cellForRowAtIndexPath(indexPath)
        cell.selected = false
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("basic", forIndexPath: indexPath) as! UITableViewCell
        
        
        
        for temp in cell.contentView.subviews {
            temp.removeFromSuperview()
        }
        
        
        let iconImage = UIImageView(frame:CGRectMake(15*ratio,5*ratio,25*ratio,25*ratio))
        iconImage.image = UIImage(named:iconNames[indexPath.section][indexPath.row])
        
        cell.contentView.addSubview(iconImage)
        
        
        
        let titleLabel = UILabel(frame: CGRectMake(50*ratio, 0*ratio, 270*ratio, 35*ratio))
        titleLabel.textAlignment = NSTextAlignment.Left
        titleLabel.textColor = UIColor.colorWithHexString("#606060")
        titleLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 11*ratio)
        titleLabel.text = cellTitles[indexPath.section][indexPath.row]
        cell.contentView.addSubview(titleLabel)
        
        
        return cell
        
    }
    
    func requestAlarm(){
        
        requestAlarmTime(15)
        
    }
    
    
    func cancelAlarm(){
        UIApplication.sharedApplication().cancelAllLocalNotifications()
    }
    
    func requestAlarmTime(time:NSTimeInterval){
        
        let notification = UILocalNotification()
        notification.alertBody = "잘하셨습니다!"
        notification.timeZone = NSTimeZone.defaultTimeZone()
        notification.fireDate = NSDate().dateByAddingTimeInterval(time)
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.hasAction = true
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
    }

    
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    
    //UIImagePickerViewDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        picker.presentingViewController?.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.presentingViewController?.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        todaitNavBar.todaitDelegate = self
        todaitNavBar.backButton.hidden = false
        self.titleLabel.text = "Setting"
        self.screenName = "Setting Activity"
        
        setNavigationBarColor(mainColor)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func backButtonClk() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
