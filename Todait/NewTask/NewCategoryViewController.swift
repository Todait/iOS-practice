//
//  NewCategoryViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 4..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit
import CoreData

protocol UpdateDelegate: NSObjectProtocol {
    func needToUpdate()
}


class NewCategoryViewController: BasicViewController,TodaitNavigationDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITextFieldDelegate{

    
    var saveCategoryButton: UIButton!
    var blurEffectView: UIVisualEffectView!
    var categoryNameTextField: PaddingTextField!
    
    var colorCollectionView: UICollectionView!
    var colorCollectionViewLayout: UICollectionViewFlowLayout!
    var colorData:[String] = ["#FFFB887E","#FFF1CB67","#FFAA9DDE","#FF5694CF","#FF5A5A5A","#FFBEFCEF","#FFC6B6A7","#FF25D59B","#FFDA5A68","#FFF5A26F"]
    var selectedIndex = 0
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var delegate:UpdateDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBlurBackground()
        addCategoryNameTextField()
        addCollectionView()
        
        
        // Do any additional setup after loading the view.
    }

    
    
    func setupBlurBackground(){
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.frame
        blurEffectView.alpha = 0.6
        view.addSubview(blurEffectView)
    }
    


    func addCategoryNameTextField(){
        
        categoryNameTextField = PaddingTextField(frame: CGRectMake(0, 0, width, 80*ratio))
        categoryNameTextField.backgroundColor = UIColor.whiteColor()
        categoryNameTextField.placeholder = "카테고리 이름"
        categoryNameTextField.textColor = UIColor.colorWithHexString("#969696")
        categoryNameTextField.font = UIFont(name: "AvenirNext-Regular", size: 20*ratio)
        categoryNameTextField.becomeFirstResponder()
        categoryNameTextField.returnKeyType = UIReturnKeyType.Done
        categoryNameTextField.delegate = self
        view.addSubview(categoryNameTextField)
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        
        saveCategory()
        
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
        
        
        return false
    }
    
    func addCollectionView(){
        
        colorCollectionViewLayout = UICollectionViewFlowLayout()
        colorCollectionView = UICollectionView(frame: CGRectMake(30*ratio, 95*ratio, 260*ratio, 150*ratio), collectionViewLayout:colorCollectionViewLayout)
        colorCollectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        colorCollectionView.backgroundColor = UIColor.clearColor()
        colorCollectionView.delegate = self
        colorCollectionView.dataSource = self
        
        view.addSubview(colorCollectionView)
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! UICollectionViewCell
        cell.layer.cornerRadius = 6*ratio
        cell.clipsToBounds = true
        cell.backgroundColor = UIColor.colorWithHexString(colorData[indexPath.row])
        
        for view in cell.contentView.subviews{
            view.removeFromSuperview()
        }
        
        
        if indexPath.row == selectedIndex {
            
            var checkImage = UIImageView(frame: CGRectMake(11.5*ratio, 11.5*ratio, 22*ratio, 22*ratio))
            checkImage.image = UIImage.maskColor("done@3x.png", color: UIColor.whiteColor())
            cell.contentView.addSubview(checkImage)
        }
        
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        selectedIndex = indexPath.row
        collectionView.reloadData()
        
        return false
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake(45*ratio, 45*ratio)
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        return 5*ratio
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        todaitNavBar.hidden = true
        todaitNavBar.todaitDelegate = self
        todaitNavBar.backButton.hidden = false
        
        addSaveCategoryBtn()
        self.screenName = "Category Activity"
        //titleLabel.text = "Category 추가"
    }
    
    func addSaveCategoryBtn(){
        saveCategoryButton = UIButton(frame: CGRectMake(288*ratio, 30*ratio, 24*ratio, 24*ratio))
        saveCategoryButton.setImage(UIImage.maskColor("newPlus.png",color:UIColor.whiteColor()), forState: UIControlState.Normal)
        saveCategoryButton.addTarget(self, action: Selector("saveCategory"), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(saveCategoryButton)
    }
    
    func saveCategory(){
        
        
        let entityDescription = NSEntityDescription.entityForName("Category", inManagedObjectContext:managedObjectContext!)
        
        let category = Category(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
        category.name = categoryNameTextField.text
        category.created_at = NSDate()
        category.color = colorData[selectedIndex]
        category.updated_at = NSDate()
        category.dirty_flag = 0
        
        var error: NSError?
        managedObjectContext?.save(&error)
        
        if let err = error {
            //에러처리
        }else{
            NSLog("Category 저장성공",1)
            needToUpdate()
        }
    }
    
    func needToUpdate(){
        if self.delegate.respondsToSelector("needToUpdate"){
            self.delegate.needToUpdate()
        }
    }
    
    func backButtonClk() {
        self.navigationController?.popViewControllerAnimated(true)
    }

    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
