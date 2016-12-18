//
//  ExpensesViewController.swift
//  GroceryPlanner
//
//  Created by Prathyusha Makam Prasad on 12/9/16.
//  Copyright © 2016 Prathyusha Makam Prasad. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth


class ExpensesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var totalExpenseLabel: UILabel!
    @IBOutlet weak var expensesTableView: UITableView!
  
    var rootRef: FIRDatabaseReference!
    var childRef: FIRDatabaseReference!
    var rootUrl:String!
    var childUrl:String = ""
    var uID:String!
    var expenses: [String:Float] = [:]
    var totalExpense:Float = 0.0

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("UID EXp: \(uID)")
        rootUrl = "https://groceryplanner-e2a60.firebaseio.com/users/"+uID+"/categories/"
        getCategories()
    }
    

    
    func getCategories(){
        // get category for each user
        rootRef = FIRDatabase.database().reference(fromURL: rootUrl)
        rootRef.observe(.value, with: {
            snapshot in
            for category in snapshot.children {
                let cat = ((category as AnyObject).key) as String
                self.expenses[cat] = 0.0
                self.getItems(cat: cat)
            }
        })
    }
    
    func getItems(cat:String){
        childRef = FIRDatabase.database().reference(fromURL: rootUrl+"\(cat)/")
        childRef.observe(.value, with: {
            snapshot1 in
            for item in snapshot1.children {
                let item1 = ((item as AnyObject).key) as String
                self.getExpense(item: item1,cat: cat)
            }
        })
    }
    
    func getExpense(item:String,cat:String){
        childRef = FIRDatabase.database().reference(fromURL: rootUrl+cat+item)
        childRef.observe(.value, with: {
            snapshot1 in
                if let dict = snapshot1.value as? NSDictionary{
                let price = dict["price"] as? Float
                let quantity = dict["quantity"] as? Float
                let cost = price! * quantity!
                self.totalExpense = self.totalExpense + cost
                self.totalExpenseLabel.text = String(self.totalExpense)
                self.expenses[cat] = self.expenses[cat]!+cost
                
        }
            DispatchQueue.main.async {
                self.expensesTableView.reloadData()
            }
        })
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return expenses.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "expenseCell", for: indexPath)
        
        let key   = Array(self.expenses.keys)[indexPath.row]
        let value = Array(self.expenses.values)[indexPath.row]
        
        // Configure the cell...
        cell.textLabel?.text = key
        cell.detailTextLabel?.text = String(describing: value)
        
        return cell
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let itemPopup = segue.destination as! GraphPopUpViewController
        itemPopup.expenses = expenses
    }
    

}
