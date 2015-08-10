//
//  SettingCategoryTableViewCell.swift
//  Todait
//
//  Created by CruzDiary on 2015. 8. 6..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class SettingCategoryTableViewCell: BasicTableViewCell {

    var categoryButton: UIButton!
    var titleLabel:UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style:style,reuseIdentifier:reuseIdentifier)
        
        selectedBackgroundView.backgroundColor = UIColor.todaitBackgroundGray()
        
        addCategoryImage()
        addTitleLabel()
        setCustomBackgroundView()
    }
    
    func setCustomBackgroundView(){
        
        let backView = UIView()
        backView.backgroundColor = UIColor.todaitWhiteGray()
        selectedBackgroundView = backView
    }
    
    func addCategoryImage(){
        
        categoryButton = UIButton(frame: CGRectMake(20, 13, 30, 30))
        categoryButton.setImage(UIImage.maskColor("category@3x.png", color: UIColor.whiteColor()), forState: UIControlState.Normal)
        categoryButton.setBackgroundImage(UIImage.maskColor("circle@3x.png", color: UIColor.todaitBackgroundGray()), forState: UIControlState.Normal)
        categoryButton.layer.cornerRadius = 15
        categoryButton.clipsToBounds = true
        addSubview(categoryButton)
        
    }
    
    func addTitleLabel(){
        
        titleLabel = UILabel(frame: CGRectMake(73, 0, 270, 56))
        titleLabel.textAlignment = NSTextAlignment.Left
        titleLabel.textColor = UIColor.todaitDarkGray()
        titleLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 16)
        addSubview(titleLabel)
        
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing == true{
            if animated == true {
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.categoryButton.transform = CGAffineTransformMakeTranslation(30, 0)
                    self.titleLabel.transform = CGAffineTransformMakeTranslation(30, 0)
                })
                
            }else{
                
                self.categoryButton.transform = CGAffineTransformMakeTranslation(30, 0)
                self.titleLabel.transform = CGAffineTransformMakeTranslation(30, 0)
            }
        }else{
            if animated == true {
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.categoryButton.transform = CGAffineTransformMakeTranslation(0, 0)
                    self.titleLabel.transform = CGAffineTransformMakeTranslation(0, 0)
                })
                
            }else{
                
                self.categoryButton.transform = CGAffineTransformMakeTranslation(0, 0)
                self.titleLabel.transform = CGAffineTransformMakeTranslation(0, 0)
            }
        }
        
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        
        if highlighted == true {
            backgroundColor = UIColor.todaitBackgroundGray()
        }else{
            backgroundColor = UIColor.whiteColor()
        }
        
    }
 
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
}
