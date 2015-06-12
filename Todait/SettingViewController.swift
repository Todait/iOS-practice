//
//  SettingViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 1..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class SettingViewController: BasicViewController,UITableViewDelegate,TodaitNavigationDelegate,UITableViewDataSource{
   
    
    var settingTableView : UITableView!
    let sectionTitles:[String] = ["설정","기타","추천하기","데이터"]
    let cellTitles:[[String]] = [["메인 사진 설정","마무리 시간 설정","알림 설정","정렬 및 보기 설정","스톱워치 실행 시 화면 켜짐 유지"],["사용설명서","공식 블로그","투데잇 공식 인스타그램","이벤트","Todait 정보"],["투데잇과 카톡하기","피드백/별점남기기","카카오톡 추천"],["프로인증코드","데이터 백업하기","데이터 복구하기"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        addSettingTableView()
        
    }
    
    func addSettingTableView(){
        
        settingTableView = UITableView(frame: CGRectMake(0,navigationHeight*ratio,width,height - navigationHeight), style: UITableViewStyle.Grouped)
        settingTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        settingTableView.contentInset = UIEdgeInsetsMake(-15*ratio, 0, 0, 0)
        settingTableView.sectionFooterHeight = 0.0
        settingTableView.delegate = self
        settingTableView.dataSource = self
        view.addSubview(settingTableView)
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        
        let sectionTitleLabel = UILabel(frame: CGRectMake(15*ratio,23*ratio, 250*ratio, 13*ratio))
        sectionTitleLabel.text = sectionTitles[section]
        sectionTitleLabel.textAlignment = NSTextAlignment.Left
        sectionTitleLabel.font = UIFont(name: "AvenirNext-Regular", size: 11*ratio)
        sectionTitleLabel.textColor = UIColor.colorWithHexString("#595959")
        
        headerView.addSubview(sectionTitleLabel)
        
        return headerView
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        
        for view in cell.contentView.subviews{
            view.removeFromSuperview()
        }
        
        let titleLabel = UILabel(frame: CGRectMake(15*ratio, 0*ratio, 270*ratio, 35*ratio))
        titleLabel.textAlignment = NSTextAlignment.Left
        titleLabel.textColor = UIColor.colorWithHexString("#606060")
        titleLabel.font = UIFont(name: "AvenirNext-Regular", size: 11*ratio)
        titleLabel.text = cellTitles[indexPath.section][indexPath.row]
        cell.contentView.addSubview(titleLabel)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        if indexPath.section == 1 && indexPath.row < 2 {
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
            
            UIApplication.sharedApplication().openURL(NSURL(string:"instagram://user?username=@%ED%88%AC%EB%8D%B0%EC%9E%87")!)
            
        }else if indexPath.section == 0 && indexPath.row == 3 {
            
            
            let sortVC = SortViewController()
            self.navigationController?.pushViewController(sortVC, animated: true)
            
        }
        
        
        
        let cell:UITableViewCell! = tableView.cellForRowAtIndexPath(indexPath)
        cell.selected = false
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTitles[section].count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 35*ratio
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45*ratio
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        todaitNavBar.todaitDelegate = self
        todaitNavBar.backButton.hidden = false
        self.titleLabel.text = "Setting"
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func backButtonClk() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
