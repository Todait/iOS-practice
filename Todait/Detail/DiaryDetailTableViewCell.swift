//
//  DiaryDetailTableViewCell.swift
//  Todait
//
//  Created by CruzDiary on 2015. 7. 21..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class DiaryDetailTableViewCell: BasicTableViewCell {

    
    var colorCircle:UIView!
    var diaryLabel:UILabel!
    var optionButton:UIButton!
    var timeLabel:UILabel!
    
    var photoCollectionVC:PhotoCollectionViewController!

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addColorCircle()
        addTimeLabel()
        addDiaryLabel()
        
        
    }
    
    
    func addColorCircle(){
        
        colorCircle = UIView(frame: CGRectMake(15*ratio, 18*ratio, 6*ratio, 6*ratio))
        colorCircle.backgroundColor = UIColor.todaitGreen()
        colorCircle.layer.cornerRadius = 3*ratio
        colorCircle.clipsToBounds = true
        addSubview(colorCircle)
        
    }
    
    func addTimeLabel(){
        
        timeLabel = UILabel(frame: CGRectMake(30*ratio, 16.75*ratio, 260*ratio, 10*ratio))
        timeLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 7.5*ratio)
        timeLabel.textAlignment = NSTextAlignment.Left
        timeLabel.textColor = UIColor.todaitDarkGray()
        addSubview(timeLabel)
        
    }
    
    func addDiaryLabel(){
        
        diaryLabel = UILabel(frame: CGRectMake(15*ratio, 30*ratio, 278*ratio, 70*ratio))
        diaryLabel.textAlignment = NSTextAlignment.Center
        diaryLabel.numberOfLines = 0
        diaryLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 10*ratio)
        diaryLabel.textColor = UIColor.todaitDarkGray()
        addSubview(diaryLabel)
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
