
//
//  InvestTableViewCell.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 3..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class InvestTableViewCell: UITableViewCell {
    
    
    
    var clockImageView: UIImageView!
    var everyDayUnitButton: UIButton!
    var everyWeekUnitButton: UIButton!
    var everyHolydayUnitButton: UIButton!
    var removeButton: UIButton!
    
    var sunButton: UIButton!
    var monButton: UIButton!
    var tueButton: UIButton!
    var wedButton: UIButton!
    var thuButton: UIButton!
    var friButton: UIButton!
    var satButton: UIButton!
    
    var weekButtons:[UIButton] = []
    
    var ratio : CGFloat!
    var indexPath: NSIndexPath!
    
    let weekNameData:[String] = ["일","월","화","수","목","금","토"]
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupRatio()
        addUnitButton()
        addDayButton()
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupRatio()
        addUnitButton()
        addDayButton()
        
    }
    
    func setupRatio(){
        var screenRect = UIScreen.mainScreen().bounds
        var screenWidth : CGFloat = screenRect.size.width
        ratio = screenWidth/320
    }
    
    func addUnitButton(){
        addEveryDayButton()
        addEveryWeekButton()
        addEveryHolydayButton()
    }
    
    func addEveryDayButton(){
        everyDayUnitButton = UIButton(frame: CGRectMake(160*ratio, 10*ratio,35*ratio,25*ratio))
        everyDayUnitButton.setTitle("매일", forState: UIControlState.Normal)
        everyDayUnitButton.layer.cornerRadius = 6*ratio
        everyDayUnitButton.clipsToBounds = true
        everyDayUnitButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12*ratio)
        everyDayUnitButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        everyDayUnitButton.setBackgroundImage(UIImage.colorImage(UIColor.colorWithHexString("C9C9C9"), frame: CGRectMake(0, 0, 40*ratio, 25*ratio)), forState:UIControlState.Normal)
        addSubview(everyDayUnitButton)
        
    }
    
    func addEveryWeekButton(){
        everyWeekUnitButton = UIButton(frame: CGRectMake(205*ratio, 10*ratio,35*ratio,25*ratio))
        everyWeekUnitButton.setTitle("주중", forState: UIControlState.Normal)
        everyWeekUnitButton.layer.cornerRadius = 6*ratio
        everyWeekUnitButton.clipsToBounds = true
        everyWeekUnitButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12*ratio)
        everyWeekUnitButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        everyWeekUnitButton.setBackgroundImage(UIImage.colorImage(UIColor.colorWithHexString("C9C9C9"), frame: CGRectMake(0, 0, 40*ratio, 25*ratio)), forState:UIControlState.Normal)
        addSubview(everyWeekUnitButton)
    }
    
    func addEveryHolydayButton(){
        everyHolydayUnitButton = UIButton(frame: CGRectMake(250*ratio, 10*ratio,35*ratio,25*ratio))
        everyHolydayUnitButton.setTitle("주말", forState: UIControlState.Normal)
        everyHolydayUnitButton.layer.cornerRadius = 6*ratio
        everyHolydayUnitButton.clipsToBounds = true
        everyHolydayUnitButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12*ratio)
        everyHolydayUnitButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        everyHolydayUnitButton.setBackgroundImage(UIImage.colorImage(UIColor.colorWithHexString("C9C9C9"), frame: CGRectMake(0, 0, 40*ratio, 25*ratio)), forState:UIControlState.Normal)
        addSubview(everyHolydayUnitButton)
    }
    
    func addDayButton(){
        
        
        let padding = 5*ratio
        let radius = 15*ratio
        
        
        for index in 0...6 {
            
            let originX = 160*ratio - 3*padding - 7*radius + CGFloat(index) * (2*radius + padding)
            
            let button = UIButton(frame: CGRectMake(originX,45*ratio,2*radius,2*radius))
            
            button.setTitle(weekNameData[index], forState: UIControlState.Normal)
            button.setTitleColor(UIColor.colorWithHexString("C9C9C9"), forState: UIControlState.Normal)
            button.setBackgroundImage(UIImage.colorImage(UIColor.clearColor(), frame: CGRectMake(0, 0, radius, radius)), forState: UIControlState.Normal)
            button.layer.borderColor = UIColor.colorWithHexString("C9C9C9").CGColor
            button.clipsToBounds = true
            button.layer.borderWidth = 0.5*ratio
            button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12*ratio)
            button.layer.cornerRadius = radius
            addSubview(button)
            weekButtons.append(button)
            
        }
        
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
