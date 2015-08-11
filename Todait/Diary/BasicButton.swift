//
//  BasicButton.swift
//  Todait
//
//  Created by CruzDiary on 2015. 7. 21..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class BasicButton: UIButton {
    
    
    var ratio:CGFloat!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupRatio()
        
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setupRatio(){
        let screenRect = UIScreen.mainScreen().bounds
        let screenWidth = screenRect.size.width
        ratio = screenWidth/320
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
