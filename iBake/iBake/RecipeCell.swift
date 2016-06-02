//
//  RecipeCell.swift
//  iBake
//
//  Created by iGuest on 5/28/16.
//  Copyright © 2016 Jennifer Kang. All rights reserved.
//

import UIKit

class RecipeCell : UITableViewCell {
    
    @IBOutlet weak var Title: UILabel!
    @IBOutlet weak var PrepTime: UILabel!
    @IBOutlet weak var RecipeImage: UIImageView!
    var RecipeID: Int!
    @IBOutlet weak var favoritedRecipe: UIButton!
    
    
    @IBAction func favorite(sender: AnyObject) {
        let heartfull_img = UIImage(named: "heart_full.png")
        if(favoritedRecipe.currentImage != heartfull_img) { // hasn't been favorited
            favoritedRecipe.setImage(heartfull_img, forState: UIControlState.Normal)
            
            var favoritesArray = [String]()
            
            
            if (NSUserDefaults.standardUserDefaults().boolForKey("setFavorites") == true) {
                favoritesArray = NSUserDefaults.standardUserDefaults().objectForKey("favoritesArray")! as! [String]
            }
            
            favoritesArray.append(Title.text!)
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "setFavorites")
            NSUserDefaults.standardUserDefaults().setObject(favoritesArray, forKey: "favoritesArray")
            NSUserDefaults.standardUserDefaults().synchronize()
            // add to favorites list
        } else {
            let heartoutline_img = UIImage(named: "heart_outline.png")
            favoritedRecipe.setImage(heartoutline_img, forState: UIControlState.Normal)
            
            //remove from favorites list
            var favoritesArray = [String]()
            
            if (NSUserDefaults.standardUserDefaults().boolForKey("setFavorites") == true) {
                favoritesArray = NSUserDefaults.standardUserDefaults().objectForKey("favoritesArray")! as! [String]
            }
            
            favoritesArray = favoritesArray.filter{$0 == Title.text!}
            if (favoritesArray.count == 0){
                NSUserDefaults.standardUserDefaults().setBool(false, forKey: "setFavorites")
            }
            NSUserDefaults.standardUserDefaults().setObject(favoritesArray, forKey: "favoritesArray")
            NSUserDefaults.standardUserDefaults().synchronize()
            
        }
        
    }
}
