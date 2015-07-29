//
//  MainListTableViewCell.swift
//  Todait
//
//  Created by CruzDiary on 2015. 7. 28..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class MainCategoryTableViewCell: BasicTableViewCell {

    var categoryCircle:UIView!
    var titleLabel:UILabel!
    var mainColor:UIColor!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setCustomBackgroundView()
        
        
        addCategoryCircle()
        addTitleLabel()
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    
    }
    
    func setCustomBackgroundView(){
        let backView = UIView()
        backView.backgroundColor = UIColor.colorWithHexString("#252525").colorWithAlphaComponent(0.7)
        selectedBackgroundView = backView
    }
    
    func addCategoryCircle(){
        categoryCircle = UIView(frame: CGRectMake(15*ratio, 10*ratio, 10*ratio, 10*ratio))
        categoryCircle.backgroundColor = UIColor.clearColor()
        categoryCircle.clipsToBounds = true
        categoryCircle.layer.cornerRadius = 5*ratio
        categoryCircle.layer.borderWidth = 1
        addSubview(categoryCircle)
    }
    
    func addTitleLabel(){
        titleLabel = UILabel(frame:CGRectMake(38*ratio, 10*ratio, 45*ratio, 10*ratio))
        titleLabel.font = UIFont(name: "AppleSDGothicNeo-Light", size: 8*ratio)
        titleLabel.textAlignment = NSTextAlignment.Left
        titleLabel.textColor = UIColor.whiteColor()
        addSubview(titleLabel)
    }
    
    func setCategorySelect(show:Bool){
        
        if show == true {
            categoryCircle.backgroundColor = mainColor
            categoryCircle.layer.borderColor = UIColor.clearColor().CGColor
        }else{
            categoryCircle.backgroundColor = UIColor.clearColor()
            categoryCircle.layer.borderColor = mainColor.CGColor
        }
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
    }
}
