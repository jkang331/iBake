//
//  WebViewController.swift
//  iBake
//
//  Created by iGuest on 6/2/16.
//  Copyright © 2016 Jennifer Kang. All rights reserved.
//

import UIKit


class WebViewController: UIViewController{
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var Navbar: UINavigationBar!
    
    var URL :String?
    var recipeName : String?
    
    @IBAction func donePressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func returnHome(sender: AnyObject) {
        let homeController = self.storyboard!.instantiateViewControllerWithIdentifier("home") as! ViewController
        self.presentViewController(homeController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Navbar.topItem!.title = recipeName
        
        let url = NSURL(string: URL!)
        let request = NSURLRequest(URL:url!)
        webView.loadRequest(request)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}