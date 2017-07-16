//
//  StackViewCell.swift
//  NBPS Sports
//
//  Created by Evan Von Oehsen on 7/2/17.
//  Copyright © 2017 NBPS Athletics. All rights reserved.
//

import UIKit


class StackViewCell: UITableViewCell {
    @IBOutlet weak var openView: UIView!
    @IBOutlet weak var stuffView: UIView! {
        
        didSet {
            
            stuffView.isHidden = true
            stuffView.alpha = 0.0
        }
    }
    
    var cellExists:Bool = false
    
    
    @IBOutlet weak var open: UIButton!
    @IBOutlet weak var boys: UIButton!
    @IBOutlet weak var girls: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
        
        
        // Initialization code
    }

    
    
}
