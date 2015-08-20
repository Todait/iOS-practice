//
//  EditWeekTimesViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 8. 19..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class EditWeekTimesViewController: WeekTimesViewController {
   
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        nextButton.hidden = true
        
        
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        
        for var index = 0 ; index < 7 ; index++ {
            
            let chart = weekCharts[index]
            timeTask.weekTimes[index] = Int(chart.currentValue)
        }
        
        super.viewWillDisappear(animated)

    }
    
}
