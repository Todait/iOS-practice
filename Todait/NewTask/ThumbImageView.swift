//
//  ThumbImageView.swift
//  Todait
//
//  Created by CruzDiary on 2015. 8. 4..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit




class ThumbImageView: BasicImageView {
   
    var onImage:UIImage!
    var offImage:UIImage!
    var selectedImage:UIImage!
    var zeroImage:UIImage!
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    func setImageOn(on:Bool){
        
        if on == true {
            image = onImage
        }else{
            image = offImage
        }
        
    }
    
    func setImageSelected(selected:Bool){
     
        if selected == true {
            image = selectedImage
        }else{
            image = onImage
        }
    }
    
    func setZeroImage(){
        image = zeroImage
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
