//
//  CategoryViewController.swift
//  GroceryPlanner
//
//  Created by Prathyusha Makam Prasad on 12/8/16.
//  Copyright © 2016 Prathyusha Makam Prasad. All rights reserved.
//

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

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryNames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = categoryNames[indexPath.row]
        
        print("cat: inside cellRow")
        return cell
    }
    
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
            DispatchQueue.main.async {
                print("cat: reload data")
                self.categoryView.reloadData()
            }
        })
    }

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
