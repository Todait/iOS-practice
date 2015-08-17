//
//  AmountTextView.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 25..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class AmountTextView: UITextView {

    
    var paragraphStyle:NSMutableParagraphStyle!
    var amountFont:UIFont!
    var unitFont:UIFont!
    
    var amountColor:UIColor!
    var slashColor:UIColor!
    var unitColor:UIColor!
    
    var ratio:CGFloat! = 0
    var baseLine:CGFloat! = 3.5
    
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        setupRatio()
        setupStyle()
        backgroundColor = UIColor.clearColor()
        userInteractionEnabled = false
    }

    func setupRatio(){
        let screenRect = UIScreen.mainScreen().bounds
        let screenWidth = screenRect.size.width
        ratio = screenWidth/320
        

    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupStyle(){
        
        setupParagraphStyle()
        setupFont()
        setupTextColor()
    }
    
    func setupParagraphStyle(){
        paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.Left
    }
    
    func setupFont(){
        amountFont = UIFont(name: "AppleSDGothicNeo-Light", size: 20*ratio)
        unitFont = UIFont(name: "AppleSDGothicNeo-Light", size: 13*ratio)
    }
    
    func setupTextColor(){
        amountColor = UIColor.todaitOrange()
        unitColor = UIColor.todaitGray()
        slashColor = UIColor.colorWithHexString("#9fa0a0")
    }
    
    
    func setupText(current:Int,total:Int,unit:String){
        
        var string:NSMutableAttributedString = getCurrentAttributedString(current)
        string.appendAttributedString(getSlashAttributedString())
        string.appendAttributedString(getTotalAttributedString(total))
        string.appendAttributedString(getUnitAttributedString(unit))
        
        self.attributedText = string
    }
    
    func getCurrentAttributedString(current:Int)->NSMutableAttributedString{
        
        let attributes = [NSForegroundColorAttributeName:amountColor,NSFontAttributeName:amountFont,NSParagraphStyleAttributeName:paragraphStyle]
        
        return NSMutableAttributedString(string:"\(current)", attributes:attributes)
    }
    
    func getSlashAttributedString()->NSMutableAttributedString{
        
         let attributes = [NSForegroundColorAttributeName:slashColor,NSFontAttributeName:amountFont,NSParagraphStyleAttributeName:paragraphStyle]
        
        return NSMutableAttributedString(string:" / ", attributes:attributes)
    }
    
    func getTotalAttributedString(total:Int)->NSMutableAttributedString{
        
        let attributes = [NSForegroundColorAttributeName:amountColor,NSFontAttributeName:amountFont,NSParagraphStyleAttributeName:paragraphStyle]
        
        return NSMutableAttributedString(string:"\(total) ", attributes:attributes)
    }
    
    func getUnitAttributedString(unit:String)->NSMutableAttributedString{
        
        let attributes = [NSForegroundColorAttributeName:unitColor,NSFontAttributeName:unitFont,NSParagraphStyleAttributeName:paragraphStyle,NSBaselineOffsetAttributeName:baseLine]
        
        return NSMutableAttributedString(string:unit, attributes:attributes)
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
