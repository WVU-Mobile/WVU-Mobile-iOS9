//
//  MainViewController.swift
//  WVU Mobile
//
//  Created by Richard Deal on 3/16/15.
//  Copyright (c) 2015 WVUMobile. All rights reserved.
//

import UIKit

class MainViewController: ViewController {    
    override func viewDidLoad() {
        self.setupGesture()
        self.setUIColors()
        super.viewDidLoad()
    }
    
    func setupGesture(){
        /*
        Toggle night mode
        */
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(MainViewController.toggleNightMode))
        tapGesture.numberOfTapsRequired = 3
        self.navigationController?.navigationBar.addGestureRecognizer(tapGesture)
    }
    
    // Toggle Night Mode
    func toggleNightMode() {
        colors.toggleNightMode()
        colors.toggleUIColors()
        self.setUIColors()
    }
    
    // Set UI colors.
    override func setUIColors() {
        self.view.backgroundColor = colors.mainViewColor
        self.navigationController?.navigationBar.barTintColor = colors.navBarColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 30)!, NSForegroundColorAttributeName: colors.textColor]
        self.view.backgroundColor = self.colors.menuViewColor
        self.navigationController?.navigationBar.tintColor = self.colors.textColor
        super.setUIColors()
    }
    
    // Pregenerated.
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.restorationIdentifier = "CenterViewController"
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}