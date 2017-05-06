
//  Verson 0.030
//
//  ViewController.swift
//  NBPS Sports
//
//  Created by Evan Von Oehsen on 2/27/17.
//  Copyright © 2017 NBPS Athletics. All rights reserved.
//
/*
 *
 INSTALL pod 'AlamofireRSSParser' 
 PARSE NBPS SPORTS NEWS FEED TO TABLEVIEW
 CELLS TAPPED OPEN TO ARTICLES ON SEPARATE WEBVIEW
 https://github.com/AdeptusAstartes/AlamofireRSSParser
 *
 */
import UIKit
//import FirebaseAuth
//import FirebaseDatabase
import Social
import Alamofire
import AlamofireRSSParser


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableContainer: UIView!
    
    @IBOutlet weak var mainTableView: UITableView!
    
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            print("not nil")
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        tableContainer.layer.cornerRadius = 10
        
        mainTableView.layer.cornerRadius = 10
        
        getRSS()
    
 
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getRSS(){
        
        _ = "http://www.nbpsathletics.org/organizations/3072/announcements"
        

        
    }
    
    

    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        
        cell.textLabel?.text = "test"
        
        
        return cell
    }
    
    open  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return false
    }

}

