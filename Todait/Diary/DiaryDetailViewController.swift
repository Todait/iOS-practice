//
//  DiaryDetailViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 7. 20..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class DiaryDetailViewController: BasicViewController,UITableViewDelegate,UITableViewDataSource,TodaitNavigationDelegate,UIActionSheetDelegate{
   
    
    var diaryTableView: UITableView!
    var day:Day!
    var task:Task!
    
    var diaryData:[Diary] = []
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    
    let TOP_MARGIN_DIARY:CGFloat! = 30.0
    let BOTTOM_MARGIN_DIARY:CGFloat = 30.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.colorWithHexString("#EFEFEF")
        
        loadDiary()
        
        addDiaryTableView()
        
    }
    
    func loadDiary(){
        
        diaryData = day.diaryList.array as! [Diary]
        
    }
    
    
    func addDiaryTableView(){
        
        
        diaryTableView = UITableView(frame: CGRectMake(6*ratio,64,width-12*ratio,height - 64), style: UITableViewStyle.Grouped)
        diaryTableView.registerClass(DiaryDetailTableViewCell.self, forCellReuseIdentifier: "diaryCell")
        
        diaryTableView.bounces = false
        diaryTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        diaryTableView.delegate = self
        diaryTableView.dataSource = self
        diaryTableView.contentOffset.y = 0
        diaryTableView.sectionFooterHeight = 0
        diaryTableView.backgroundColor = UIColor.colorWithHexString("#EFEFEF")
        diaryTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        view.addSubview(diaryTableView)
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("diaryCell", forIndexPath: indexPath) as! DiaryDetailTableViewCell
        
        
        for view in cell.contentView.subviews{
            view.removeFromSuperview()
        }
        
        
        let diary = diaryData[indexPath.section]
        cell.diaryLabel.text = diary.body
        cell.diaryLabel.sizeToFit()
        cell.diaryLabel.frame = CGRectMake(15*ratio, 30*ratio + TOP_MARGIN_DIARY, 278*ratio, cell.diaryLabel.frame.size.height)
        cell.timeLabel.text = getTimeStringFromSeconds(1000)
        cell.optionButton.indexPath = indexPath
        cell.optionButton.addTarget(self, action: Selector("optionButtonClk:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        return cell
    }
    
    func optionButtonClk(button:IndexPathButton){
        
        let actionSheet = IndexPathActionSheet(title:nil, delegate: self, cancelButtonTitle: getCancelString(), destructiveButtonTitle:nil, otherButtonTitles:"게시물 수정","공유","게시물 삭제")
        
        actionSheet.indexPath = button.indexPath
        actionSheet.showInView(view)
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        
        let actionSheet:IndexPathActionSheet = actionSheet as! IndexPathActionSheet
        
        switch buttonIndex {
            
        case 1: editPostAtIndex(actionSheet.indexPath.section)
        case 2: sharePostAtIndex(actionSheet.indexPath.section)
        case 3: deletePostAtIndex(actionSheet.indexPath.section)
        
        default: return
        
        }
        
    }
    
    func editPostAtIndex(index:Int){
    
        let diaryEditVC = DiaryEditViewController()
        diaryEditVC.diary = diaryData[index]
        
        
        self.navigationController?.pushViewController(diaryEditVC, animated: true)
        
    }
    
    func sharePostAtIndex(index:Int){
        
        
        let diary = diaryData[index]
        var images:[UIImage] = []
        
        for imageData in diary.imageList {
            let imageData:ImageData! = imageData as! ImageData
            images.append(UIImage(data: imageData.image)!)
        }
        
        let actionVC = UIActivityViewController(activityItems:images, applicationActivities:nil)
        
        self.presentViewController(actionVC, animated: true) { () -> Void in
            
        }
        
    }
    
    func deletePostAtIndex(index:Int){
        
        
        let diary = diaryData[index]
        managedObjectContext?.deleteObject(diary)
        
        var error:NSError?
        managedObjectContext?.save(&error)
        
        if error == nil {
            NSLog("Diary 삭제완료",0)
            diaryData.removeAtIndex(index)
            
            diaryTableView.beginUpdates()
            diaryTableView.deleteSections(NSIndexSet(index: index), withRowAnimation: UITableViewRowAnimation.Automatic)
            diaryTableView.endUpdates()
        }
    }
    
  
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRectMake(0, 0, 308*ratio, 204*ratio))
        
        let diary = diaryData[section]
        
        let photoLayout = UICollectionViewFlowLayout()
        photoLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        let photoVC = PhotoCollectionViewController(collectionViewLayout: photoLayout)
        photoVC.data = diary.imageList
        photoVC.view.frame = CGRectMake(0, 0, 308*ratio, 204*ratio)
        photoVC.collectionView?.frame = CGRectMake(0, 0, 308*ratio, 204*ratio)
        addChildViewController(photoVC)
        
        headerView.addSubview(photoVC.view)
        photoVC.collectionView?.reloadData()
        
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let diary = diaryData[section]
        
        if diary.imageList.count == 0 {
            return 0*ratio
        }
        
        return 204*ratio
        
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        
        let diary = diaryData[indexPath.section]
        
        let label = UILabel(frame: CGRectMake(0, 0, 278*ratio, 0))
        label.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 10*ratio)
        label.numberOfLines = 0
        label.text = diary.body
        
        let labelSize = label.sizeThatFits(CGSizeMake(278*ratio,CGFloat.max))
        
        return 30*ratio + TOP_MARGIN_DIARY + labelSize.height + BOTTOM_MARGIN_DIARY
        
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        
        
        
        
        
        return false
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return diaryData.count
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        todaitNavBar.todaitDelegate = self
        todaitNavBar.backButton.hidden = false
        
        if let task = task {
            
            let category = task.categoryId
            titleLabel.text = category.name + " - " + task.name
            
        }
        
    }
    
    
    func backButtonClk() {
        
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
}
