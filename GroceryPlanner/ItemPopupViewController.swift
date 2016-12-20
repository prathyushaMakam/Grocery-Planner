//
//  ItemPopupViewController.swift
//  GroceryPlanner
//
//  Created by Kanvi Khanna on 12/10/16.
//  Copyright © 2016 Prathyusha Makam Prasad. All rights reserved.
//

// ItemPopupViewController allows user to create the new Items.

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth


class ItemPopupViewController: UIViewController {

    var rootURL:String!
    var ref: FIRDatabaseReference!
    var category:String!
    var uID:String!
    @IBOutlet weak var itemLabel: UITextField!
    @IBOutlet weak var priceLabel: UITextField!
    @IBOutlet weak var quantityLabel: UITextField!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    
    var keyboardActive = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
// New item entered by the user is uploaded to the database along with its price and quantity.
    @IBAction func saveItem(_ sender: AnyObject) {
        
        rootURL = "https://groceryplanner-e2a60.firebaseio.com/users/"+uID+"/categories/"+category+"/"
        if (!itemLabel.text!.isEmpty && priceLabel.text != "0" && !priceLabel.text!.isEmpty && quantityLabel.text != "0" && !quantityLabel.text!.isEmpty) {
            let itemName = itemLabel.text
            let price:Float = Float(priceLabel.text!)!
            let quantity = Float(quantityLabel.text!)!
            let dict: [String: Float] = ["price": price, "quantity": quantity]
            ref = FIRDatabase.database().reference(fromURL: rootURL)
            ref.child(itemName!).setValue(dict)
            self.dismiss(animated: true, completion: nil)
        }
            
        else{
            errorLabel.text = "Please enter data to save."
        }
        
    }
    
    @IBAction func cancel(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField != self.itemLabel && keyboardActive == false {
            self.popupView.frame.origin.y -= 96
            self.keyboardActive = true
        }
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        if textField != self.itemLabel && keyboardActive == true {
            self.popupView.frame.origin.y += 96
            self.keyboardActive = false
        }
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.popupView.endEditing(true)
        return false
    }
}
