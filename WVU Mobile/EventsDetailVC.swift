//
//  EventsDetailVC.swift
//  WVU Mobile
//
//  Created by Kaitlyn Landmesser & Richard Deal on 4/2/15.
//  Copyright (c) 2015 WVUMobile. All rights reserved.
//

import Foundation
import UIKit

class EventsDetailVC: MainViewController, UITableViewDelegate, UITableViewDataSource{
    
    var tableView =  UITableView()
    
    var selectedFeedTitle = String()
    var selectedFeedFeedContent = String()
    var selectedFeedURL = String()
    var time = ""
    var date: NSDate!
    
    override func viewDidLoad() {
        /*
        Set up table view.
        */
        tableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.Plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .None
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.showsVerticalScrollIndicator = false
        
        self.view.addSubview(self.tableView)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Web", style: UIBarButtonItemStyle.Plain, target: self, action: "loadWeb")

        setUIColors()
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        tableView.reloadData()
        setupGesture()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.evo_drawerController?.removeGestureRecognizers()
        super.viewWillAppear(true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.evo_drawerController?.setupGestureRecognizers()
        super.viewWillDisappear(true)
    }
    
        // Return number of rows in section.
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    // Return number of sections in table view.
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // Return cell for row at index.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()

        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        cell.backgroundColor = colors.mainViewColor
        cell.textLabel?.textColor = colors.textColor
        cell.textLabel?.numberOfLines = 0
        
        if indexPath.row == 0 {
            cell.textLabel?.text = selectedFeedTitle
            cell.textLabel?.font = UIFont(name: "HelveticaNeue-LightItalic", size: 19)
        } else if indexPath.row == 1 {
            let formatter = NSDateFormatter()
            formatter.dateStyle = NSDateFormatterStyle.MediumStyle
            cell.textLabel?.text = "\(formatter.stringFromDate(date)) \(time)"
            cell.textLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 13)
        } else if indexPath.row == 2 {
            cell.textLabel?.text = selectedFeedFeedContent
            cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 17)
        }
        
        return cell
    }
    
    func loadWeb(){
        let feedPage = WebPageViewController()
        feedPage.url = selectedFeedURL
        self.navigationController?.pushViewController(feedPage, animated: true)
    }
    
    override func setUIColors() {
        tableView.reloadData()
        tableView.backgroundColor = colors.menuViewColor
        super.setUIColors()
    }
    
    // Pregenerated.
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.restorationIdentifier = "NewsViewController"
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}