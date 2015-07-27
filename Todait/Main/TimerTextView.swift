//
//  TimerTextView.swift
//  Todait
//
//  Created by CruzDiary on 2015. 7. 27..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class TimerTextView: UITextView {

    
    var paragraphStyle:NSMutableParagraphStyle!
    
    var stringFont:UIFont!
    var numberFont:UIFont!
    
    var stringColor:UIColor!
    var numberColor:UIColor!
    
    
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
        stringFont = UIFont(name: "AppleSDGothicNeo-Light", size: 20*ratio)
        numberFont = UIFont(name: "AppleSDGothicNeo-Regular", size: 13*ratio)
    }
    
    func setupTextColor(){
        stringColor = UIColor.todaitGray()
        numberColor = UIColor.todaitOrange()
    }
    
    
    func setupText(seconds:NSTimeInterval){
        
        
        let remainder : Int = Int(seconds % 3600 )
        let hour : Int = Int(seconds / 3600)
        let minute : Int = Int(remainder / 60)
        let second : Int = Int(remainder % 60)
        
        var string:NSMutableAttributedString = getAttributedNumberString(String(format:"%02lu",arguments:[hour]))
        string.appendAttributedString(getAttributedTextString(" : "))
        string.appendAttributedString(getAttributedNumberString(String(format:"%02lu",arguments:[minute])))
        string.appendAttributedString(getAttributedTextString(" : "))
        string.appendAttributedString(getAttributedNumberString(String(format:"%02lu",arguments:[second])))
        string.appendAttributedString(getAttributedTextString(" 시간"))
        
        self.attributedText = string
    }
    
    func getAttributedNumberString(string:String)->NSMutableAttributedString{
        
        let attributes = [NSForegroundColorAttributeName:numberColor,NSFontAttributeName:numberFont]
        
        return NSMutableAttributedString(string:string,attributes:attributes)
        
    }
    
    func getAttributedTextString(string:String)->NSMutableAttributedString{
        
        let attributes = [NSForegroundColorAttributeName:stringColor,NSFontAttributeName:stringFont]
        
        return NSMutableAttributedString(string:string,attributes:attributes)
        
    }
    
    /*
    func getAttributedStringWithNumber(number:Int)->NSMutableAttributedString{
        
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
        
    */
}
