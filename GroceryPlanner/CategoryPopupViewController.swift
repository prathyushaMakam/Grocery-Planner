//
//  CategoryPopupViewController.swift
//  GroceryPlanner
//
//  Created by Kanvi Khanna on 12/10/16.
//  Copyright © 2016 Prathyusha Makam Prasad. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class CategoryPopupViewController: UIViewController {

    let rootURL = "https://groceryplanner-e2a60.firebaseio.com/users/1/categories/"
    var ref: FIRDatabaseReference!

    @IBOutlet weak var categoryLabel: UITextField!
    @IBOutlet weak var itemLabel: UITextField!
    @IBOutlet weak var priceLabel: UITextField!
    @IBOutlet weak var quantityLabel: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBAction func saveCategory(_ sender: AnyObject) {
        
        
        if categoryLabel.text != nil {
            if itemLabel.text != nil {
                if priceLabel.text != "0" {
                    if quantityLabel.text != "0"{
                        let categoryName = categoryLabel.text
                        let itemName = itemLabel.text
                        let price:Float = Float(priceLabel.text!)!
                        let quantity = Float(quantityLabel.text!)!
                        let dict: [String: Float] = ["price": price, "quantity": quantity]
                        ref = FIRDatabase.database().reference(fromURL: rootURL)
                        ref.child(categoryName!).child(itemName!).setValue(dict)
                        self.dismiss(animated: true, completion: nil)
                        
                    }
                }
                        
            }
        }
        errorLabel.text = "Please enter data to save."
        print("cat pop: uploaded")
        
    }
    
    @IBAction func cancel(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        priceLabel.text = "0"
        quantityLabel.text = "0"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
