//
//  InternetManager.swift
//  Todait
//
//  Created by CruzDiary on 2015. 8. 25..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit



class InternetManager{
    
    
    var status:NetworkStatus?
    
    var internet:Reachability?
    var isConnectionRequired:Bool = false
    
    func isInternetEnable()->Bool{
        
        var stat = internet!.currentReachabilityStatus()
        
        switch stat.value {
        case 0: return false
        default: return true
        }
        
    }
    
    class var sharedInstance: InternetManager {
        
        struct Internet {
            static var onceToken: dispatch_once_t = 0
            static var instance: InternetManager? = nil
            
        }
        
        dispatch_once(&Internet.onceToken) {
            Internet.instance = InternetManager()
        }
        
        return Internet.instance!
    }
    
    
}
