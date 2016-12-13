//
//  MyListPopupViewController.swift
//  GroceryPlanner
//
//  Created by Prathyusha Makam Prasad on 12/12/16.
//  Copyright © 2016 Prathyusha Makam Prasad. All rights reserved.
//

import UIKit


class MyListPopupViewController: UIViewController {
    
    var valToPass:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func cancelButton(_ sender: AnyObject){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveItem(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}



