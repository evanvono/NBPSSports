
//  Verson 0.016
//
//  ViewController.swift
//  NBPS Sports
//
//  Created by Evan Von Oehsen on 2/27/17.
//  Copyright © 2017 NBPS Athletics. All rights reserved.
//

import UIKit
import SwiftSpinner

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print("hello")
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func demoSpinner(){
        
        SwiftSpinner.show(delay: 0.5, title:"Test it looks good", animated: true)
        SwiftSpinner.hide()
        
    }


}

