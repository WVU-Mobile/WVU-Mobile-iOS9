//
//  LineViewController.swift
//  WVU Mobile
//
//  Created by Kaitlyn Landmesser & Richard Deal on 3/31/15.
//  Copyright (c) 2015 WVUMobile. All rights reserved.
//

import UIKit
import GoogleMaps

class LineViewController: MainViewController, UITableViewDelegate, UITableViewDataSource, GMSMapViewDelegate {
    
    var tableView = UITableView()
    var line: BusLine!
    var coords: Dictionary <String, CLLocationCoordinate2D>!
    var map: GMSMapView!
    var selected = -1
    var markerArray = [GMSMarker]()
    
    override func viewDidLoad() {
        self.title = line.name
        
        /*
        Set up Google Map View.
        */
        let camera = GMSCameraPosition.cameraWithLatitude(39.635582, longitude: -79.954747, zoom:12)
        map = GMSMapView.mapWithFrame(CGRectMake(0, 65, self.view.bounds.width, (self.view.bounds.height) * 0.4), camera: camera)
        map.delegate = self
        
        // Add each stop as Marker
        for stop in line.stops {
            let marker = GMSMarker()
            marker.position = coords[stop]!
            marker.title = stop
            marker.map = map
            marker.icon = GMSMarker.markerImageWithColor(colors.mountainLineGreen)
            markerArray.append(marker)
        }
        
        // Parse
        let path = NSBundle.mainBundle().pathForResource(line.name, ofType: "txt")
        var text = ""
        
        do {
            text = try String(contentsOfFile: path!, encoding: NSUTF8StringEncoding)
        } catch {
            print("ugh")
        }
        
        let shape = GMSMutablePath()
        let shapeArray = text.componentsSeparatedByString("\n")
        for set in shapeArray {
            let c = set.componentsSeparatedByString("\t")
            shape.addCoordinate(CLLocationCoordinate2DMake((c[0] as NSString).doubleValue, (c[1] as NSString).doubleValue))
        }
        let polyline = GMSPolyline(path: shape)
        polyline.strokeWidth = 5.0
        polyline.map = map
        
        self.view.addSubview(map)
        
        /*
        Set up Table View.
        */
        tableView = UITableView(frame: CGRectMake(0, 266, self.view.bounds.width, (self.view.bounds.height)-266), style: UITableViewStyle.Plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .None
        tableView.backgroundColor = colors.menuViewColor
        tableView.showsVerticalScrollIndicator = false
        
        self.view.addSubview(self.tableView)
        
        twitterButton()
        
        setUIColors()
        super.viewDidLoad()
    }
    
    func twitterButton() {
        let infoImage = UIImage(named: "twitterInfo")
        
        let infoView = UIImageView(frame: CGRectMake(0, 0, 27, 27))
        infoView.image = infoImage
        infoView.image = infoView.image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        
        let infoButton = UIButton(frame: (infoView.bounds))
        infoButton.setBackgroundImage(infoView.image, forState: UIControlState.Normal)
        infoButton.addTarget(self, action: #selector(LineViewController.loadTwitter), forControlEvents: UIControlEvents.TouchUpInside)
        
        let infoButtonItem = UIBarButtonItem(customView: infoButton)
        
        self.navigationItem.rightBarButtonItem = infoButtonItem
    }
    
    func loadTwitter() {
        let feedPage = WebPageViewController()
        feedPage.url = "https://twitter.com/\(line.twitter)"
        self.navigationController?.pushViewController(feedPage, animated: true)
    }
    
    // Return number of rows in section.
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return line.stops.count + 1
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.tableView.reloadData()
        self.setupGesture()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.evo_drawerController?.removeGestureRecognizers()
        super.viewWillAppear(true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.evo_drawerController?.setupGestureRecognizers()
        super.viewWillDisappear(true)
    }
    
    // Return number of sections in table view.
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return UITableViewAutomaticDimension
        }
        else {
            return 50
        }
    }
    
    // Return height for header in section.
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    // Return header information for section.
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRectMake(0, 0, self.view.bounds.width, 25))
        let label = UILabel(frame: CGRectMake(0, 0, self.view.bounds.width, 25))
        label.textColor = colors.textColor
        headerView.backgroundColor = colors.secondaryColor
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 14)
        label.text = line.runTime
        label.textAlignment = .Center
        label.lineBreakMode = .ByWordWrapping
        
        headerView.addSubview(label)
        
        return headerView
    }
    
    // Return cell for row at index.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
        
        cell.textLabel?.textColor = colors.textColor
        
        if indexPath.row == 0 {
            cell.backgroundColor = colors.secondaryColor
            cell.textLabel?.text = line.hoursString
            cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 12)
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.lineBreakMode = .ByWordWrapping
            cell.textLabel?.textAlignment = .Center
            cell.selectionStyle = .None
            
        }
        else {
            cell.backgroundColor = colors.mainViewColor
            cell.textLabel?.text = line.stops[indexPath.row-1]
            cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 14)
            if !NSUserDefaults.standardUserDefaults().boolForKey("nightMode") {
                cell.imageView?.image = UIImage(named: "stops")
            }
            else {
                cell.imageView?.image = UIImage(named: "dstops")
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row > 0 {
            if selected != indexPath.row - 1 {
                selected = indexPath.row - 1
                let name = line.stops[selected]
                let camera = GMSCameraPosition(target: coords[name]!, zoom: 16, bearing: 0, viewingAngle: 0)
                map.animateToCameraPosition(camera)
                map.selectedMarker = markerArray[indexPath.row - 1]
            }
            else {
                map.selectedMarker = nil
                let camera = GMSCameraPosition(target: CLLocationCoordinate2DMake(39.635582, -79.954747), zoom: 12, bearing: 0, viewingAngle: 0)
                map.animateToCameraPosition(camera)
                tableView.cellForRowAtIndexPath(indexPath)?.selected = false
                selected = -1
            }
        }
    }
    
    override func setUIColors() {
        self.tableView.backgroundColor = colors.menuViewColor
        self.tableView.reloadData()
        super.setUIColors()
    }
    
    // Pregenerated.
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.restorationIdentifier = "DiningViewController"
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
