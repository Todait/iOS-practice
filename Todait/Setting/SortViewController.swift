//
//  SortViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 12..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit



class SortViewController: BasicTableViewController,TodaitNavigationDelegate,UITableViewDataSource,UITableViewDelegate{

    
    let sortTitle:[[String]] = [["기본 정렬","이름 정렬","카테고리 정렬","사용자 정렬"],["오늘 목표","오늘 쉬는 목표","완료 목표","미완료 목표","시작전 목표"]]
    //var sortTableView:UITableView!
    
    var sortIndex = 1
    var showIndex = 7
    
    let checkValue:[Int] = [1,2,4,8,16]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sectionTitles = ["정렬 설정","보기 설정"]
        
        setupIndex()
     
        //addSortTableView()
    }
    
    func setupIndex(){
        sortIndex = defaults.integerForKey("sortIndex")
        showIndex = defaults.integerForKey("showIndex")
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("basic", forIndexPath: indexPath) as! UITableViewCell
        
        for view in cell.contentView.subviews{
            view.removeFromSuperview()
        }
        
        
        let titleLabel = UILabel(frame: CGRectMake(15*ratio, 0*ratio, 270*ratio, 35*ratio))
        titleLabel.textAlignment = NSTextAlignment.Left
        titleLabel.textColor = UIColor.colorWithHexString("#606060")
        titleLabel.font = UIFont(name: "AvenirNext-Regular", size: 11*ratio)
        titleLabel.text = sortTitle[indexPath.section][indexPath.row]
        cell.contentView.addSubview(titleLabel)
        
        
        
        
        if indexPath.section == 0 && sortIndex & checkValue[indexPath.row] == checkValue[indexPath.row] {
            
            var checkImage = UIImageView(frame: CGRectMake(283*ratio, 6.75*ratio, 22*ratio, 22*ratio))
            checkImage.image = UIImage.maskColor("done@3x.png", color: UIColor.todaitGreen())
            cell.contentView.addSubview(checkImage)
            
        }else if indexPath.section == 1 && showIndex & checkValue[indexPath.row] == checkValue[indexPath.row] {
            var checkImage = UIImageView(frame: CGRectMake(283*ratio, 6.75*ratio, 22*ratio, 22*ratio))
            checkImage.image = UIImage.maskColor("done@3x.png", color: UIColor.todaitGreen())
            cell.contentView.addSubview(checkImage)
        }
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        
        if indexPath.section == 0 {
            sortIndex = checkValue[indexPath.row]
            
            if indexPath.row == 3 {
                let userSortVC = UserSortViewController()
                self.navigationController?.pushViewController(userSortVC, animated: true)
            }
            
        }else if indexPath.section == 1 {
            
            
            if showIndex & checkValue[indexPath.row] == checkValue[indexPath.row] {
                showIndex = showIndex - checkValue[indexPath.row]
            }else{
                showIndex = showIndex + checkValue[indexPath.row]
            }
        
        }
        
        defaults.setInteger(sortIndex, forKey: "sortIndex")
        defaults.setInteger(showIndex, forKey: "showIndex")
        
        tableView.reloadData()
        
        return false
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sortTitle.count
    }

    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortTitle[section].count
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        todaitNavBar.todaitDelegate = self
        todaitNavBar.backButton.hidden = false
        self.titleLabel.text = "정렬 및 보기 설정"
        
        self.screenName = "Custom Sort Activity"
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func backButtonClk() {
        self.navigationController?.popViewControllerAnimated(true)
    }

}
