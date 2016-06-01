//
//  ViewController.swift
//  iBake
//
//  Created by Jennifer Kang on 5/16/16.
//  Copyright © 2016 Jennifer Kang. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{

//, UISearchBarDelegate, UISearchDisplayDelegate {

    @IBOutlet weak var RecipesList: UITableView!
    @IBOutlet weak var Search: UISearchBar!
    
    var tableData = searchRecipe("dessert")["Results"]
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var recipes:[String]?;
    var searchResults: [String]?;
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        searchResults = recipes?.filter({$0.containsString(searchText)})
        
        RecipesList.reloadData()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //TODO: switch to Recipe View
        let recipeStepController = self.storyboard!.instantiateViewControllerWithIdentifier("recipeStep") as! StepController
//        recipeStepController.subject = retrieveSubjectsList()[indexPath.row]
//        secondViewController.questionsList = questionsList[secondViewController.subject!]
        self.presentViewController(recipeStepController, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 10; //TODO: this will be dependend on the number of recipes we have
        return (tableData?.count)!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75.0;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let recipeIdentifier = "recipe"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(recipeIdentifier) as! RecipeCell
        
        //Configuring the cell
        let cellData = tableData![indexPath.row] as! NSDictionary
        
        let imgurl = NSURL(string: (cellData["ImageURL"] as? String)!)
        let imgdata = NSData(contentsOfURL: imgurl!)
        
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
        cell.RecipeImage?.image = UIImage(data: imgdata!)
        
        //Adding a Separator Line to the Bottom
        let separatorLineView = UIView.init(frame: CGRectMake(0, cell.frame.size.height - 0.5 , self.view.frame.width, 1))
        separatorLineView.backgroundColor = UIColor.lightGrayColor()
        cell.addSubview(separatorLineView)
        
        return cell;
    }
    
    // SearchBarDelegate
    /*func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        print("searchText \(searchText)")
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        print("searchText \(searchBar.text)")
    }*/
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.RecipesList.delegate = self
        self.RecipesList.dataSource = self
        self.Search.delegate = self
//        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        RecipesList.tableHeaderView = searchController.searchBar
        
        // TESTING TESTING TESTING
        //print("TESTING")
        //print(searchRecipe("dessert")["Results"])
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

