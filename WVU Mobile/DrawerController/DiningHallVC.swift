//
//  DiningHallViewController.swift
//  WVU Mobile
//
//  Created by Kaitlyn Landmesser & Richard Deal on 2/21/15.
//  Copyright (c) 2015 WVUMobile. All rights reserved.
//

import UIKit
import GoogleMaps

class DiningHallVC: MainViewController, UITableViewDelegate, UITableViewDataSource, GMSMapViewDelegate {
    
    var menuView = UITableView()
    var infoView: UIView!
    var pageView: UIPageViewController!
    var map: GMSMapView!
    var descriptionLabel: UILabel!
    var hoursLabel = UILabel()
    var hoursDetailLabel = UILabel()
    var rControl: UIRefreshControl!
    var diningInfo: DiningJSON!
    var loading: UIActivityIndicatorView!
    var menus = NSDictionary()
    var key = NSArray()
    var segmentControl = UISegmentedControl()
    var toolBar = UIToolbar()
    
    // change date toolbar
    var datePicker: UIView!
    var date = NSDate()
    var formatter = NSDateFormatter()
    var dayButton: UIButton!
    var backButton: UIButton!
    var forwardButton: UIButton!
    
    override func viewDidLoad() {
        // loader
        self.navigationController?.navigationBar.tintColor = self.colors.textColor
        loading = UIActivityIndicatorView(frame: CGRectMake(self.view.frame.size.width/2 - 10, self.view.frame.size.height/2 - 10, 20, 20))
        loading.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
        loading.startAnimating()
        self.view.addSubview(loading)
        
        setUIColors()
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.evo_drawerController?.setupGestureRecognizers()
        super.viewWillDisappear(true)
    }
    
    func setupView() {
        self.evo_drawerController?.removeGestureRecognizers()
        
        /*
            Set up Menu view.
        */
        menuView = UITableView(frame: CGRectMake(0, 104, self.view.bounds.width, self.view.bounds.height - 104), style: UITableViewStyle.Plain)
        menuView.delegate = self
        menuView.dataSource = self
        menuView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        menuView.separatorStyle = .None
        menuView.contentInset = UIEdgeInsetsMake(-1, 0, 0, 0)
        menuView.backgroundColor = colors.menuViewColor
        menuView.showsVerticalScrollIndicator = false
        
        // Segmented Control
        toolBar = UIToolbar(frame: CGRectMake(0,64,(self.view.bounds.width),40))
        toolBar.barTintColor = colors.navBarColor
        segmentControl = UISegmentedControl(items: ["M E N U", "I N F O"])
        segmentControl.frame = (CGRectMake((self.view.bounds.width * 0.1),5,(self.view.bounds.width * 0.8),30))
        segmentControl.selectedSegmentIndex = 0
        segmentControl.tintColor = colors.textColor
        segmentControl.addTarget(self, action: "valueChanged", forControlEvents: UIControlEvents.ValueChanged)
        
        

        toolBar.addSubview(segmentControl)
        self.view.addSubview(toolBar)
        
        self.view.addSubview(menuView)
    
        // Check if dining hall is closed or network is down
        let errorLabel = UILabel(frame: CGRectMake(0, 50, self.view.bounds.width, 50))
        errorLabel.textColor = colors.textColor
        errorLabel.textAlignment = .Center
        errorLabel.font = UIFont(name: "HelveticaNeue-Light", size: 18)

        if diningInfo.error == true {
            errorLabel.text = "There is no network connection."
            menuView.addSubview(errorLabel)
        }
        else if menus.count == 0 {
            errorLabel.text = "C L O S E D"
            menuView.addSubview(errorLabel)
        }
        
        /*
            Set up Info view.
        */
        infoView = UIView(frame: CGRectMake(0, 104, self.view.bounds.width, self.view.bounds.height - 104))
        
        super.viewDidLoad()
        
        descriptionLabel = UILabel(frame: CGRectMake(0, (infoView.bounds.height) * 0.5, infoView.bounds.width, (infoView.bounds.height) * 0.12))
        descriptionLabel.backgroundColor = colors.prtGray2
        descriptionLabel.textAlignment = .Center
        descriptionLabel.font = UIFont(name: "HelveticaNeue-Light", size: 14)
        descriptionLabel.lineBreakMode = .ByWordWrapping
        descriptionLabel.numberOfLines = 0
        
        hoursLabel = UILabel(frame: CGRectMake(0, (infoView.bounds.height) * 0.62, infoView.bounds.width, (infoView.bounds.height) * 0.06))
        hoursLabel.text = "HOURS"
        hoursLabel.textAlignment = .Center
        hoursLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        
        hoursDetailLabel = UILabel(frame: CGRectMake(0, (infoView.bounds.height) * 0.68, infoView.bounds.width, (infoView.bounds.height) * 0.32))
        hoursDetailLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 18)
        hoursDetailLabel.lineBreakMode = .ByWordWrapping
        hoursDetailLabel.numberOfLines = 0
        hoursDetailLabel.textAlignment = .Center

