//
//  MainPhotoViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 22..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit
import Photos

class MainPhotoViewController: BasicViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,TodaitNavigationDelegate{
   
    
    var currentImageView:UIImageView!
    var blurImageView:UIVisualEffectView!

    var mainColor:UIColor!
    
    var infoLabel:UILabel!
    var photoCollectionView:UICollectionView!
    var photoCollectionViewLayout:UICollectionViewFlowLayout!
    var selectIndexPath:NSIndexPath!
    var photos:[PHAsset] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = mainColor
        
        setupSelectIndexPath()
        
        
        addCurrentImageView()
        getFilterView()
        
        addInfoLabel()
        addPhotoCollectionView()
        getPhotos()
        
        
    }
    
    
    func addCurrentImageView(){
        
        currentImageView = UIImageView(frame: CGRectMake(0, 64, width, 250*ratio - 64))
        currentImageView.contentMode = UIViewContentMode.ScaleAspectFill
        currentImageView.clipsToBounds = true
        
        getMainImage()

        view.addSubview(currentImageView)
        
    }
    
    
    
    
    func getMainImage(){
        
        if let check: AnyObject = defaults.objectForKey("mainPhoto") {
            
            let localIdentifier:String! = defaults.objectForKey("mainPhoto") as! String
            var image:UIImage!
            
            if let check = localIdentifier {
                getMainImageFromPhotos(check as String)
            }else{
                
            }
        }
    }
    
    
    
    func getMainImageFromPhotos(localIdentifier:String){
        
        let assetResult = PHAsset.fetchAssetsWithLocalIdentifiers([localIdentifier], options: nil)
        let imageManager = PHCachingImageManager()
        
        
        if assetResult.count != 0 {
            assetResult.enumerateObjectsUsingBlock { (object, Int, Bool) -> Void in
                
                
                let asset:PHAsset = object as! PHAsset
                
                
                imageManager.requestImageForAsset(asset, targetSize: CGSizeMake(self.width,250*self.ratio), contentMode: PHImageContentMode.AspectFill, options: nil) {(image, info) -> Void in
                    self.currentImageView.image = image
                }
            }
        }
    }
    
    func getFilterView(){
        
        let filterView = UIImageView(frame: CGRectMake(0, 0, width, 250*ratio - 64))
        filterView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        currentImageView.addSubview(filterView)
    }
    
    
    func setupSelectIndexPath(){
        
        var find:Bool = false
        var index:Int = 0
        for asset in photos {
            
            let assetItem:PHAsset = asset as PHAsset
            
            if assetItem.localIdentifier == defaults.objectForKey("mainPhoto") as! String {
                find == true
            
                selectIndexPath = NSIndexPath(forItem:index, inSection: 0)
            }
            index = index + 1
        }
        
        if find == false {
            selectIndexPath = NSIndexPath(forItem: 0, inSection: 0)
        }
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
    
    
    func addInfoLabel(){
    
        infoLabel = UILabel(frame: CGRectMake(15*ratio, 250*ratio, 200*ratio, 22*ratio))
        infoLabel.textAlignment = NSTextAlignment.Left
        infoLabel.textColor = UIColor.whiteColor()
        infoLabel.text = "Photo"
        infoLabel.font = UIFont(name: "AvenirNext-Regular", size: 12*ratio)
        view.addSubview(infoLabel)
    }
    
    func addPhotoCollectionView(){
        
        photoCollectionViewLayout = UICollectionViewFlowLayout()
        photoCollectionView = UICollectionView(frame: CGRectMake(0,272*ratio,width,height-272*ratio), collectionViewLayout:photoCollectionViewLayout)
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
        
        let asset = photos[indexPath.row] as PHAsset
        cell.updateImage(asset)
        
        
        
        if selectIndexPath == indexPath {
            cell.checkImage.hidden = false
        }else{
            cell.checkImage.hidden = true
        }
        
        
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        let asset = photos[indexPath.row] as PHAsset
        
        defaults.setValue(asset.localIdentifier, forKey:"mainPhoto")
        getMainImage()
        
        selectIndexPath = indexPath
        collectionView.reloadData()
        
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
        todaitNavBar.todaitDelegate = self
        todaitNavBar.backButton.hidden = false
        self.titleLabel.text = "Photo"
        self.screenName = "Photo Activity"
        
        setNavigationBarColor(mainColor)
    }
    
    
    func backButtonClk(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
}
