//
//  RegisterViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 7. 22..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit
import MobileCoreServices

class RegisterViewController: BasicViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,DiaryImageDelegate{

    
    var scrollView:UIScrollView!
    
    var loginButton:UIButton!
    
    var profileButton:UIButton!
    var cameraButton:UIButton!
    
    var nameField:PaddingTextField!
    var emailField:PaddingTextField!
    var passwordField:PaddingTextField!
    var confirmField:PaddingTextField!
    
    var jobField:PaddingTextField!
    var objectField:PaddingTextField!
    
    var registerButton:UIButton!
    
    var newMedia:Bool! = false
    
    var selectedIndexPath:NSIndexPath!
    var jobData:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.todaitGreen().colorWithAlphaComponent(0.8)
        addScrollView()
        addLoginButton()
        addProfileButton()
        addCameraButton()
        addNameField()
        addEmailField()
        addPasswordField()
        addConfirmField()
        addJobField()
        addObjectField()
        
        addRegisterButton()
    }
    
    func addScrollView(){
        
        scrollView = UIScrollView(frame: CGRectMake(0, 0, width, height))
        scrollView.contentSize = CGSizeMake(width, height)
        scrollView.backgroundColor = UIColor.clearColor()
        view.addSubview(scrollView)
        
    }
    
    func addLoginButton(){
        
        loginButton = UIButton(frame: CGRectMake(15*ratio,64*ratio, 150*ratio, 30*ratio))
        loginButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        loginButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        loginButton.setTitle("로그인", forState: UIControlState.Normal)
        loginButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12*ratio)
        scrollView.addSubview(loginButton)
        
    }
    
    func addProfileButton(){
        
        profileButton = UIButton(frame: CGRectMake(120*ratio, 76*ratio, 80*ratio, 80*ratio))
        profileButton.contentMode = UIViewContentMode.ScaleAspectFill
        profileButton.clipsToBounds = true
        profileButton.layer.cornerRadius = 40*ratio
        profileButton.layer.borderColor = UIColor.todaitGreen().CGColor
        profileButton.layer.borderWidth = 3*ratio
        profileButton.addTarget(self, action: Selector("profileButtonClk"), forControlEvents: UIControlEvents.TouchUpInside)
        scrollView.addSubview(profileButton)
        
    }
    
    func profileButtonClk(){
        
        showPhotoInputView()
    }
    
    func addCameraButton(){
        
        cameraButton = UIButton(frame: CGRectMake(180*ratio, 136*ratio, 26*ratio, 26*ratio))
        cameraButton.backgroundColor = UIColor.todaitGreen()
        cameraButton.clipsToBounds = true
        cameraButton.layer.cornerRadius = 13*ratio
        cameraButton.addTarget(self, action: Selector("cameraButtonClk"), forControlEvents: UIControlEvents.TouchUpInside)
        scrollView.addSubview(cameraButton)
        
    }
    
    func cameraButtonClk(){
        
        showPhotoInputView()
        
    }
    
    
    func showPhotoInputView(){
        
        
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
            
            profileButton.setImage(image, forState: UIControlState.Normal)
            
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
    
    func addNameField(){
        
        nameField = PaddingTextField(frame: CGRectMake(0, 198*ratio, width, 48*ratio))
        nameField.attributedPlaceholder = NSAttributedString.getAttributedString("Name",font:UIFont(name: "AppleSDGothicNeo-Regular", size: 12*ratio)!,color:UIColor.whiteColor())
        nameField.padding = 30*ratio
        nameField.textAlignment = NSTextAlignment.Left
        nameField.delegate = self
        nameField.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.4)
        nameField.textColor = UIColor.whiteColor()
        nameField.returnKeyType = UIReturnKeyType.Next
        scrollView.addSubview(nameField)
        
    }
    
    func addEmailField(){
        
        emailField = PaddingTextField(frame: CGRectMake(0, 247*ratio, width, 48*ratio))
        emailField.attributedPlaceholder = NSAttributedString.getAttributedString("E-mail",font:UIFont(name: "AppleSDGothicNeo-Regular", size: 12*ratio)!,color:UIColor.whiteColor())
        emailField.padding = 30*ratio
        emailField.textAlignment = NSTextAlignment.Left
        emailField.delegate = self
        emailField.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.4)
        emailField.textColor = UIColor.whiteColor()
        emailField.returnKeyType = UIReturnKeyType.Next
        scrollView.addSubview(emailField)
        
    }
    
    func addPasswordField(){
        
        passwordField = PaddingTextField(frame: CGRectMake(0, 296*ratio, width, 48*ratio))
        passwordField.padding = 30*ratio
        passwordField.attributedPlaceholder = NSAttributedString.getAttributedString("Password",font:UIFont(name: "AppleSDGothicNeo-Regular", size: 12*ratio)!,color:UIColor.whiteColor())
        
        passwordField.textAlignment = NSTextAlignment.Left
        passwordField.delegate = self
        passwordField.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.4)
        passwordField.textColor = UIColor.whiteColor()
        passwordField.returnKeyType = UIReturnKeyType.Join
        scrollView.addSubview(passwordField)
    }
    
    func addConfirmField(){
        
        confirmField = PaddingTextField(frame: CGRectMake(0, 345*ratio, width, 48*ratio))
        confirmField.padding = 30*ratio
        confirmField.attributedPlaceholder = NSAttributedString.getAttributedString("Password",font:UIFont(name: "AppleSDGothicNeo-Regular", size: 12*ratio)!,color:UIColor.whiteColor())
        
        confirmField.textAlignment = NSTextAlignment.Left
        confirmField.delegate = self
        confirmField.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.4)
        confirmField.textColor = UIColor.whiteColor()
        confirmField.returnKeyType = UIReturnKeyType.Join
        scrollView.addSubview(confirmField)
    }

    
    func addObjectField(){
        
        
        jobField = PaddingTextField(frame: CGRectMake(0, 399*ratio, width, 48*ratio))
        jobField.padding = 30*ratio
        jobField.attributedPlaceholder = NSAttributedString.getAttributedString("직업",font:UIFont(name: "AppleSDGothicNeo-Regular", size: 12*ratio)!,color:UIColor.whiteColor())
        
        jobField.textAlignment = NSTextAlignment.Left
        jobField.delegate = self
        jobField.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.4)
        jobField.textColor = UIColor.whiteColor()
        jobField.returnKeyType = UIReturnKeyType.Join
        scrollView.addSubview(jobField)
    }
    
    func addJobField(){
        
        objectField = PaddingTextField(frame: CGRectMake(0, 448*ratio, width, 48*ratio))
        objectField.padding = 30*ratio
        objectField.attributedPlaceholder = NSAttributedString.getAttributedString("목표",font:UIFont(name: "AppleSDGothicNeo-Regular", size: 12*ratio)!,color:UIColor.whiteColor())
        
        objectField.textAlignment = NSTextAlignment.Left
        objectField.delegate = self
        objectField.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.4)
        objectField.textColor = UIColor.whiteColor()
        objectField.returnKeyType = UIReturnKeyType.Join
        scrollView.addSubview(objectField)
    }
    
    func addRegisterButton(){
        
        registerButton = UIButton(frame: CGRectMake(0, 501*ratio , width, 35*ratio))
        registerButton.setBackgroundImage(UIImage.colorImage(UIColor(red: 1, green: 1, blue: 1, alpha: 0.3), frame: CGRectMake(0, 0, width, 70*ratio)), forState: UIControlState.Normal)
        registerButton.setTitle("가입완료", forState: UIControlState.Normal)
        registerButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        registerButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Reguar", size: 14*ratio)
        registerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        
        scrollView.addSubview(registerButton)
        
    }
    
    
    
        
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.todaitNavBar.hidden = true
        
    }
    
}
