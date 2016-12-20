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
    var itemQuantity: [String] = []
    var newList: [String:String] = [:]
    var rootUrl:String!
    var uID:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rootUrl = "https://groceryplanner-e2a60.firebaseio.com/users/"+uID+"/"
    }
    
// Retrieves the data whenever view will appears on the app
    override func viewWillAppear(_ animated: Bool) {
        getCategories()
        self.uploadNewList()
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
        let itemName = listItems[indexPath.row]
        cell.textLabel?.text = itemName
        cell.detailTextLabel?.text =  itemQuantity[indexPath.row]
        return cell
    }
    
// Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deleteItem = listItems[indexPath.row]
        FIRDatabase.database().reference().child("users").child(FIRAuth.auth()!.currentUser!.uid).child("NewList").child(deleteItem).removeValue()
            listItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "addNewItem"){
            let newItemPopup = segue.destination as! MyListPopupViewController
            newItemPopup.uID = uID
        }
    }
    
    func getCategories(){
        listItems = []
        
        // get category for each user
        rootRef = FIRDatabase.database().reference(fromURL: rootUrl)
        rootRef.child("categories").observeSingleEvent(of: .value, with: { snapshot in
            if let result = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for child in result {
                    
                    // create the child url to get items
                    let childUrl = self.rootUrl+"categories/"+child.key+"/"
                    // get item under each category
                    self.getItems(childUrl: childUrl)
                }
            } else {
                print("no results")
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
// Retrieves all the items of every category from the database
    func getItems(childUrl: String){
        self.childRef = FIRDatabase.database().reference(fromURL: childUrl)
        self.childRef.observeSingleEvent(of:.value, with: {
            snapshot1 in
            if let result = snapshot1.children.allObjects as? [FIRDataSnapshot]{
            for item in result{
                let newItem = ((item as AnyObject).key) as String
                //self.listItems.append((item as AnyObject).key)
                // url to get the quantities of items
                let quantityUrl = childUrl+newItem+"/"
                self.getQuantity(newItem:newItem, quantityUrl:quantityUrl)
            }
            }
            else {
                print("no results\n")
            }
        })
        { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getQuantity(newItem:String, quantityUrl:String){
        let quantityRef = FIRDatabase.database().reference(fromURL: quantityUrl)
        quantityRef.observeSingleEvent(of:.value, with: {snapshot in
            if let dict = snapshot.value as? NSDictionary{
                let itemQuantity = String(describing: dict["quantity"]!)
                self.newList[newItem] = itemQuantity
            }else {
                print("no results\n")
            }
        })
        { (error) in
            print(error.localizedDescription)
        }
    }
    
    func  uploadNewList() {
        // uploads the new list to database
        let newListUrl = self.rootUrl+"/NewList/"
        let newListRef = FIRDatabase.database().reference(fromURL: newListUrl)
        newListRef.updateChildValues(self.newList)
        
        // retrives new list from firebase to update the table.
        newListRef.observeSingleEvent(of:.value, with: {snapshot in
            let enumerator = snapshot.children
            while let items = enumerator.nextObject() as? FIRDataSnapshot{
                let new = items.key
                let quantity = String(describing: items.value!)
                self.listItems.append(new)
                self.itemQuantity.append(quantity)
                print("\(new) + \(quantity)")
            }
            
            DispatchQueue.main.async {
                self.myListTableView.reloadData()
            }
        })
        { (error) in
            print(error.localizedDescription)
        }
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
