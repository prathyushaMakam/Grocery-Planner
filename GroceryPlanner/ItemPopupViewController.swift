//
//  ItemPopupViewController.swift
//  GroceryPlanner
//
//  Created by Kanvi Khanna on 12/10/16.
//  Copyright © 2016 Prathyusha Makam Prasad. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ItemPopupViewController: UIViewController {

    var rootURL:String!
    var ref: FIRDatabaseReference!
    var category:String!
    @IBOutlet weak var itemLabel: UITextField!
    @IBOutlet weak var priceLabel: UITextField!
    @IBOutlet weak var quantityLabel: UITextField!
    @IBOutlet weak var popupView: UIView!
    
    var keyboardActive = false
    
    @IBAction func saveItem(_ sender: AnyObject) {
        rootURL = "https://groceryplanner-e2a60.firebaseio.com/users/1/categories/"+category+"/"
        let itemName = itemLabel.text!
        
        if (itemName != ""){
            
        var price = priceLabel.text!
        var quantity = quantityLabel.text!
       
        if (price == "")
        {
            price = "0"
            if (quantity == ""){
                quantity = "0"
            }
        }
        
        let dict: [String: String] = ["price": price, "quantity": quantity]
        ref = FIRDatabase.database().reference(fromURL: rootURL)
        ref.child(itemName).setValue(dict)
            print("item pop: uploaded")
            self.dismiss(animated: true, completion: nil)
        }
        else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancel(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField != self.itemLabel && keyboardActive == false {
            self.popupView.frame.origin.y -= 165
            self.keyboardActive = true
        }
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        if textField != self.itemLabel && keyboardActive == true {
            self.popupView.frame.origin.y += 165
            self.keyboardActive = false
        }
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.popupView.endEditing(true)
        return false
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
