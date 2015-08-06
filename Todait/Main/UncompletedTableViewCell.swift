//
//  UncompletedTableViewCell.swift
//  Todait
//
//  Created by CruzDiary on 2015. 8. 6..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class UncompletedTableViewCell: BasicTableViewCell {

    var alertImageView:UIImageView!
    var titleLabel:UILabel!
    var contentsLabel:UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        backgroundColor = UIColor.todaitRed()
        addAlertImageView()
    
    }
    
    func addAlertImageView(){
        
        alertImageView = UIImageView(frame: CGRectMake(0, 0, 68, 58))
        alertImageView.image = UIImage(named: "ic_exclamation_mark@3x.png")
        addSubview(alertImageView)
        
    }
    
    func addTitleLabel(){
        
        titleLabel = UILabel(frame: CGRectMake(70, 11, 250, 14))
        titleLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 11)
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textAlignment = NSTextAlignment.Left
        self.addSubview(titleLabel)
        
    }
    
    func addContentsLabel(){
        contentsLabel = UILabel(frame: CGRectMake(70, 20, 250, 32))
        contentsLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 16)
        contentsLabel.textColor = UIColor.whiteColor()
        contentsLabel.textAlignment = NSTextAlignment.Left
        self.addSubview(contentsLabel)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    
}
