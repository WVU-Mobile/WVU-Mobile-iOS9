//
//  DiningViewController.swift
//  WVU Mobile
//
//  Created by Kaitlyn Landmesser & Richard Deal on 2/4/15.
//  Copyright (c) 2015 WVUMobile. All rights reserved.
//

import UIKit

class DiningViewController: CenterViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView = UITableView()
    
    var labels: [String] = ["Cafe Evansdale",
                            "Summit Cafe",
                            "Arnold's Diner",
                            "Boreman Bistro",
                            "Terrace Room",
                            "Hatfields"]
    
    var campus: [String] = ["Evansdale Campus",
                            "Downtown Campus",
                            "Downtown Campus",
                            "Downtown Campus",
                            "Downtown Campus",
                            "Downtown Campus"]
    
    /*
    var retail: [String] = ["Burger King",
                            "Chick-fil-a",
                            "Bits and Bytes",
                            "da Vinci's",
                            "Brew n' Gold Cafe",
                            "Cavanaugh’s",
                            "Eliza's",
                            "The Greenhouse: An EatWell Cafe",
                            "Saikou Sushi",
                            "Lyon's Den",
                            "Waterfront Cafe",
                            "Sbarro",
                            "Taziki's"]
    */

    override func viewDidLoad() {
        self.title = "Dining"

        /*
            Change back bar button to custom text, while preserving the back arrow.
        */
        let backItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        
        /*
            Mounty Bounty button
        */
        mountyBountyButton()
        
        
        /*
            Set up table view.
        */
        tableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.Plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        //tableView.separatorStyle = .None
        tableView.separatorColor = colors.textColor
        tableView.rowHeight = 100.0
        tableView.backgroundColor = colors.menuViewColor
        tableView.showsVerticalScrollIndicator = false
        
        self.view.addSubview(self.tableView)
        
        setUIColors()
        super.viewDidLoad()
    }
    
    func mountyBountyButton(){
        let infoImage = UIImage(named: "Info")
        
        let infoView = UIImageView(frame: CGRectMake(0, 0, 27, 27))
        infoView.image = infoImage
        infoView.image = infoView.image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        
        let infoButton = UIButton(frame: (infoView.bounds))
        infoButton.setBackgroundImage(infoView.image, forState: UIControlState.Normal)
        infoButton.addTarget(self, action: "loadMountyBounty", forControlEvents: UIControlEvents.TouchUpInside)
        
        let infoButtonItem = UIBarButtonItem(customView: infoButton)
        
        self.navigationItem.rightBarButtonItem = infoButtonItem
    }
    
    func loadMountyBounty(){
        let feedPage = WebPageViewController()
        feedPage.url = "https://mymountaineercard.wvu.edu/login/"
        self.navigationController?.pushViewController(feedPage, animated: true)
    }
    
    // Return number of rows in section.
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.labels.count
        }
        else {
            //return self.retail.count
            return 0
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.tableView.reloadData()
        self.setupGesture()
    }
    
    // Return number of sections in table view.
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
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
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 15)
        
        switch section {
        case 0:
            label.text = "DINING HALLS"
        case 1:
            label.text = "RETAIL LOCATIONS"
        default:
            label.text = "ERROR"
        }
        
        headerView.addSubview(label)
        
        return headerView
    }

    
    // Return cell for row at index.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 18)
        cell = UITableViewCell(style: UITableViewCellStyle.Subtitle,
            reuseIdentifier: "cell")

        //selected background view color
        let bgColorView = UIView()
        bgColorView.backgroundColor = colors.selectColor
        cell.selectedBackgroundView = bgColorView
        
        cell.backgroundColor = colors.mainViewColor
        cell.textLabel?.textColor = colors.textColor

        if indexPath.section == 0 {
            cell.textLabel?.text = self.labels[indexPath.row]
            
            cell.detailTextLabel?.textColor = colors.textColor
            cell.detailTextLabel?.text = self.campus[indexPath.row]
            cell.detailTextLabel?.font = UIFont(name: "HelveticaNeue-LightItalic", size: 16)
        }

        return cell
    }
    
    // Load Dining Hall view after cell selection.
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected \(indexPath.row).")
        if indexPath.section == 0{
            switch indexPath.row {
                case 0:
                    self.navigationController?.pushViewController(CafeEvansdaleVC(), animated: true)
                case 1:
                    self.navigationController?.pushViewController(SummitCafeVC(), animated: true)
                case 2:
                    self.navigationController?.pushViewController(ArnoldsDinerVC(), animated: true)
                case 3:
                    self.navigationController?.pushViewController(BoremanBistroVC(), animated: true)
                case 4:
                    self.navigationController?.pushViewController(TerraceRoomVC(), animated: true)
                case 5:
                    self.navigationController?.pushViewController(HatfieldsVC(), animated: true)
                default:
                    break
            }
        }
        else {
            
        }
        self.tableView.cellForRowAtIndexPath(indexPath)?.selected = false
    }
    
    override func setUIColors() {
        self.tableView.backgroundColor = colors.menuViewColor
        self.tableView.reloadData()
        tableView.separatorColor = colors.textColor
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
