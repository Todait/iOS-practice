//
//  TimeLogViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 29..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

class CategoryEditViewController: BasicViewController,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UITextFieldDelegate{
    
    
    var editedCategory:Category!
    
    
    var filterView:UIImageView!
    var categoryView:UIView!
    var addButton:UIButton!
    var confirmButton:UIButton!
    var infoLabel:UILabel!
    
    
    var categoryTextField:UITextField!
    
    var colorCollectionView:UICollectionView!
    var colorCollectionViewLayout:UICollectionViewFlowLayout!
    
    var categoryData: [Category] = []
    
    //let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var selectedIndex:Int! = 0
    var isAddCategoryView:Bool! = false
    var delegate:CategoryDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedIndex = getIndexFromCategoryColorString(editedCategory.color)
        
        addFilterView()
        addCategoryView()
        addInfoView()
        addConfirmButton()
        
        addCategoryField()
        addColorCollectionView()
        
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
        infoLabel.text = editedCategory.name
        categoryView.addSubview(infoLabel)
    }
    
    func addWhiteView(){
        let whiteView = UIView(frame: CGRectMake(0, 33*ratio, 294*ratio, 191*ratio))
        whiteView.backgroundColor = UIColor.whiteColor()
        categoryView.addSubview(whiteView)
    }
    
    
    
    
    func addConfirmButton(){
        
        confirmButton = UIButton(frame: CGRectMake(0, 232*ratio, 294*ratio, 43*ratio))
        confirmButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        confirmButton.setTitle("수정", forState: UIControlState.Normal)
        confirmButton.setBackgroundImage(UIImage.colorImage(UIColor.todaitGreen(), frame: CGRectMake(0, 0, 294*ratio, 43*ratio)), forState: UIControlState.Normal)
        confirmButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo", size: 15*ratio)
        confirmButton.addTarget(self, action: Selector("confirmButtonClk"), forControlEvents: UIControlEvents.TouchUpInside)
        categoryView.addSubview(confirmButton)
    }
    
    func confirmButtonClk(){
        
        
        categoryTextField.resignFirstResponder()
        saveCategory()
        categoryEdited(editedCategory)
        closeButtonClk()

    }
    
    
    func saveCategory(){
        
        ProgressManager.show()
        
        var params:[String:AnyObject] = makeCategoryBatchParams(categoryTextField.text,String.categoryColorStringAtIndex(selectedIndex))
        
        setUserHeader()
        
        Alamofire.request(.POST, SERVER_URL + BATCH , parameters: params).responseJSON(options: nil) {
            (request, response , object , error) -> Void in
            
            
            if let object:AnyObject = object {
                
                let jsons = JSON(object)
                let syncData = encodeData(jsons["results"][0]["body"])
                self.realmManager.synchronize(syncData)
                
                
                let categoryData = encodeData(jsons["results"][1]["body"])
                let json:JSON? = categoryData["category"]
                
                
                if let json = json {
                    self.defaults.setObject(json.stringValue, forKey: "sync_at")
                    self.realmManager.synchronizeCategory(json)
                    
                    
                    if let serverId = json["id"].int {
                        
                        let predicate = NSPredicate(format: " archived == false && serverId == %lu",serverId)
                        let editedCategory = self.realm.objects(Category).filter(predicate)
                        
                        
                        if editedCategory.count > 0 {
                            self.categoryEdited(editedCategory.first!)
                        }
                    }
                }
            }
            
            ProgressManager.hide()
            self.closeButtonClk()
        }
    }
    
    func categoryEdited(category:Category){
        
        
        if let delegate = self.delegate{
            
            if delegate.respondsToSelector("categoryEdited:"){
                
                delegate.categoryEdited(category)
                
            }
        }
    }
    
    func addCategoryField(){
        
        categoryTextField = UITextField(frame: CGRectMake(10*ratio, 55*ratio, 274*ratio, 20*ratio))
        categoryTextField.placeholder = "카테고리 이름을 입력해주세요."
        categoryTextField.textAlignment = NSTextAlignment.Center
        categoryTextField.returnKeyType = UIReturnKeyType.Done
        categoryTextField.delegate = self
        categoryTextField.textColor = UIColor.todaitLightGray()
        categoryTextField.text = editedCategory.name
        categoryTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        categoryView.addSubview(categoryTextField)
        
        let line = UIView(frame: CGRectMake(10*ratio,85*ratio,274*ratio,1))
        line.backgroundColor = UIColor.todaitLightGray()
        categoryView.addSubview(line)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        confirmButtonClk()
        
        
        return true
    }
    
    func addColorCollectionView(){
        
        colorCollectionViewLayout = UICollectionViewFlowLayout()
        colorCollectionView = UICollectionView(frame: CGRectMake(8*ratio, 115*ratio, 278*ratio, 75*ratio), collectionViewLayout:colorCollectionViewLayout)
        
        colorCollectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        colorCollectionView.backgroundColor = UIColor.clearColor()
        colorCollectionView.delegate = self
        colorCollectionView.dataSource = self
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
        
        
        registerForKeyboardNotification()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        resignForKeyboardNotification()
    }
    
    func resignForKeyboardNotification(){
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    
    func registerForKeyboardNotification(){
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWasShown:"), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillBeHidden:"), name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func keyboardWasShown(aNotification:NSNotification){
        
        var info:[NSObject:AnyObject] = aNotification.userInfo!
        var kbSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)!.CGRectValue().size as CGSize
        
        
        
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            
            self.categoryView.transform = CGAffineTransformMakeTranslation(0, -self.categoryView.frame.size.height - kbSize.height)
            
            }, completion: nil)
        
    }
    
    func keyboardWillBeHidden(aNotification:NSNotification){
        
        
        
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            
            self.categoryView.transform = CGAffineTransformMakeTranslation(0, 0)
            
            }, completion: nil)
    }
    
}
