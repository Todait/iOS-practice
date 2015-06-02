//
//  ParallelHeaderView.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 1..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class ParallelHeaderView: UIView, UIScrollViewDelegate {

    
    var backgroundImage : UIImage!
    var backgroundImageView : UIImageView!
    var dateLabel : UILabel!
    
    
    var completionInfoLabel : UILabel!
    var completionRateLabel : UILabel!
    var studyInfoLabel : UILabel!
    var studyTimeLabel : UILabel!
    var remainingTimeLabel : UILabel!
    
    var ratio : CGFloat!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupRatio()
        
        addBackgroundImageView()
        addDateLabel()
        addCompletionInfoLabel()
        addCompletionRateLabel()
        addStudyInfoLabel()
        addStudyTimeLabel()
        addRemainingTimeLabel()
        addCenterLine()
        
        self.clipsToBounds = true
    }

    func setupRatio(){
        var screenRect = UIScreen.mainScreen().bounds
        var screenWidth : CGFloat = screenRect.size.width
        ratio = screenWidth/320
    }
    
    func addBackgroundImageView(){
        
        setupBackgroundImage()
        
        backgroundImageView = UIImageView(image: backgroundImage)
        backgroundImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        self.addSubview(backgroundImageView)
        
        addFilterImageView()
    }
    
    func setupBackgroundImage(){
        backgroundImage = UIImage(named: "test.png")
    }
    
    func addFilterImageView(){
        let filterView = UIImageView(frame: backgroundImageView.frame)
        filterView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        backgroundImageView.addSubview(filterView)
    }
    
    func addDateLabel(){
        dateLabel = UILabel(frame: CGRectMake(30*ratio, 15*ratio, 260*ratio, 30*ratio))
        dateLabel.textColor = UIColor.whiteColor()
        dateLabel.font = UIFont(name: "AvenirNext-Regular", size: 16*ratio)
        dateLabel.textAlignment = NSTextAlignment.Center
        dateLabel.text = "2015.06.01"
        backgroundImageView.addSubview(dateLabel)
        
    }
    
    func addCompletionInfoLabel(){
        completionInfoLabel = UILabel(frame: CGRectMake(30*ratio, 80*ratio, 100*ratio, 22*ratio))
        completionInfoLabel.textColor = UIColor.whiteColor()
        completionInfoLabel.font = UIFont(name: "AvenirNext-Regular", size: 12*ratio)
        completionInfoLabel.textAlignment = NSTextAlignment.Center
        completionInfoLabel.text = "성취율"
        backgroundImageView.addSubview(completionInfoLabel)
    }
    
    func addCompletionRateLabel(){
        completionRateLabel = UILabel(frame: CGRectMake(30*ratio, 100*ratio, 100*ratio, 50*ratio))
        completionRateLabel.textColor = UIColor.whiteColor()
        completionRateLabel.font = UIFont(name: "AvenirNext-Regular", size: 35*ratio)
        completionRateLabel.textAlignment = NSTextAlignment.Center
        completionRateLabel.text = "80%"
        backgroundImageView.addSubview(completionRateLabel)
    }
    
    func addStudyInfoLabel(){
        studyInfoLabel = UILabel(frame: CGRectMake(190*ratio, 80*ratio, 100*ratio, 22*ratio))
        studyInfoLabel.textColor = UIColor.whiteColor()
        studyInfoLabel.font = UIFont(name: "AvenirNext-Regular", size: 12*ratio)
        studyInfoLabel.textAlignment = NSTextAlignment.Center
        studyInfoLabel.text = "오늘 공부한 시간"
        backgroundImageView.addSubview(studyInfoLabel)
    }
    
    func addStudyTimeLabel(){
        studyTimeLabel = UILabel(frame: CGRectMake(190*ratio, 100*ratio, 100*ratio, 50*ratio))
        studyTimeLabel.textColor = UIColor.whiteColor()
        studyTimeLabel.font = UIFont(name: "AvenirNext-Regular", size: 35*ratio)
        studyTimeLabel.textAlignment = NSTextAlignment.Center
        studyTimeLabel.text = "12:34"
        backgroundImageView.addSubview(studyTimeLabel)
    }
    
    func addRemainingTimeLabel(){
        remainingTimeLabel = UILabel(frame: CGRectMake(60*ratio, 180*ratio, 200*ratio, 20*ratio))
        remainingTimeLabel.textAlignment = NSTextAlignment.Center
        remainingTimeLabel.textColor = UIColor.whiteColor()
        remainingTimeLabel.text = "오늘 남은 시간 12:33:39"
        remainingTimeLabel.font = UIFont(name: "AvenirNext-Regular", size: 14*ratio)
        backgroundImageView.addSubview(remainingTimeLabel)
    }
    
    func addCenterLine(){
        let line = UIView(frame: CGRectMake(159.75*ratio, 60*ratio, 0.5*ratio, 100*ratio))
        line.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        backgroundImageView.addSubview(line)
    }
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //ScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        NSLog("%f", scrollView.contentOffset.y)
        
        var newFrame = backgroundImageView.frame
        
        if scrollView.contentOffset.y*0.5 > 0 {
            newFrame.origin.y = scrollView.contentOffset.y*0.5
        }else{
            newFrame.origin.y = 0
        }
        
        backgroundImageView.frame = newFrame
        
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
