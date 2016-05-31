//
//  apiCall.swift
//  iBake
//
//  Created by Timothy Luong on 5/28/16.
//  Copyright © 2016 Jennifer Kang. All rights reserved.
//

import Foundation

// API constants
let apiKey = "dvxSfm9307Qf9RsF3rMU8dhs88XLZFkc"
let searchAPIAddress = "http://api.bigoven.com/recipes?"
let recipeAPIAddress = "http://api.bigoven.com/recipe/" // needs {recipe_id}?api_key={apiKey}

// API search variables
var pageLimit = "1"
var resultsPerPage = "30"
var searchMode: Bool = false // false: By title, true: Any match
var searchParameter: String = "&title_kw="


func searchRecipe(keyWord: String!) -> [AnyObject] {
    
    var result = [AnyObject]()

    // trim white spaces
    var searchWord = keyWord.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    // replace spaces within the search word with +
    searchWord = searchWord.stringByReplacingOccurrencesOfString(" ", withString: "+")
    
    if searchMode {
        searchParameter = "&any_kw="
    } else {
        searchParameter = "&title_kw="
    }
    
    // construct URL object to make HTTP request to API server
    let apiURL: NSURL? = NSURL(string: searchAPIAddress + "api_key=" + apiKey + searchParameter + searchWord + "&pg=" + pageLimit + "&rpp=" + resultsPerPage)
    let request = NSMutableURLRequest(URL: apiURL!)
    let session = NSURLSession.sharedSession()
    request.HTTPMethod = "GET"
    
    // add headers to the request. The API uses "Accept" field to determine output format. We want JSON.
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("false", forHTTPHeaderField: "cache")
    
    let task = session.dataTaskWithRequest(request) {
        (data, response, error) -> Void in
        
        let httpResponse = response as! NSHTTPURLResponse
        let statusCode = httpResponse.statusCode
        
        if (statusCode == 200) {
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
                result = json as! [AnyObject]
            } catch {
                print("Error with Json: \(error)")
            }
        }
    }
    
    task.resume()
    
    return result
    
    /*
     
     // error variables
     //var error: AutoreleasingUnsafeMutablePointer<NSErrorPointer?> = nil
     //var err: NSError?
    
     // response of the http request - deprecated?
     // var response: AutoreleasingUnsafeMutablePointer<NSURLResponse?> = nil
     
     //data received by the http request using a synchronouse request
     //var responseData = NSURLConnection.sendSynchronousRequest(request, returningResponse: response, error:nil) as NSData!
     
    // handle response data
    if error != nil {
        print("error")
    } else {
        
        var json = NSJSONSerialization.JSONObjectWithData(responseData, options: .MutableLeaves, error: &err) as? NSDictionary
        if let jsonDataFromAPI = json {
            result = jsonDataFromAPI["Results"] as Array<AnyObject>
        } else {
            let jsonStr = NSString(data: responseData, encoding: NSUTF8StringEncoding)
            print(jsonStr)
            print("Error: did not receive json.")
        }
        
    } */
}

func getRecipe(recipeID: String!) -> [AnyObject] {
    var result = [AnyObject]()
    
    // construct URL object to make HTTP request to API server
    let apiURL: NSURL? = NSURL(string: recipeAPIAddress + recipeID + "?api_key=" + apiKey)
    let request = NSMutableURLRequest(URL: apiURL!)
    let session = NSURLSession.sharedSession()
    request.HTTPMethod = "GET"
    
    // add headers to the request. The API uses "Accept" field to determine output format. We want JSON.
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("false", forHTTPHeaderField: "cache")
    
    let task = session.dataTaskWithRequest(request) {
        (data, response, error) -> Void in
        
        let httpResponse = response as! NSHTTPURLResponse
        let statusCode = httpResponse.statusCode
        
        if (statusCode == 200) {
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
                result = json as! [AnyObject]
            } catch {
                print("Error with Json: \(error)")
            }
        }
    }
    
    task.resume()
    
    return result
}