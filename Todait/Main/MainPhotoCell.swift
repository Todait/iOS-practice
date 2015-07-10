//
//  MainPhotoCell.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 22..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit
import Photos

class MainPhotoCell: UICollectionViewCell {
    
    var photoImage:UIImageView!
    var checkImage:UIImageView!
    var ratio:CGFloat! = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.whiteColor()
        setupRatio()
        addPhotoImageView()
        addCheckImageView()
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
    
    func addCheckImageView(){
        checkImage = UIImageView(frame: CGRectMake(31*ratio, 31*ratio, 44*ratio, 44*ratio))
        checkImage.image = UIImage.maskColor("done@3x.png", color: UIColor.todaitGreen())
        checkImage.hidden = true
        addSubview(checkImage)
    }
    
    func updateImage(asset:PHAsset){
        
        
        let scale = UIScreen.mainScreen().scale
        let imageManager = PHCachingImageManager()
        
        imageManager.requestImageForAsset(asset, targetSize: CGSizeMake(106*ratio*scale,106*ratio*scale), contentMode: PHImageContentMode.AspectFill, options: nil) { (image, info) -> Void in
            self.photoImage.image = image
            
        }
        
        
    }
}
