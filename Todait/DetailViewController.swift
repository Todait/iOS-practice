//
//  DetailViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 2..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class DetailViewController: BasicViewController,TodaitNavigationDelegate{
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        todaitNavBar.todaitDelegate = self
        todaitNavBar.backButton.hidden = false
        self.titleLabel.text = "큭하하"
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func backButtonClk() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
