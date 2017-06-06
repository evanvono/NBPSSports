//
//  Constants.swift
//  NBPS Sports
//
//  Created by Evan Von Oehsen on 5/15/17.
//  Copyright © 2017 NBPS Athletics. All rights reserved.
//

import Foundation

struct Constants {
    
    struct UserDetails {
        
        static var email = "email"
    }
    
    struct NotificationKeys {
        static let SignedIn = "onSignInCompleted"
    }
    struct gameDetails {
        
        static var gameTapped = "game"
    }
    
    struct Segues {
        static let SignInToEditor = "SignInToEditor"
        
        static let showArticle = "showArticle"
        
        
        static let FootballDetail = "FootballDetail"
        static let FootballAuthDetail = "FootballAuthDetail"
        // static let FpToSignIn = "FPToSignIn"
    }
}
