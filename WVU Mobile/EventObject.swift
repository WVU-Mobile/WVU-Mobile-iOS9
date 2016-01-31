//
//  EventObject.swift
//  WVU Mobile
//
//  Created by Kaitlyn Landmesser & Richard Deal on 3/9/15.
//  Copyright (c) 2015 WVUMobile. All rights reserved.
//

import UIKit
import Foundation

extension String {
    var htmlToString:String {
        do {
            return try NSAttributedString(data: dataUsingEncoding(NSUTF8StringEncoding)!, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute:NSUTF8StringEncoding], documentAttributes: nil).string
        } catch {
            return ""
        }
    }
    var htmlToNSAttributedString:NSAttributedString {
        do {
            return try NSAttributedString(data: dataUsingEncoding(NSUTF8StringEncoding)!, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute:NSUTF8StringEncoding], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
}

class EventObject: NSObject {
    var decoded = false
    var startDate: NSDate!
    var endDate: NSDate!
    var title: String!
    var link: String!
    var descrip = ""
    var location: String!
    
    var time = ""
    var startT: String = ""
    var endT: String = ""

    override init() {
        super.init()
    }
    
    func decode(){
        if decoded == false {
            let d2 = formatDescription(descrip)
            
            var stuffArr = d2.componentsSeparatedByString("\n")
            
            descrip = ""
            
            if stuffArr.count > 8 {
                startT = stuffArr[3]
                endT = stuffArr[7]
                
                if startT == "" && endT == "" {
                    time = "All Day"
                } else if endT == "" {
                    time = startT
                } else {
                    time = "\(startT) - \(endT)"
                }
                
                for i in 8...stuffArr.count-1 {
                    descrip = descrip + stuffArr[i] + "\n"
                }
            }
            decoded = true
        }
    }
    
    func formatDescription(rawDescript: String) -> String {
        let htmlString = String(rawDescript).htmlToString
        
        return htmlString
    }
}