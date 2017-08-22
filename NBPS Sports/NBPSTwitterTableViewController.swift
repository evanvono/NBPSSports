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
        
        if (Twitter.sharedInstance().sessionStore.hasLoggedInUsers()) {
            
            
            // App must have at least one logged-in user to compose a Tweet
            
            
            let composer = TWTRComposer()
            
            composer.setText("@NBPSAthletics #NBPSportsApp ")
            
            // Called from a UIViewController
            
            composer.show(from: self, completion: { result in
                print(result)
                if (result == TWTRComposerResult.cancelled) {
                    print("Tweet composition cancelled")
                }
                else {
                    print("Sending tweet!")
                }
                
            })
            
        } else {
            // Log in, and then check again
            Twitter.sharedInstance().logIn { session, error in
                if session != nil { // Log in succeeded
                    
                    let composer = TWTRComposerViewController.emptyComposer()
                    self.present(composer, animated: true, completion: nil)
                    
                } else {
                    
                    let alert = UIAlertController(title: "No Twitter Accounts Available", message: "You must log in using the Twitter app to use this functionality.", preferredStyle: .alert)
                    self.present(alert, animated: false, completion: nil)
                    
                }
            }
        }
    }
    
}
