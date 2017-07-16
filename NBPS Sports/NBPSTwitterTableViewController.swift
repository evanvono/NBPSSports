//
//  NBPSTwitterTableViewController.swift
//  NBPS Sports
//
//  Created by Evan Von Oehsen on 7/2/17.
//  Copyright © 2017 NBPS Athletics. All rights reserved.
//

import UIKit
import TwitterKit

class NBPSTwitterTableViewController:  TWTRTimelineViewController {
    @IBOutlet weak var menuButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            //print("not nil")
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            
            
        }
        
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        
        
        
        self.dataSource = TWTRUserTimelineDataSource(screenName: "NBPSAthletics", apiClient: TWTRAPIClient())
    }
}
