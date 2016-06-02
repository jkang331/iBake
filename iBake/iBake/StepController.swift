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
    @IBOutlet weak var ViewIngredientsButton: UIButton!
    @IBOutlet weak var setTimerButton: UIButton!
    
    var counter = 0;
    var displayedIngredients = false;
    
    
    @IBAction func previousStepSelected(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    
    @IBAction func nextStepSelected(sender: AnyObject) {
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
    
    @IBAction func setTimer(sender: AnyObject) {
        let timerViewController = self.storyboard!.instantiateViewControllerWithIdentifier("timer") as! TimerViewController
        timerViewController.instruction = "Step \(counter): \(stepLabel.text!)"
        timerViewController.recipeName = recipeName
        self.presentViewController(timerViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func viewIngredients(sender: AnyObject) {
        // popover
        
        let alertController = UIAlertController.init(title: "Ingredients", message: ingredientsList!, preferredStyle: .Alert)
        let doneAction = UIAlertAction(title:"Done", style:.Default) {(action) in };
        alertController.addAction(doneAction)
        self.presentViewController(alertController, animated: true) {}

        
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
            updateLabel() // to parse the instructions in order to have instructionsArray != nil
            stepTitle.text = "Step \(counter) out of \(instructionsArray!.count)"
            
        }
    }
    
    func updateLabel() {
        
        if (!displayedIngredients && ingredientsList == nil){
            // parse ingredients
            ingredientsList = ""
            let ingredientsArray = recipeDictionary!["Ingredients"] as! NSArray

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
                
                if (name != "<null>" && name != "") {
                    if (notes == "<null>" || notes == "") {
                        ingredientsList = ingredientsList! + "\n[\(amount)] \(unit) \(name)"
                        
                    }  else {
                        ingredientsList = ingredientsList! + "\n[\(amount)] \(unit) \(name) (\(notes))"
                    }
                }
                
                
                
            }
            
            // Will display total time
            if(!String(recipeDictionary!["TotalMinutes"]!).containsString("0") && !String(recipeDictionary!["TotalMinutes"]!).containsString("<null>")){
                stepLabel.text = "Recipe Time: \(recipeDictionary!["TotalMinutes"]!) minutes\n\(ingredientsList!)"
            }else {
                stepLabel.text = "\(ingredientsList!)"
            }
            
            stepLabel.textAlignment = NSTextAlignment.Left
            displayedIngredients = true
            
        } else if (!displayedIngredients && ingredientsList != nil ){
            stepLabel.text = ingredientsList!
            stepLabel.textAlignment = NSTextAlignment.Left
            displayedIngredients = true
        }else {
            
            // First check if it is directing to a webpage
            if String(recipeDictionary!["Instructions"]!).containsString("www.") || String(recipeDictionary!["Instructions"]!).containsString("http:") {
                
                //TODO: display webview here instead
                instructionsArray = [String(recipeDictionary!["Instructions"]!) + ""]
                stepLabel.text = instructionsArray![0]
                
            } else{
                if (instructionsArray == nil || instructionsArray!.count == 0) {
                    // parse instructions and fill array
                    
                    //TODO: check if instructions contain ":" (random edge case on chocolate eclair dessert -_-)
                    
                    let instructions = String(recipeDictionary!["Instructions"]!)
                    instructionsArray = instructions.characters.split(".").map(String.init)
                }
            
                stepLabel.text = instructionsArray![counter - 1] + "."
            }
        }
        
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Navbar.topItem!.title = recipeName
        updateTitle()
        updateLabel()
        
        if(stepTitle.text != "Ingredients" && instructionsArray != nil && (counter) >= instructionsArray!.count) {
            nextButton.enabled = false
        }
        
        if(stepTitle.text == "Ingredients") {
            ViewIngredientsButton.enabled = false
        }
        
        if(stepTitle.text == "Ingredients" || !(stepLabel.text!.containsString("minute") || stepLabel.text!.containsString("hour"))) {
            setTimerButton.enabled = false
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
