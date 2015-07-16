#!/usr/bin/env xcrun swift
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

func dateFormatter() -> NSDateFormatter {
    let formatter = NSDateFormatter()
    formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'+00:00'"
    formatter.locale = NSLocale.currentLocale()
    formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
    return formatter
}

class Client {
    func getRequest(completionHandler: (NSURLResponse?, NSData?, NSError?) -> Void) {
        let url = NSURL(string: "http://localhost:9292")
        let request = NSURLRequest(URL: url!)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            completionHandler(response, data, error)
        }
        task!.resume()
    }
    
    func parseToJSONDictionary(data: NSData, completionHandler: (JSONDictionary?, NSError?) -> Void) {
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? JSONDictionary
            completionHandler(json, nil)
        } catch let jsonError as NSError {
            print("Error parsing JSON: \(jsonError)")
            completionHandler(nil, jsonError)
        }
    }
    
    func parse(data: NSData, completionHandler: (Payload?) -> Void) {
        parseToJSONDictionary(data) { json, error in
            if (json != nil) {
                let payload = Payload(fromJSONDictionary: json!)
                completionHandler(payload)
            } else {
                completionHandler(nil)
            }
        }
    }
}

struct Payload {
    let name: String
    let theBestNumber: Int
    let pi: Double
    let timestamp: NSDate
    
    init(fromJSONDictionary json: JSONDictionary) {
        self.init(name: json["name"] as! String,
         theBestNumber: json["best_number"] as! Int,
                    pi: json["pi"] as! Double,
             timestamp: dateFormatter().dateFromString(json["right_now"] as! String)!)
    }
    init(name: String, theBestNumber: Int, pi: Double, timestamp: NSDate) {
        self.name = name
        self.theBestNumber = theBestNumber
        self.pi = pi
        self.timestamp = timestamp
    }
}

func currentTimeMillis() -> Int64{
    let nowDouble = NSDate().timeIntervalSince1970
    return Int64(nowDouble*1000)
}

print(currentTimeMillis())
for i in 0..<100 {
    let client = Client()
    client.getRequest { (response, data, error) -> Void in
        if (data != nil) {
            client.parse(data!, completionHandler: { payload in
                print("Typed response: \(payload!)")
            })
        } else {
            print("Error: \(error!)")
        }
    }
}
print(currentTimeMillis())
NSRunLoop.currentRunLoop().run()
