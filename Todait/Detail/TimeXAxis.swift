//
//  TimeXAxis.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 15..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class TimeXAxis: UIView {
    
    var labels:[UILabel] = []
    
    var title:[String] = ["0시","오전4시","오전8시","점심","오후4시","오후8시","자정"]
    var ratio:CGFloat! = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupRatio()
        setupLabels(frame)
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupRatio(){
        let screenRect = UIScreen.mainScreen().bounds
        let screenWidth = screenRect.size.width
        ratio = screenWidth/320
    }
    
    
    func setupLabels(frame:CGRect){
        
        
        
        let width = frame.size.width/7
        let height = frame.size.height
        
        for index in 0...6 {
            
            let label = UILabel(frame:CGRectMake(width*CGFloat(index),0,width,height))
            label.textColor = UIColor.todaitGray()
            label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 8*ratio)
            label.textAlignment = NSTextAlignment.Center
            label.text = title[index]
            addSubview(label)
        }
        
    }
    
    func seletedLabelAtIndex(index:Int){
        
        for label in labels {
            label.font = UIFont(name:"AppleSDGothicNeo-Regular",size:8*ratio)
        }
        
        UIView.animateWithDuration(1.5, animations: { () -> Void in
            
            let label =  self.labels[index]
            label.font = UIFont(name:"AppleSDGothicNeo-Regular",size:11*self.ratio)
        })
        
    }
    
    func updateLabel(){
        
    }
}
