//
//  SettingsViewController.swift
//  WVU Mobile
//
//  Created by Richard Deal on 4/3/15.
//  Copyright (c) 2015 WVUMobile. All rights reserved.
//

import UIKit
import MessageUI

class SettingsViewController: CenterViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {
    
    var tableView = UITableView()
    
    var nightSwitch = UISwitch(frame: CGRectMake(150, 300, 0, 0))
    
    let facebookImage = UIImage(named: "like")
    let twitterImage = UIImage(named: "follow")
    
    let rickyButton = UIButton(type: UIButtonType.Custom)
    let kateButton = UIButton(type: UIButtonType.Custom)
    
    let jeremyButton = UIButton(type: UIButtonType.Custom)
    let coreyButton = UIButton(type: UIButtonType.Custom)
    let facebookButton = UIButton(type: UIButtonType.Custom)
    let twitterButton = UIButton(type: UIButtonType.Custom)
    
    let kateURL = NSURL(string: "https://twitter.com/kateinthecosmos")
    let rickyURL = NSURL(string: "https://twitter.com/rickydeal11")
    let jeremyURL = NSURL(string: "https://twitter.com/jdole21")
    let coreyURL = NSURL(string: "https://twitter.com/coreyrexroad")
    let twitterURL = NSURL(string: "https://twitter.com/wvumobile")
    let facebookURL = NSURL(string: "https://facebook.com/wvumobile")
    
    override func viewDidLoad() {
        self.title = "Settings"
        
        /*
        Set up table view.
        */
        tableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.Grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")

        tableView.rowHeight = 43.0
        tableView.backgroundColor = colors.menuViewColor
        tableView.showsVerticalScrollIndicator = false
        
        // Set up Night Mode Switch
        self.nightSwitch.on = NSUserDefaults.standardUserDefaults().boolForKey("nightMode")
        self.nightSwitch.setOn(NSUserDefaults.standardUserDefaults().boolForKey("nightMode"), animated: NSUserDefaults.standardUserDefaults().boolForKey("nightMode"))
        self.nightSwitch.addTarget(self, action: "nightSwitchValueDidChange:", forControlEvents: .ValueChanged)
        self.nightSwitch.onTintColor = colors.switchColor

        // Set up Ricky Button
        rickyButton.frame = CGRectMake(100, 100, 100, 40)
        rickyButton.setBackgroundImage(twitterImage, forState: UIControlState.Normal)
        rickyButton.addTarget(self, action: "twitterButtonAction:", forControlEvents:.TouchUpInside)
        
        // Set up Kate Button
        kateButton.frame = CGRectMake(100, 100, 100, 40)
        kateButton.setImage(twitterImage, forState: .Normal)
        kateButton.addTarget(self, action: "twitterButtonAction:", forControlEvents:.TouchUpInside)
        
        // Set up Jeremy Button
        jeremyButton.frame = CGRectMake(100, 100, 100, 40)
        jeremyButton.setImage(twitterImage, forState: .Normal)
        jeremyButton.addTarget(self, action: "twitterButtonAction:", forControlEvents:.TouchUpInside)
        
        // Set up Corey Button
        coreyButton.frame = CGRectMake(100, 100, 100, 40)
        coreyButton.setImage(twitterImage, forState: .Normal)
        coreyButton.addTarget(self, action: "twitterButtonAction:", forControlEvents:.TouchUpInside)
        
        // Set up Facebook Button
        facebookButton.frame = CGRectMake(100, 100, 100, 40)
        facebookButton.setImage(facebookImage, forState: .Normal)
        facebookButton.addTarget(self, action: "facebookButtonAction:", forControlEvents:.TouchUpInside)
        
        // Set up Twitter Button
        twitterButton.frame = CGRectMake(100, 100, 100, 40)
        twitterButton.setImage(twitterImage, forState: .Normal)
        twitterButton.addTarget(self, action: "twitterButtonAction:", forControlEvents:.TouchUpInside)
        
        self.view.addSubview(self.tableView)
        
        setUIColors()
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.tableView.reloadData()
        self.setupGesture()
    }
    
    // Functionality for Night Mode Switch
    func nightSwitchValueDidChange(sender: UISwitch!) {
        colors.toggleNightMode()
        colors.toggleUIColors()
        self.setUIColors()
    }
    
    // Functionality of the Twitter Buttons
    func twitterButtonAction (sender: UIButton) {
        if sender == kateButton {
            if let twitterAppURL = NSURL(string: "twitter://user?screen_name=kateinthecosmos") {
                UIApplication.sharedApplication().openURL(twitterAppURL)
            }
            UIApplication.sharedApplication().openURL(kateURL!)
        }
        else if sender == rickyButton {
            if let url = NSURL(string: "twitter://user?screen_name=rickydeal11") {
                UIApplication.sharedApplication().openURL(url)
            }
            UIApplication.sharedApplication().openURL(rickyURL!)
        }
        else if sender == jeremyButton {
            if let url = NSURL(string: "twitter://user?screen_name=jdole21") {
                UIApplication.sharedApplication().openURL(url)
            }
            UIApplication.sharedApplication().openURL(jeremyURL!)
        }
        else if sender == coreyButton {
            if let url = NSURL(string: "twitter://user?screen_name=coreyrexroad") {
                UIApplication.sharedApplication().openURL(url)
            }
            UIApplication.sharedApplication().openURL(coreyURL!)
        }
        else if sender == twitterButton {
            if let url = NSURL(string: "twitter://user?screen_name=WVUMobile") {
                UIApplication.sharedApplication().openURL(url)
            }
            UIApplication.sharedApplication().openURL(twitterURL!)
        }
    }
    
