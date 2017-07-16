//
//  AppState.swift
//  NBPS Sports
//
//  Created by Evan Von Oehsen on 5/15/17.
//  Copyright © 2017 NBPS Athletics. All rights reserved.
//

import Foundation

class AppState: NSObject {
    
    static let sharedInstance = AppState()
    
    var signedIn = false
    var displayName: String = "editor"
    var articleImage:UIImage = #imageLiteral(resourceName: "NBP-Icon-Border")
    var sportTitle = "Football"
    
    
    let myGroup = DispatchGroup()
    // var photoUrl: NSURL?
}
