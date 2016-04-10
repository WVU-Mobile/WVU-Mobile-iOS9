//
//  Events.swift
//  WVU Mobile
//
//  Created by Kaitlyn Landmesser & Richard Deal on 3/9/15.
//  Copyright (c) 2015 WVUMobile. All rights reserved.
//

import UIKit
import Foundation

class Events: NSObject {
    var events = NSMutableArray()
    var url = "https://cal.wvu.edu/RSSSyndicator.aspx?category=&location=&type=N&binary=Y"
    
    override init() {
        super.init()
        pullRSS()
    }
    
    class var sharedInstance: Events{
        struct Static {
            static let instance : Events = Events()
        }
        return Static.instance
    }
    
    func pullRSS (){
        let nsURL = NSURL(string: url)!
        let parser: RSSParser = RSSParser().initWithURL(nsURL) as! RSSParser
        let feed = parser.feeds
        
        for i in 0 ..< feed.count {
            let fTitle: String = feed[i].objectForKey("title") as! String
            let fDescript: String = feed[i].objectForKey("description") as! String
            let fLink: String = feed[i].objectForKey("link") as! String
            let fDate: String = feed[i].objectForKey("pubDate") as! String
            
            let event = EventObject()
            event.title = fTitle
            event.link = fLink
            event.startDate = formatDate(fDate)
            event.descrip = fDescript
                        
            events.addObject(event)
        }
    }
    
    func eventsOnDay(date: NSDate) -> NSMutableArray {
        let todaysEvents = NSMutableArray()
        let calender = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        
        for e in events {
            let tempE = e as! EventObject
            let dif = calender?.compareDate(date, toDate: tempE.startDate, toUnitGranularity: .Day)
            if dif == NSComparisonResult.OrderedSame{
                todaysEvents.addObject(tempE)
            }
        }
        
        return todaysEvents
    }
    
    func formatDate(rawDate: String) -> NSDate{
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT")
        dateFormatter.dateStyle = NSDateFormatterStyle.FullStyle
        
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss 'GMT\n'"
        let date: NSDate = dateFormatter.dateFromString(rawDate)!
        
        return date
    }
}