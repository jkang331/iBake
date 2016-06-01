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
    var ingredientsList : String?
    var instructionsArray : [String]?
    
    @IBOutlet weak var previousButton: UIBarButtonItem!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    @IBOutlet weak var Navbar: UINavigationBar!
    @IBOutlet weak var stepTitle: UILabel!
    @IBOutlet weak var stepLabel: UILabel!
    
    var counter = 0;
    var displayedIngredients = false;
    
    
    @IBAction func previousStepSelected(sender: AnyObject) {
        let previousStepViewController = self.storyboard!.instantiateViewControllerWithIdentifier("recipeStep") as! StepController
        
        previousStepViewController.recipeDictionary = recipeDictionary
        previousStepViewController.recipeName = recipeName
        previousStepViewController.instructionsArray = instructionsArray
        previousStepViewController.counter = counter - 1
        previousStepViewController.ingredientsList = ingredientsList
        previousStepViewController.displayedIngredients = displayedIngredients
        
        if (previousStepViewController.counter == 0) {
            previousStepViewController.displayedIngredients = false
            
        }
        previousStepViewController.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
//        UIView.beginAnimations("LeftFlip", context: nil)
//        UIView.setAnimationDuration(0.8)
//        UIView.setAnimationTransition(.FlipFromLeft, forView: view , cache: true)
//        UIView.commitAnimations()
        self.presentViewController(previousStepViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func nextStepSelected(sender: AnyObject) {
        
        
        
        // need to check if end or not
        
        
        let nextStepViewController = self.storyboard!.instantiateViewControllerWithIdentifier("recipeStep") as! StepController
        nextStepViewController.recipeDictionary = recipeDictionary
        nextStepViewController.recipeName = recipeName
        nextStepViewController.ingredientsList = ingredientsList
        nextStepViewController.instructionsArray = instructionsArray
        nextStepViewController.counter = counter + 1
        nextStepViewController.displayedIngredients = displayedIngredients
        
        
        
        nextStepViewController.modalTransitionStyle = UIModalTransitionStyle.PartialCurl
        self.presentViewController(nextStepViewController, animated: true, completion: nil)
        
        
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
            
        }
    }
    
    func updateLabel() {
        
        if (!displayedIngredients && ingredientsList == nil){
            // parse ingredients
            var ingredientsList = ""
            let ingredientsArray = recipeDictionary!["Ingredients"] as! NSArray
            print(ingredientsArray.count)
            for i in ingredientsArray {
                let ingredient = i as! NSDictionary
                print(i)
                let name = String(ingredient["Name"]!).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                var amount = String(ingredient["Quantity"]!).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                let unit = String(ingredient["Unit"]!).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).stringByReplacingOccurrencesOfString("(", withString: "").stringByReplacingOccurrencesOfString(")", withString: "").stringByReplacingOccurrencesOfString("<null>", withString: "")
                let notes = String(ingredient["PreparationNotes"]!).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).stringByReplacingOccurrencesOfString("(", withString: "").stringByReplacingOccurrencesOfString(")", withString: "")
                
                if(amount.containsString(".")){
                    let num = Float(amount)
                    amount = NSString.localizedStringWithFormat("%.02f", num!) as String
                }
                
                
                if (notes == "<null>" || notes == "") {
                    ingredientsList = ingredientsList + "\n[\(amount)] \(unit) \(name)"
                    
                }  else {
                    ingredientsList = ingredientsList + "\n[\(amount)] \(unit) \(name) (\(notes))"
                }
                
                
            }
            stepLabel.text = ingredientsList
            stepLabel.textAlignment = NSTextAlignment.Left
            displayedIngredients = true
            
        } else if (!displayedIngredients && ingredientsList != nil ){
            stepLabel.text = ingredientsList
            stepLabel.textAlignment = NSTextAlignment.Left
            displayedIngredients = true
        }else {
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
