//
//  ViewController.swift
//  GroceryPlanner
//
//  Created by Prathyusha Makam Prasad on 11/20/16.
//  Copyright © 2016 Prathyusha Makam Prasad. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuView: UIView!
    var menuShowing = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Shawdow effect for menu
        menuView.layer.shadowOpacity = 1
        menuView.layer.shadowRadius = 6
    }
    
    
    // Open menu on clicking menu button by sliding
    @IBAction func openMenu(_ sender: AnyObject) {
        
        // Creating the sliding effect for the menuBar
        if(menuShowing){
            leadingConstraint.constant = -215
        } else {
            leadingConstraint.constant = 0
            
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }
        menuShowing = !menuShowing
    }
    
}

