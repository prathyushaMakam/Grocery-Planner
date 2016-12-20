//
//  CategoryPopupViewController.swift
//  GroceryPlanner
//
//  Created by Kanvi Khanna on 12/10/16.
//  Copyright © 2016 Prathyusha Makam Prasad. All rights reserved.
//
// CategoryPopupViewController allows user to create the new category.

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth


class CategoryPopupViewController: UIViewController {
    
    var uID:String!
    var rootURL:String = ""
    var ref: FIRDatabaseReference!

    @IBOutlet weak var categoryLabel: UITextField!
    @IBOutlet weak var itemLabel: UITextField!
    @IBOutlet weak var priceLabel: UITextField!
    @IBOutlet weak var quantityLabel: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        rootURL = "https://groceryplanner-e2a60.firebaseio.com/users/"+uID+"/categories/"
    }
    
// New category entered by the user is uploaded to the database along with the item and its price and quantity.
    @IBAction func saveCategory(_ sender: AnyObject) {
        
        if (!categoryLabel.text!.isEmpty && !itemLabel.text!.isEmpty && priceLabel.text != "0" && !priceLabel.text!.isEmpty && quantityLabel.text != "0" && !quantityLabel.text!.isEmpty) {
            let categoryName = self.categoryLabel.text
            let itemName = itemLabel.text
            let price:Float = Float(priceLabel.text!)!
            let quantity = Float(quantityLabel.text!)!
            let dict: [String: Float] = ["price": price, "quantity": quantity]
            ref = FIRDatabase.database().reference(fromURL: rootURL)
            ref.child(categoryName!).child(itemName!).setValue(dict)
            self.dismiss(animated: true, completion: nil)
        }
            
        else{
            errorLabel.text = "Please enter data to save."
        }
        print("cat pop: uploaded")        
    }
    
    @IBAction func cancel(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
}
