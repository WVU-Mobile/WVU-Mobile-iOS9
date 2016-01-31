//
//  CenterViewController.swift
//  WVU Mobile
//
//  Created by Kaitlyn Landmesser & Richard Deal on 2/4/15.
//  Copyright (c) 2015 WVUMobile. All rights reserved.
//

import UIKit

class CenterViewController: MainViewController {
    override func viewDidLoad() {
        self.setupLeftMenuButton()
        self.setUIColors()
        super.viewDidLoad()
    }
    
    // Set up left menu button.
    func setupLeftMenuButton() {
        let menuImage = UIImage(named: "Menu.png")

        let menuView = UIImageView(frame: CGRectMake(0, 0, 30, 30))
        menuView.image = menuImage
        menuView.image = menuView.image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        
        let menuButton = UIButton(frame: (menuView.bounds))
        menuButton.setBackgroundImage(menuView.image, forState: UIControlState.Normal)
        menuButton.addTarget(self, action: "leftDrawerButtonPress:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let menuButtonItem = UIBarButtonItem(customView: menuButton)
        
        self.navigationItem.leftBarButtonItem = menuButtonItem
    }
    
    // Detect hamburger press.
    func leftDrawerButtonPress(sender: AnyObject?) {
        self.evo_drawerController?.toggleDrawerSide(.Left, animated: true, completion: nil)
    }
    
    // Set UI colors.
    override func setUIColors() {
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