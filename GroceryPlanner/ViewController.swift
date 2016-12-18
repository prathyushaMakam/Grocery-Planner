//
//  ViewController.swift
//  GroceryPlanner
//
//  Created by Prathyusha Makam Prasad on 11/20/16.
//  Copyright © 2016 Prathyusha Makam Prasad. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ViewController: UIViewController {
     
    @IBOutlet weak var passwordTextbox: UITextField!
    @IBOutlet weak var emailTextbox: UITextField!
    
    var userID:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func loginAction(_ sender: AnyObject) {
        
        let email = emailTextbox.text
        let password = passwordTextbox.text
        FIRAuth.auth()?.signIn(withEmail: email!, password: password!, completion: { (user, error) in
            guard let user = user else{
                if let error = error {
                    if let errCode = FIRAuthErrorCode(rawValue: error._code) {
                        switch errCode {
                        case .errorCodeUserNotFound:
                            self.showAlert("User account not found. Try registering")
                        case .errorCodeWrongPassword:
                            self.showAlert("Incorrect username/password combination")
                        default:
                            self.showAlert("Error: \(error.localizedDescription)")
                        }
                    }
                    return
                }
                assertionFailure("user and error are nil")
                return
            }
            self.userID = user.uid
            self.signIn()
        })
    }
    
    
    func showAlert(_ message: String) {
        let alertController = UIAlertController(title: "To Do App", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func signIn() {
        performSegue(withIdentifier: "loginToTabView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "loginToTabView"){
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

