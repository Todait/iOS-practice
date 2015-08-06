//
//  SettingMainSortingViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 8. 6..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class SettingMainSortingViewController: BasicTableViewController {
   
    
    
    var sortIndex = 1
    var showIndex = 7
    
    let checkValue:[Int] = [1,2,4,8,16]
    var closeButton:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sectionTitles = ["정렬 방식","보기 설정"]
        cellTitles = [["시간 순 정렬","이름 순 정렬","카테고리 순 정렬","사용자 정렬"],["카테고리 정렬 설정","사용자 정렬 설정","미완료 목표 표시"]]
        setupIndex()
        
        //addSortTableView()
    }
    
    
    func setupIndex(){
        sortIndex = defaults.integerForKey("sortIndex")
        showIndex = defaults.integerForKey("showIndex")
    }
    
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        
        let sectionTitleLabel = UILabel(frame: CGRectMake(15,0, 250, 29))
        sectionTitleLabel.text = sectionTitles[section]
        sectionTitleLabel.textAlignment = NSTextAlignment.Left
        sectionTitleLabel.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 12)
        sectionTitleLabel.textColor = UIColor.todaitDarkGray()
        
        headerView.addSubview(sectionTitleLabel)
        
        return headerView
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        
        let cell = tableView.dequeueReusableCellWithIdentifier("basic", forIndexPath: indexPath) as! UITableViewCell
        
        for view in cell.contentView.subviews{
            view.removeFromSuperview()
        }
        
        
        let titleLabel = UILabel(frame: CGRectMake(32, 0, 250, 43))
        titleLabel.textAlignment = NSTextAlignment.Left
        titleLabel.textColor = UIColor.todaitDarkGray()
        titleLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 13)
        titleLabel.text = cellTitles[indexPath.section][indexPath.row]
        cell.contentView.addSubview(titleLabel)
        
        
        
        var checkImage = UIImageView(frame: CGRectMake(290*ratio, 12, 19, 19))
        cell.contentView.addSubview(checkImage)
        
        if indexPath.section == 0 && sortIndex & checkValue[indexPath.row] == checkValue[indexPath.row] {
            
            checkImage.image = UIImage(named: "bt_check_green@3x.png")
            
        }else if indexPath.section == 1 {
            
            let detailImage = UIImageView(frame: CGRectMake(320*ratio - 25, 16.5, 5, 10))
            detailImage.image = UIImage(named: "bt_arrange_arrow@3x.png")
            cell.contentView.addSubview(detailImage)
         
            
            if indexPath.row == 2 {
                
                let completeLabel = UILabel(frame: CGRectMake(200*ratio, 0, 85*ratio,43))
                completeLabel.text = "표시안함"
                completeLabel.textAlignment = NSTextAlignment.Right
                completeLabel.font = UIFont(name: "AppleSDGothicNeo-Semibold", size: 12)
                completeLabel.textColor = UIColor.todaitGreen()
                cell.contentView.addSubview(completeLabel)
                
            }
            
            
        }
        return cell
        
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        
        if indexPath.section == 0 {
            sortIndex = checkValue[indexPath.row]
            
            
        }else if indexPath.section == 1 {
            
            
            if showIndex & checkValue[indexPath.row] == checkValue[indexPath.row] {
                showIndex = showIndex - checkValue[indexPath.row]
            }else{
                showIndex = showIndex + checkValue[indexPath.row]
            }
            
            
            if indexPath.row == 1 {
                
                let userSortVC = UserSortViewController()
                self.navigationController?.pushViewController(userSortVC, animated: true)
            
            }
            
        }
        
        defaults.setInteger(sortIndex, forKey: "sortIndex")
        defaults.setInteger(showIndex, forKey: "showIndex")
        
        tableView.reloadData()
        
        return false
    }
    
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 29
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 43
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.titleLabel.text = "정렬 설정"
    
        addCloseButton()
        
    }
    
    func addCloseButton(){
        
        if closeButton != nil {
            return
        }
        
        closeButton = UIButton(frame: CGRectMake(10, 30, 28, 28))
        closeButton.setBackgroundImage(UIImage(named: "newgoal_closed@3x.png"), forState: UIControlState.Normal)
        closeButton.addTarget(self, action: Selector("closeButtonClk"), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(closeButton)
    }
    
    func closeButtonClk(){
        
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
        
    }
}
