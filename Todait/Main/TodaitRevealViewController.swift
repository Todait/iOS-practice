//
//  TodaitRevealViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 16..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class TodaitRevealViewController: SWRevealViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        rearViewRevealWidth = 80
        rearViewRevealOverdraw = 30
        bounceBackOnOverdraw = false
        bounceBackOnLeftOverdraw = true
        //bounceBackOnLeftOverdraw = false
        //stableDragOnLeftOverdraw = true
        
        setFrontViewPosition(FrontViewPosition.Right, animated: false)
        
        // Do any additional setup after loading the view.
    }

    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
