//
//  Section.swift
//  NBPS Sports
//
//  Created by Evan Von Oehsen on 8/6/17.
//  Copyright © 2017 NBPS Athletics. All rights reserved.
//

import Foundation


struct Section {
    
    var sport: String!
    var subcategories: [String]!
    var expanded: Bool!
    
    init(sport: String, subcategories: [String], expanded:Bool) {
        
        self.sport = sport
        self.subcategories = subcategories
        self.expanded = expanded
    }
}
