//
//  ProfileViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 7. 6..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class ProfileViewController: BasicViewController {
   
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        todaitNavBar.backButton.hidden = true
        
    }
}