    // Functionality of the Facebook Button
    func facebookButtonAction (sender: UIButton) {
        if sender == facebookButton {
            if let url = NSURL(string: "fb://profile/1532449943665741") {
                UIApplication.sharedApplication().openURL(url)
            }
            UIApplication.sharedApplication().openURL(facebookURL!)
        }
    }
    
    // Functionality of the Email Button
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 3 && indexPath.row == 0 {
            sendEmailButtonTapped(UITableViewCell)
        }
        
        self.tableView.cellForRowAtIndexPath(indexPath)?.selected = false
    }
    
    @IBAction func sendEmailButtonTapped(sender: AnyObject) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        }
        else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients(["wvumobileapp@gmail.com"])
        mailComposerVC.setSubject("Feedback - iOS")
        mailComposerVC.setMessageBody("", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send Email.  Please check Email configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    // END FUNCIONALITY OF EMAIL BUTTON
    
    // Return number of sections in table view.
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    // Return number of rows in section.
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else if section == 1 {
            return 5
        }
        else if section == 2 {
            return 2
        }
        else if section == 3 {
            return 1
        }
        else {
            return 0
        }
    }
    
    // Header
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return ""
        }
        else if section == 1 {
            return "DEVELOPERS"
        }
        else if section == 2 {
            return "WVU Mobile"
        }
        else if section == 3 {
            return "SEND FEEDBACK"
        }
        else {
            return ""
        }
    }
    
    // Footer
    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 0 {
            //return "Change the first screen that loads to the PRT Status for quick access."
            return "You can toggle Night Mode from any view by triple tapping the Navigation Bar."
        }
        else if section == 1 {
            return "If you would like to see more from us, please follow us on Twitter!"
        }
        else if section == 2 {
            return "You can also like and follow WVU Mobile on Facebook and Twitter!"
        }
        else if section == 3 {
            return "Please send questions, suggestions, or bug reports to our email address."
        }
        else {
            return ""
        }
    }
    
    // Format cells here
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       let cell = UITableViewCell(style: .Value1, reuseIdentifier: "cell")
        
        if indexPath.row == 0 && indexPath.section == 0 {
            cell.selectionStyle = .None
            cell.backgroundColor = colors.cellColor
            cell.textLabel?.text = "Night Mode"
            cell.textLabel?.textColor = colors.textColor
            cell.accessoryView = nightSwitch
        }
        else if indexPath.row == 1 && indexPath.section == 0 {
            cell.selectionStyle = .None
            cell.backgroundColor = colors.cellColor
            cell.textLabel?.text = "PRT Status Default"
            cell.textLabel?.textColor = colors.textColor
            //cell.accessoryView = prtSwitch
        }
        else if indexPath.row == 0 && indexPath.section == 1 {
            cell.selectionStyle = .None
            cell.backgroundColor = colors.cellColor
            cell.textLabel?.text = "Kate"
            cell.textLabel?.textColor = colors.textColor
            cell.accessoryView = kateButton
        }
        else if indexPath.row == 1 && indexPath.section == 1 {
            cell.selectionStyle = .None
            cell.backgroundColor = colors.cellColor
            cell.textLabel?.text = "Ricky"
            cell.textLabel?.textColor = colors.textColor
            cell.accessoryView = rickyButton
        }
        else if indexPath.row == 2 && indexPath.section == 1 {
            cell.selectionStyle = .None
            cell.backgroundColor = colors.cellColor
            cell.textLabel?.text = "Jeremy"
            cell.textLabel?.textColor = colors.textColor
            cell.accessoryView = jeremyButton
        }
        else if indexPath.row == 3 && indexPath.section == 1 {
            cell.selectionStyle = .None
            cell.backgroundColor = colors.cellColor
            cell.textLabel?.text = "Corey"
            cell.textLabel?.textColor = colors.textColor
            cell.accessoryView = coreyButton
        }
        else if indexPath.row == 4 && indexPath.section == 1 {
            cell.selectionStyle = .None
            cell.backgroundColor = colors.cellColor
            cell.textLabel?.text = "Thomas"
            cell.textLabel?.textColor = colors.textColor
        }
        else if indexPath.row == 0 && indexPath.section == 2 {
            cell.selectionStyle = .None
            cell.backgroundColor = colors.cellColor
            cell.textLabel?.text = "Like on Facebook"
            cell.textLabel?.textColor = colors.textColor
            cell.accessoryView = facebookButton
        }
        else if indexPath.row == 1 && indexPath.section == 2 {
            cell.selectionStyle = .None
            cell.backgroundColor = colors.cellColor
            cell.textLabel?.text = "Follow on Twitter"
            cell.textLabel?.textColor = colors.textColor
            cell.accessoryView = twitterButton
        }
        else if indexPath.row == 0 && indexPath.section == 3 {
            // cell.selectionStyle = .None
            cell.backgroundColor = colors.cellColor
            cell.textLabel?.text = "wvumobileapp@gmail.com"
            cell.textLabel?.textColor = colors.textColor
            
        }
        return cell
    }
    
    // Set UI Colors
    override func setUIColors() {
        self.tableView.backgroundColor = colors.menuViewColor
        self.tableView.reloadData()
        super.setUIColors()
    }
    
    // Pregenerated.
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.restorationIdentifier = "SettingsViewController"
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
