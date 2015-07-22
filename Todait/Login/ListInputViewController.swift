//
//  ListInputViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 7. 22..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class ListInputViewController: BasicViewController,UITableViewDelegate,UITableViewDataSource{
    
    var tableTitle:String! = ""
    
    var filterView:UIImageView!
    var tableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addFilterView()
    
    }
    
    func addFilterView(){
        
        filterView = UIImageView(frame: view.frame)
        filterView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        view.addSubview(filterView)
        
    }
    
    func addTableView(){
        
        tableView = UITableView(frame: CGRectMake(13*ratio, 90*ratio, 294*ratio, height - 150*ratio), style: UITableViewStyle.Plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.registerClass(CategorySettingTableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.todaitNavBar.hidden = true
        
        
    }
   
}
