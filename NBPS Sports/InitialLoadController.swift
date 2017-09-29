//
//  InitialLoadingViewController.swift
//  NBPS Sports
//
//  Created by Evan Von Oehsen on 9/17/17.
//  Copyright © 2017 NBPS Athletics. All rights reserved.
//

import UIKit
import SwiftSpinner
import Firebase

class InitialLoadController: UIViewController {
    
    
    var ref = FIRDatabaseReference()
    var _refHandle =  FIRDatabaseHandle()
    
    
    var checkTimer: Timer!
    
    var hasRepeated = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        checkTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.checkConnection), userInfo: nil, repeats: true)
        
        SwiftSpinner.useContainerView(self.view)
        SwiftSpinner.show("Connecting to network...")
        
    }
    
    func viewDidDisappear(){
        
        
            
            FIRDatabase.database().reference(withPath: ".info/connected").removeAllObservers()
            
            
        
        
        checkTimer.invalidate()
        
        
    }
    func checkConnection(){
        
        let connectedRef = FIRDatabase.database().reference(withPath: ".info/connected")
        _refHandle = connectedRef.observe(.value, with: { snapshot in
            
            
            if let connected = snapshot.value as? Bool, connected {
                
                //SwiftSpinner.appearance().tintColor = UIColor.green
                if connected == false {
                    
                    if self.hasRepeated {
                        
                        SwiftSpinner.show("Still trying...").addTapHandler({
                            
                            print("tapped")
                            
                        }, subtitle: "Connection is taking longer than expected.")
                        
                        
                        
                    } else {
                        SwiftSpinner.show("Trying to connect...")
                        self.hasRepeated = true
                        
                    }
                    
                    
                    
                } else {
                    
                    self.performSegue(withIdentifier: "ConnectionSuccessful", sender: nil)
                    
                }
                
               /*
                SwiftSpinner.show("Failed to connect, tap to dismiss.", animated: false).addTapHandler({
                    
                    
                    SwiftSpinner.hide()
                    
                  //  self.hidden = true
                    
                    
                }, subtitle: "Please check your connection; your content will load automatically.")
                */
            }
        })
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
