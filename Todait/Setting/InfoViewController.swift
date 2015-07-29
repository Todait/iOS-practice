//
//  InfoViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 18..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class InfoViewController: BasicTableViewController,TodaitNavigationDelegate{
    
    
    
    
    var iconNames = ["ic_fragment_daily_statistics_achievement_rate.png","ic_setting_open_source_license.png"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sectionTitles = ["Todait 정보"]
        cellTitles = [["현재버전","오픈소스 라이선스"]]
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 2
    }


    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("basic", forIndexPath: indexPath) as! UITableViewCell
        
        
        
        for temp in cell.contentView.subviews {
            temp.removeFromSuperview()
        }
        
        
        let iconImage = UIImageView(frame:CGRectMake(15*ratio,5*ratio,25*ratio,25*ratio))
        iconImage.image = UIImage(named:iconNames[indexPath.row])
        
        cell.contentView.addSubview(iconImage)
        
        
        
        let titleLabel = UILabel(frame: CGRectMake(50*ratio, 0*ratio, 270*ratio, 35*ratio))
        titleLabel.textAlignment = NSTextAlignment.Left
        titleLabel.textColor = UIColor.colorWithHexString("#606060")
        titleLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 11*ratio)
        titleLabel.text = cellTitles[indexPath.section][indexPath.row]
        cell.contentView.addSubview(titleLabel)
        
        
        return cell
        
    }
    

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        todaitNavBar.todaitDelegate = self
        todaitNavBar.backButton.hidden = false
        self.titleLabel.text = "Information"
        self.screenName = "Information Activity"
        
        //setNavigationBarColor(mainColor)
    }

    func backButtonClk(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
}
