//
//  CategoryViewController.swift
//  GroceryPlanner
//
//  Created by Prathyusha Makam Prasad on 12/8/16.
//  Copyright © 2016 Prathyusha Makam Prasad. All rights reserved.
//
// CategoryViewController first tab in TabView Controller. Displays all categories created by the user.

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth


class CategoryViewController: UITableViewController {
    
    @IBOutlet weak var categoryView: UITableView!
    var rootRef: FIRDatabaseReference!
    var categoryNames: [String] = []
    var valToPass:String!
    var uID:String!
    var rootUrl:String!
    
    override func viewDidLoad() {        
        super.viewDidLoad()
        rootUrl = "https://groceryplanner-e2a60.firebaseio.com/users/"+uID+"/categories/"
        fetchCategories()
        categoryView.delegate = self
        categoryView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryNames.count
    }

// Displays the category names in a table
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = categoryNames[indexPath.row]
        return cell
    }
    
// On clicking the cell in table it reoutes to a table view that displays Items in that particular category
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCategory = categoryNames[indexPath.row]
        valToPass = selectedCategory
        performSegue(withIdentifier: "toItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toItems"){
            let nav = segue.destination as! UINavigationController
            let itemView = nav.topViewController as! ItemsTableViewController
            itemView.categoryValue = valToPass
            itemView.uID = uID
        }
        
        if(segue.identifier == "categoryPopupSegue"){
            let catPopupView = segue.destination as! CategoryPopupViewController
            catPopupView.uID = uID
        }
    }
    
//  Fetches the categories of the current user from the Database
    func fetchCategories()
    {
        print("cat: inside calling fetch \(categoryNames.count)")

        rootRef = FIRDatabase.database().reference(fromURL: rootUrl)
        rootRef.observe(.value, with: {
            snapshot in
            var newCategories: [String] = []
            for category in snapshot.children {
                print("cat: inside snapshot.children \(category)")
                newCategories.append((category as AnyObject).key)
                print("cat: \(self.categoryNames) n \(self.categoryNames.count)")
            }
            self.categoryNames = newCategories
            
            // reloads the table view after retrieving the data from database
            DispatchQueue.main.async {
                print("cat: reload data")
                self.categoryView.reloadData()
            }
        })
    }

// Logouts from the current sigined in user and routes back to the login page
    @IBAction func logoutButton(_ sender: AnyObject) {
        if FIRAuth.auth()?.currentUser != nil {
            do {
                try FIRAuth.auth()?.signOut()
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Login")
                present(vc, animated: true, completion: nil)
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
}
