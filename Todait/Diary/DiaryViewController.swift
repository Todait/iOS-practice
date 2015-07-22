//
//  MemoViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 7. 16..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit
import CoreData
import MobileCoreServices

class DiaryViewController: BasicViewController,TodaitNavigationDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,DiaryImageDelegate{
   
    
    var doneButton:UIButton!
    var diaryTextView:UITextView!
    
    var photoButton1:UIButton!
    var photoButton2:UIButton!
    var photoButton3:UIButton!
    
    var task:Task!
    var day:Day!
    
    var newMedia:Bool! = false
    var selectedButtonTag = 0
    
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.colorWithHexString("#EEEEEE")
        addDiaryTextView()
        addPhotoButton()
        
    }
    
    
    
    func addDiaryTextView(){
        
        diaryTextView = UITextView(frame: CGRectMake(5*ratio, 64 + 5*ratio, 310*ratio, 250*ratio))
        diaryTextView.backgroundColor = UIColor.whiteColor()
        diaryTextView.becomeFirstResponder()
        diaryTextView.text = ""
        view.addSubview(diaryTextView)
    }
    
    
    func addPhotoButton(){
        
        photoButton1 = UIButton(frame: CGRectMake(10*ratio, 64 + 270*ratio, 100*ratio, 100*ratio))
        photoButton1.backgroundColor = UIColor.whiteColor()
        photoButton1.addTarget(self, action: Selector("photoButtonClk:"), forControlEvents: UIControlEvents.TouchUpInside)
        photoButton1.setTitle("+", forState: UIControlState.Normal)
        photoButton1.contentMode = UIViewContentMode.ScaleAspectFill
        photoButton1.clipsToBounds = true
        photoButton1.tag = 0
        photoButton1.imageView?.contentMode = UIViewContentMode.ScaleAspectFill
        view.addSubview(photoButton1)
        
        photoButton2 = UIButton(frame: CGRectMake(111*ratio, 64 + 270*ratio, 100*ratio, 100*ratio))
        photoButton2.backgroundColor = UIColor.whiteColor()
        photoButton2.addTarget(self, action: Selector("photoButtonClk:"), forControlEvents: UIControlEvents.TouchUpInside)
        photoButton2.setTitle("+", forState: UIControlState.Normal)
        photoButton2.tag = 1
        photoButton2.imageView?.contentMode = UIViewContentMode.ScaleAspectFill
        view.addSubview(photoButton2)
        
        photoButton3 = UIButton(frame: CGRectMake(212*ratio, 64 + 270*ratio, 100*ratio, 100*ratio))
        photoButton3.backgroundColor = UIColor.whiteColor()
        photoButton3.addTarget(self, action: Selector("photoButtonClk:"), forControlEvents: UIControlEvents.TouchUpInside)
        photoButton3.setTitle("+", forState: UIControlState.Normal)
        photoButton3.tag = 2
        photoButton3.imageView?.contentMode = UIViewContentMode.ScaleAspectFill
        view.addSubview(photoButton3)
        
        
    }
    
    func photoButtonClk(button:UIButton){
        
        selectedButtonTag = button.tag
        
        var showDiaryPhotoVC = DiaryPhotoInputViewController()
        showDiaryPhotoVC.delegate = self
        showDiaryPhotoVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        
        self.navigationController?.presentViewController(showDiaryPhotoVC, animated: false, completion: { () -> Void in
            
        })
        
    }
    
    func showAlbum() {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.mediaTypes = [kUTTypeImage as String]
        imagePicker.allowsEditing = false
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
        newMedia = false
        
    }
    
    func showCamera() {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        imagePicker.mediaTypes = [kUTTypeImage as String]
        imagePicker.allowsEditing = false
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
        newMedia = true
        
    }
    
    
    func showDiaryPhotoVC(){
        
        
        
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        if mediaType == (kUTTypeImage as String) {
            
     
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            
            switch selectedButtonTag {
            case 0: photoButton1.setImage(image, forState: UIControlState.Normal)
            case 1: photoButton2.setImage(image, forState: UIControlState.Normal)
            case 2: photoButton3.setImage(image, forState: UIControlState.Normal)
            default: photoButton1.setImage(image, forState: UIControlState.Normal)
            }
            
            
            if newMedia == true {
                UIImageWriteToSavedPhotosAlbum(image, self, "image:didFinishSavingWithError:contextInfo:", nil)
            }
        }
    }
    
    func image(image:UIImage, didFinishSavingWithError error:NSErrorPointer, contextInfo:UnsafePointer<Void>){
        
        if error != nil {
            
        }
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
         self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        todaitNavBar.todaitDelegate = self
        todaitNavBar.backButton.hidden = false
        
        if let task = task {
            
            let category = task.category_id
            titleLabel.text = category.name + " - " + task.name
        
        }
        
        addDoneButton()
        
    }
    
    func addDoneButton(){
        
        doneButton = UIButton(frame: CGRectMake(280*ratio, 32, 24, 24))
        doneButton.backgroundColor = UIColor.yellowColor()
        doneButton.addTarget(self, action: Selector("doneButtonClk"), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(doneButton)
        
    }
    
    func doneButtonClk(){
        
        saveNewDiary()
        
    }
    
    
    func saveNewDiary(){
        
        
        let entityDescription = NSEntityDescription.entityForName("Diary", inManagedObjectContext:managedObjectContext!)
        let diary = Diary(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
        
        diary.day_id = day
        diary.body = diaryTextView.text
        diary.created_at = NSDate()
        
        if let image = photoButton1.imageView?.image {
            saveNewImage(image,diary: diary)
        }
        
        if let image = photoButton2.imageView?.image {
            saveNewImage(image,diary: diary)
        }
        
        if let image = photoButton3.imageView?.image {
            saveNewImage(image,diary: diary)
        }
        
        
        var error: NSError?
        managedObjectContext?.save(&error)
        
        backButtonClk()
        
    }
    
    func saveNewImage(image:UIImage,diary:Diary){
        
        
        let entityDescription = NSEntityDescription.entityForName("ImageData", inManagedObjectContext:managedObjectContext!)
        let imageData = ImageData(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
        imageData.image = UIImageJPEGRepresentation(image, 1.0)
        imageData.diary_id = diary
        
        var error: NSError?
        managedObjectContext?.save(&error)
        
    }
    
    func backButtonClk() {
        
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
}
