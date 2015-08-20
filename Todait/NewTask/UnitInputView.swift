//
//  UnitInputView.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 24..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

protocol UnitInputViewDelegate:NSObjectProtocol {
    
    func updateUnit(unit:String)
}

class UnitInputView: UIView,UICollectionViewDelegate,UICollectionViewDataSource{

    
    private var unitCollectionView:UICollectionView!
    private var unitCollectionViewLayout:UICollectionViewFlowLayout!
    
    var title:[String] = ["개","문제","쪽"]
    var ratio:CGFloat! = 0
    var delegate:UnitInputViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupRatio()
        addUnitCollectionView()
        
    }
    
    
    func setupRatio(){
        let screenRect = UIScreen.mainScreen().bounds
        let screenWidth = screenRect.size.width
        ratio = screenWidth/320
    }
    

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addUnitCollectionView(){
        
        unitCollectionViewLayout = UICollectionViewFlowLayout()
        unitCollectionView = UICollectionView(frame: CGRectMake(0, 0, 320*ratio, 40*ratio), collectionViewLayout:unitCollectionViewLayout)
        unitCollectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        unitCollectionView.backgroundColor = UIColor.clearColor()
        unitCollectionView.delegate = self
        unitCollectionView.dataSource = self
        
        addSubview(unitCollectionView)
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! UICollectionViewCell
        
        
        let unitLabel = UILabel(frame:CGRectMake(10*ratio,0*ratio,106*ratio,40*ratio))
        unitLabel.text = title[indexPath.row]
        unitLabel.textColor = UIColor.whiteColor()
        unitLabel.textAlignment = NSTextAlignment.Center
        unitLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12*ratio)
        cell.contentView.addSubview(unitLabel)
        
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        if let delegate = delegate {
            if delegate.respondsToSelector("updateUnit:"){
                delegate.updateUnit(title[indexPath.row])
            }
        }
        
        return false
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake(106*ratio, 40*ratio)
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        return 1*ratio
    }

    
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
