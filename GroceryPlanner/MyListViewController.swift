//
//  MyListViewController.swift
//  GroceryPlanner
//
//  Created by Prathyusha Makam Prasad on 12/10/16.
//  Copyright © 2016 Prathyusha Makam Prasad. All rights reserved.
//

// Displays the next week's list items to be purchased

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth


class MyListViewController: UITableViewController{

    @IBOutlet weak var myListTableView: UITableView!
    var rootRef: FIRDatabaseReference!
    var childRef: FIRDatabaseReference!
    var listItems: [String] = []
    var rootUrl:String!
    var childUrl:String = ""
    var uID:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rootUrl = "https://groceryplanner-e2a60.firebaseio.com/users/"+uID+"/"
    }
    
// Retrieves the data whenever view will appears on the app
    override func viewWillAppear(_ animated: Bool) {
        getCategories()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItems.count
    }
    
// Displays the next week list on the table view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myListCell", for: indexPath)
        cell.textLabel?.text = listItems[indexPath.row]
        return cell
    }
    
// Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            listItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    func getCategories(){
        listItems = []
        
        // get category for each user
        rootRef = FIRDatabase.database().reference(fromURL: rootUrl)
        rootRef.child("categories").observeSingleEvent(of: .value, with: { snapshot in
            if let result = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for child in result {
                    
                    // create the child url
                    self.childUrl = self.rootUrl+"categories/"+child.key+"/"
                    
                    // get item under each category
                    self.getItems()
                }
            } else {
                print("no results")
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
// Retrieves all the items of every category from the database
    func getItems(){
        self.childRef = FIRDatabase.database().reference(fromURL: self.childUrl)
        self.childRef.observeSingleEvent(of:.value, with: {
            snapshot1 in
            for item in snapshot1.children {
                self.listItems.append((item as AnyObject).key)
            }
            DispatchQueue.main.async {
                self.myListTableView.reloadData()
            }
        })
    }
    
// Logout from the current sigined in user account and routes back to the login page
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
