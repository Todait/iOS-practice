//
//  DetailCalendarCell.swift
//  Todait
//
//  Created by CruzDiary on 2015. 7. 9..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class DetailCalendarCell: UITableViewCell {
    
    var weekCalendarVC:DetailWeekCalendarViewController!
    var monthCalendarVC:DetailMonthCalendarViewController!

    var width:CGFloat!
    var height:CGFloat!
    var ratio:CGFloat! = 0
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupRatio()
        addMonthView()
        addWeekView()
        
    }
    
    func setupRatio(){
        let screenRect = UIScreen.mainScreen().bounds
        let screenWidth = screenRect.size.width
        ratio = screenWidth/320
        width = 310*ratio/7
        height = 49*ratio
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addMonthView(){
        
        monthCalendarVC = DetailMonthCalendarViewController()
        monthCalendarVC.view.backgroundColor = UIColor.redColor()
        
        addSubview(monthCalendarVC.view)
        
    }
    
    func addWeekView(){
        
        weekCalendarVC = DetailWeekCalendarViewController()
        weekCalendarVC.view.backgroundColor = UIColor.whiteColor()
        weekCalendarVC.view.frame = CGRectMake(0, 0, 320*ratio, 60*ratio)
        addSubview(weekCalendarVC.view)
        
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
