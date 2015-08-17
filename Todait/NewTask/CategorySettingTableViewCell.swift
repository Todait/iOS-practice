//
//  AimTableViewCell.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 1..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit



class CategorySettingTableViewCell: UITableViewCell {
    var titleLabel : UILabel!
    var colorBoxView : UIView!
    var selectedImageView: UIImageView!
    
    var ratio : CGFloat!
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        setupRatio()
        addTitleLabel()
        addColorBoxView()
        addSelectedImageView()
    }
    
    func setupRatio(){
        let screenRect = UIScreen.mainScreen().bounds
        let screenWidth = screenRect.size.width
        ratio = screenWidth/320
    }
    
    func addTitleLabel(){
        titleLabel = UILabel(frame: CGRectMake(29*ratio, 0*ratio, 250*ratio, 50*ratio))
        titleLabel.font = UIFont(name: "AppleSDGothicNeo-Light", size: 13*ratio)
        titleLabel.textColor = UIColor.todaitGray()
        titleLabel.textAlignment = NSTextAlignment.Left
        self.addSubview(titleLabel)
    }
    
    func addColorBoxView(){
        colorBoxView = UIView(frame: CGRectMake(0, 0, 4.5*ratio , 50*ratio))
        colorBoxView.backgroundColor = UIColor.clearColor()
        self.addSubview(colorBoxView)
    }
    
    func addSelectedImageView(){
        
        selectedImageView = UIImageView(frame:CGRectMake(294*ratio - 30, 12, 19, 19))
        self.addSubview(selectedImageView)
        
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        if highlighted == true {
            self.backgroundColor = UIColor.todaitLightGray()
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
