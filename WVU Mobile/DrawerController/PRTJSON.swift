//
//  JSONDecoder.swift
//  WVU Mobile
//
//  Created by Kaitlyn Landmesser & Richard Deal on 2/10/15.
//  Copyright (c) 2015 WVUMobile. All rights reserved.
//

import Foundation

class PRTJSON {
    
    var status: NSString
    var message: NSString
    var timestamp: Int!
    
    init() {
        status = ""
        message = ""
        timestamp = Int(NSDate().timeIntervalSince1970)
        pullJSON()
    }
    
    //{"status":"1","message":"The PRT is running on a normal schedule.","timestamp":"1424205918","stations":[],"bussesDispatched":"0","duration":[]}
    func pullJSON() {
        let timestamp = Int(NSDate().timeIntervalSince1970)
        let urlPath: String = "https://prtstatus.wvu.edu/api/\(timestamp)/?format=json"
        print(urlPath)

        let url = NSURL(string: urlPath)!
        _ = NSURLSession.sharedSession()
        
        let data = NSData(contentsOfURL: url)
        
        
        if data == nil {
            message = "No network connection."
            status = "Error"
        } else {
            do {
                if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                    message = json["message"] as! NSString
                    status = json["status"] as! NSString
                }
            } catch {
                print("JSON Error")
                message = "Error"
                status = "Error"
            }
        }
    }
}
