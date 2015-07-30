//
//  LoginViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 7. 22..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit
import Alamofire


class LoginViewController: BasicViewController,UITextFieldDelegate,ValidationDelegate{
   
    var scrollView:UIScrollView!
    
    var logoImageView:UIImageView!
    
    var emailTextField:PaddingTextField!
    var passwordField:PaddingTextField!
    
    var currentTextField:UITextField!
    
    var skipButton:UIButton!
    var loginButton:UIButton!
    var findButton:UIButton!
    var registerButton:UIButton!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        view.backgroundColor = UIColor.todaitGreen().colorWithAlphaComponent(0.8)
        
        addScrollView()
        
        
        
        addLogoImageView()
        
        addSkipButton()
        addEmailField()
        addPasswordField()
        addFindButton()
        addLoginButton()
        addRegisterButton()
        
        
        //showMainTabbarVC()
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
    
    func addLogoImageView(){
        
        logoImageView = UIImageView(frame: CGRectMake(90*ratio, 117*ratio, 140*ratio, 37*ratio))
        logoImageView.image = UIImage(named:"title@3x.png")
        scrollView.addSubview(logoImageView)
    }
    
    
    func addSkipButton(){
        
        skipButton = UIButton(frame: CGRectMake(15*ratio, 182*ratio, 295*ratio, 35*ratio))
        skipButton.setTitle("건너뛰고 시작하기", forState: UIControlState.Normal)
        skipButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        skipButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Light", size: 11*ratio)
        skipButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        scrollView.addSubview(skipButton)
        
    }
    
    func addEmailField(){
        
        emailTextField = PaddingTextField(frame: CGRectMake(0, 222*ratio, width, 48*ratio))
        emailTextField.attributedPlaceholder = NSAttributedString.getAttributedString("E-mail",font:UIFont(name: "AppleSDGothicNeo-Regular", size: 14*ratio)!,color:UIColor.whiteColor())
        emailTextField.padding = 30*ratio
        emailTextField.textAlignment = NSTextAlignment.Left
        emailTextField.delegate = self
        emailTextField.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.4)
        emailTextField.textColor = UIColor.whiteColor()
        emailTextField.returnKeyType = UIReturnKeyType.Next
        emailTextField.tintColor = UIColor.whiteColor()
        scrollView.addSubview(emailTextField)
        
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
        
        if textField == emailTextField {
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
        
        
        let validator = Validator()
        
        validator.registerField(emailTextField, rules:[EmailRule(message:"Invalid email")])
        validator.registerField(passwordField, rules:[PasswordRule]())
        validator.validate(self)
        
    }
    
    func validationSuccessful(){
        requestLogin()
    }
    
    func requestLogin(){
        
        var params:[String:AnyObject] = [:]
        let email = emailTextField.text as String
        let password = passwordField.text as String
        params["user"] = ["email":email,"password":password]
        
        var manager = Alamofire.Manager.sharedInstance
        manager.session.configuration.HTTPAdditionalHeaders = ["Content-Type":"application/json","Accept" : "application/vnd.todait.v1+json"]
        
        Alamofire.request(.POST, "https://todait.com/sessions", parameters: params).responseJSON(options: nil) { (request, response, object, error) -> Void in
            
            let json = JSON(object!)
            print(json)
            
            
            
            let errorMessage = json["error"]
            
            if errorMessage == "Invalid email or password."{
                print("ERROR")
                
                
            }else{
                print("login ")
                self.showMainTabbarVC()
            }
        }
    }
    
    func validationFailed(errors: [UITextField:ValidationError]){
        
        
        
        
        
        NSLog("error")
    }
    
    func showMainTabbarVC(){
        performSegueWithIdentifier("showMainTabbarVC", sender: self)
    }
    
    
    
    func addFindButton(){
        
        findButton = UIButton(frame: CGRectMake(10*ratio, 354*ratio, 300*ratio, 35*ratio))
        findButton.setTitle("이메일이나 비밀번호가 생각나지 않는다면?", forState: UIControlState.Normal)
        findButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        findButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        findButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Light", size: 11*ratio)
        scrollView.addSubview(findButton)
        
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
        
        self.navigationController?.pushViewController(RegisterViewController(), animated: true)
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
    
        currentTextField = textField
    
    }
    
    
}
