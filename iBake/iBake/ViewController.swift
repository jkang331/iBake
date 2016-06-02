//
//  ViewController.swift
//  iBake
//
//  Created by Jennifer Kang on 5/16/16.
//  Copyright © 2016 Jennifer Kang. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate{


    @IBOutlet weak var RecipesList: UITableView!
    @IBOutlet weak var SearchBar: UISearchBar!
    
    var tableData = searchRecipe("dessert")["Results"]
    var initialData = []
    var keyword = ""
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var recipes:[String]?;
    var searchResults: [String]?;
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        searchResults = recipes?.filter({$0.containsString(searchText)})
        
        RecipesList.reloadData()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // 1. retrieve recipe
        // 2. parse recipe --> get ingredients + get instructions
        
        // if it's the load more button
        if (indexPath.row == (tableData?.count)!) {
            page = String(Int(page)! + 1)
            if (searchController.active) {
                let newRecipes = searchRecipe("dessert \(keyword)")["Results"]
                let newData = [] + (tableData as! Array) + (newRecipes as! Array)
                tableData = newData
            } else {
                let newRecipes = searchRecipe("Dessert")["Results"]
                let newData = [] + (tableData as! Array) + (newRecipes as! Array)
                tableData = newData
            }
            RecipesList.reloadData()
        } else {
            // end any instance of the search controller
            searchController.active = false
            
            let cellSelected = tableView.cellForRowAtIndexPath(indexPath) as! RecipeCell
            let recipeDictionary = getRecipe(cellSelected.RecipeID);
            
            let recipeStepController = self.storyboard!.instantiateViewControllerWithIdentifier("recipeStep") as! StepController
            recipeStepController.recipeDictionary = recipeDictionary
            recipeStepController.recipeName = cellSelected.Title.text
            self.presentViewController(recipeStepController, animated: true, completion: nil)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (tableData?.count)! + 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75.0;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let recipeIdentifier = "recipe"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(recipeIdentifier) as! RecipeCell
        
        if (indexPath.row == (tableData?.count)!) {
            cell.Title.text = "Want to load more recipes?"
            cell.PrepTime.text = "Click here!"
            cell.RecipeImage?.image = UIImage(contentsOfFile: "pusheen_letsbake.jpg")
            return cell
        }
        
        //Configuring the cell
        let cellData = tableData?.objectAtIndex(indexPath.row) as! NSDictionary
        
        let imgurl = NSURL(string: (cellData["ImageURL"] as? String)!)
        
        var imgdata : NSData?;
        if(imgurl != nil){
            imgdata = NSData(contentsOfURL: imgurl!)
        }
        
        
        
        // Code to get totalminutes shown from each recipe, takes WAY too long
        //let recipeID = cellData["RecipeID"] as? Int
        //let recipeData = getRecipe(recipeID!)
        //cell.PrepTime.text = String((recipeData["TotalMinutes"] as? Int)!) + " minutes"
        
        var numStars = String(round((cellData["StarRating"] as? Double)! * 10.0)/10.0)
        if (numStars == "0.0") {
            numStars = "No"
        }
        
        cell.RecipeID = cellData["RecipeID"] as? Int
        cell.Title.text = cellData["Title"] as? String
        cell.PrepTime.text = numStars + " stars"
        if imgdata != nil {
            cell.RecipeImage?.image = UIImage(data: imgdata!)
        }
        
        
        //Adding a Separator Line to the Bottom
        let separatorLineView = UIView.init(frame: CGRectMake(0, cell.frame.size.height - 0.5 , self.view.frame.width, 1))
        separatorLineView.backgroundColor = UIColor.lightGrayColor()
        cell.addSubview(separatorLineView)
        
        return cell;
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        super.didRotateFromInterfaceOrientation(fromInterfaceOrientation)
        RecipesList.reloadData()
    }
    
    // SearchBarDelegate
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        print("cancel button called")
        if (keyword != "") {
            page = "1"
            keyword = ""
            tableData = initialData
            RecipesList.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        print("search button called")
        page = "1"
        keyword = searchBar.text!
        tableData = searchRecipe("dessert \(keyword)")["Results"]
        RecipesList.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.RecipesList.delegate = self
        self.RecipesList.dataSource = self
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        RecipesList.tableHeaderView = searchController.searchBar
        initialData = tableData as! NSArray
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

