//
//  FeedPageViewController.swift
//  RSSwift
//
//  Created by Arled Kola on 27/10/2014.
//  Copyright (c) 2014 Arled. All rights reserved.
//

import UIKit

class FeedPageViewController: MainViewController {

    var textView: UITextView!
    var titleView: UITextView!
    var dateView: UITextView!
    
    var selectedFeedTitle = String()
    var selectedFeedFeedContent = String()
    var selectedFeedURL = String()
    var date = String()
    
    override func viewDidLoad() {
        self.title = "News"
                
        titleView = UITextView(frame: CGRectMake(5, 0, self.view.bounds.width-10, self.view.bounds.height * 0.35))
        dateView = UITextView(frame: CGRectMake(5, self.view.bounds.height * 0.35, self.view.bounds.width-10, self.view.bounds.height * 0.1))
        textView = UITextView(frame: CGRectMake(5, self.view.bounds.height * 0.45, self.view.bounds.width-10, self.view.bounds.height * 0.55))
        
        titleView.editable = false
        titleView.text = "\(selectedFeedTitle)"
        titleView.font = UIFont(name: "HelveticaNeue", size: 22)
        
        dateView.editable = false
        dateView.text = "\(date)"
        dateView.font = UIFont(name: "HelveticaNeue", size: 13)
        
        textView.editable = false
        textView.text = "\(selectedFeedFeedContent)"
        textView.font = UIFont(name: "HelveticaNeue-LightItalic", size: 18)
        
        self.view.addSubview(titleView)
        self.view.addSubview(dateView)
        self.view.addSubview(textView)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Web", style: UIBarButtonItemStyle.Plain, target: self, action: "loadWeb")
        setUIColors()
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.evo_drawerController?.removeGestureRecognizers()
        super.viewWillAppear(true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.evo_drawerController?.setupGestureRecognizers()
        super.viewWillDisappear(true)
    }
    
    override func setUIColors() {
        textView.backgroundColor = self.colors.menuViewColor
        textView.textColor = self.colors.textColor
        
        dateView.backgroundColor = self.colors.menuViewColor
        dateView.textColor = self.colors.textColor
        
        titleView.backgroundColor = self.colors.menuViewColor
        titleView.textColor = self.colors.textColor
        
        super.setUIColors()
    }
    
    func loadWeb() {
        let feedPage = WebPageViewController()
        feedPage.url = selectedFeedURL
        self.navigationController?.pushViewController(feedPage, animated: true)
    }
    
}
