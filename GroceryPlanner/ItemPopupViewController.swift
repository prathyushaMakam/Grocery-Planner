//
//  ItemPopupViewController.swift
//  GroceryPlanner
//
//  Created by Kanvi Khanna on 12/10/16.
//  Copyright © 2016 Prathyusha Makam Prasad. All rights reserved.
//

import UIKit

class ItemPopupViewController: UIViewController {

    @IBAction func saveItem(_ sender: AnyObject) {
    }
    @IBAction func cancel(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
