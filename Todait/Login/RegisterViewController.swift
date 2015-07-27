//
//  RegisterViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 7. 22..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit
import MobileCoreServices
import Alamofire

class RegisterViewController: BasicViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,DiaryImageDelegate,ListInputDelegate{

    
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
    
    var currentTextField:UITextField!
    
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
        scrollView.bounces = false
        view.addSubview(scrollView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector("resignAllKeyBoard"))
        scrollView.addGestureRecognizer(tapGesture)
        
    }
    
    func resignAllKeyBoard(){
        
        if let textField = currentTextField {
            currentTextField.resignFirstResponder()
        }
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
        profileButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFill
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
        nameField.attributedPlaceholder = NSAttributedString.getAttributedString("Name",font:UIFont(name: "AppleSDGothicNeo-Regular", size: 14*ratio)!,color:UIColor.whiteColor())
        nameField.padding = 30*ratio
        nameField.textAlignment = NSTextAlignment.Left
        nameField.delegate = self
        nameField.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.4)
        nameField.textColor = UIColor.whiteColor()
        nameField.returnKeyType = UIReturnKeyType.Next
        nameField.tintColor = UIColor.whiteColor()
        nameField.font = UIFont(name:"AppleSDGothicNeo-Regular", size: 14*ratio)
        scrollView.addSubview(nameField)
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        switch textField {
            
        case nameField: emailField.becomeFirstResponder()
        case emailField: passwordField.becomeFirstResponder()
        case passwordField: confirmField.becomeFirstResponder()
        case confirmField: showJobInputView()
        default: return true
            
        }
        
        return true
    }
    
    func showJobInputView(){
        
        
        let listInputVC = ListInputViewController()
        
        listInputVC.dataSource = ["초등학생","중학생","고등학생","대학생","직장인"]
        listInputVC.tableTitle = "직업"
        listInputVC.buttonTitle = "취소"
        listInputVC.delegate = self
        listInputVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        
        self.navigationController?.presentViewController(listInputVC, animated: false, completion: { () -> Void in
            
        })
        
        
    }
    
    func selectedString(string:String){
        
        jobField.text = string
        scrollView.scrollRectToVisible(jobField.frame, animated: true)
        
    }
    
    func addEmailField(){
        
        emailField = PaddingTextField(frame: CGRectMake(0, 247*ratio, width, 48*ratio))
        emailField.attributedPlaceholder = NSAttributedString.getAttributedString("E-mail",font:UIFont(name: "AppleSDGothicNeo-Regular", size: 14*ratio)!,color:UIColor.whiteColor())
        emailField.padding = 30*ratio
        emailField.textAlignment = NSTextAlignment.Left
        emailField.delegate = self
        emailField.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.4)
        emailField.textColor = UIColor.whiteColor()
        emailField.returnKeyType = UIReturnKeyType.Next
        emailField.tintColor = UIColor.whiteColor()
        emailField.font = UIFont(name:"AppleSDGothicNeo-Regular", size: 14*ratio)
        scrollView.addSubview(emailField)
        
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        currentTextField = textField
        
        return true
        
    }
    
    func addPasswordField(){
        
        passwordField = PaddingTextField(frame: CGRectMake(0, 296*ratio, width, 48*ratio))
        passwordField.padding = 30*ratio
        passwordField.attributedPlaceholder = NSAttributedString.getAttributedString("Password",font:UIFont(name: "AppleSDGothicNeo-Regular", size: 14*ratio)!,color:UIColor.whiteColor())
        
        passwordField.textAlignment = NSTextAlignment.Left
        passwordField.delegate = self
        passwordField.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.4)
        passwordField.textColor = UIColor.whiteColor()
        passwordField.returnKeyType = UIReturnKeyType.Next
        passwordField.tintColor = UIColor.whiteColor()
        passwordField.font = UIFont(name:"AppleSDGothicNeo-Regular", size: 14*ratio)
        scrollView.addSubview(passwordField)
    }
    
    func addConfirmField(){
        
        confirmField = PaddingTextField(frame: CGRectMake(0, 345*ratio, width, 48*ratio))
        confirmField.padding = 30*ratio
        confirmField.attributedPlaceholder = NSAttributedString.getAttributedString("Password",font:UIFont(name: "AppleSDGothicNeo-Regular", size: 14*ratio)!,color:UIColor.whiteColor())
        
        confirmField.textAlignment = NSTextAlignment.Left
        confirmField.delegate = self
        confirmField.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.4)
        confirmField.textColor = UIColor.whiteColor()
        confirmField.returnKeyType = UIReturnKeyType.Next
        confirmField.tintColor = UIColor.whiteColor()
        confirmField.font = UIFont(name:"AppleSDGothicNeo-Regular", size: 14*ratio)
        scrollView.addSubview(confirmField)
    }

    
    func addJobField(){
        
        
        jobField = PaddingTextField(frame: CGRectMake(0, 399*ratio, width, 48*ratio))
        jobField.padding = 30*ratio
        jobField.attributedPlaceholder = NSAttributedString.getAttributedString("직업",font:UIFont(name: "AppleSDGothicNeo-Regular", size: 14*ratio)!,color:UIColor.whiteColor())
        
        jobField.textAlignment = NSTextAlignment.Left
        jobField.delegate = self
        jobField.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.4)
        jobField.textColor = UIColor.whiteColor()
        jobField.returnKeyType = UIReturnKeyType.Next
        jobField.tintColor = UIColor.whiteColor()
        jobField.font = UIFont(name:"AppleSDGothicNeo-Regular", size: 14*ratio)
        scrollView.addSubview(jobField)
    }
    
    func addObjectField(){
        
        objectField = PaddingTextField(frame: CGRectMake(0, 448*ratio, width, 48*ratio))
        objectField.padding = 30*ratio
        objectField.attributedPlaceholder = NSAttributedString.getAttributedString("목표",font:UIFont(name: "AppleSDGothicNeo-Regular", size: 14*ratio)!,color:UIColor.whiteColor())
        
        objectField.textAlignment = NSTextAlignment.Left
        objectField.delegate = self
        objectField.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.4)
        objectField.textColor = UIColor.whiteColor()
        objectField.returnKeyType = UIReturnKeyType.Next
        objectField.tintColor = UIColor.whiteColor()
        objectField.font = UIFont(name:"AppleSDGothicNeo-Regular", size: 14*ratio)
        scrollView.addSubview(objectField)
    }
    
    func addRegisterButton(){
        
        registerButton = UIButton(frame: CGRectMake(0, 501*ratio , width, 35*ratio))
        registerButton.setBackgroundImage(UIImage.colorImage(UIColor(red: 1, green: 1, blue: 1, alpha: 0.3), frame: CGRectMake(0, 0, width, 70*ratio)), forState: UIControlState.Normal)
        registerButton.setTitle("가입완료", forState: UIControlState.Normal)
        registerButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        registerButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Reguar", size: 14*ratio)
        registerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        registerButton.addTarget(self, action: Selector("registerButtonClk"), forControlEvents: UIControlEvents.TouchUpInside)
        
        scrollView.addSubview(registerButton)
        
        
    }
    
    
    func registerButtonClk(){
        
        var params:[String:AnyObject] = [:]
        
        
        let name = nameField.text as String
        let email = emailField.text as String
        let password = passwordField.text as String
        let confirm = confirmField.text as String
        let job = jobField.text as String
        let object = objectField.text as String
        
        
        
        params["user"] = ["email":email,"name":name,"password":password,"password_confirmation":confirm,"grade":job,"image_names":"test.jpeg"]
        
        
        var manager = Alamofire.Manager.sharedInstance
        manager.session.configuration.HTTPAdditionalHeaders = ["Content-Type":"application/json","Accept" : "application/vnd.todait.v1+json"]
        
        
        Alamofire.request(.POST, "https://todait.com/registrations", parameters: params).responseJSON(options: nil) { (request, response, object, error) -> Void in
            
            let json = JSON(object!)
            print(json)
            
            
        }
    }
    
    
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.todaitNavBar.hidden = true
        
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
        
        var contentInsets = UIEdgeInsetsMake(0, 0, kbSize.height, 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect = self.view.frame
        aRect.size.height = aRect.size.height - kbSize.height
        
        if (!CGRectContainsPoint(aRect, registerButton.frame.origin)) {
            
            scrollView.scrollRectToVisible(registerButton.frame, animated: true)
        }
        
        
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            //self.unitView.transform = CGAffineTransformMakeTranslation(0, -kbSize.height-40*self.ratio)
            }, completion: nil)
        
    }
    
    func keyboardWillBeHidden(aNotification:NSNotification){
        
        var contentInsets = UIEdgeInsetsZero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        
        
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            //self.unitView.transform = CGAffineTransformMakeTranslation(0, 40*self.ratio)
            }) { (Bool) -> Void in
                //self.unitView.hidden = true
        }
        
    }

    
}
