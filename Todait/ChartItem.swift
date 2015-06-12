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
