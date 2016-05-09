//
//  File.swift
//  US-CAN Exchange
//
//  Created by Jason P'ng on 2016-05-05.
//  Copyright © 2016 Jason P'ng. All rights reserved.
//

import Foundation

typealias ServiceResponse = (JSON, NSError?) -> Void

class RestAPIManager : NSObject{
    
    static let sharedInstance = RestAPIManager ()
    let baseURL = "https://openexchangerates.org/api/"
    let appID = "7365236634594d25b4bb2a66d1588987"
    
    let testURL = "http://api.randomuser.me/"
    
    func getExchangeRates (onCompletion : (JSON) -> Void){
        let route = createURL("latest.json", appID: appID, baseGDP: "USD")
        makeHTTPGetRequest(route, onCompletion: {json, err in
            onCompletion (json as JSON)})
    }
    
    func makeHTTPGetRequest (path : String, onCompletion : ServiceResponse) {
        //This should definitely crash if the URL doesn't parse correctly
        let request = NSMutableURLRequest (URL : NSURL (string : path)!)
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data,response, error -> Void in
            //Can this crash? what happens when the request is unsuccessful?
            let d = data
            let json : JSON
            if d == nil {
                json = JSON (NSNull())
            } else {
                json = JSON(data : d!) ?? JSON (NSNull())
            }
            print ("didn't crash loading?")
            print (json)
            onCompletion (json, error)})
        task.resume()
    }
    
    func createURL (fileRequest : String, appID : String, baseGDP : String) -> String{
        return "\(baseURL)\(fileRequest)?app_id=\(appID)&base=\(baseGDP)"
    }
}