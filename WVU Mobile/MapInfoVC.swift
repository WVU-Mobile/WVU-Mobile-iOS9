//
//  MapInfoVC.swift
//  WVU Mobile
//
//  Created by Kaitlyn Landmesser & Richard Deal on 8/1/15.
//  Copyright (c) 2015 WVUMobile. All rights reserved.
//

import Foundation
import CoreLocation
import GoogleMaps

class MapInfoVC: MainViewController, UITableViewDelegate, UITableViewDataSource{
    
    var tableView =  UITableView()
    var imageView = UIImageView()
    var mainView = UIView()
    var map = GMSMapView()
    
    var name: String
    var code: String
    var longitude: Double
    var latitude: Double
    var mapsJSON: MapsJSON
    let METERS_PER_HOUR: Double = 4988.0
    let IMAGE_URL = "http://beta.campusmap.wvu.edu/images/locations/"
    var address = ""
    
    init(name: String, code: String, latitude: Double, longitude: Double){
        self.name = name
        self.code = code
        self.mapsJSON = MapsJSON(code: code, name: name)
        self.latitude = latitude
        self.longitude = longitude
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        self.title = self.code
        /*
        Set up table view.
        */
        if (mapsJSON.address as String == ""){
            getAddressFromLatLon()
        }

        tableView = UITableView(frame: CGRectMake(0, (self.view.bounds.height - 64) * 0.5, self.view.bounds.width, (self.view.bounds.height + 64) * 0.5), style: UITableViewStyle.Plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .None
        tableView.estimatedRowHeight = 25
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.showsVerticalScrollIndicator = false
        
        
        mainView = UIView(frame: CGRectMake(0, 64, self.view.bounds.width, (self.view.bounds.height - 64) * 0.5))
        
        let name = mapsJSON.image as String
        
        if (name != "") {
            let image: UIImage = getBuildingImage(mapsJSON.image as String)
            imageView = UIImageView(frame: mainView.bounds)
            imageView.image = image
            imageView.contentMode = UIViewContentMode.ScaleAspectFill
            imageView.clipsToBounds = true
            mainView.addSubview(imageView)
        } else {
            let camera = GMSCameraPosition.cameraWithLatitude(latitude, longitude: longitude, zoom:17)
            map = GMSMapView.mapWithFrame(mainView.bounds, camera: camera)
            map.settings.scrollGestures = false
            map.settings.zoomGestures = false
            
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            marker.title = name
            marker.map = map
            marker.icon = GMSMarker.markerImageWithColor(colors.mountainLineGreen)
            
            mainView.addSubview(map)
        }
        
        self.view.addSubview(mainView)
        self.view.addSubview(self.tableView)
        
        walkingButton()
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
        return 16
    }
    
    // Return number of sections in table view.
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // Return height for header in section.
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    // Return header information for section.
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRectMake(0, 0, self.view.bounds.width, 40))
        let label = UILabel(frame: CGRectMake(10, 0, self.view.bounds.width, 40))
        label.textColor = colors.textColor
        headerView.backgroundColor = colors.headerColor
        label.font = UIFont(name: "HelveticaNeue-Light", size: 18)
        label.textAlignment = NSTextAlignment.Center

        label.text = self.name
        
        headerView.addSubview(label)
        
