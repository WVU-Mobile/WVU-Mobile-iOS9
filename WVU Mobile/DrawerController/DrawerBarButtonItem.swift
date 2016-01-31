//
//  AppDelegate.swift
//  WVU Mobile
//
//  Created by Richard Deal on 1/28/15.
//  Copyright (c) 2015 WVUMobile. All rights reserved.
//


import UIKit
import Foundation

public class DrawerBarButtonItem: UIBarButtonItem {
    var menuButton: Hamburger
    var colors = UIColors()
    
    public override init() {
        self.menuButton = Hamburger(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        super.init()
    }
    
    public init(target: AnyObject?, action: Selector) {
        self.menuButton = Hamburger(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        self.menuButton.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        super.init()
    }
    
    public required convenience init(coder aDecoder: NSCoder) {
        let barButtonItem = UIBarButtonItem(coder: aDecoder)
        self.init(target: barButtonItem!.target, action: barButtonItem!.action)
    }
    
}
