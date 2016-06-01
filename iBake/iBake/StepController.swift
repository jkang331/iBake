//
//  StepController.swift
//  iBake
//
//  Created by iGuest on 5/28/16.
//  Copyright © 2016 Jennifer Kang. All rights reserved.
//

import UIKit

class StepController: UIViewController{
    var recipeDictionary : NSDictionary?
    var recipeName : String?
    
    @IBOutlet weak var previousButton: UIBarButtonItem!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    @IBOutlet weak var Navbar: UINavigationBar!
    @IBOutlet weak var stepTitle: UILabel!
    @IBOutlet weak var stepLabel: UILabel!
    
    var counter = 1;
    var displayedIngredients = false;
    
    
    @IBAction func previousStepSelected(sender: AnyObject) {
    }
    
    @IBAction func nextStepSelected(sender: AnyObject) {
    }
    
    
    @IBAction func HomeButton(sender: AnyObject) {
        let homeController = self.storyboard!.instantiateViewControllerWithIdentifier("home") as! ViewController
        self.presentViewController(homeController, animated: true, completion: nil)
    }
    
    
    func updateTitle() {
        if (!displayedIngredients){
            stepTitle.text = "Ingredients"
            previousButton.enabled = false
        } else {
            stepTitle.text = "Step \(counter)"
            counter += 1
        }
    }
    
    func updateLabel() {
        if (!displayedIngredients){
            // parse ingredients
            //not sure what this struct is
            let ingredientsBlock = recipeDictionary!["Ingredients"]
//            print(ingredientsBlock.count)
            print(recipeDictionary!["Ingredients"])
            print(recipeDictionary!["Ingredients"])  //get's main ingredient
        } else {
            //get from instructions
            stepLabel.text = String(recipeDictionary!["Instructions"])
            print(recipeDictionary!["Instructions"])
        }
        
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Navbar.topItem!.title = recipeName
        updateTitle()
        updateLabel()
        
        
        print(recipeDictionary!["TotalMinutes"])
        print(recipeDictionary!["PrimaryIngredient"])
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
