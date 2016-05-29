//
//  StepController.swift
//  iBake
//
//  Created by iGuest on 5/28/16.
//  Copyright © 2016 Jennifer Kang. All rights reserved.
//

import UIKit

class StepController: UIViewController{
    @IBOutlet weak var Navbar: UINavigationBar!
    
    @IBAction func previousStepSelected(sender: AnyObject) {
    }
    
    @IBAction func nextStepSelected(sender: AnyObject) {
    }
    
    
    @IBAction func HomeButton(sender: AnyObject) {
        let homeController = self.storyboard!.instantiateViewControllerWithIdentifier("home") as! ViewController
        self.presentViewController(homeController, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
