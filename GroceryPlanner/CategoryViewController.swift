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
        print("cat: b4 viewLoad \(categoryNames.count)")
        
        super.viewDidLoad()
        print("cat: after viewLoad and calling fetch \(categoryNames.count)")
        print("UID cat: \(uID)")
        rootUrl = "https://groceryplanner-e2a60.firebaseio.com/users/"+uID+"/categories/"
        for i in categoryNames{
            print("cat: \(i)")
        }
        fetchCategories()
        print("cat: after calling fetch \(categoryNames.count)")
        
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
        print("item: \(selectedCategory)")
        valToPass = selectedCategory
        print("item: valTO \(valToPass)")
        performSegue(withIdentifier: "toItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toItems"){
            let nav = segue.destination as! UINavigationController
            print("item nav working")
            let itemView = nav.topViewController as! ItemsTableViewController
            print("item to sent: \(valToPass)")
            itemView.categoryValue = valToPass
            itemView.uID = uID
            print("item itemView.: \(itemView.categoryValue) ")
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
    

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    

    

}
