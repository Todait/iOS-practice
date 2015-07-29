//
//  MainCategoryCollectionViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 7. 29..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit
import CoreData

class MainCategoryCollectionViewController: BasicViewController,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    
    var categoryView:UICollectionView!
    
    var categoryData: [Category] = []
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var filterView:UIVisualEffectView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addFilterView()
        loadCategoryData()
        addCategoryView()
        
        
    }
    
    func addFilterView(){
        
        let effect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        filterView = UIVisualEffectView(effect: effect)
        filterView.frame = CGRectMake(0*ratio,0,320*ratio,55*ratio)
        filterView.alpha = 0.8
        view.addSubview(filterView)
    }
    
    func loadCategoryData(){
        
        let entityDescription = NSEntityDescription.entityForName("Category",inManagedObjectContext:managedObjectContext!)
        
        let request = NSFetchRequest()
        request.entity = entityDescription
        
        var error: NSError?
        
        categoryData = managedObjectContext?.executeFetchRequest(request, error: &error) as! [Category]
        
        NSLog("Category results %@",categoryData)
    }

    
    
    func addCategoryView(){
        
        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        categoryView = UICollectionView(frame: CGRectMake(0, 0, width, 55*ratio), collectionViewLayout:layout)
        
        categoryView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        categoryView.backgroundColor = UIColor.clearColor()
        categoryView.delegate = self
        categoryView.dataSource = self
        categoryView.pagingEnabled = true
        categoryView.showsHorizontalScrollIndicator = false
        categoryView.contentInset = UIEdgeInsetsMake(0*ratio, 0, 0, 0)
        categoryView.contentOffset = CGPointMake(0, 0)
        
        view.addSubview(categoryView)
        
    }
    
   
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
        case 0: return 1
        case 1: return categoryData.count
        case 2: return categoryData.count
        default: return 1
            
        }
        
        return categoryData.count
        
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        NSLog("Month cellforrow", 1)
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! UICollectionViewCell
        
        
        for temp in cell.contentView.subviews {
            
            temp.removeFromSuperview()
            
        }
        
        
        if indexPath.section == 0 {
            
            
            
            let sortImageView = UIImageView(frame: CGRectMake(22.5*ratio, 14*ratio, 15*ratio, 15*ratio))
            sortImageView.contentMode = UIViewContentMode.ScaleAspectFill
            sortImageView.image = UIImage(named: "ic_arrange_arrange@3x.png")
            cell.contentView.addSubview(sortImageView)
            
            
            
            
            let titleLabel = UILabel(frame:CGRectMake(0,34*ratio,60*ratio,11*ratio))
            titleLabel.text = "정렬설정"
            titleLabel.textColor = UIColor.whiteColor()
            titleLabel.textAlignment = NSTextAlignment.Center
            titleLabel.font = UIFont(name:"AppleSDGothicNeo-Medium",size:9*ratio)
            cell.contentView.addSubview(titleLabel)
            
            
            let line = UIView(frame:CGRectMake(63.5*ratio,10*ratio,1*ratio,35*ratio))
            line.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.1)
            cell.contentView.addSubview(line)
            
        }else if indexPath.section == 2 {
            
            let sortImageView = UIImageView(frame: CGRectMake(22.5*ratio, 15*ratio, 15*ratio, 15*ratio))
            sortImageView.contentMode = UIViewContentMode.ScaleAspectFill
            sortImageView.image = UIImage(named: "ic_arrange_folder@3x.png")
            cell.contentView.addSubview(sortImageView)
            
            
            let titleLabel = UILabel(frame:CGRectMake(0,33*ratio,60*ratio,24*ratio))
            titleLabel.text = "보기설정"
            titleLabel.textColor = UIColor.whiteColor()
            titleLabel.textAlignment = NSTextAlignment.Center
            titleLabel.font = UIFont(name:"AppleSDGothicNeo-Medium",size:9*ratio)
            cell.contentView.addSubview(titleLabel)
            
        }else {
            
            
            let category = categoryData[indexPath.row]
            let mainColor = UIColor.colorWithHexString(category.color)
            
            let categoryCircle = UIView(frame: CGRectMake(15*ratio, 15*ratio, 10*ratio, 10*ratio))
            categoryCircle.backgroundColor = UIColor.clearColor()
            categoryCircle.clipsToBounds = true
            categoryCircle.layer.cornerRadius = 5*ratio
            categoryCircle.layer.borderWidth = 1
            categoryCircle.layer.borderColor = mainColor.CGColor
            cell.contentView.addSubview(categoryCircle)
            
            
            
            let titleLabel = UILabel(frame:CGRectMake(0,35*ratio,40*ratio,10*ratio))
            titleLabel.text = category.name
            titleLabel.textColor = UIColor.whiteColor()
            titleLabel.textAlignment = NSTextAlignment.Center
            titleLabel.font = UIFont(name:"AppleSDGothicNeo-Ultralight",size:8*ratio)
            cell.contentView.addSubview(titleLabel)
            
            
            if category.hidden == false {
                categoryCircle.backgroundColor = mainColor
                categoryCircle.layer.borderColor = UIColor.clearColor().CGColor
            }else{
                categoryCircle.backgroundColor = UIColor.clearColor()
                categoryCircle.layer.borderColor = mainColor.CGColor
            }
            
        }
        
        
        
        
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        
        cell!.selected = true
        
        let category = categoryData[indexPath.row]
        category.hidden = !category.hidden
        
        var error: NSError?
        managedObjectContext?.save(&error)
        
        if error == nil {
            NSNotificationCenter.defaultCenter().postNotificationName("categoryDataMainUpdate", object: nil)
        }
        
        collectionView.reloadItemsAtIndexPaths([indexPath])
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        
        if indexPath.section == 1 {
            return CGSizeMake(40*ratio,55*ratio)
        }
        
        
        
        return CGSizeMake(64*ratio , 55*ratio)
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        return 0*ratio
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSizeZero
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeZero
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        todaitNavBar.hidden = true
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "categoryDataChanged", name: "categoryDataChanged", object: nil)
        
        
    }
    
    
    func categoryDataChanged(){
        
        loadCategoryData()
        categoryView.reloadData()
    }
    

}
