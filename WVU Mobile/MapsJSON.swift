//
//  MapJSON.swift
//  WVU Mobile
//
//  Created by Kaitlyn Landmesser & Richard Deal on 3/23/15.
//  Copyright (c) 2015 WVUMobile. All rights reserved.
//

import Foundation

class MapsJSON {
    
    var code: NSString!
    var name: NSString!
    var web: NSString!
    var description: NSString!
    var prt: NSDictionary!
    var parking: NSDictionary!
    var phone: NSString!
    var address: NSString!
    var campus: NSString!
    var image: NSString!
    var subtype: NSString!
    var wifi: Int!
    
    init(code: String, name: String) {
        self.code = code
        self.name = name
        web = "No website listed."
        description = ""
        prt = ["name":"","distance":-1]
        parking = ["name":"","distance":-1]
        phone = "No number listed."
        address = ""
        campus = ""
        image = ""
        subtype = "WVU"
        wifi = 0
        pullJSON()
    }
    
    func pullJSON() {
        var urlPath: String = "http://beta.campusmap.wvu.edu/api.json?api=true&bCode=\(code)"

        if (code == "NRCCE") {
             urlPath = "http://beta.campusmap.wvu.edu/api.json?api=true&alpha=National"
        } else if (name.substringWithRange(NSRange(location: 0, length: 6)) == "Public" || code == "ST2"){
            name = name.stringByReplacingOccurrencesOfString(" ", withString: "%20")
            urlPath = "http://beta.campusmap.wvu.edu/api.json?api=true&alpha=\(name)"
        } else if (code == "PRT"){
            name = name.stringByReplacingOccurrencesOfString(" ", withString: "%20")
            urlPath = "http://beta.campusmap.wvu.edu/api.json?api=true&alpha=\(name)"
        } else if (code == "SPH-D") {
            urlPath = "http://beta.campusmap.wvu.edu/api.json?api=true&alpha=Spruce%20house"
        }
        
        let url = NSURL(string: urlPath)!
        _ = NSURLSession.sharedSession()
        
        let data = NSData(contentsOfURL: url)
        
        if data == nil {
            print("debug")
        } else {
            do {
                if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSArray {
                    if json.count > 0 {
                        if let jsonDict = json[0] as? NSDictionary {
                            web = jsonDict["url"] as? NSString
                            description = jsonDict["description"] as? NSString
                            prt = jsonDict["prt"] as? NSDictionary
                            parking = jsonDict["parking"] as? NSDictionary
                            phone = jsonDict["phone"] as? NSString
                            address = jsonDict["address"] as? NSString
                            campus = jsonDict["campus"] as? NSString
                            image = jsonDict["image"] as? NSString
                            subtype = jsonDict["subtype"] as? NSString
                            wifi = jsonDict["wifi"] as? Int
                        
                            if web == nil { web = "No website listed." }
                            if description == nil { description = "" }
                            if prt == nil { prt = ["name":"","distance":-1] }
                            if parking == nil { parking = ["name":"","distance":-1] }
                            if phone == nil { phone = "No number listed." }
                            if address == nil { address = "" }
                            if campus == nil { campus = "" }
                            if image == nil { image = "" }
                            if subtype == nil { subtype = "WVU" }
                            if wifi == nil { wifi = 0 }
                        }
                    }
                }
            } catch {
                
            }
            
        }
    }
}