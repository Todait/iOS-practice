//
//  DetailHeaderView.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 24..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit
import Photos

class DetailView: UIView {

    
    var mainImageView:UIImageView!
    var filterImageView:UIImageView!
    var dateLabel:UILabel!
    var timeLabel:UILabel!
    var amountLabel:UILabel!
    
    
    var categoryCircle:UIView!
    var categoryLabel:UILabel!
    
    var ratio : CGFloat! = 0
    
    let detailViewHeight:CGFloat = 115
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupRatio()
        
        addMainImageView()
        addFilterImageView()
        addDateView()
        addTimeView()
        addAmountView()
        addCategoryView()
        
    }
    
    func setupRatio(){
        let screenRect = UIScreen.mainScreen().bounds
        let screenWidth = screenRect.size.width
        ratio = screenWidth/320
    }
    
    
    func addMainImageView(){
        
        mainImageView = UIImageView(frame: CGRectMake(0, 0, 320*ratio, detailViewHeight*ratio))
        updateMainPhoto()
        mainImageView.contentMode = UIViewContentMode.ScaleAspectFill
        mainImageView.clipsToBounds = true
        addSubview(mainImageView)
        
    }
    
    
    func updateMainPhoto(){
        
        var defaults = NSUserDefaults.standardUserDefaults()
        
        let localIdentifier: AnyObject? = defaults.objectForKey("mainPhoto")
        
        if let check = localIdentifier {
            
            let assetResult = PHAsset.fetchAssetsWithLocalIdentifiers([localIdentifier!], options: nil)
            let imageManager = PHCachingImageManager()
            
            
            if assetResult.count != 0 {
                assetResult.enumerateObjectsUsingBlock { (object, Int, Bool) -> Void in
                    
                    
                    let asset:PHAsset = object as! PHAsset
                    
                    
                    imageManager.requestImageForAsset(asset, targetSize: CGSizeMake(320*self.ratio,self.detailViewHeight*self.ratio), contentMode: PHImageContentMode.AspectFill, options: nil) {(image, info) -> Void in
                        self.mainImageView.image = image
                    }
                    
                }
            }
        }
    }
    
    
    func addFilterImageView(){
        
        filterImageView = UIImageView(frame: CGRectMake(0, 0, 320*ratio,detailViewHeight*ratio))
        filterImageView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        addSubview(filterImageView)
        
    }

    func addDateView(){
        
        let imageIcon = UIImageView(frame: CGRectMake(21*ratio, 70*ratio, 10*ratio, 10*ratio))
        imageIcon.image = UIImage(named: "detail_basic_11@3x.png")
        addSubview(imageIcon)
        
        dateLabel = UILabel(frame: CGRectMake(40*ratio, 69*ratio, 130*ratio,12*ratio))
        dateLabel.font = UIFont(name: "HelveticaNeue", size: 10*ratio)
        dateLabel.textColor = UIColor.whiteColor()
        dateLabel.textAlignment = NSTextAlignment.Left
        addSubview(dateLabel)
    }
    
    func addTimeView(){
        
        let imageIcon = UIImageView(frame: CGRectMake(181*ratio, 70*ratio, 10*ratio, 10*ratio))
        imageIcon.image = UIImage(named: "detail_basic_14@3x.png")
        addSubview(imageIcon)
        
        
        timeLabel = UILabel(frame: CGRectMake(200*ratio, 69*ratio, 130*ratio, 12*ratio))
        timeLabel.font = UIFont(name: "HelveticaNeue", size: 10*ratio)
        timeLabel.textColor = UIColor.whiteColor()
        timeLabel.textAlignment = NSTextAlignment.Left
        addSubview(timeLabel)
    }
    
    func addAmountView(){
        
        let imageIcon = UIImageView(frame: CGRectMake(21*ratio, 90*ratio, 10*ratio, 10*ratio))
        imageIcon.image = UIImage(named: "detail_basic_19@3x.png")
        addSubview(imageIcon)
        
        amountLabel = UILabel(frame: CGRectMake(40*ratio, 89*ratio, 160*ratio, 12*ratio))
        amountLabel.font = UIFont(name: "HelveticaNeue", size: 10*ratio)
        amountLabel.textColor = UIColor.whiteColor()
        amountLabel.textAlignment = NSTextAlignment.Left
        addSubview(amountLabel)
    }
    
    func addCategoryView(){
        
        
        categoryCircle = UIView(frame:CGRectMake(181*ratio,90*ratio,10*ratio,10*ratio))
        categoryCircle.layer.cornerRadius = 5*ratio
        categoryCircle.clipsToBounds = true
        addSubview(categoryCircle)
        
        
        categoryLabel = UILabel(frame: CGRectMake(200*ratio, 89*ratio, 160*ratio, 12*ratio))
        categoryLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 10*ratio)
        categoryLabel.textColor = UIColor.whiteColor()
        categoryLabel.textAlignment = NSTextAlignment.Left
        addSubview(categoryLabel)
        
        
    }
    
    
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}

