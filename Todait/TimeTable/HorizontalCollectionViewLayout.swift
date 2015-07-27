//
//  HorizontalCollectionViewLayout.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 25..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

public class HorizontalCollectionViewLayout : UICollectionViewFlowLayout {
    
    
    private var cellWidth:CGFloat! = 90
    private var cellHeight:CGFloat! = 90
    var ratio:CGFloat! = 0
    
    public override func prepareLayout() {
        
        setupRatio()
        
        cellWidth = 320*ratio / 7
        cellHeight = 48*ratio
        
    }
    

    
    func setupRatio(){
        var screenRect = UIScreen.mainScreen().bounds
        var screenWidth : CGFloat = screenRect.size.width
        ratio = screenWidth/320
    }
    
    public override func collectionViewContentSize() -> CGSize {
        let numberOfPages = Int(ceilf(Float(cellCount) / Float(cellsPerPage)))
        let width = numberOfPages * Int(boundsWidth)
        return CGSize(width: CGFloat(width), height: boundsHeight)
    }
    
    public override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        var allAttributes = [UICollectionViewLayoutAttributes]()
        
        for (var i = 0; i < cellCount; ++i) {
            let indexPath = NSIndexPath(forRow: i, inSection: 0)
            let attr = createLayoutAttributesForCellAtIndexPath(indexPath)
            allAttributes.append(attr)
        }
        
        return allAttributes
    }
    
    public override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        return createLayoutAttributesForCellAtIndexPath(indexPath)
    }
    
    public override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    private func createLayoutAttributesForCellAtIndexPath(indexPath:NSIndexPath)
        -> UICollectionViewLayoutAttributes {
            let layoutAttributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
            layoutAttributes.frame = createCellAttributeFrame(indexPath.row)
            return layoutAttributes
    }
    
    private var boundsWidth:CGFloat {
        return self.collectionView!.bounds.size.width
    }
    
    private var boundsHeight:CGFloat {
        return self.collectionView!.bounds.size.height
    }
    
    private var cellCount:Int {
        return self.collectionView!.numberOfItemsInSection(0)
    }
    
    private var verticalCellCount:Int {
        return Int(floorf(Float(boundsHeight) / Float(cellHeight)))
    }
    
    private var horizontalCellCount:Int {
        return Int(floorf(Float(boundsWidth) / Float(cellWidth)))
    }
    
    private var cellsPerPage:Int {
        return verticalCellCount * horizontalCellCount
    }
    
    private func createCellAttributeFrame(row:Int) -> CGRect {
        let frameSize = CGSize(width: cellHeight, height: cellWidth)
        let frameX = calculateCellFrameHorizontalPosition(row)
        let frameY = calculateCellFrameVerticalPosition(row)
        return CGRectMake(frameX, frameY, frameSize.width, frameSize.height)
    }
    
    private func calculateCellFrameHorizontalPosition(row:Int) -> CGFloat {
        let columnPosition = row % horizontalCellCount
        let cellPage = Int(floorf(Float(row) / Float(cellsPerPage)))
        return CGFloat(cellPage * Int(boundsWidth) + columnPosition * Int(cellWidth))
    }
    
    private func calculateCellFrameVerticalPosition(row:Int) -> CGFloat {
        let rowPosition = (row / horizontalCellCount) % verticalCellCount
        return CGFloat(rowPosition * Int(cellHeight))
    }
}