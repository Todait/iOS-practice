//
//  ProgressManager.swift
//  Todait
//
//  Created by CruzDiary on 2015. 8. 11..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class ProgressManager{

    private static let sharedInstance = ProgressManager()
    private var progressView:ProgressView?
 
    
    init() {
        
    }
    
    class func show(){
        
        let progressView:ProgressView = UIView.fromNib(nibNameOrNil: "ProgressView")
        
        if let window = UIApplication.sharedApplication().keyWindow {
            window.addSubview(progressView)
            progressView.center = window.center
            progressView.startAnimation()
            sharedInstance.progressView?.removeFromSuperview()
            sharedInstance.progressView = progressView
        }
        
    }
    
    class func hide(){
        
        if let progressView = sharedInstance.progressView {
            progressView.stopAnimation()
            progressView.removeFromSuperview()
        }
        
    }
    
}
