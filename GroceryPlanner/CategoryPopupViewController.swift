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

    let rootURL = "https://groceryplanner-e2a60.firebaseio.com/users/1/categories"
    var ref: FIRDatabaseReference!

    @IBOutlet weak var categoryLabel: UITextField!
    @IBOutlet weak var itemLabel: UITextField!
    @IBOutlet weak var priceLabel: UITextField!
    @IBOutlet weak var quantityLabel: UITextField!
    
    @IBAction func saveCategory(_ sender: AnyObject) {
        let cate:String = categoryLabel.text!
        let itemName:String = itemLabel.text!
        
        var price:Float = Float(priceLabel.text!)!
        var quantity:Float = Float(quantityLabel.text!)!
        if (price == nil)
        {
            price = 0
            if (quantity == nil){
                quantity = 0
            }
        }
        
        let dict: [String: Float] = ["price": price, "quantity": quantity]
        
        ref = FIRDatabase.database().reference(fromURL: rootURL)
        ref.child(cate).child(itemName).setValue(dict)
        print("cat pop: uploaded")
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
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
