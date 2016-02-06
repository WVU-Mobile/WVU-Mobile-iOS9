//
//  MapViewController.swift
//  WVU Mobile
//
//  Created by Kaitlyn Landmesser & Richard Deal on 2/4/15.
//  Copyright (c) 2015 WVUMobile. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: CenterViewController, CLLocationManagerDelegate, GMSMapViewDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    struct mapCoordinate {
        var code: String
        var name: String
        var latitude: Double
        var longitude: Double
    }
    
    var color = UIColors()
    let locationManager = CLLocationManager()
    var mapView = GMSMapView()
    //let searchBar = UITextView()
    var searchBar: UISearchBar!
    var filtered = [GMSMarker]()
    var tableView: UITableView!
    var active:Bool = false
    var gesture: UITapGestureRecognizer!
    
    var academicMarkers = [GMSMarker]()
    var housingMarkers = [GMSMarker]()
    var parkingMarkers = [GMSMarker]()
    var prtMarkers = [GMSMarker]()

    
    //var academicCoords = [["code": "ARH-D", "name":"Arnold Hall", "latitude": 39.632486, "longitude": -79.950469]]
    var academicCoords: Array <mapCoordinate> = [
        mapCoordinate(code: "WDB-D", name: "Woodburn Hall", latitude: 39.6359019354253, longitude: -79.9553555622697),
        mapCoordinate(code: "AEL-E", name: "Aerodynamics Laboratory", latitude: 39.645670, longitude: -79.974281),
        mapCoordinate(code: "AER-E", name: "Advanced Engineering Research Building", latitude: 39.646064, longitude: -79.971300),
        mapCoordinate(code: "AGS-E", name: "Agricultrial Sciences Building", latitude: 39.645768, longitude: -79.969936),
        mapCoordinate(code: "ALH-E",   name: "Allen Hall", latitude: 39.646186, longitude: -79.967245),
        mapCoordinate(code: "ARM-D", name: "Armstrong Hall", latitude: 39.63505832, longitude: -79.95578438),
        mapCoordinate(code: "ASA-E", name: "Agricultural Sciences Annex", latitude: 39.646773, longitude: -79.968235),
        mapCoordinate(code: "BIC-E", name: "Bicentennial Housing", latitude: 39.639645, longitude: -79.935943),
        mapCoordinate(code: "BKH-D", name: "Brooks Hall", latitude: 39.635585, longitude: -79.956277),
        mapCoordinate(code: "BMRF-H",name: "Biomedical Research Facility", latitude: 39.655504, longitude: -79.957020),
        mapCoordinate(code: "BUE-D", name: "Business and Economics Building", latitude: 39.636591, longitude: -79.954545),
        mapCoordinate(code: "CAC-E", name: "Creative Arts Center", latitude: 39.648136, longitude: -79.975703),
        mapCoordinate(code: "CHI-D", name: "Chitwood Hall", latitude: 39.636101, longitude: -79.954638),
        mapCoordinate(code: "CKH-D", name: "Clark Hall", latitude: 39.633747, longitude: -79.954364),
        mapCoordinate(code: "CLN-D", name: "Colson Hall", latitude: 39.633961, longitude: -79.955330),
        mapCoordinate(code: "COL-E", name: "Coliseum", latitude: 39.649228, longitude: -79.981588),
        mapCoordinate(code: "CS1-E", name: "Crime Scene House 1", latitude: 39.648919, longitude: -79.964796),
        mapCoordinate(code: "CS2-E", name: "Crime Scene House 2", latitude: 39.649303, longitude: -79.964376),
        mapCoordinate(code: "CS3-E", name: "Crime Scene House 3", latitude: 39.649330, longitude: -79.964668),
        mapCoordinate(code: "CSG-E", name: "Crime Scene Garage", latitude: 39.649070, longitude: -79.964985),
        mapCoordinate(code: "CRL-D", name: "Chemistry Research Laboratory", latitude: 39.633366, longitude: -79.953559),
        mapCoordinate(code: "CRP-E", name: "Chestnut Ridge Prof Building", latitude: 39.657176, longitude: -79.954237),
        mapCoordinate(code: "CRR-E", name: "Chestnut Ridge Research Building", latitude: 39.657046, longitude: -79.955224),
        mapCoordinate(code: "EIE-D", name: "Eisland Hall", latitude: 39.633687, longitude: -79.956106),
        mapCoordinate(code: "EMH-D", name: "Elizabeth Moore Hall", latitude: 39.634949, longitude: -79.955152),
        mapCoordinate(code: "ERA-E", name: "ERC RFL Annex Building", latitude: 39.648041, longitude: -79.965808),
        mapCoordinate(code: "ERB-E", name: "Engineering Research Building", latitude: 39.645674, longitude: -79.972463),
        mapCoordinate(code: "ESB-E", name: "Engineering Sciences Building", latitude: 39.64588716, longitude: -79.97374445),
        mapCoordinate(code: "EVL-E", name: "Evansdale Library", latitude: 39.645244, longitude: -79.971272),
        mapCoordinate(code: "FCH-E", name: "Fieldcrest Hall", latitude: 39.652458, longitude: -79.963139),
        mapCoordinate(code: "FH1-D", name: "650 Spruce", latitude: 39.633102, longitude: -79.951462),
        mapCoordinate(code: "FH2-D", name: "660 North High", latitude: 39.634039, longitude: -79.952016),
        mapCoordinate(code: "FH3-D", name: "670 North High", latitude: 39.634159, longitude: -79.951871),
        mapCoordinate(code: "FH4-D", name: "672 North High", latitude: 39.634380, longitude: -79.951776),
        mapCoordinate(code: "FH5-D", name: "216 Belmar", latitude: 39.635233, longitude: -79.950493),
        mapCoordinate(code: "FH6-D", name: "225 Belmar", latitude: 39.635455, longitude: -79.950040),
        mapCoordinate(code: "GRH-E", name: "Green House 1", latitude: 39.644174, longitude: -79.969498),
        mapCoordinate(code: "GSK-D", name: "Gaskins House", latitude: 39.635477, longitude: -79.951699),
        mapCoordinate(code: "HOD-D", name: "Hodges Hall", latitude: 39.634179, longitude: -79.956053),
        mapCoordinate(code: "HSN-H", name: "Health Science North", latitude: 39.655325, longitude: -79.958258),
        mapCoordinate(code: "HSS-H", name: "Health Science South", latitude: 39.654202, longitude: -79.957886),
        mapCoordinate(code: "KNP-D", name: "Knapp Hall", latitude: 39.632628, longitude: -79.956980),
        mapCoordinate(code: "LIB-D", name: "Charles C. Wise Library",latitude: 39.633197, longitude: -79.954384),
        mapCoordinate(code: "LSB-D", name: "Life Science Building", latitude: 39.637073, longitude: -79.95559),
        mapCoordinate(code: "LWC-E", name: "Law Center", latitude: 39.648602, longitude: -79.958558),
        mapCoordinate(code: "MAR-D", name: "Martin Hall", latitude: 39.635564, longitude: -79.954967),
        mapCoordinate(code: "MBRC-H",name: "Mary Bab Randolph Cancer Center", latitude: 39.654234, longitude: -79.958051),
        mapCoordinate(code: "MEC-E", name: "Museum Education Center", latitude: 39.645670, longitude: -79.974281),
        mapCoordinate(code: "MHH-D", name: "Ming Hsieh Hall", latitude: 39.636563, longitude: -79.953605),
        mapCoordinate(code: "MRB-E", name: "Mineral Resouces Building", latitude: 39.646646, longitude: -79.973855),
        mapCoordinate(code: "MTL-D", name: "Mountain Lair", latitude: 39.634769, longitude: -79.953585),
        mapCoordinate(code: "NAT-E", name: "Natatorium-Shell", latitude: 39.650066, longitude: -79.984071),
        mapCoordinate(code: "NIO-E", name: "NIOSH Building", latitude: 39.654928, longitude: -79.953951),
        mapCoordinate(code: "NRCCE", name: "National Research Center", latitude: 39.645265, longitude: -79.972007),
        mapCoordinate(code: "NSH-E", name: "North Street House", latitude: 39.645320, longitude: -79.955655),
        mapCoordinate(code: "NUR-E", name: "Nursery School", latitude: 39.649382, longitude: -79.978264),
        mapCoordinate(code: "OGH-D", name: "Oglebay Hall", latitude: 39.63614332, longitude: -79.95367751),
        mapCoordinate(code: "OWP-D", name: "One Waterfront Place", latitude: 39.624787, longitude: -79.963449),
        mapCoordinate(code: "PAS-E", name: "CPASS Building", latitude: 39.649653, longitude: -79.969059),
        mapCoordinate(code: "PER-E", name: "Percival Hall", latitude: 39.645802, longitude: -79.967373),
        mapCoordinate(code: "PSK-E", name: "Milan Pusker Stadium", latitude: 39.649100, longitude: -79.954304),
        mapCoordinate(code: "PUR-D", name: "Puritan House", latitude: 39.634436, longitude: -79.955086),
        mapCoordinate(code: "SRC-E", name: "Student Recreation Center", latitude: 39.648185, longitude: -79.970821),
        mapCoordinate(code: "RRI-D", name: "Regional Research Institute", latitude: 39.657042, longitude: -79.955258),
        mapCoordinate(code: "SMT-D", name: "Summit", latitude: 39.638754, longitude: -79.956599),
        mapCoordinate(code: "SSC-D", name: "Student Services Center", latitude: 39.635580, longitude: -79.953599),
        mapCoordinate(code: "STA-D", name: "Stansbury Hall", latitude: 39.634974, longitude: -79.956884),
        mapCoordinate(code: "STH-E", name: "Student Health", latitude: 39.649033, longitude: -79.969748),
        mapCoordinate(code: "USC-E", name: "University Services Center", latitude: 39.654098, longitude: -79.968307),
        mapCoordinate(code: "VNB-D", name: "Vandalia Blue", latitude: 39.638916, longitude: -79.951788),
        mapCoordinate(code: "VNG-D", name: "Vandalia Gold", latitude: 39.638038, longitude: -79.951686),
        mapCoordinate(code: "WHI-D", name: "White Hall", latitude: 39.632882, longitude: -79.954649),
        //EVC-E Evansdale Crossing
        mapCoordinate(code: "EVC-E", name: "Evansdale Crossing", latitude: 39.647872, longitude: -79.973245)]
    
    var housingCoords: Array <mapCoordinate>  = [
        mapCoordinate(code: "STL-D", name: "Stalnaker Hall", latitude: 39.635324, longitude: -79.952693),
        mapCoordinate(code: "SMT-D", name: "Summit", latitude: 39.638754, longitude: -79.956599),
        mapCoordinate(code: "SPH-D", name: "International House", latitude: 39.631943, longitude: -79.952475),
        mapCoordinate(code: "MCA-E", name: "Med Center Apartment - Building K", latitude: 39.654057, longitude: -79.961932),
        mapCoordinate(code: "MCB-E", name: "Med Center Apartment - Building J", latitude: 39.653888, longitude: -79.962887),
        mapCoordinate(code: "LYT-E", name: "Lyon Tower", latitude: 39.647870, longitude: -79.966405),
        mapCoordinate(code: "LNC-D", name: "Lincon Hall", latitude: 39.649402, longitude: -79.965612),
        mapCoordinate(code: "HON-D", name: "Honors Hall", latitude: 39.638232, longitude: -79.956504),
        mapCoordinate(code: "DAD-D", name: "Dadisman Dorm", latitude: 39.635676, longitude: -79.952417),
        mapCoordinate(code: "BXT-E", name: "Braxton Towner", latitude: 39.648432, longitude: -79.966257),
        mapCoordinate(code: "BRN-D", name: "Boreman Hall North", latitude: 39.633550, longitude: -79.952287),
        mapCoordinate(code: "BRS-D", name: "Boreman Hall South", latitude: 39.633025, longitude: -79.952418),
        mapCoordinate(code: "BRF-D", name: "Boreman Residential Facility", latitude: 39.632973, longitude: -79.952183),
        mapCoordinate(code: "BRT-E", name: "Brooke Tower", latitude: 39.648985, longitude: -79.965791),
        mapCoordinate(code: "BTT-E", name: "Bennett Tower", latitude: 39.648217, longitude: -79.967014),
        mapCoordinate(code: "ARN-D", name: "Arnold Hall", latitude: 39.632486, longitude: -79.950469),
        mapCoordinate(code: "", name: "University Park", latitude: 39.650447, longitude: -79.962131)]
    
    var parkingCoords: Array <mapCoordinate> = [
        mapCoordinate(code: "ST2", name: "Mountainlair Parking Garage - ST2", latitude: 39.63390982, longitude: -79.95299488),
        mapCoordinate(code: "Life Sciences", name: "Public Parking - ST7", latitude: 39.63751225, longitude: -79.95525867),
        mapCoordinate(code: "Mountaineer Station", name: "Public Parking - ST3", latitude: 39.654853595827, longitude: -79.960985183716),
        //mapCoordinate(code: "COL-D", name: "Coliseum Parking", latitude: 39.648575, longitude: -79.980191),
        mapCoordinate(code: "Honors Hall Public Parking", name: "Public Parking - ST5", latitude: 39.63799558, longitude: -79.95540351),
        //mapCoordinate(code: "ST10-D",name: "Business & Economics Public Parking", latitude: 39.637181, longitude: -79.953980),
        mapCoordinate(code: "Erickson Alumni Center", name: "Public Parking - ST8", latitude: 39.65083684, longitude: -79.96430576),
        //mapCoordinate(code: "ST9-E", name: "CAC Public Parking", latitude: 39.648516, longitude: -79.973899),
        mapCoordinate(code: "Greenhouse Public Parking", name: "Public Parking - ST6", latitude: 39.64504699, longitude: -79.96659368),
        mapCoordinate(code: "Ag Sciences", name: "Public Parking - ST4", latitude: 39.64623248, longitude: -79.96853024),
        mapCoordinate(code: "Greenhouse", name: "Public Parking - ST1", latitude: 39.64411345, longitude: -79.97030586)
    ]

    var prtCoords: Array <mapCoordinate> = [
        mapCoordinate(code: "PRT",   name: "PRT Station - Walnut St.", latitude: 39.6300056, longitude: -79.9572596),
        mapCoordinate(code: "PRT",   name: "PRT Station -  Beechurst Ave.", latitude: 39.63486415, longitude: -79.95614916),
        mapCoordinate(code: "PRT",   name: "PRT Station - Engineering", latitude: 39.646907, longitude: -79.973238),
        mapCoordinate(code: "PRT",   name: "PRT Station - Evansdale Residential Complex", latitude: 39.64756555, longitude: -79.9693054),
        mapCoordinate(code: "PRT",   name: "PRT Station - Health Sciences Center", latitude: 39.65508791, longitude: -79.9601993)]
    
    // This isn't being used. SRC is in academicCoords
    var recreationCoords = [
        mapCoordinate(code: "SRC-E", name: "Student Recreation Center", latitude: 39.648185, longitude: -79.970821)]
    
    override func viewDidLoad() {
        self.title = "Map"
        
        /*
        Change back bar button to custom text, while preserving the back arrow.
        */
        let backItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        let camera = GMSCameraPosition.cameraWithLatitude(39.6359019354253,
            longitude: -79.9553555622697, zoom: 17)
        mapView = GMSMapView.mapWithFrame(CGRectMake(0, 64, self.view.bounds.width, self.view.bounds.height), camera: camera)
        mapView.delegate = self
        self.view = mapView
        
        var text = ""
        
        // Parse
        let path = NSBundle.mainBundle().pathForResource("PRT", ofType: "txt")

        do {
            text = try String(contentsOfFile: path!, encoding: NSUTF8StringEncoding)
        } catch {
            print("There was an error with MapViewController")
        }
        
        let shape = GMSMutablePath()
        let shapeArray = text.componentsSeparatedByString("\n")
        for set in shapeArray {
            let c = set.componentsSeparatedByString("\t")
            shape.addCoordinate(CLLocationCoordinate2DMake((c[0] as NSString).doubleValue, (c[1] as NSString).doubleValue))
        }
        let polyline = GMSPolyline(path: shape)
        polyline.strokeWidth = 5.0
        polyline.strokeColor = colors.prtShapeColor
        polyline.map = mapView
        
        //self.view.addSubview(mapView)
        
        academicMarkers = setupMarkers(academicCoords, color: color.academicColor)
        housingMarkers = setupMarkers(housingCoords, color: color.housingColor)
        parkingMarkers = setupMarkers(parkingCoords, color: color.parkingColor)
        prtMarkers = setupMarkers(prtCoords, color: color.prtColor)
        
        searchBar = UISearchBar()
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        
        tableView = UITableView(frame: CGRectMake(0, 64, self.view.bounds.width, 300), style: UITableViewStyle.Grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = colors.alpha
        
        gesture = UITapGestureRecognizer(target: self, action: "dismiss")
        self.view.addGestureRecognizer(gesture)
        
        super.viewDidLoad()
    }
    
    func search(item: String) -> Array<GMSMarker>{
        let all = [academicMarkers, housingMarkers, prtMarkers, parkingMarkers]
        var matches = Array<GMSMarker>()
        
        for type in all {
            for place in type {
                if place.title == item || place.snippet == item {
                    matches.append(place)
                }
            }
        }
        return matches
    }
    
    func setupMarkers(coords: Array<mapCoordinate>, color: UIColor) -> [GMSMarker]{
        var markers = [GMSMarker]()
        for coord in coords{
            let lat = coord.latitude
            let long = coord.longitude
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2DMake(CLLocationDegrees(lat), CLLocationDegrees(long))
            marker.title = coord.code
            marker.snippet = coord.name
            marker.map = mapView
            marker.icon = GMSMarker.markerImageWithColor(color)
            
            markers.append(marker)
        }
        
        return markers
    }
    
    override func leftDrawerButtonPress(sender: AnyObject?) {
        dismiss()
        super.leftDrawerButtonPress(sender)
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
            mapView.myLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    
    /*func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if let location = locations.first as? CLLocation {
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            locationManager.stopUpdatingLocation()
        }
    }*/
        
    func mapView(mapView: GMSMapView!, didTapInfoWindowOfMarker marker: GMSMarker!) {
        let infoPage = MapInfoVC(name: marker.snippet, code: marker.title, latitude: marker.position.latitude, longitude: marker.position.longitude)
        
        self.navigationController?.pushViewController(infoPage, animated: true)
    }
    
    // Return number of rows in section.
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filtered.count
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    // Return number of sections in table view.
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let c = filtered[indexPath.row]
        let camera = GMSCameraPosition(target: CLLocationCoordinate2D(latitude: CLLocationDegrees(c.position.latitude), longitude: CLLocationDegrees(c.position.longitude)), zoom: 18, bearing: 30, viewingAngle: 90)
        mapView.animateToCameraPosition(camera)
        mapView.selectedMarker = c
        dismiss()
    }
    
    // Return cell for row at index.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style: .Subtitle, reuseIdentifier: "cell")
        cell.backgroundColor = colors.alpha2
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.detailTextLabel?.textColor = UIColor.whiteColor()
        
        var c : GMSMarker
        c = filtered[indexPath.row]
        
        // Configure the cell
        cell.textLabel?.text = c.title
        cell.detailTextLabel?.text = c.snippet
        
        return cell
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        filtered = []
        self.view.addSubview(self.tableView)
        active = true
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        dismiss()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        dismiss()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filtered = []
        for i in academicMarkers {
            if (i.title.lowercaseString.rangeOfString(searchText.lowercaseString) != nil) || (i.snippet.lowercaseString.rangeOfString(searchText.lowercaseString) != nil) {
                filtered.append(i)
            }
        }
        for i in housingMarkers {
            if (i.title.lowercaseString.rangeOfString(searchText.lowercaseString) != nil) || (i.snippet.lowercaseString.rangeOfString(searchText.lowercaseString) != nil) {
                filtered.append(i)
            }
        }
        for i in parkingMarkers {
            if (i.title.lowercaseString.rangeOfString(searchText.lowercaseString) != nil) || (i.snippet.lowercaseString.rangeOfString(searchText.lowercaseString) != nil) {
                filtered.append(i)
            }
        }
        for i in prtMarkers {
            if (i.title.lowercaseString.rangeOfString(searchText.lowercaseString) != nil) || (i.snippet.lowercaseString.rangeOfString(searchText.lowercaseString) != nil) {
                filtered.append(i)
            }
        }
        if filtered.count != 0 {
            self.view.removeGestureRecognizer(gesture)
        }
        else {
            self.view.addGestureRecognizer(gesture)
        }
        tableView.reloadData()
    }

    func dismiss(){
        if active == true{
            filtered = []
            tableView.reloadData()
            tableView.removeFromSuperview()
            tableView.clearsContextBeforeDrawing = true
            searchBar.resignFirstResponder()
            searchBar.text = ""
            self.view.addGestureRecognizer(gesture)
            active = false
        }
    }

    // Pregenerated.
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.restorationIdentifier = "MapViewController"
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
