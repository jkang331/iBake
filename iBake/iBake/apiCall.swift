//
//  apiCall.swift
//  iBake
//
//  Created by Timothy Luong on 5/28/16.
//  Copyright © 2016 Jennifer Kang. All rights reserved.
//

import Foundation

// API constants
let apiKey = "5LS5n6Z6m4ZRnc7vyN8L5qa637iEy7XD"
let searchAPIAddress = "http://api.bigoven.com/recipes?"
let recipeAPIAddress = "http://api.bigoven.com/recipe/" // needs {recipe_id}?api_key={apiKey}

// API search variables
var pageLimit = "1"
var resultsPerPage = "30"
var searchMode: Bool = true // false: By title, true: Any match
var searchParameter: String = "&title_kw="

var pingingServer = true


func searchRecipe(keyWord: String!) -> NSDictionary {
    
    var result = [:]
    pingingServer = true

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
    print(apiURL)
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
                result = json as! NSDictionary
            } catch {
                print("Error with Json: \(error)")
            }
        }
        
        pingingServer = false
    }
    
    task.resume()
    
    while (pingingServer) {
        print("Pinging Search")
    }
    
    return result
}

func getRecipe(recipeID: Int!) -> NSDictionary {
    
    var result = [:]
    pingingServer = true
    
    // construct URL object to make HTTP request to API server
    print(recipeAPIAddress + "\(recipeID)?api_key=" + apiKey)
    let apiURL: NSURL? = NSURL(string: recipeAPIAddress + "\(recipeID)?api_key=" + apiKey)
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
                result = json as! NSDictionary
            } catch {
                print("Error with Json: \(error)")
            }
        }
        
        pingingServer = false
    }
    
    task.resume()
    
    while (pingingServer) {
        print("Pinging Recipe")
    }
    
    return result
}