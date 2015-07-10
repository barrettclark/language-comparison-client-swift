//
//  ViewController.swift
//  client-swift
//
//  Created by Barrett Clark on 7/10/15.
//  Copyright © 2015 Sabre Labs. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let client = Client()
        client.getRequest { (response, data, error) -> Void in
            if (data != nil) {
                client.parse(data!, completionHandler: { (json, error) -> Void in
                    NSLog("Untyped JSON: \(json!)")
                })
            } else {
                NSLog("Error: \(error!)")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

