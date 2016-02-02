//
//  AppDelegate.swift
//  WVU Mobile
//
//  Created by Richard Deal on 1/28/15.
//  Copyright (c) 2015 WVUMobile. All rights reserved.
//

import UIKit
import GoogleMaps


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var drawerController: DrawerController!
    var googleMapsApiKey = "AIzaSyCKBl3CNZJPKGBU8Nf6tiO3sTVhF4QyIj0"
    
    func application(application: UIApplication, willFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {        
        let menuViewController = MenuViewController()
        let mainViewController = NewsViewController()
        
        let mainNavController = UINavigationController(rootViewController: mainViewController)
        mainNavController.restorationIdentifier = "MainNavigationControllerRestorationKey"
        
        let menuNavController = UINavigationController(rootViewController: menuViewController)
        menuNavController.restorationIdentifier = "MenuNavigationControllerRestorationKey"
        
        UINavigationBar.appearance().shadowImage = UIImage()
        
        self.drawerController = DrawerController()
        self.drawerController.centerViewController = mainNavController
        self.drawerController.leftDrawerViewController = menuNavController
        self.drawerController.showsShadows = true
        
        self.drawerController.restorationIdentifier = "Drawer"
        self.drawerController.maximumLeftDrawerWidth = (UIScreen.mainScreen().bounds.width * 0.8)
        self.drawerController.openDrawerGestureModeMask = .All
        self.drawerController.closeDrawerGestureModeMask = .All
        self.drawerController.shouldStretchDrawer = false
        
        // Set Animation Type
        //self.drawerController.drawerVisualStateBlock = DrawerVisualState.slideAndScaleVisualStateBlock
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        self.window!.rootViewController = self.drawerController
        
        return true
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        self.window!.backgroundColor = UIColor.whiteColor()
        self.window!.makeKeyAndVisible()
        
        
        let settings = UIUserNotificationSettings(forTypes: [UIUserNotificationType.Alert, UIUserNotificationType.Badge, UIUserNotificationType.Sound], categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        //Google Maps key
        GMSServices.provideAPIKey(googleMapsApiKey)
        
        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        NSLog("Failed to get : \(error)")
    }
    
    func application(application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func application(application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func application(application: UIApplication, viewControllerWithRestorationIdentifierPath identifierComponents: [AnyObject], coder: NSCoder) -> UIViewController? {
        if let key = identifierComponents.last as? String {
            if key == "Drawer" {
                return self.window!.rootViewController
            }
            else if key == "MainNavigationControllerRestorationKey" {
                return (self.window!.rootViewController as! DrawerController).centerViewController
            }
            else if key == "MenuNavigationControllerRestorationKey" {
                return (self.window!.rootViewController as! DrawerController).leftDrawerViewController
            }
            else if key == "MenuViewController" {
                if let leftVC = (self.window!.rootViewController as? DrawerController)?.leftDrawerViewController {
                    if leftVC.isKindOfClass(UINavigationController) {
                        return (leftVC as! UINavigationController).topViewController
                    }
                    else {
                        return leftVC
                    }
                }
            }
        }
        return nil
    }
}
