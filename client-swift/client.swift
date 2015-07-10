//
//  client.swift
//  client-swift
//
//  Created by Barrett Clark on 7/10/15.
//  Copyright © 2015 Sabre Labs. All rights reserved.
//

import Foundation

typealias JSON = AnyObject
typealias JSONDictionary = Dictionary<String, JSON>
typealias JSONArray = Array<NSDictionary>

class Client {
    func getRequest(completionHandler: (NSURLResponse?, NSData?, NSError?) -> Void) {
        let url = NSURL(string: "http://localhost:9292")
        let request = NSURLRequest(URL: url!)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            completionHandler(response, data, error)
        }
        task!.resume()
    }
    
    func parse(data: NSData, completionHandler: (JSONDictionary?, NSError?) -> Void) {
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? JSONDictionary
            completionHandler(json, nil)
        } catch let jsonError as NSError {
            NSLog("Error parsing JSON: \(jsonError)")
            completionHandler(nil, jsonError)
        }
    }
}
