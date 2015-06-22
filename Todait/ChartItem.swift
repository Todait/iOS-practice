//
//  ChartItem.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 4..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class ChartItem: NSObject {
    var color: UIColor!
    var value: NSNumber!
    
    init(color:UIColor,value:NSNumber){
        
        self.color = color
        self.value = value
    }
}


class CategoryItem: NSObject {
    
    var color: UIColor!
    var value: NSNumber!
    var category: Category!
    
    init(color:UIColor,value:NSNumber,category:Category){
        
        self.color = color
        self.value = value
        self.category = category
    }
    
    
}