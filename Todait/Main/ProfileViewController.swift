//
//  ProfileViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 23..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class ProfileViewController: BasicViewController {
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
    
    
    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.todaitNavBar.hidden = true
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    
}
