//
//  JSONDecoder.swift
//  WVU Mobile
//
//  Created by Kaitlyn Landmesser & Richard Deal on 2/10/15.
//  Copyright (c) 2015 WVUMobile. All rights reserved.
//

import Foundation

class DiningJSON {
    var locationID: String!
    var day: Int!
    var month: Int!
    var year: Int!
    var jsonResult: NSArray!
    var error: Bool!
    
    var menus = NSMutableDictionary()
    var key = NSMutableArray()
    
    init(ID: String) {
        let date = NSDate()
        let components = NSCalendar.currentCalendar().components([NSCalendarUnit.Day, NSCalendarUnit.Month, NSCalendarUnit.Year], fromDate: date)
        
        locationID = ID
        
        day = components.day
        month = components.month
        year = components.year
        error = false
        
        pullJSON()
        
        if error == false {
            setupArrays()
        }
    }
    
    func pullJSON() {
        let urlPath: String = "http://diningmenuservice.wvu.edu/\(locationID)/\(month)/\(day)/\(year)/1410376600000/?callback="
        print(urlPath)
        let url = NSURL(string: urlPath)!
        _ = NSURLSession.sharedSession()
        
        let data = NSData(contentsOfURL: url)
        
        if data == nil {
            error = true
        } else {
            do {
                try jsonResult = NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSArray
            } catch {
                print("There was an error pulling the PRT JSON data.")
            }
        }
    }
    
    func setupArrays() {
        let breakfastSection = NSMutableArray()
        let healthyUBreakfastSection = NSMutableArray()
        let lunchSection = NSMutableArray()
        let healthyULunchSection = NSMutableArray()
        let dinnerSection = NSMutableArray()
        let healthyUDinnerSection = NSMutableArray()
        
        //Loop through every dictionary in the JSON feed
        for var i = 0; i < jsonResult.count; i++ {
            let dict = jsonResult[i] as! NSDictionary
            //switch on type of menu items
            let d = dict["meal"] as! NSString
            
            if !d.isEqual(nil) {
                var item = dict["item"] as! NSString
                
                if !item.isEqual(""){
                    item = item.stringByReplacingOccurrencesOfString("\"", withString: "")
                
                    switch d {
                        case "BREAKFAST":
                            breakfastSection.addObject(item)
                        case "HEALTHY \"U\" BREAKFAST":
                            healthyUBreakfastSection.addObject(item)
                        case "\r\nBREAKFAST ACTION STATION ":
                            breakfastSection.addObject(item)
                        case "LUNCH":
                            lunchSection.addObject(item)
                        case "HEALTHY \"U\" LUNCH":
                            healthyULunchSection.addObject(item)
                        case "\r\nLUNCH ACTION STATION ":
                            lunchSection.addObject(item)
                        case "DINNER":
                            dinnerSection.addObject(item)
                        case "HEALTHY \"U\" DINNER":
                            healthyUDinnerSection.addObject(item)
                        case "\r\nDINNER ACTION STATION ":
                            dinnerSection.addObject(item)
                        default:
                            break
                    }
                }
            }
        }
        if breakfastSection.count > 0 {
            menus.setObject(breakfastSection, forKey: "BREAKFAST")
            key.addObject("BREAKFAST")
        }
        if healthyUBreakfastSection.count > 0 {
            menus.setObject(healthyUBreakfastSection, forKey: "HEALTHY \"U\" BREAKFAST")
            key.addObject("HEALTHY \"U\" BREAKFAST")
        }
        if lunchSection.count > 0{
            menus.setObject(lunchSection, forKey: "LUNCH")
            key.addObject("LUNCH")
        }
        if healthyULunchSection.count > 0 {
            menus.setObject(healthyULunchSection, forKey: "HEALTHY \"U\" LUNCH")
            key.addObject("HEALTHY \"U\" LUNCH")
        }
        if dinnerSection.count > 0 {
            menus.setObject(dinnerSection, forKey: "DINNER")
            key.addObject("DINNER")
        }
        if healthyULunchSection.count > 0 {
            menus.setObject(healthyUDinnerSection, forKey: "HEALTHY \"U\" DINNER")
            key.addObject("HEALTHY \"U\" DINNER")
        }
    }
}