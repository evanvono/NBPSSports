//
//  NBPSTwitterTableViewController.swift
//  NBPS Sports
//
//  Created by Evan Von Oehsen on 7/2/17.
//  Copyright © 2017 NBPS Athletics. All rights reserved.
//

import UIKit
import TwitterKit
import Social


class NBPSTwitterTableViewController:  TWTRTimelineViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        
        
        
        self.dataSource = TWTRUserTimelineDataSource(screenName: "NBPSAthletics", apiClient: TWTRAPIClient())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
    }
    
    
    @IBAction func didTapTwitter(_ sender: Any) {
        
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
            
            let tweetComposer = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            tweetComposer?.setInitialText("@NBPSAthletics #NBPSportsApp")
            
            //tweetComposer.addImage(UIImage(named:""))
            
            self.present(tweetComposer!, animated: true, completion: nil)
        } else {
            
            let alertMessage = UIAlertController(title: "Twitter not available", message: "You may associate this phone with a Twitter account in settings>Twitter or through the Twitter app.", preferredStyle: .alert)
            alertMessage.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertMessage, animated: true, completion: nil)
            
        }
        
    }
    
}
