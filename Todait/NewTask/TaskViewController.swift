//
//  NewGoalStep1ViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 7. 31..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class TaskViewController: BasicViewController {
   
    var amountCalculatorView:UIButton!
    var dateCalculatorView:UIButton!
    
    
    var closeButton:UIButton!
    
    
    var amountImage:UIImageView!
    var dateImage:UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.todaitBackgroundGray()
        
        addAmountCalculatorView()
        addDateCalculatorView()
        
        
    }
    
    func addAmountCalculatorView(){
        
        amountCalculatorView = UIButton(frame: CGRectMake(7*ratio, 64 + 7*ratio, 306*ratio, 200*ratio))
        amountCalculatorView.backgroundColor = UIColor.whiteColor()
        amountCalculatorView.layer.cornerRadius = 5
        amountCalculatorView.clipsToBounds = true
        amountCalculatorView.setBackgroundImage(UIImage.colorImage(UIColor.whiteColor(), frame: CGRectMake(0,0,306*ratio,200*ratio)), forState: UIControlState.Normal)
        
        amountCalculatorView.setBackgroundImage(UIImage.colorImage(UIColor.todaitLightGray(), frame: CGRectMake(0,0,306*ratio,200*ratio)), forState: UIControlState.Highlighted)
        view.addSubview(amountCalculatorView)
        
        addAmountContentsView()
        
        
        
        amountCalculatorView.addTarget(self, action: "amountButtonTouchDown", forControlEvents: UIControlEvents.TouchDown)
        amountCalculatorView.addTarget(self, action: "amountButtonTouchUpInside", forControlEvents: UIControlEvents.TouchUpInside)
        amountCalculatorView.addTarget(self, action: "amountButtonTouchUpOutside", forControlEvents: UIControlEvents.TouchUpOutside)
    }
    
    func amountButtonTouchDown(){
        amountImage.image = UIImage(named: "newgoal_step1_amount_push@3x.png")
    }
    
    func amountButtonTouchUpInside(){
        amountImage.image = UIImage(named: "newgoal_step1_amount@3x.png")
        let AmountVC = AmountTaskViewController()
        self.navigationController?.pushViewController(AmountVC, animated: true)
        
        
    }
    func amountButtonTouchUpOutside(){
        amountImage.image = UIImage(named: "newgoal_step1_amount@3x.png")
    }
    
    
    func addAmountContentsView(){
        
        amountImage = UIImageView(frame: CGRectMake(0, 0, 55*ratio, 55*ratio))
        amountImage.image = UIImage(named: "newgoal_step1_amount@3x.png")
        amountImage.center = CGPointMake(153*ratio,55*ratio)
        amountCalculatorView.addSubview(amountImage)
        
        let titleLabel = UILabel(frame: CGRectMake(20*ratio, 111*ratio, 266*ratio, 16*ratio))
        titleLabel.text = "공부량 계산"
        titleLabel.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 14*ratio)
        titleLabel.textColor = UIColor.todaitDarkGray()
        titleLabel.textAlignment = NSTextAlignment.Center
        amountCalculatorView.addSubview(titleLabel)
        
        let infoLabel = UILabel(frame: CGRectMake(20*ratio, 140*ratio, 266*ratio, 40*ratio))
        infoLabel.numberOfLines = 0
        
        var paraStyle = NSMutableParagraphStyle()
        paraStyle.paragraphSpacing = 10*ratio
        paraStyle.alignment = NSTextAlignment.Center
        
        infoLabel.attributedText = NSAttributedString.getAttributedString("목표하는 기간에 따라서,\n하루에 공부해야하는 양을 알려드립니다", font: UIFont(name: "AppleSDGothicNeo-Light", size: 9*ratio)!, color: UIColor.todaitGray(), paraStyle: paraStyle)
        amountCalculatorView.addSubview(infoLabel)
        
    }
    
    
    func addDateCalculatorView(){
        
        dateCalculatorView = UIButton(frame: CGRectMake(7*ratio, 64 + 214*ratio, 306*ratio, 200*ratio))
        dateCalculatorView.backgroundColor = UIColor.whiteColor()
        dateCalculatorView.layer.cornerRadius = 5
        dateCalculatorView.clipsToBounds = true
        
        
        
        dateCalculatorView.setBackgroundImage(UIImage.colorImage(UIColor.whiteColor(), frame: CGRectMake(0,0,306*ratio,200*ratio)), forState: UIControlState.Normal)
        
        dateCalculatorView.setBackgroundImage(UIImage.colorImage(UIColor.todaitLightGray(), frame: CGRectMake(0,0,306*ratio,200*ratio)), forState: UIControlState.Highlighted)
        view.addSubview(dateCalculatorView)
        
        
        addDateContentsView()
        
        
        dateCalculatorView.addTarget(self, action: "dateButtonTouchDown", forControlEvents: UIControlEvents.TouchDown)
        dateCalculatorView.addTarget(self, action: "dateButtonTouchUpInside", forControlEvents: UIControlEvents.TouchUpInside)
        dateCalculatorView.addTarget(self, action: "dateButtonTouchUpOutside", forControlEvents: UIControlEvents.TouchUpOutside)
    }
    
    func dateButtonTouchDown(){
        dateImage.image = UIImage(named: "newgoal_step1_time_push@3x.png")
    }
    
    func dateButtonTouchUpInside(){
        
        dateImage.image = UIImage(named: "newgoal_step1_time@3x.png")
        let step2TimeVC = NewGoalStep2TimeViewController()
        self.navigationController?.pushViewController(step2TimeVC, animated: true)
        
    }
    func dateButtonTouchUpOutside(){
        dateImage.image = UIImage(named: "newgoal_step1_time@3x.png")
    }
    
    
    
    func addDateContentsView(){
        
        dateImage = UIImageView(frame: CGRectMake(0, 0, 55*ratio, 55*ratio))
        dateImage.image = UIImage(named: "newgoal_step1_time@3x.png")
        dateImage.center = CGPointMake(153*ratio,55*ratio)
        dateCalculatorView.addSubview(dateImage)
        
        let titleLabel = UILabel(frame: CGRectMake(20*ratio, 111*ratio, 266*ratio, 16*ratio))
        titleLabel.text = "기간 계산"
        titleLabel.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 14*ratio)
        titleLabel.textColor = UIColor.todaitDarkGray()
        titleLabel.textAlignment = NSTextAlignment.Center
        dateCalculatorView.addSubview(titleLabel)
        
        let infoLabel = UILabel(frame: CGRectMake(20*ratio, 140*ratio, 266*ratio, 40*ratio))
        infoLabel.numberOfLines = 0
        
        var paraStyle = NSMutableParagraphStyle()
        paraStyle.paragraphSpacing = 10*ratio
        paraStyle.alignment = NSTextAlignment.Center
        
        infoLabel.attributedText = NSAttributedString.getAttributedString("목표하는 공부의 양에 따라서,\n목표를 달성할 수 있는 기간을 알려드립니다.", font: UIFont(name: "AppleSDGothicNeo-Light", size: 9*ratio)!, color: UIColor.todaitGray(), paraStyle: paraStyle)
        dateCalculatorView.addSubview(infoLabel)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        titleLabel.text = "새 목표 생성"
        
        addCloseButton()
        
    }
    
    func addCloseButton(){
        
        if closeButton != nil {
            return
        }
        
        closeButton = UIButton(frame: CGRectMake(2, 22, 44, 44))
        closeButton.setBackgroundImage(UIImage(named: "nav_bt_closed@3x.png"), forState: UIControlState.Normal)
        closeButton.addTarget(self, action: Selector("closeButtonClk"), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(closeButton)
    }
    
    func closeButtonClk(){
        
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        
        
    }
    
    
}
