
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
    
    var ratio : CGFloat!
    var indexPath: NSIndexPath!
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        setupRatio()
        addUnitButton()
        
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
        
    }
    
    func addEveryWeekButton(){
        
    }
    
    func addEveryHolydayButton(){
        
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
