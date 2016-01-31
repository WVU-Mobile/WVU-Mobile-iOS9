//
//  ViewController.swift
//  WVU Mobile
//
//  Created by Kaitlyn Landmesser & Richard Deal on 1/31/15.
//  Copyright (c) 2015 WVUMobile. All rights reserved.
//

import UIKit

class ViewController: UIViewController {    
    
    var colors: UIColors = UIColors.sharedInstance
    
    override func viewDidLoad() {
        self.setUIColors()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "contentSizeDidChangeNotification:", name: UIContentSizeCategoryDidChangeNotification, object: nil)
        
        super.viewDidLoad()
    }
    
    // Set status bar color.
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        if NSUserDefaults.standardUserDefaults().boolForKey("nightMode") {
            return UIStatusBarStyle.LightContent
        }
        else {
            return UIStatusBarStyle.Default
        }
    }
    
    // Set UI colors.
    func setUIColors() {
        UIApplication.sharedApplication().statusBarStyle = preferredStatusBarStyle()
    }
}
