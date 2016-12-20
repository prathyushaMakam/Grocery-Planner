//
//  MyListPopupViewController.swift
//  GroceryPlanner
//
//  Created by Prathyusha Makam Prasad on 12/12/16.
//  Copyright © 2016 Prathyusha Makam Prasad. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class MyListPopupViewController: UIViewController {
    
    var valToPass:String!
    var uID:String!
    @IBOutlet weak var itemName: UITextField!
    @IBOutlet weak var itemQuantity: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func cancelButton(_ sender: AnyObject){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveItem(_ sender: AnyObject) {
        let rootURL = "https://groceryplanner-e2a60.firebaseio.com/users/"+uID+"/NewList/"
        if (!itemName.text!.isEmpty && itemQuantity.text != "0" && !itemQuantity.text!.isEmpty) {
            let itemName = self.itemName.text
            let quantity = itemQuantity.text!
            var dict: [String: String] = [:]
            dict[itemName!] = quantity
            let ref = FIRDatabase.database().reference(fromURL: rootURL)
            ref.updateChildValues(dict)
            self.dismiss(animated: true, completion: nil)
        }
            
        else{
            errorLabel.text = "Please enter data to save."
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}



