//
//  LoginViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 7. 22..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit
import Alamofire


class LoginViewController: BasicViewController,UITextFieldDelegate,ValidationDelegate,KeyboardHelpDelegate,LoginDelegate{
   
    var scrollView:UIScrollView!
    
    var backgroundImage:UIImageView!
    
    var logoImageView:UIImageView!
    
    var emailField:PaddingTextField!
    var passwordField:PaddingTextField!
    var currentTextField:UITextField?
    
    var skipButton:UIButton!
    var loginButton:UIButton!
    var findButton:UIButton!
    var registerButton:UIButton!
    
    
    
    
    private enum Status{
        case Email
        case Password
        case None
    }
    
    private var status:Status? = Status.None
    
    
    var keyboardHelpView:KeyboardHelpView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        view.backgroundColor = UIColor.todaitGreen().colorWithAlphaComponent(0.8)
        
        addBackgroundImage()
        addScrollView()
        
        
        addLogoImageView()
        
        addEmailField()
        addPasswordField()
        addFindButton()
        addLoginButton()
        addRegisterButton()
        
        addKeyboardHelpView()
        
        //login()
    }
    
    func addBackgroundImage(){
        
        backgroundImage = UIImageView(frame: view.frame)
        backgroundImage.image = UIImage(named: "bg@3x.png")
        view.addSubview(backgroundImage)
        
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
        
        if (!CGRectContainsPoint(aRect, findButton.frame.origin)) {
            
            scrollView.scrollRectToVisible(findButton.frame, animated: true)
            
        }
        
        
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            self.keyboardHelpView.transform = CGAffineTransformMakeTranslation(0, -kbSize.height-38*self.ratio)
            }, completion: nil)
        
    }
    
    func keyboardWillBeHidden(aNotification:NSNotification){
        
        var contentInsets = UIEdgeInsetsZero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        
        
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            
            self.keyboardHelpView.transform = CGAffineTransformMakeTranslation(0, 0*self.ratio)
            
            }) { (Bool) -> Void in
                //self.unitView.hidden = true
        }
        
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
            textField.resignFirstResponder()
        }
    
    }
    
    func addLogoImageView(){
        
        logoImageView = UIImageView(frame: CGRectMake(90*ratio, 117*ratio, 140*ratio, 37*ratio))
        logoImageView.image = UIImage(named:"title@3x.png")
        scrollView.addSubview(logoImageView)
    }
    
    
    
    func addEmailField(){
        
        emailField = PaddingTextField(frame: CGRectMake(0, 222*ratio, width, 48*ratio))
        emailField.attributedPlaceholder = NSAttributedString.getAttributedString("E-mail",font:UIFont(name: "AppleSDGothicNeo-Regular", size: 14*ratio)!,color:UIColor.whiteColor())
        emailField.padding = 30*ratio
        emailField.textAlignment = NSTextAlignment.Left
        emailField.delegate = self
        emailField.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.4)
        emailField.textColor = UIColor.whiteColor()
        emailField.returnKeyType = UIReturnKeyType.Next
        emailField.tintColor = UIColor.whiteColor()
        scrollView.addSubview(emailField)
        
    }
    
    func addPasswordField(){
        
        passwordField = PaddingTextField(frame: CGRectMake(0, 271*ratio, width, 48*ratio))
        passwordField.padding = 30*ratio
        passwordField.attributedPlaceholder = NSAttributedString.getAttributedString("Password",font:UIFont(name: "AppleSDGothicNeo-Regular", size: 14*ratio)!,color:UIColor.whiteColor())
        
        passwordField.textAlignment = NSTextAlignment.Left
        passwordField.delegate = self
        passwordField.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.4)
        passwordField.textColor = UIColor.whiteColor()
        passwordField.returnKeyType = UIReturnKeyType.Join
        passwordField.tintColor = UIColor.whiteColor()
        passwordField.secureTextEntry = true
        
        scrollView.addSubview(passwordField)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField == emailField {
            passwordField.becomeFirstResponder()
        }else if textField == passwordField {
            loginButtonClk()
        }
        
        return true
    }
    
    
    func addLoginButton(){
        
        loginButton = UIButton(frame:CGRectMake(0, 324*ratio, width, 35*ratio))
        loginButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 14*ratio)
        loginButton.setTitle("로그인", forState: UIControlState.Normal)
        loginButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        loginButton.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 0.3), forState: UIControlState.Highlighted)
        loginButton.setBackgroundImage(UIImage.colorImage(UIColor(red: 1, green: 1, blue: 1, alpha: 0.2), frame: CGRectMake(0, 0, width, 35*ratio)), forState: UIControlState.Normal)
        loginButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        scrollView.addSubview(loginButton)
        
        loginButton.addTarget(self, action: Selector("loginButtonClk"), forControlEvents: UIControlEvents.TouchUpInside)
        
    }
    
    
    func loginButtonClk(){
        
        
        
        ProgressManager.show()
        
        let validator = Validator()
        
        validator.registerField(emailField, rules:[MinLengthRule(length: 1, message: "이메일을 입력해주세요.")])//,EmailRule(message:"올바른 이메일을 입력해주세요."),])
        //validator.registerField(passwordField, rules:[MinLengthRule(length: 1, message: "비밀번호를 입력해주세요."),MinLengthRule(length: 8, message: "비밀번호는 8자 이상입니다."),PasswordRule(message:"올바른 비밀번호를 입력해주세요")])
        validator.validate(self)
        
    }
    
    func validationSuccessful(){
        requestLogin()
    }
    
    func requestLogin(){
        
        var params:[String:AnyObject] = [:]
        let email = emailField.text as String
        let password = passwordField.text as String
        params["user"] = ["email":email,"password":password]
        
        var manager = Alamofire.Manager.sharedInstance
        manager.session.configuration.HTTPAdditionalHeaders = ["Content-Type":"application/json","Accept" : "application/vnd.todait.v1+json"]
        
        
        Alamofire.request(.POST, SERVER_URL + LOGIN, parameters: params , encoding: .JSON).responseJSON(options: nil) { (request, response, object, error) -> Void in
            
            
            if let object: AnyObject = object {
                let json = JSON(object)
                print(json)
                
                
                
                let errorMessage = json["error"]
                let success = json["success"].stringValue
                
                
                if errorMessage == "Invalid email or password."{
                    print("ERROR")
                }else if (success == "true"){
                    print("login ")
                    
                    self.defaults.setObject(email, forKey: "email")
                    self.defaults.setObject(json["data"]["authentication_token"].stringValue, forKey: "token")
                    
                    self.login()
                    
                    
                }else{
                    ProgressManager.hide()
                }

            }else{
                ProgressManager.hide()
            }
        }
    }
    
    func validationFailed(errors: [UITextField:ValidationError]){
        
        
        for ( textField , error) in errors {
            
            let alert = UIAlertView(title: "Invalid", message: error.errorMessage, delegate: nil, cancelButtonTitle: "Cancel")
            
            alert.show()
            
            return
        }
        
        ProgressManager.hide()
    }
    
    func login(){
        performSegueWithIdentifier("showMainTabbarVC", sender: self)
    }
    
    
    
    func addFindButton(){
        
        
        findButton = UIButton(frame: CGRectMake(10*ratio, 354*ratio, 300*ratio, 35*ratio))
        findButton.setTitle("이메일이나 비밀번호가 생각나지 않는다면?", forState: UIControlState.Normal)
        findButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        findButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        findButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Light", size: 11*ratio)
        //scrollView.addSubview(findButton)
        
    }
    
    func addRegisterButton(){
        
        registerButton = UIButton(frame: CGRectMake(0, height-70*ratio, width, 70*ratio))
        registerButton.setBackgroundImage(UIImage.colorImage(UIColor(red: 1, green: 1, blue: 1, alpha: 0.3), frame: CGRectMake(0, 0, width, 70*ratio)), forState: UIControlState.Normal)
        registerButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        registerButton.setTitle("회원가입", forState: UIControlState.Normal)
        registerButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 14*ratio)
        registerButton.titleEdgeInsets = UIEdgeInsetsMake(5*ratio, 0, 0, 0)
        registerButton.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 0.3), forState: UIControlState.Highlighted)
        registerButton.addTarget(self, action: Selector("registerButtonClk"), forControlEvents: UIControlEvents.TouchUpInside)
        scrollView.addSubview(registerButton)
        
        
        let registerInfoLabel = UILabel(frame: CGRectMake(20*ratio, 5*ratio, 280*ratio, 30*ratio))
        registerInfoLabel.text = "회원 가입 시, 정보를 백업하여 편리하게 관리하실 수 있습니다"
        registerInfoLabel.textColor = UIColor.whiteColor()
        registerInfoLabel.textAlignment = NSTextAlignment.Center
        registerInfoLabel.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 10*ratio)
        registerButton.addSubview(registerInfoLabel)
        
        
    }
    
    func registerButtonClk(){
        
        let registerVC = RegisterViewController()
        registerVC.delegate = self
        
        self.navigationController?.pushViewController(registerVC, animated: false)
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
    
        currentTextField = textField
        
        if let currentTextField = currentTextField {
            
            switch currentTextField {
                
            case emailField: keyboardHelpView.setStatus(KeyboardHelpStatus.Start) ; status = .Email
            case passwordField: keyboardHelpView.setStatus(KeyboardHelpStatus.End) ; status = .Password
                
            default : return
                
            }
        }
        
    }
    
    
    
    
    func addKeyboardHelpView(){
        
        keyboardHelpView = KeyboardHelpView(frame: CGRectMake(0, height , width, 38*ratio + 185*ratio))
        keyboardHelpView.backgroundColor = UIColor.whiteColor()
        keyboardHelpView.leftImageName = "bt_keybord_left@3x.png"
        keyboardHelpView.rightImageName = "bt_keybord_right@3x.png"
        keyboardHelpView.delegate = self
        keyboardHelpView.setStatus(KeyboardHelpStatus.Center)
        
        view.addSubview(keyboardHelpView)
        
        
        let line = UIView(frame: CGRectMake(0, 38*ratio-1, width, 1))
        line.backgroundColor = UIColor.colorWithHexString("#d1d5da")
        keyboardHelpView.addSubview(line)
        
    }
    
    func leftButtonClk(){
        
        if let status = status {
            
            switch status as Status {
            case .Password: self.status = .Email ; emailField.becomeFirstResponder() ; keyboardHelpView.setStatus(KeyboardHelpStatus.Start)
            default: self.status = .None ; confirmButtonClk()
            }
        }
    }
    
    
    
    func rightButtonClk(){
        
        if let status = status {
            switch status as Status {
            case .Email: passwordField.becomeFirstResponder() ; self.status = .Password ; keyboardHelpView.setStatus(KeyboardHelpStatus.End)
            default: self.status = .None ; confirmButtonClk()
            }
        }
    }

    func confirmButtonClk() {
        
        if let currentTextField = currentTextField {
            currentTextField.resignFirstResponder()
        }
    }
}