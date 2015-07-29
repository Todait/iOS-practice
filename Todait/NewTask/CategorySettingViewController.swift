//
//  TimeLogViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 29..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit
import CoreData

class CategorySettingViewController: BasicViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UITextFieldDelegate{
    
    
    var selectedCategory:Category!
    
    
    var filterView:UIImageView!
    var categoryView:UIView!
    var addButton:UIButton!
    var confirmButton:UIButton!
    var infoLabel:UILabel!
    
    var categoryTableView:UITableView!
    
    var categoryTextField:UITextField!
    
    var colorCollectionView:UICollectionView!
    var colorCollectionViewLayout:UICollectionViewFlowLayout!
    
    var categoryData: [Category] = []
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var selectedIndex:Int! = 0
    var isAddCategoryView:Bool! = false
    var delegate:CategoryDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategoryData()

        addFilterView()
        addCategoryView()
        addInfoView()
        addCategoryTableView()
        addConfirmButton()
        
        addCategoryField()
        addColorCollectionView()
    
    }
    
    func loadCategoryData(){
        
        let entityDescription = NSEntityDescription.entityForName("Category",inManagedObjectContext:managedObjectContext!)
        let request = NSFetchRequest()
        
        request.entity = entityDescription
        
        var error: NSError?
        
        categoryData = managedObjectContext?.executeFetchRequest(request, error: &error) as! [Category]
        
        if let category = selectedCategory {
            
        }else{
            selectedCategory = categoryData.first
        }
        
        
        NSLog("Category results %@",categoryData)
    }
    
    func addFilterView(){
        
        filterView = UIImageView(frame: view.frame)
        filterView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        view.addSubview(filterView)
        
    }
    
    func addCategoryView(){
        
        categoryView = UIView(frame: CGRectMake(13.5*ratio, height, 294*ratio,286*ratio))
        categoryView.backgroundColor = UIColor.clearColor()
        view.addSubview(categoryView)
        
        
    }
    
    func addInfoView(){
        
        addGrayView()
        addInfoLabel()
        addWhiteView()
        addAddButton()
        
    }
    
    
    func closeButtonClk(){
        
        UIView.animateWithDuration(0.4, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            self.categoryView.transform = CGAffineTransformMakeTranslation(0, 0)
            }, completion: { (Bool) -> Void in
                
                self.dismissViewControllerAnimated(false, completion: { () -> Void in
                    
                })
        })
    }
    
    
    func addGrayView(){
        let grayView = UIView(frame: CGRectMake(0, 0, 294*ratio,33*ratio))
        grayView.backgroundColor = UIColor.colorWithHexString("#949494")
        categoryView.addSubview(grayView)
    }
    
    func addInfoLabel(){
        infoLabel = UILabel(frame: CGRectMake(13*ratio, 0, 200*ratio, 33*ratio))
        infoLabel.textAlignment = NSTextAlignment.Left
        infoLabel.textColor = UIColor.whiteColor()
        infoLabel.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 12.5*ratio)
        infoLabel.text = "카테고리 설정"
        categoryView.addSubview(infoLabel)
    }
    
    func addWhiteView(){
        let whiteView = UIView(frame: CGRectMake(0, 33*ratio, 294*ratio, 191*ratio))
        whiteView.backgroundColor = UIColor.whiteColor()
        categoryView.addSubview(whiteView)
    }
    
    func addAddButton(){
        
        addButton = UIButton(frame: CGRectMake(255*ratio, 7.5*ratio, 28*ratio,20*ratio))
        addButton.layer.cornerRadius = 10*ratio
        addButton.backgroundColor = UIColor.colorWithHexString("#9F9F9F")
        addButton.setTitle("추가", forState: UIControlState.Normal)
        addButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        addButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 7.5*ratio)
        addButton.addTarget(self, action: Selector("addButtonClk"), forControlEvents: UIControlEvents.TouchDown)
        addButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        categoryView.addSubview(addButton)
        
    }
    
    func addButtonClk(){
        
        
        showAddCategoryView()
        
        
    }
    
    func showAddCategoryView(){
        
        
        
        UIView.animateWithDuration(0.4, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            self.categoryView.transform = CGAffineTransformMakeTranslation(0, 0)
            }, completion: { (Bool) -> Void in
                
                self.addButton.hidden = true
                self.infoLabel.text = "새 카테고리 생성"
                self.confirmButton.setTitle("추가", forState: UIControlState.Normal)
                self.categoryTableView.hidden = true
                self.categoryTextField.hidden = false
                self.colorCollectionView.hidden = false
                self.isAddCategoryView = true
                
                UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut , animations: { () -> Void in
                    self.categoryView.transform = CGAffineTransformMakeTranslation(0, -275*self.ratio)
                    
                    }) { (Bool) -> Void in
                        
                }
                
                
        })
        
        
        

    }
    
    func showSettingCategoryView(){
        
        infoLabel.text = "카테고리 설정"
        confirmButton.setTitle("확인", forState: UIControlState.Normal)
        
    }
    
    
    func addCategoryTableView(){
        
        categoryTableView = UITableView(frame: CGRectMake(0, 33*ratio, 294*ratio, 192*ratio))
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        categoryTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        categoryTableView.registerClass(CategorySettingTableViewCell.self, forCellReuseIdentifier: "Cell")
        categoryView.addSubview(categoryTableView)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryData.count
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        selectedCategory = categoryData[indexPath.row]
        
        tableView.reloadData()
        
        return false
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CategorySettingTableViewCell
        
        let category = categoryData[indexPath.row] as Category
        cell.colorBoxView.backgroundColor = UIColor.colorWithHexString(category.color)
        cell.titleLabel.text = category.name
        
        
        
        if category == selectedCategory {
            
            cell.selectedImageView.image = UIImage.maskColor("icon_check_wt@3x.png", color: UIColor.todaitGreen())
        }else{
            cell.selectedImageView.image = nil
        }
        
        
        
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 48*ratio
    }
    
    func addConfirmButton(){
        
        confirmButton = UIButton(frame: CGRectMake(0, 232*ratio, 294*ratio, 43*ratio))
        confirmButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        confirmButton.setTitle("확인", forState: UIControlState.Normal)
        confirmButton.setBackgroundImage(UIImage.colorImage(UIColor.todaitGreen(), frame: CGRectMake(0, 0, 294*ratio, 43*ratio)), forState: UIControlState.Normal)
        confirmButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo", size: 15*ratio)
        confirmButton.addTarget(self, action: Selector("confirmButtonClk"), forControlEvents: UIControlEvents.TouchUpInside)
        categoryView.addSubview(confirmButton)
    }
    
    func confirmButtonClk(){
        
        if isAddCategoryView == true {
            
            saveCategory()
            
            //추가
        }else{
            
            //확인
            categoryEdited(selectedCategory)
        }
        
        /*
        if self.delegate.respondsToSelector("saveTimeLog:"){
            
            
            let time = getTimeLog()
            self.delegate.saveTimeLog(time)
            
            closeButtonClk()
        }
        */
        
        closeButtonClk()
        
    }
    
    
    func saveCategory(){
        
        
        let entityDescription = NSEntityDescription.entityForName("Category", inManagedObjectContext:managedObjectContext!)
        
        let category = Category(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
        category.name = categoryTextField.text
        category.createdAt = NSDate()
        category.color = String.categoryColorStringAtIndex(selectedIndex)
        category.updatedAt = NSDate()
        category.dirtyFlag = 0
        category.hidden = false
        
        var error: NSError?
        managedObjectContext?.save(&error)
        
        if let err = error {
            //에러처리
        }else{
            NSLog("Category 저장성공",1)
            
            
            NSNotificationCenter.defaultCenter().postNotificationName("categoryDataChanged", object: nil)
            
            categoryEdited(category)
            
        }
    }
    
    func categoryEdited(category:Category){
        
        if self.delegate.respondsToSelector("categoryEdited:"){
            
            self.delegate.categoryEdited(category)
            
        }
        
    }
    
    func addCategoryField(){
        
        categoryTextField = UITextField(frame: CGRectMake(10*ratio, 65*ratio, 274*ratio, 20*ratio))
        categoryTextField.placeholder = "카테고리 이름을 입력해주세요."
        categoryTextField.textAlignment = NSTextAlignment.Center
        categoryTextField.hidden = true
        categoryTextField.returnKeyType = UIReturnKeyType.Done
        categoryTextField.delegate = self
        categoryView.addSubview(categoryTextField)
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return false
    }
    
    func addColorCollectionView(){
        
        colorCollectionViewLayout = UICollectionViewFlowLayout()
        colorCollectionView = UICollectionView(frame: CGRectMake(8*ratio, 135*ratio, 278*ratio, 75*ratio), collectionViewLayout:colorCollectionViewLayout)
        
        colorCollectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        colorCollectionView.backgroundColor = UIColor.clearColor()
        colorCollectionView.delegate = self
        colorCollectionView.dataSource = self
        colorCollectionView.hidden = true
        categoryView.addSubview(colorCollectionView)
        
        
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! UICollectionViewCell
        
        for view in cell.contentView.subviews{
            view.removeFromSuperview()
        }
        
        let circle = UIView(frame:CGRectMake(1.5*ratio, 1.5*ratio, 25*ratio, 25*ratio))
        circle.backgroundColor = UIColor.colorWithHexString(String.categoryColorStringAtIndex(indexPath.row))
        cell.contentView.addSubview(circle)
        
        
        if indexPath.row == selectedIndex {
            
            let checkView = UIImageView(frame: CGRectMake(5*ratio, 7*ratio, 15*ratio, 11*ratio))
            checkView.image = UIImage(named: "icon_check_wt@3x.png")
            circle.addSubview(checkView)
        }

        
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        selectedIndex = indexPath.row
        /*
        themeTextField.tintColor = UIColor.colorWithHexString(String.colorString(indexPath.row))
        themeTextField.textColor = UIColor.colorWithHexString(String.colorString(indexPath.row))
        themeTextField.attributedPlaceholder = getColorPlaceHolder("Untitled Theme", color: UIColor.colorWithHexString(String.colorString(indexPath.row)))
*/
        collectionView.reloadData()
        
        
        
        return false
    }
    
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake(25*ratio, 25*ratio)
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        return 1.5*ratio
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1.5*ratio
    }
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        let touch: AnyObject? = (touches as NSSet).anyObject()
        let touchPoint:CGPoint! = touch?.locationInView(view)
        
        if touchPoint.y < height - 286*ratio {
            closeButtonClk()
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        todaitNavBar.hidden = true
        
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut , animations: { () -> Void in
            self.categoryView.transform = CGAffineTransformMakeTranslation(0, -275*self.ratio)
            
            }) { (Bool) -> Void in
                
        }
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
}