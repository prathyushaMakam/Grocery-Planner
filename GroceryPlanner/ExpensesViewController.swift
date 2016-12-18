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
    var expenseRef: FIRDatabaseReference!
    var rootUrl:String!
    var uID:String!
    var expenses: [String:Float] = [:]
    var totalExpense:Float = 0.0

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("UID EXp: \(uID)")
        rootUrl = "https://groceryplanner-e2a60.firebaseio.com/users/"+uID+"/categories/"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getCategories()
    }
    
    func getCategories(){
        self.totalExpense = 0
        
        rootRef = FIRDatabase.database().reference(fromURL: rootUrl)
        rootRef.observeSingleEvent(of: .value, with: { snapshot in
            if let result = snapshot.children.allObjects as? [FIRDataSnapshot] {
                print("exp: getCategories handler enter\n")
                for child in result {
                    // create the child url
                    let cat = ((child as AnyObject).key) as String
                    print("exp: in cat = \(cat)\n")
                    self.expenses[cat] = 0.0
                    print("exp: in cat expenses[\(cat)] = \(self.expenses[cat])\n")
                    let childUrl = self.rootUrl+child.key+"/"
                    print("exp: in cat childUrl = \(childUrl)\n")
                    // get item under each category
                    self.getItems1(cat: cat, url: childUrl)
                }
            } else {
                print("no results\n")
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    //get all items under all categories
    func getItems1(cat:String, url:String){
        print("exp: in item childUrl = \(url)\n")
        childRef = FIRDatabase.database().reference(fromURL: url)
        childRef.observeSingleEvent(of: .value, with: {snapshot in
            print("exp: getItems handler enter\n")
            if let result = snapshot.children.allObjects as? [FIRDataSnapshot]{
                for child in result {
                    let item1 = ((child as AnyObject).key) as String
                    print("exp: in item = \(item1)\n")
                    let expenseUrl = url+child.key+"/"
                    print("exp: in item self.expenseUrl= \(expenseUrl)\n")
                    self.getExpense(item:item1,cat:cat, expenseUrl:expenseUrl)
                }
            }
            else {
                print("no results\n")
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    func getExpense(item:String,cat:String, expenseUrl:String){
        
        print("exp: in expense expenseUrl = \(expenseUrl)\n")
        
        expenseRef = FIRDatabase.database().reference(fromURL: expenseUrl)
        expenseRef.observeSingleEvent(of:.value, with: {snapshot in
            print("exp: getExpense handler enter\n")
            if let dict = snapshot.value as? NSDictionary{
                print("exp: in expense dict = \(dict) \n")
                let price = dict["price"] as? Float
                print("exp: in expense price = \(price)\n")
                let quantity = dict["quantity"] as? Float
                print("exp: in expense quantity = \(quantity)\n")
                let cost = price! * quantity!
                print("exp: in expense cost = \(cost)\n")
                self.totalExpense = self.totalExpense + cost
                print("exp: in expense totalExpense = \(self.totalExpense)\n")
                self.expenses[cat] = self.expenses[cat]!+cost
                print("exp: in expense self.expenses[\(cat)] =\(self.expenses[cat])\n")
                self.totalExpenseLabel.text = String(self.totalExpense)
            }
            else {
                print("no results\n")
            }
            
            DispatchQueue.main.async {
                self.expensesTableView.reloadData()
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
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
