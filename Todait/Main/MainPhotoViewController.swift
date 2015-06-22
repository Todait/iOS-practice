//
//  MainPhotoViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 22..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit
import Photos

class MainPhotoViewController: BasicViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
   
    var photoCollectionView:UICollectionView!
    var photoCollectionViewLayout:UICollectionViewFlowLayout!
    var selectIndexPath:NSIndexPath!
    var photos:[PHAsset] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addPhotoCollectionView()
        getPhotos()
        
        
    }
    
    
    func getPhotos(){
        
        
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending: false)]
        
        
        
        
        let result = PHAssetCollection.fetchAssetCollectionsWithType(PHAssetCollectionType.Moment, subtype: PHAssetCollectionSubtype.AlbumRegular, options: options)
        
        result.enumerateObjectsUsingBlock { (object, Int, Bool) -> Void in
            
            
            let assetResult = PHAsset.fetchAssetsInAssetCollection(object as! PHAssetCollection, options: nil)
            
            assetResult.enumerateObjectsUsingBlock({ (object, Int, Bool) -> Void in
                self.photos.append(object as! PHAsset)
            })
            
            
            
            
        }
    }
    
    
    func addPhotoCollectionView(){
        
        photoCollectionViewLayout = UICollectionViewFlowLayout()
        photoCollectionView = UICollectionView(frame: CGRectMake(0,64,width,height-64), collectionViewLayout:photoCollectionViewLayout)
        photoCollectionView.registerClass(MainPhotoCell.self, forCellWithReuseIdentifier: "photoCell")
        photoCollectionView.backgroundColor = UIColor.clearColor()
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        
        view.addSubview(photoCollectionView)
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("photoCell", forIndexPath: indexPath) as! MainPhotoCell
        
        for view in cell.contentView.subviews{
            view.removeFromSuperview()
        }
        
        
        let asset = photos[indexPath.row] as PHAsset
        let identifier = asset.localIdentifier
        let scale = UIScreen.mainScreen().scale
        let imageManager = PHCachingImageManager()
        
        
        imageManager.requestImageForAsset(asset, targetSize: CGSizeMake(106*ratio*scale,106*ratio*scale), contentMode: PHImageContentMode.AspectFill, options: nil) { (image, info) -> Void in
            cell.photoImage.image = image
        
        }
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        let asset = photos[indexPath.row] as PHAsset
        
        defaults.setValue(asset.localIdentifier, forKey:"mainPhoto")
        
        return false
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake(106*ratio, 106*ratio)
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        return 1*ratio
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1*ratio
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //todaitNavBar.todaitDelegate = self
        todaitNavBar.backButton.hidden = false
        self.titleLabel.text = "Photo"
        self.screenName = "Photo Activity"
        
        //setNavigationBarColor(mainColor)
    }
    
    
    func backButtonClk(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
}
