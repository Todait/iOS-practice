//
//  DiaryPhotoViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 7. 17..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

protocol DiaryImageDelegate:NSObjectProtocol {
    
    func showCamera()
    func showAlbum()
    
}


class DiaryPhotoInputViewController: BasicViewController {
   
    var filterView:UIImageView!
    var resetView:UIView!
    
    
    var cameraButton:UIButton!
    var albumButton:UIButton!
    var cancelButton:UIButton!
    
    
    var task_type:String! = ""
    var unit:String! = ""
    
    var delegate:DiaryImageDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addFilterView()
        addResetView()
        addCameraButton()
        addAlbumButton()
        addCancelButton()
        
        
    }
    
    func addFilterView(){
        
        filterView = UIImageView(frame: view.frame)
        filterView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        view.addSubview(filterView)
        
    }
    
    func addResetView(){
        
        resetView = UIView(frame: CGRectMake(13.5*ratio, height, 294*ratio,154*ratio))
        resetView.backgroundColor = UIColor.clearColor()
        view.addSubview(resetView)
        
        
    }
    
    func addCameraButton(){
        cameraButton = UIButton(frame: CGRectMake(0,0*ratio,294*ratio,50*ratio))
        cameraButton.setTitle("카메라", forState: UIControlState.Normal)
        cameraButton.setTitleColor(UIColor.todaitGray(), forState: UIControlState.Normal)
        cameraButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12*ratio)
        cameraButton.backgroundColor = UIColor.whiteColor()
        cameraButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        cameraButton.titleEdgeInsets = UIEdgeInsetsMake(0, 15*ratio, 0, 0)
        cameraButton.addTarget(self, action: Selector("showCamera"), forControlEvents: UIControlEvents.TouchUpInside)
        resetView.addSubview(cameraButton)
    }
    
    func showCamera(){
        
        UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            self.resetView.transform = CGAffineTransformMakeTranslation(0, 0)
            }, completion: { (Bool) -> Void in
                
                self.dismissViewControllerAnimated(false, completion: { () -> Void in
                    
                    if let delegate = self.delegate {
                        if delegate.respondsToSelector("showCamera"){
                            delegate.showCamera()
                        }
                    }
                })
        })
    }
    
    func addAlbumButton(){
        albumButton = UIButton(frame: CGRectMake(0,51*ratio,294*ratio,50*ratio))
        albumButton.setTitle("사진 보관함", forState: UIControlState.Normal)
        albumButton.setTitleColor(UIColor.todaitGray(), forState: UIControlState.Normal)
        albumButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12*ratio)
        albumButton.backgroundColor = UIColor.whiteColor()
        albumButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        albumButton.titleEdgeInsets = UIEdgeInsetsMake(0, 15*ratio, 0, 0)
        albumButton.addTarget(self, action: Selector("showAlbum"), forControlEvents: UIControlEvents.TouchUpInside)
        resetView.addSubview(albumButton)
    }
    
    func showAlbum(){
        
        UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            self.resetView.transform = CGAffineTransformMakeTranslation(0, 0)
            }, completion: { (Bool) -> Void in
                
                self.dismissViewControllerAnimated(false, completion: { () -> Void in
                    
                    if let delegate = self.delegate {
                        if delegate.respondsToSelector("showAlbum"){
                            delegate.showAlbum()
                        }
                    }
                })
        })
    }
    
    func addCancelButton(){
        cancelButton = UIButton(frame: CGRectMake(0, 111*ratio, 294*ratio, 43*ratio))
        cancelButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        cancelButton.setTitle("취소", forState: UIControlState.Normal)
        cancelButton.setBackgroundImage(UIImage.colorImage(UIColor.todaitLightGray(), frame: CGRectMake(0, 0, 294*ratio, 43*ratio)), forState: UIControlState.Normal)
        cancelButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo", size: 15*ratio)
        cancelButton.addTarget(self, action: Selector("closeButtonClk"), forControlEvents: UIControlEvents.TouchUpInside)
        resetView.addSubview(cancelButton)
    }
    
    
    
    func closeButtonClk(){
        
        UIView.animateWithDuration(0.4, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            self.resetView.transform = CGAffineTransformMakeTranslation(0, 0)
            }, completion: { (Bool) -> Void in
                
                self.dismissViewControllerAnimated(false, completion: { () -> Void in
                    
                })
        })
    }
    
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        closeButtonClk()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        todaitNavBar.hidden = true
        
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut , animations: { () -> Void in
            self.resetView.transform = CGAffineTransformMakeTranslation(0, -154*self.ratio)
            
            }) { (Bool) -> Void in
                
        }
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
}
