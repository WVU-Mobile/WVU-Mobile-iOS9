//
//  BufferVC.swift
//  WVU Mobile
//
//  Created by Kaitlyn Landmesser on 2/26/15.
//  Copyright (c) 2015 WVUMobile. All rights reserved.
//
import UIKit

class BufferVC: CenterViewController{
    
    override func viewDidLoad() {
        
        let prtNavView = UINavigationController(rootViewController: PRTTableViewController())
        self.evo_drawerController?.setCenterViewController(prtNavView, withCloseAnimation: true, completion: nil)
        
        super.viewDidLoad()
    }
    
    // Dispose of any resources that can be recreated.
     override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Pregenerated.
     override init() {
        super.init()
        self.restorationIdentifier = "PRTTableViewController"
    }
    
    // Pregenerated.
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.restorationIdentifier = "PRTTableViewController"
    }
    
}