//
//  PRTTableViewController.swift
//  WVU Mobile
//
//  Created by Kaitlyn Landmesser & Richard Deal on 2/20/15.
//  Copyright (c) 2015 WVUMobile. All rights reserved.
//

import UIKit

class PRTTableViewController: CenterViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView = UITableView()
    var backgroundColor: UIColor!
    var image: UIImage!
    var statusText: String!
    var statusTextColor: UIColor!
    var prtInfo: PRTJSON!
    var rControl: UIRefreshControl!
    var loading: UIActivityIndicatorView!
    
    
    var dimensions: [CGFloat] = [
        0.35,
        0.12,
        0.31,
        0.22]
    
    override func viewDidLoad() {
        //loader
        loading = UIActivityIndicatorView(frame: CGRectMake(self.view.frame.size.width/2 - 10, self.view.frame.size.height/2 - 10, 20, 20))
        loading.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
        loading.startAnimating()
        self.view.addSubview(loading)
        
        self.title = "PRT"
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            //JSON Objects
            self.prtInfo = PRTJSON()
            
            dispatch_async(dispatch_get_main_queue(), {
                // stop and remove the spinner on the background when done
                self.loading.stopAnimating()
                self.loadPRTView()
            })
        })
        
        setUIColors()
        super.viewDidLoad()
    }
    
    func loadPRTView(){
        // Switch view elements based on PRT status
        switch self.prtInfo.status{
            // PRT Okay
        case "1":
            backgroundColor = self.colors.green
            image = UIImage(named: "check")!
            statusText = "O N L I N E"
            statusTextColor = self.colors.green
            // PRT Partially down
        case "2", "5", "6", "10":
            backgroundColor = self.colors.orange
            image = UIImage(named: "yield")!
            statusText = "W A R N I N G"
            statusTextColor = self.colors.orange
            // PRT Out of Service
        case "4", "8", "9":
            backgroundColor = self.colors.red
            image = UIImage(named: "stop")!
            statusText = "O F F L I N E"
            statusTextColor = self.colors.pink
            // Default to 1
        default:
            backgroundColor = self.colors.orange
            image = UIImage(named: "yield")!
            statusText = "E R R O R"
            statusTextColor = self.colors.orange
        }
        
        /*
            Set up table view.
        */
        tableView = UITableView(frame: CGRectMake(0,64,self.view.bounds.width,self.view.bounds.height-64), style: .Grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .None
        tableView.contentInset = UIEdgeInsetsMake(-1, 0, 0, 0)
        tableView.backgroundColor = self.colors.menuViewColor
        tableView.showsVerticalScrollIndicator = false
        
        self.view.addSubview(self.tableView)
        
        rControl = UIRefreshControl(frame: CGRectMake(0,100,self.view.bounds.width,70.0))
        rControl.addTarget(self, action: #selector(PRTTableViewController.refresh), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(rControl)
        rControl.layer.zPosition = self.rControl.layer.zPosition-1
    }
    
    // Reload JSON and data inside tables.
    func refresh(){
        self.prtInfo.pullJSON()
        self.loadPRTView()
        self.tableView.reloadData()
        self.rControl.endRefreshing()
    }
    
    // Return height for header in section.
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    // Return number of rows in section.
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dimensions.count
    }
    
    // Return cell for row at index.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        switch indexPath.row{
            
            // Image
        case 0:
            cell.backgroundColor = self.backgroundColor
            let imageView = UIImageView(frame: CGRectMake(self.view.bounds.width/2 - (((self.view.bounds.height - 64) * 0.31)/2), ((self.view.bounds.height - 64) * 0.02) , (self.view.bounds.height - 64) * 0.31, (self.view.bounds.height - 64) * 0.31))
            imageView.image = self.image
            cell.addSubview(imageView)
            
            // Status
        case 1:
            cell.backgroundColor = self.colors.prtGray1
            cell.textLabel?.text = statusText
            cell.textLabel?.textColor = statusTextColor
            cell.textLabel?.textAlignment = .Center
            cell.textLabel?.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 40)
            
            // Message
        case 2:
            cell.backgroundColor = self.colors.secondaryColor
            cell.textLabel?.text = prtInfo.message as String
            cell.textLabel?.textColor = self.colors.textColor
            cell.textLabel?.textAlignment = .Center
            cell.textLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 25)
            cell.textLabel?.lineBreakMode = .ByWordWrapping
            cell.textLabel?.numberOfLines = 0
            break
            
            // Hours
        case 3:
            cell.backgroundColor = self.colors.mainViewColor
            cell.textLabel?.text = "Monday to Friday 7:00 AM to 8:00 PM \nSaturday CLOSED \nSunday CLOSED"
            cell.textLabel?.textColor = self.colors.textColor
            cell.textLabel?.textAlignment = .Center
            cell.textLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 17)
            cell.textLabel?.lineBreakMode = .ByWordWrapping
            cell.textLabel?.numberOfLines = 0
        default:
            break
        }
        /*
        Turn off cell selction.
        */
        cell.userInteractionEnabled = false
        
        return cell
    }
    
    // Return height for row at index.
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return (self.dimensions[indexPath.row] * ((self.view.bounds.height)-64))
    }
    
    // Recenter screen after scroller. A
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate == false {
            self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
        }
    }
    
    // Recenter screen after scrolling. B
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
    }

    // Set UI colors.
    override func setUIColors() {
        super.setUIColors()
        loading.color = colors.loadingColor
        self.tableView.backgroundColor = self.colors.menuViewColor
        self.tableView.reloadData()
    }
    
    // Pregenerated.
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.restorationIdentifier = "PRTTableViewController"
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
