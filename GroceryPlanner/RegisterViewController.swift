//
//  RegisterViewController.swift
//  GroceryPlanner
//
//  Created by Prathyusha Makam Prasad on 12/15/16.
//  Copyright © 2016 Prathyusha Makam Prasad. All rights reserved.
//

// Allows the user to create new account

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class RegisterViewController: UIViewController {
    @IBOutlet weak var registerView: UIView!

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    var userID:String!
    var rootURL = "https://groceryplanner-e2a60.firebaseio.com/users/"
    var ref:FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
// Creates the new user using the entered gmail address and password
    @IBAction func createAccount(_ sender: UIButton) {
        
        let email = emailTextField.text
        let password = passwordTextField.text
        
        FIRAuth.auth()?.createUser(withEmail: email!, password: password!, completion: { (user, error) in
            if let error = error {
                if let errCode = FIRAuthErrorCode(rawValue: error._code) {
                    switch errCode {
                    case .errorCodeInvalidEmail:
                        self.showAlert("Enter a valid email.")
                    case .errorCodeEmailAlreadyInUse:
                        self.showAlert("Email already in use.")
                    default:
                        self.showAlert("Error: \(error.localizedDescription)")
                    }
                }
                return
            }
            self.userID = user?.uid
            self.setCredentials()
            self.signIn()
        })
    }
    
// Implements the alert pop-up
    func showAlert(_ message: String) {
        let alertController = UIAlertController(title: "Grocery Planner", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
// Stores the new user's gmail address and password in database
    func setCredentials() {
        
        let dict: [String: String] = ["username": emailTextField.text!, "password": passwordTextField.text!]
        ref = FIRDatabase.database().reference(fromURL: rootURL)
        ref.child(userID).setValue(dict)
    }

// Routes to the first scene (Tab View Controller) after logging in succesfully and sends the current UserID
    
    func signIn() {
        print("UserID sigin: \(self.userID)")
        performSegue(withIdentifier: "toHome", sender: self)
    }
    
// Routes back to login page
    @IBAction func goToLogin(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: {})
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toHome"){
            let tab = segue.destination as! UITabBarController
            let nav = tab.viewControllers?.first as! UINavigationController
            let nav1 = tab.viewControllers?[1] as! UINavigationController
            let nav2 = tab.viewControllers?[2] as! UINavigationController
            let sendID = nav.topViewController as! CategoryViewController
            let sendUID = nav1.topViewController as! ExpensesViewController
            let senduID = nav2.topViewController as! MyListViewController
            
            print("UID reg1: \(self.userID)")
            
            sendID.uID = userID
            sendUID.uID = userID
            senduID.uID = userID
        }
    }
}
