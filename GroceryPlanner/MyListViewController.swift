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
        self.updateNewList()
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
        let newItem = listItems[indexPath.row]
        cell.textLabel?.text = listItems[indexPath.row]
        cell.detailTextLabel?.text =  newList[newItem]
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
    
    func  updateNewList() {
        listItems = []

        let newListUrl = self.rootUrl+"/NewList/"
        let newListRef = FIRDatabase.database().reference(fromURL: newListUrl)
        
        // retrives new list from firebase to update the table.
        newListRef.observeSingleEvent(of:.value, with: {snapshot in
            let enumerator = snapshot.children
            while let items = enumerator.nextObject() as? FIRDataSnapshot{
                let new = items.key
                let quantity = items.value as! String
                print("\(quantity)")
                self.newList[new] = quantity
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
