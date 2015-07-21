//
//  BasicCollectionViewCell.swift
//  Todait
//
//  Created by CruzDiary on 2015. 7. 21..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class BasicCollectionViewCell: UICollectionViewCell {
    
    var ratio:CGFloat! = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupRatio()
    
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupRatio(){
        let screenRect = UIScreen.mainScreen().bounds
        let screenWidth = screenRect.size.width
        ratio = screenWidth/320
    }
    
}
