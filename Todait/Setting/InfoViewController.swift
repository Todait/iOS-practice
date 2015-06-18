//
//  InfoViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 18..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class InfoViewController: BasicTableViewController,TodaitNavigationDelegate{
    
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
        
        let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        
        //let cell = tableView.dequeueReusableCellWithIdentifier("basic", forIndexPath: indexPath) as! UITableViewCell

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
