//
//  CafeEvansdaleVC.swift
//  WVU Mobile
//
//  Created by Kaitlyn Landmesser & Richard Deal on 2/26/15.
//  Copyright (c) 2015 WVUMobile. All rights reserved.
//

import UIKit
import GoogleMaps

class CafeEvansdaleVC: DiningHallVC {
    
    override func viewDidLoad() {
        self.title = "Cafe Evansdale"

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            //JSON Objects
            self.diningInfo = DiningJSON(ID: "1")
            self.menus = self.diningInfo.menus
            self.key = self.diningInfo.key
            
            dispatch_async(dispatch_get_main_queue(), {
                // stop and remove the spinner on the background when done
                self.loading.stopAnimating()
                self.setupView()
                })
            })
        
        super.viewDidLoad()
        }
    
    override func setupView() {
        super.setupView()
        
        /*
            Setup info labels
        */
        descriptionLabel.text = "Cafe Evansdale is located in Brooke Tower and serves breakfast, lunch, and dinner."
        
        hoursDetailLabel.text = "Monday - Thursday 7:00 AM to 8:00 PM \n Friday 7:00 AM to 6:30 PM \n Saturday & Holidays 9:00 AM to 6:30 PM \n Sunday 9:00 AM to 7:30 PM"
        
        /* 
            Setup map
        */
        let camera = GMSCameraPosition.cameraWithLatitude(39.648935, longitude: -79.966303, zoom:16)
        let map = GMSMapView.mapWithFrame(CGRectMake(0, 0, self.view.bounds.width, (infoView.bounds.height) * 0.5), camera: camera)
        map.delegate = self
        let marker = GMSMarker()
        
        marker.position = camera.target
        marker.title = "Cafe Evansdale"
        marker.map = map
        marker.tappable = true
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
        let alertController = UIAlertController(title: "", message: "Get directions to Cafe Evansdale?", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) {
            (action) in
        }
        alertController.addAction(cancelAction)
        let OKAction = UIAlertAction(title: "Directions", style: .Default) {
            (action) in
            if let url = NSURL(string: "http://maps.apple.com/?daddr=952+Dudley+St+Morgantown+WV+26505+United+States,+CA&saddr=current+location") {
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
        self.restorationIdentifier = "CafeEvansdaleVC"
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
