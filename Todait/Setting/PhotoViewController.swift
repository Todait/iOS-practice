
//
//  PhotoViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 18..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit
import Photos

class PhotoViewController: BasicTableViewController,TodaitNavigationDelegate{
    
    
    var photos:[PHAsset] = []
    var mainColor:UIColor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sectionTitles = ["Todait 정보"]
        cellTitles = [["현재버전","오픈소스 라이선스"]]
        
        
        
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return photos.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("basic", forIndexPath: indexPath) as! UITableViewCell
        
        let asset = photos[indexPath.row] as PHAsset
        let identifier = asset.localIdentifier
        let scale = UIScreen.mainScreen().scale
        let imageManager = PHCachingImageManager()
        
        
        let imageView = UIImageView(frame:CGRectMake(0,0,width,250*ratio))
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.clipsToBounds = true
        //imageView.image =
        imageManager.requestImageForAsset(asset, targetSize: CGSizeMake(width,250*ratio), contentMode: PHImageContentMode.AspectFill, options: nil) { (image, info) -> Void in
            imageView.image = image
        }
        
        cell.addSubview(imageView)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 250*ratio
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let asset = photos[indexPath.row] as PHAsset
        
        defaults.setValue(asset.localIdentifier, forKey:"mainPhoto")
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        todaitNavBar.todaitDelegate = self
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
