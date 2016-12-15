//
//  ItemsTableViewController.swift
//  GroceryPlanner
//
//  Created by Kanvi Khanna on 12/10/16.
//  Copyright © 2016 Prathyusha Makam Prasad. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


class ItemsTableViewController: UITableViewController {

    @IBOutlet weak var itemsTableView: UITableView!
    var rootRef: FIRDatabaseReference!
    var listItems:[String] = []
    var categoryValue:String!
    var rootUrl:String!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("item recieved: \(categoryValue)")
        rootUrl = ("https://groceryplanner-e2a60.firebaseio.com/users/1/categories/"+categoryValue)
        fetchItems()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "itemPopupSegue"){
            let itemPopup = segue.destination as! ItemPopupViewController
            itemPopup.category = categoryValue
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        cell.textLabel?.text = listItems[indexPath.row]
        
        return cell
    }
    
    func fetchItems()
    {
       // print("cat: inside calling fetch \(categoryNames.count)")
        
        rootRef = FIRDatabase.database().reference(fromURL: rootUrl)
        rootRef.observe(.value, with: {
            snapshot in
            var newItems:[String] = []
            for items in snapshot.children {
                print("cat: inside snapshot.children \(items)")
                newItems.append((items as AnyObject).key)
               // print("cat: \(self.categoryNames) n \(self.categoryNames.count)")
            }
            self.listItems = newItems
            DispatchQueue.main.async {
                print("cat: reload data")
                self.itemsTableView.reloadData()
            }
        })
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            listItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func BackToCategories(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
}
