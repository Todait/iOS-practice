//
//  MainPhotoCell.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 22..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class MainPhotoCell: UICollectionViewCell {
    
    var photoImage:UIImageView!
    var ratio:CGFloat! = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupRatio()
        addPhotoImageView()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupRatio(){
        let screenRect = UIScreen.mainScreen().bounds
        let screenWidth = screenRect.size.width
        ratio = screenWidth/320
    }
    
    
    func addPhotoImageView(){
        
        photoImage = UIImageView(frame: CGRectMake(0, 0, 106*ratio, 106*ratio))
        photoImage.contentMode = UIViewContentMode.ScaleAspectFill
        photoImage.clipsToBounds = true
        addSubview(photoImage)
    }
}
