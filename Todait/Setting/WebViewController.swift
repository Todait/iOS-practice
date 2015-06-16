//
//  WebViewController.swift
//  Todait
//
//  Created by CruzDiary on 2015. 6. 4..
//  Copyright (c) 2015년 GpleLab. All rights reserved.
//

import UIKit

class WebViewController: BasicViewController,UIWebViewDelegate,TodaitNavigationDelegate{

    
    var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addWebView()
        
        // Do any additional setup after loading the view.
    }
    
    func addWebView(){
        webView = UIWebView(frame:CGRectMake(0, navigationHeight*ratio-20*ratio, width, height-44*ratio))
        
        
        let url:String = "http://m.blog.naver.com/PostList.nhn?blogId=todait"
        let nsUrl:NSURL = NSURL(string: url)!
        let request = NSURLRequest(URL: nsUrl, cachePolicy:NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30)
        webView.loadRequest(request)
        view.addSubview(webView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        todaitNavBar.todaitDelegate = self
        todaitNavBar.backButton.hidden = false
        self.titleLabel.text = "사용설명서"
        
        self.screenName = "Web Activity"
    }
    
    func backButtonClk() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
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
