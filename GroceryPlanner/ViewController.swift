//
//  ViewController.swift
//  GroceryPlanner
//
//  Created by Prathyusha Makam Prasad on 11/20/16.
//  Copyright © 2016 Prathyusha Makam Prasad. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UITabBarController {
 

    var menuShowing = false
    
    var rootRef = FIRDatabase.database().reference()
    var childRef = FIRDatabase.database().reference(withPath: "groceryplanner-e2a60")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Firebase: \(childRef.key)")
    }
    
}

