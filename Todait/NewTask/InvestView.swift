//
//  InvestView.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 17..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

protocol InvestUpdateDelegate:NSObjectProtocol{
    func updateIndex(index:Int,select:Bool)
}


class InvestView: UIView {
    
    var mainColor:UIColor!
    var selected:Bool! = false
    
    var index:Int!
    var upDragButton:UIButton!
    var downDragButton:UIButton!
    var width:CGFloat! = 0
    var height:CGFloat! = 0
    
    var delegate:InvestUpdateDelegate!
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        width = frame.size.width
        height = frame.size.height
        
        addDragButton()
        
    }
    
    
    func addDragButton(){
        
        upDragButton = UIButton(frame:CGRectMake(0,-30,width,30))
        upDragButton.hidden = true
        addSubview(upDragButton)
        
        downDragButton = UIButton(frame:CGRectMake(0,height,width,30))
        downDragButton.hidden = true
        addSubview(downDragButton)
        
    }
    
    
    func update(){
        backgroundColor = mainColor.colorWithAlphaComponent(0.1)
    }
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func showDragBar(hidden:Bool){
        
        downDragButton.hidden = hidden
        upDragButton.hidden = hidden
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        if selected == true {
            backgroundColor = mainColor.colorWithAlphaComponent(0.1)
            investViewDeselect()
        }else{
            investViewSelect()
        }
        
    }
    
    func investViewSelect(){
        selected = true
        backgroundColor = mainColor
        showDragBar(false)
        
        self.delegate.updateIndex(index,select: true)
    }
    
    func investViewDeselect(){
        selected = false
        backgroundColor = mainColor.colorWithAlphaComponent(0.1)
        showDragBar(true)
        self.delegate.updateIndex(index,select:false)
        
    }
    
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        /*
        if selected == true {
            backgroundColor = mainColor
        }else{
            backgroundColor = mainColor.colorWithAlphaComponent(0.1)
        }
        */
    }
    
    override func touchesCancelled (touches: Set<NSObject>, withEvent event: UIEvent) {
        /*
        
        if selected == true {
            backgroundColor = mainColor
        }else{
            backgroundColor = mainColor.colorWithAlphaComponent(0.1)
        }
        
        */
    }
    
}
