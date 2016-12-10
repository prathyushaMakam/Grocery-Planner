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

class CategoryViewController: UITableViewController {
    
    @IBOutlet weak var categoryView: UITableView!
    var rootRef: FIRDatabaseReference!
    var categoryNames: [String] = ["d"]
    var rootUrl = "https://groceryplanner-e2a60.firebaseio.com/categories/"

    override func viewDidLoad() {
        print("cat: b4 viewLoad \(categoryNames.count)")
        //fetchCategories()

        super.viewDidLoad()
        print("cat: after viewLoad and calling fetch \(categoryNames.count)")

        categoryView.dataSource = self
        categoryView.delegate = self
        fetchCategories()
        print("cat: after calling fetch \(categoryNames.count)")
        
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
        //print("cat \(categoryNames) count \(categoryNames.count)")
        //print("cat: inside return count \(self.categoryNames) n \(categoryNames.count)")

        return categoryNames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = categoryNames[indexPath.row]
        
        DispatchQueue.main.async {
            self.categoryView.reloadData()
        }
        return cell
    }
    
    func fetchCategories()
    {
        print("cat: inside calling fetch \(categoryNames.count)")

        rootRef = FIRDatabase.database().reference(fromURL: rootUrl)
        rootRef.observe(.value, with: {
            snapshot in
            for category in snapshot.children {
                self.categoryNames.append((category as AnyObject).key)
                //self.categoryNames.append(((category.self as AnyObject).key) as String)
            }
            print("cat: \(self.categoryNames) n \(self.categoryNames.count)")
        })
        

        
    }

    
    

   
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
