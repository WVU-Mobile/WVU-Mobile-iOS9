//
//  EventsViewController.swift
//  WVU Mobile
//
//  Created by Kaitlyn Landmesser & Richard Deal on 2/4/15.
//  Copyright (c) 2015 WVUMobile. All rights reserved.
//

import UIKit

class EventsViewController: CenterViewController, UITableViewDelegate, UITableViewDataSource, NSXMLParserDelegate {
    
    var tableView = UITableView()
    var feed : NSArray = []
    var url: NSURL = NSURL()
    var loading: UIActivityIndicatorView!
    var rControl: UIRefreshControl!
    var rssURL = ""
    var events: Events!
    var selectedEvents: NSMutableArray!
    
    //toolbar
    var datePicker: UIView!
    var date = NSDate()
    var formatter = NSDateFormatter()
    var dayButton: UIButton!
    var backButton: UIButton!
    var forwardButton: UIButton!
    
    override func viewDidLoad() {
        self.title = "Events"
        rssURL = "https://cal.wvu.edu/RSSSyndicator.aspx?category=&location=&type=N&binary=Y"

        /*
            Change back bar button to custom text, while preserving the back arrow.
        */
        let backItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        
        /*
            Loader
        */
        loading = UIActivityIndicatorView(frame: CGRectMake(self.view.frame.size.width/2 - 10, self.view.frame.size.height/2 - 10, 20, 20))
        loading.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
        loading.startAnimating()
        self.view.addSubview(loading)
        
        createToolbar()
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            self.events = Events.sharedInstance
            self.selectedEvents = self.events.eventsOnDay(NSDate())
            
            dispatch_async(dispatch_get_main_queue(), {
                // stop and remove the spinner on the background when done
                self.setupView()
                self.loading.stopAnimating()
            })
        })
        setUIColors()
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
        setupGesture()
        super.viewDidAppear(true)
    }
    
    func setupView(){
        /*
        Set up table view.
        */
        tableView = UITableView(frame: CGRectMake(-0.25, 110, self.view.bounds.width + 0.25, self.view.bounds.height-110), style: UITableViewStyle.Plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        //tableView.separatorStyle = .None
        tableView.separatorColor = colors.textColor
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.showsVerticalScrollIndicator = false
        
        dayButton.addTarget(self, action: "click", forControlEvents: UIControlEvents.TouchUpInside)
        forwardButton.addTarget(self, action: "forward", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)

        self.view.addSubview(self.tableView)
        
        let error = UILabel(frame: CGRectMake(self.view.bounds.width/2 - 125, self.view.bounds.height/2, 250, 40))
        self.view.addSubview(error)
        if selectedEvents.count == 0 {
            error.text = "There are no events to display."
            error.font = UIFont(name: "HelveticaNeue-Thin", size: 18)
            error.textColor = colors.textColor
            error.textAlignment = .Center
        } else {
            error.text = ""
        }
        
        rControl = UIRefreshControl(frame: CGRectMake(0,100,self.view.bounds.width,70.0))
        rControl.addTarget(self, action: Selector("refresh"), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(rControl)
        rControl.layer.zPosition = self.rControl.layer.zPosition-1
        
        setUIColors()
    }
    
    
    func createToolbar(){
        datePicker = UIView(frame: CGRectMake(0, 64, self.view.bounds.width, 46))
        
        setDateButton()
        
        backButton = UIButton(type: UIButtonType.System)
        backButton.frame = CGRectMake(self.view.bounds.width/4 - 25, 5, 50, 36)
        backButton.setTitle("<", forState: .Normal)
        backButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 22)
        
        forwardButton = UIButton(type: UIButtonType.System)
        forwardButton.frame = CGRectMake((self.view.bounds.width/4) * 3 - 25, 5, 50, 36)
        forwardButton.setTitle(">", forState: .Normal)
        forwardButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 22)

        datePicker.addSubview(backButton)
        datePicker.addSubview(forwardButton)
        self.view.addSubview(datePicker)
    }
    
    func setDateButton(){
        formatter.dateStyle = NSDateFormatterStyle.ShortStyle
        
        dayButton = UIButton(type: UIButtonType.System)
        dayButton.frame = CGRectMake(self.view.bounds.width/2 - 50, 5, 100, 36)
        dayButton.setTitle(formatter.stringFromDate(date), forState: .Normal)
        dayButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 16)
        
        datePicker.addSubview(dayButton)
    }
    
    func click(){
        date = NSDate()
        setDateButton()
        
        selectedEvents = events.eventsOnDay(date)
        setupView()
    }
    
    
    func back(){
        let calendar = NSCalendar.currentCalendar()
        let yesterday = calendar.dateByAddingUnit(.Day, value: -1, toDate: date, options: [])
        date = yesterday!
        setDateButton()
        
        selectedEvents = events.eventsOnDay(date)
        setupView()
    }
    
    func forward(){
        let calendar = NSCalendar.currentCalendar()
        let yesterday = calendar.dateByAddingUnit(.Day, value: 1, toDate: date, options: [])
        date = yesterday!
        setDateButton()
        
        selectedEvents = events.eventsOnDay(date)
        setupView()
    }
    
    func refresh(){
        events.pullRSS()
        rControl.endRefreshing()
    }
    
    // Return number of rows in section.
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedEvents.count
    }
    
    // Return number of sections in table view.
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // Return cell for row at index.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        let event = selectedEvents.objectAtIndex(indexPath.row) as! EventObject
        
        event.decode()
        
        cell.backgroundColor = self.colors.mainViewColor
        cell.textLabel?.textColor = self.colors.subtitleTextColor
        cell.textLabel?.text = "\(event.time)"
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 13)
        cell.textLabel?.numberOfLines = 0

        
        cell.detailTextLabel?.text = event.title
        cell.detailTextLabel?.textColor = self.colors.textColor
        cell.detailTextLabel?.font = UIFont(name: "HelveticaNeue-LightItalic", size: 16)
        cell.detailTextLabel?.numberOfLines = 0
        
        //selected background view color
        let bgColorView = UIView()
        bgColorView.backgroundColor = colors.selectColor
        cell.selectedBackgroundView = bgColorView
        
        //cell.layer.borderWidth = 0.25
        //cell.layer.borderColor = colors.selectBlue.CGColor
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let event = selectedEvents.objectAtIndex(indexPath.row) as! EventObject
        
        let feedPage = WebPageViewController()
        feedPage.url = event.link
        self.navigationController?.pushViewController(feedPage, animated: true)
        tableView.cellForRowAtIndexPath(indexPath)?.selected = false
    }
    
    override func setUIColors() {
        tableView.reloadData()
        tableView.backgroundColor = colors.menuViewColor
        tableView.separatorColor = colors.textColor
        
        loading.color = colors.loadingColor
        
        datePicker.backgroundColor = colors.tertiaryColor
        backButton.backgroundColor = colors.secondaryColor
        forwardButton.backgroundColor = colors.secondaryColor
        dayButton.backgroundColor = colors.secondaryColor

        backButton.setTitleColor(colors.textColor, forState: .Normal)
        forwardButton.setTitleColor(colors.textColor, forState: .Normal)
        dayButton.setTitleColor(colors.textColor, forState: .Normal)
        
        super.setUIColors()
    }
    
    // Pregenerated.
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.restorationIdentifier = "EventsViewController"
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
