//
//  ItemsTableViewController.swift
//  GroceryPlanner
//
//  Created by Kanvi Khanna on 12/10/16.
//  Copyright © 2016 Prathyusha Makam Prasad. All rights reserved.
//
// Displays the stored items in that particular category

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth



class ItemsTableViewController: UITableViewController {

    @IBOutlet weak var itemsTableView: UITableView!
    var rootRef: FIRDatabaseReference!
    var listItems:[String] = []
    var categoryValue:String!
    var uID:String!
    var rootUrl:String!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        rootUrl = ("https://groceryplanner-e2a60.firebaseio.com/users/"+uID+"/categories/"+categoryValue)
        fetchItems()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "itemPopupSegue"){
            let itemPopup = segue.destination as! ItemPopupViewController
            itemPopup.category = categoryValue
            itemPopup.uID = uID
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItems.count
    }

// Displays Items in that particular category
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        cell.textLabel?.text = listItems[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            listItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

//  Fetches the categories of the current user from the Database
    func fetchItems()
    {
        rootRef = FIRDatabase.database().reference(fromURL: rootUrl)
        rootRef.observe(.value, with: {
            snapshot in
            var newItems:[String] = []
            for items in snapshot.children {
                newItems.append((items as AnyObject).key)
            }
            self.listItems = newItems
            
// reloads the table view after retrieving the data from database
            DispatchQueue.main.async {
                print("cat: reload data")
                self.itemsTableView.reloadData()
            }
        })
    }

    @IBAction func BackToCategories(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
}
