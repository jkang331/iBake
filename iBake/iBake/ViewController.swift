//
//  ViewController.swift
//  iBake
//
//  Created by Jennifer Kang on 5/16/16.
//  Copyright © 2016 Jennifer Kang. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var RecipesList: UITableView!
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //TODO: switch to Recipe View
        //let secondViewController = self.storyboard!.instantiateViewControllerWithIdentifier("question") as! QuestionController
        //secondViewController.subject = retrieveSubjectsList()[indexPath.row]
        //secondViewController.questionsList = questionsList[secondViewController.subject!]
        //self.presentViewController(secondViewController, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5; //TODO: this will be dependend on the number of recipes we have
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75.0;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let recipeIdentifier = "recipe"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(recipeIdentifier) as! RecipeCell
        
        //Configuring the cell
        cell.Title.text = "Recipe Name"
        cell.PrepTime.text = "20 min"
        cell.RecipeImage?.image = UIImage(named: "pusheen_letsbake.jpg" )
        
        
        
        //Adding a Separator Line to the Bottom
        let separatorLineView = UIView.init(frame: CGRectMake(0, cell.frame.size.height - 0.5 , self.view.frame.width, 1))
        separatorLineView.backgroundColor = UIColor.lightGrayColor()
        cell.addSubview(separatorLineView)
        
        return cell;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.RecipesList.delegate = self
        self.RecipesList.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

