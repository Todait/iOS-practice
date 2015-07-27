
//
//  TimeTableCategoryCell.swift
//  Todait
//
//  Created by CruzDiary on 2015. 7. 16..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class TimeTableCategoryCell: UITableViewCell {
    
    var ratio:CGFloat! = 0
    var colorBox:UIView!
    var titleLabel:UILabel!
    var timeLabel:UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clearColor()
        
        addColorBox()
        addTitleLabel()
        addTimeLabel()
        
    }
    
    func addColorBox(){
        
        colorBox = UIView(frame: CGRectMake(0, 0, 5, 50))
        colorBox.backgroundColor = UIColor.todaitGreen()
        addSubview(colorBox)
    }
    
    func addTitleLabel(){
        
        titleLabel = UILabel(frame: CGRectMake(15, 10, 80, 15))
        titleLabel.text = "운동"
        titleLabel.textAlignment = NSTextAlignment.Left
        titleLabel.textColor = UIColor.todaitDarkGray()
        titleLabel.font = UIFont(name: "AppleSDGothicNeo-UltraLight", size: 12)
        addSubview(titleLabel)
        
    }
    
    func addTimeLabel(){
        
        timeLabel = UILabel(frame: CGRectMake(15, 30 , 80, 15))
        timeLabel.text = "3시간 00분"
        timeLabel.textAlignment = NSTextAlignment.Left
        timeLabel.textColor = UIColor.todaitDarkGray()
        timeLabel.font = UIFont(name: "AppleSDGothicNeo-Light", size: 10)
        addSubview(timeLabel)
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupRatio(){
        var screenRect = UIScreen.mainScreen().bounds
        var screenWidth : CGFloat = screenRect.size.width
        ratio = screenWidth/320
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