        //infoView.addSubview(map)
        infoView.addSubview(descriptionLabel)
        infoView.addSubview(hoursLabel)
        infoView.addSubview(hoursDetailLabel)
        
        rControl = UIRefreshControl(frame: CGRectMake(0,100,self.view.bounds.width,70.0))
        rControl.addTarget(self, action: Selector("refresh"), forControlEvents: UIControlEvents.ValueChanged)
        menuView.addSubview(rControl)
        rControl.layer.zPosition = self.rControl.layer.zPosition-1
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: "loadInfo")
        leftSwipe.direction = UISwipeGestureRecognizerDirection.Left
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: "loadMenu")
        rightSwipe.direction = UISwipeGestureRecognizerDirection.Right
        
        infoView.addGestureRecognizer(rightSwipe)
        menuView.addGestureRecognizer(leftSwipe)
        
        setUIColors()
    }
    
    // Functionality for Segmented Control
    func valueChanged() {
        if segmentControl.selectedSegmentIndex == 0 {
            loadMenu()
        }
        else if segmentControl.selectedSegmentIndex == 1 {
            loadInfo()
        }
    }
    
    // Reload JSON and data inside tables.
    func refresh() {
        diningInfo.pullJSON()
        menuView.reloadData()
        rControl.endRefreshing()
    }
    
    func loadMenu() {
        //infoView.removeFromSuperview()
        self.view.addSubview(menuView)
        segmentControl.selectedSegmentIndex = 0
    }
    
    func loadInfo() {
        //menuView.removeFromSuperview()
        self.view.addSubview(infoView)
        segmentControl.selectedSegmentIndex = 1
    }
    
    // Return number of rows in each section of table.
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (menus[key[section] as! NSString] as! NSArray).count
    }
    
    // Return number of sections in table view.
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return menus.count
    }
    
    // Return height for header in section.
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    // Return header information for section.
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRectMake(0, 0, self.view.bounds.width, 25))
        let label = UILabel(frame: CGRectMake(10, 0, self.view.bounds.width, 25))
        label.textColor = colors.textColor
        headerView.backgroundColor = colors.headerColor
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        
        label.text = key[section] as! NSString as String
        
        headerView.addSubview(label)
        
        return headerView
    }
    
    // Return height for row at index.
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 30
    }
    
    // Return cell for row at index.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.menuView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        let array = (menus[key[indexPath.section] as! NSString] as! NSArray)
        cell.textLabel?.text = array[indexPath.row] as! NSString as String
        
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 18)
        cell.backgroundColor = colors.mainViewColor
        cell.textLabel?.textColor = colors.textColor
        
        /*
        Turn off cell selction.
        */
        cell.userInteractionEnabled = false
        
        return cell
    }
    
    // Set UI colors.
    override func setUIColors() {
        loading.color = colors.loadingColor
        hoursLabel.backgroundColor = colors.headerColor
        hoursDetailLabel.backgroundColor = colors.mainViewColor
        hoursLabel.textColor = colors.textColor
        hoursDetailLabel.textColor = colors.textColor
        toolBar.barTintColor = colors.navBarColor
        segmentControl.tintColor = colors.textColor
        menuView.reloadData()
        
        super.setUIColors()
    }
    
    // Pregenerated.
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.restorationIdentifier = "DiningHallVC"
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
