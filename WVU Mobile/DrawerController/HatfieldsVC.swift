//
//  HatfieldsVC.swift
//  WVU Mobile
//
//  Created by Kaitlyn Landmesser & Richard Deal on 2/26/15.
//  Copyright (c) 2015 WVUMobile. All rights reserved.
//

import UIKit
import GoogleMaps

class HatfieldsVC: DiningHallVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            //JSON Objects
            self.diningInfo = DiningJSON(ID: "6")
            self.menus = self.diningInfo.menus
            self.key = self.diningInfo.key

            dispatch_async(dispatch_get_main_queue(), {
                // stop and remove the spinner on the background when done
                self.loading.stopAnimating()
                self.setupView()
            })
        })
        
        self.title = "Hatfields"
    }
    
    override func setupView() {
        super.setupView()
        
        /*
            Setup info labels
        */
        descriptionLabel.text = "Hatfields is located in the Mountain Lair and serves breakfast and lunch."
        hoursDetailLabel.text = "Monday - Friday 7:15 AM to 10:00 PM \n and 11:00 AM to 2:00 PM \n Saturday, Sunday, & Holidays CLOSED"
        
        /*
            Setup map
        */
        let camera = GMSCameraPosition.cameraWithLatitude(39.634752, longitude: -79.953916, zoom:16)
        let map = GMSMapView.mapWithFrame(CGRectMake(0, 0, self.view.bounds.width, (infoView.bounds.height) * 0.5), camera: camera)
        map.delegate = self
        let marker = GMSMarker()

        marker.position = camera.target
        marker.title = "Hatfields"
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
        let alertController = UIAlertController(title: "", message: "Get directions to Hatfields?", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) {
            (action) in
        }
        alertController.addAction(cancelAction)
        let OKAction = UIAlertAction(title: "Directions", style: .Default) {
            (action) in
            if let url = NSURL(string: "http://maps.apple.com/?sspn=1550+University+Ave+Morgantown+WV+26505+United+States,saddr=current+location") {
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
        self.restorationIdentifier = "HatfieldsVC"
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