        return headerView
    }
    
    // Return cell for row at index.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        cell.backgroundColor = colors.mainViewColor
        cell.textLabel?.textColor = colors.textColor
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-LightItalic", size: 16)
        cell.userInteractionEnabled = false
        
        if indexPath.row == 0 {
            cell = subtitleCell()
            cell.textLabel?.text = "Type"
        } else if indexPath.row == 1 {
            cell.textLabel?.text = (mapsJSON.campus as String) + " " + (mapsJSON.subtype as String)
        } else if indexPath.row == 2 {
            cell = subtitleCell()
            cell.textLabel?.text = "Info"
        } else if indexPath.row == 3 {
            cell.textLabel?.text = mapsJSON.description as String
        } else if indexPath.row == 4 {
            cell = subtitleCell()
            cell.textLabel?.text = "Address"
        } else if indexPath.row == 5 {
            cell.textLabel?.text = mapsJSON.address as String + "\nMorgantown, WV 26502"
        } else if indexPath.row == 6 {
            cell = subtitleCell()
            cell.textLabel?.text = "Phone"
        } else if indexPath.row == 7 {
            let num =  mapsJSON.phone as String
            if (num != "No number listed.") {cell.userInteractionEnabled = true}
            cell.textLabel?.text = num
        } else if indexPath.row == 8 {
            cell = subtitleCell()
            cell.textLabel?.text = "Website"
        } else if indexPath.row == 9 {
            let web = mapsJSON.web as String
            if (web != "No website listed.") {cell.userInteractionEnabled = true}
            cell.textLabel?.text = web
        } else if indexPath.row == 10 {
            cell = subtitleCell()
            cell.textLabel?.text = "Wifi"
        } else if indexPath.row == 11 {
            cell.textLabel?.text = ((mapsJSON.wifi as Int) == 1) ? "Yes" : "No"
        } else if indexPath.row == 12 {
            cell = subtitleCell()
            cell.textLabel?.text = "Closest Parking"
        } else if indexPath.row == 13 {
            let parkingName = mapsJSON.parking.objectForKey("name") as! String
            let parkingDistance = mapsJSON.parking.objectForKey("distance") as! Double
            let pstring = metersToMinutes(parkingDistance)

            cell.textLabel?.text = parkingName + " " + pstring
        } else if indexPath.row == 14 {
            cell = subtitleCell()
            cell.textLabel?.text = "Closest PRT"
        } else if indexPath.row == 15 {
            let prtName = mapsJSON.prt.objectForKey("name") as! String
            let prtDistance = mapsJSON.prt.objectForKey("distance") as! Double
            let pstring = metersToMinutes(prtDistance)

            cell.textLabel?.text = prtName + " " + pstring
        }
        
        return cell
    }   
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        if (indexPath.row == 7) {
            alert("Call", link: "tel://\(self.mapsJSON.phone as String)")
        } else if (indexPath.row == 9) {
            alert("Open in Safari", link: mapsJSON.web as String)
        }
    }
    
    func alert(message: String, link: String) {
        let alertController = UIAlertController(title: "", message: "\(message)?", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            
        }
        alertController.addAction(cancelAction)
        let OKAction = UIAlertAction(title: "Yes", style: .Default) { (action) in
            if let url = NSURL(string: link) {
                UIApplication.sharedApplication().openURL(url)
            }
        }
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated: true) {
            
        }
    }
    
    func metersToMinutes(meters: Double) -> String{
        let minutes = (meters / METERS_PER_HOUR) * 100.0
        let rounded = Int(round(minutes))
        
        var formattedMinutes = ""
        
        if rounded == 0 {
            formattedMinutes = "(Less than 1 minute walk)"
        } else if rounded == 1 {
            formattedMinutes = "(1 minute walk)"
        } else if rounded > 1 {
            formattedMinutes = "(" + String(rounded) + " minute walk)"
        } else {
            formattedMinutes = "Walking estimate not available."
        }
        return formattedMinutes
    }
    
    
    func getBuildingImage(name: String) -> UIImage {
        var image: UIImage = UIImage()
        let urlfirst = IMAGE_URL + name + ".jpg"
        print(name)
        print(urlfirst)

        if let url = NSURL(string: urlfirst) {
            if let data = NSData(contentsOfURL: url){
                image = UIImage(data: data)!
            }
        }
        
        return image
    }
    
    func walkingButton() {
        let infoImage = UIImage(named: "walking")
        
        
        let infoView = UIImageView(frame: CGRectMake(0, 0, 27, 27))
        infoView.image = infoImage
        infoView.image = infoView.image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        
        let infoButton = UIButton(frame: (infoView.bounds))
        infoButton.setBackgroundImage(infoView.image, forState: UIControlState.Normal)
        infoButton.addTarget(self, action: "walkingDirections", forControlEvents: UIControlEvents.TouchUpInside)
        
        let infoButtonItem = UIBarButtonItem(customView: infoButton)
        
        self.navigationItem.rightBarButtonItem = infoButtonItem
    }
    
    func walkingDirections(){
        var a = mapsJSON.address as String
        if a != "" {
            a = a + "\nMorgantown WV 26502"
        } else {
            a = self.address
        }
        
        a = a.stringByReplacingOccurrencesOfString(" ", withString: "+", options: .LiteralSearch, range: nil)
        a = a.stringByReplacingOccurrencesOfString("\n", withString: "+", options: .LiteralSearch, range: nil)
        
        
        let alertController = UIAlertController(title: "", message: "Get directions?", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) {
            (action) in
        }
        alertController.addAction(cancelAction)
        let OKAction = UIAlertAction(title: "Directions", style: .Default) {
            (action) in
            if let url = NSURL(string: "http://maps.apple.com/?daddr=" + a + "+United+States,+CA&saddr=current+location") {
                UIApplication.sharedApplication().openURL(url)
            }
        }
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated: true) {
            
        }
    }
    
    // crashed with pierpont, brf, arnold, farm, nrc, sas
    func getAddressFromLatLon(){
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            
            if error != nil || placemarks == nil {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
            }
            
            else if placemarks!.count > 0 {
                let pm = placemarks![0] as CLPlacemark
                let a = pm.subThoroughfare
                //let a = pm.subThoroughfare + " " + pm.thoroughfare + "\n" + pm.locality + " WV " + pm.postalCode
                self.setAddress(a!)
            }
            else {
                print("Problem with the data received from geocoder")
            }
        })
    }
    
    private func setAddress(address: String){
        self.address = address
    }
    
    func subtitleCell() -> UITableViewCell{
        let cell = UITableViewCell()
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        cell.backgroundColor = colors.mainViewColor
        
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 13)
        cell.textLabel?.textColor = self.colors.subtitleTextColor
        cell.textLabel?.numberOfLines = 0
        cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.x, cell.frame.size.width, 20);

        return cell
    }

    override func setUIColors() {
        tableView.reloadData()
        tableView.backgroundColor = colors.menuViewColor
        super.setUIColors()
    }
    
    // Pregenerated.
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        self.name = ""
        self.code = ""
        self.latitude = 0
        self.longitude = 0
        self.mapsJSON = MapsJSON(code: code, name: name)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.restorationIdentifier = "NewsViewController"
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}