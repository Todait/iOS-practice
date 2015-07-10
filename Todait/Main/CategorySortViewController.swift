//
//  CategorySortViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 23..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class CategorySortViewController: BasicViewController,UITableViewDelegate,UITableViewDataSource{
 
    
    var filterOringinX:CGFloat! = 0
    var filterImageView:UIImageView!
    var sortTableView:UITableView!
    var sortTitle:[String] = ["기본 정렬","이름 정렬","카테고리 정렬","사용자 정렬","완료된 목표 보기"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clearColor()
        
        addFilterImageView()
        addSortTableView()
    }
    
    func addFilterImageView(){
        
        filterImageView = UIImageView(frame: CGRectMake(filterOringinX, 0, width - filterOringinX, height))
        filterImageView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)
        view.addSubview(filterImageView)
    }
    
    func addSortTableView(){
        
        sortTableView = UITableView(frame: CGRectMake(filterOringinX,20*ratio,width - filterOringinX - 10*ratio,245*ratio), style: UITableViewStyle.Grouped)
        sortTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        sortTableView.contentInset = UIEdgeInsetsMake(-20*ratio, 0, 0, 0)
        sortTableView.delegate = self
        sortTableView.dataSource = self
        sortTableView.contentOffset.y = 0
        sortTableView.backgroundColor = UIColor.clearColor()
        sortTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        view.addSubview(sortTableView)
    }
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        
        cell.backgroundColor = UIColor.clearColor()
        cell.contentView.backgroundColor = UIColor.clearColor()
        
        for temp in cell.contentView.subviews{
            temp.removeFromSuperview()
        }
        
        if indexPath.row == 0 {
            
            var path = UIBezierPath()
            path.moveToPoint(CGPointMake(0*ratio, 24.5*ratio))
            path.addLineToPoint(CGPointMake(8*ratio, 16.5*ratio))
            path.addLineToPoint(CGPointMake(8*ratio, 0*ratio))
            path.addLineToPoint(CGPointMake(width - filterOringinX - 10*ratio, 0*ratio))
            path.addLineToPoint(CGPointMake(width - filterOringinX - 10*ratio, 49*ratio))
            path.addLineToPoint(CGPointMake(8*ratio, 49*ratio))
            path.addLineToPoint(CGPointMake(8*ratio, 32.5*ratio))
            path.addLineToPoint(CGPointMake(0*ratio, 24.5*ratio))
            
            var layer = CAShapeLayer()
            layer.path = path.CGPath
            layer.fillColor = UIColor.colorWithHexString("#394344").CGColor
            layer.strokeStart = 0
            layer.strokeEnd = 1
            cell.contentView.layer.addSublayer(layer)
            
        }else{
            
            var path = UIBezierPath()
            path.moveToPoint(CGPointMake(8*ratio, 0*ratio))
            path.addLineToPoint(CGPointMake(width - filterOringinX - 10*ratio, 0*ratio))
            path.addLineToPoint(CGPointMake(width - filterOringinX - 10*ratio, 49*ratio))
            path.addLineToPoint(CGPointMake(8*ratio, 49*ratio))
            path.addLineToPoint(CGPointMake(8*ratio, 0*ratio))
            
            var layer = CAShapeLayer()
            layer.path = path.CGPath
            layer.fillColor = UIColor.colorWithHexString("#394344").CGColor
            layer.strokeStart = 0
            layer.strokeEnd = 1
            cell.contentView.layer.addSublayer(layer)
            
        }
        
        let titleLabel = UILabel(frame: CGRectMake(38*ratio, 0, 200*ratio,49*ratio))
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textAlignment = NSTextAlignment.Left
        titleLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12.5*ratio)
        titleLabel.text = sortTitle[indexPath.row]
        
        cell.contentView.addSubview(titleLabel)
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 49*ratio
    }

    
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.dismissViewControllerAnimated(false, completion: { () -> Void in
            
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.todaitNavBar.hidden = true
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
}
