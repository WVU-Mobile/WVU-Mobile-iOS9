//
//  SummitCafeVC.swift
//  WVU Mobile
//
//  Created by Kaitlyn Landmesser & Richard Deal on 2/26/15.
//  Copyright (c) 2015 WVUMobile. All rights reserved.
//

import UIKit
import GoogleMaps

class SummitCafeVC: DiningHallVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            //JSON Objects
            self.diningInfo = DiningJSON(ID: "2")
            self.menus = self.diningInfo.menus
            self.key = self.diningInfo.key
            
            dispatch_async(dispatch_get_main_queue(), {
                // stop and remove the spinner on the background when done
                self.loading.stopAnimating()
                self.setupView()
            })
        })
        self.title = "Summit Cafe"
    }
    
    override func setupView() {
        super.setupView()
        
        /*
        Setup info labels
        */
        descriptionLabel.text = "Summit Cafe is located in Summit Hall and serves breakfast, lunch, and dinner."
        hoursDetailLabel.text = "Monday - Friday 7:00 AM to 7:00 PM \n Saturday, Sunday, & Holidays 11:00 AM to 6:30 PM"
        
        /*
        Setup map
        */
        let camera = GMSCameraPosition.cameraWithLatitude(39.638829, longitude: -79.956533, zoom:16)
        let map = GMSMapView.mapWithFrame(CGRectMake(0, 0, self.view.bounds.width, (infoView.bounds.height) * 0.5), camera: camera)
        map.delegate = self
        let marker = GMSMarker()
        
        marker.position = camera.target
        marker.title = "Summit Cafe"
        marker.map = map
        map.selectedMarker = marker
        map.settings.scrollGestures = false
        map.settings.zoomGestures = false
        
        infoView.addSubview(map)
    }
    
    func mapView(mapView: GMSMapView!, didTapInfoWindowOfMarker marker: GMSMarker!) {
        alert()
    }
    
    // Alert so people don't fat finger it
    func alert() {
        let alertController = UIAlertController(title: "", message: "Get directions to Summit Cafe?", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) {
            (action) in
        }
        alertController.addAction(cancelAction)
        let OKAction = UIAlertAction(title: "Directions", style: .Default) {
            (action) in
            if let url = NSURL(string: "http://maps.apple.com/?daddr=211+Grant+Ave+Morgantown+WV+26505+United+States,+CA&saddr=current+location") {
                UIApplication.sharedApplication().openURL(url)
            }
        }
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated: true) {
            
        }
    }
    
    // Pregenerated.
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.restorationIdentifier = "SummitCafeVC"
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
