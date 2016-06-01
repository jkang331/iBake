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
    
    var counter = 1;
    var displayedIngredients = false;
    
    
    @IBAction func previousStepSelected(sender: AnyObject) {
    }
    
    @IBAction func nextStepSelected(sender: AnyObject) {
        //SET displayedIngredients to true
        //handoff on variables
        
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
