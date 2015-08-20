//
//  ProgressView.swift
//  Todait
//
//  Created by CruzDiary on 2015. 8. 10..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class ProgressView: UIView {

    @IBOutlet weak var progressImage: UIImageView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
    }
    
    func startAnimation(){
        
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.toValue = M_PI * 2.0
        animation.repeatCount = Float.infinity
        animation.duration = 1
        animation.cumulative = true
        progressImage.layer.addAnimation(animation, forKey: "rotation")
        
    }
    
    func stopAnimation(){
        
        progressImage.layer.removeAllAnimations()
        
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
