//
//  AppDelegate.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 1..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit
import CoreData
import AWSS3

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        setAppearance()
        setNotification(application)
        setAmazonWebService()
        setGoogleAnalytics()
        
        
        downloadDefaultImagesFromS3()
        
        
        return true
    }
    
    func setAppearance(){
        
        UIView.appearance().tintColor = UIColor.todaitGreen()
        UIWindow.appearance().tintColor = UIColor.todaitGreen()
        UIActionSheet.appearance().tintColor = UIColor.todaitGreen()
        UITextField.appearance().tintColor = UIColor.todaitGreen()
        
    }
    
    
    func setNotification(application: UIApplication){
        
        let notiTypes = UIUserNotificationType.Alert | UIUserNotificationType.Badge | UIUserNotificationType.Sound
        let settings = UIUserNotificationSettings(forTypes: notiTypes, categories: nil)
        
        application.registerUserNotificationSettings(settings)
    }
    
    func setAmazonWebService(){
        
        
        let credentialProvider = AWSStaticCredentialsProvider(accessKey: CREDENTIAL_ACCESS_KEY, secretKey: CREDENTIAL_SECRET_KEY)
        
        let configuration = AWSServiceConfiguration(region: .APNortheast1, credentialsProvider: credentialProvider)
        
        
        AWSServiceManager.defaultServiceManager().defaultServiceConfiguration = configuration

    
    }
    
    func setGoogleAnalytics(){
        
        
        GAI.sharedInstance().trackUncaughtExceptions = true
        GAI.sharedInstance().dispatchInterval = 20
        GAI.sharedInstance().logger.logLevel = GAILogLevel.Verbose
        GAI.sharedInstance().trackerWithTrackingId("UA-57213357-3")
    
    }

    
    func downloadDefaultImagesFromS3(){
        
        let transferManager =  AWSS3TransferManager.defaultS3TransferManager()
        
        let downloadRequest = AWSS3TransferManagerDownloadRequest.new()
        downloadRequest.bucket = AWSS3_BUCKET_NAME
        //downloadRequest.key = "base/" + fileName
        //downloadRequest.body = uploadURL
        
    }
    
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        
        NSLog("%@",notification)
        
    }
    
    
    
    
    func applicationWillResignActive(application: UIApplication) {
        
        /*
        window?.rootViewController?.dismissViewControllerAnimated(true, completion: { () -> Void in
        
        })
        */
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        
    }

}

