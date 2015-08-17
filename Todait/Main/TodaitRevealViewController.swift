//
//  TodaitRevealViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 16..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class TodaitRevealViewController: SWRevealViewController {

    var ratio:CGFloat! = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRatio()
        
        rearViewRevealWidth = 100*ratio
        rearViewRevealOverdraw = 30*ratio
        bounceBackOnOverdraw = false
        bounceBackOnLeftOverdraw = true
        
        
    }

    func setupRatio(){
        let screenRect = UIScreen.mainScreen().bounds
        let screenWidth = screenRect.size.width
        ratio = screenWidth/320
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
