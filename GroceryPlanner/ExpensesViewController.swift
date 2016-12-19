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
        rootUrl = "https://groceryplanner-e2a60.firebaseio.com/users/"+uID+"/categories/"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getCategories()
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

    func getCategories(){
        self.totalExpense = 0
        
        rootRef = FIRDatabase.database().reference(fromURL: rootUrl)
        rootRef.observeSingleEvent(of: .value, with: { snapshot in
            if let result = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for child in result {
                    // create the child url
                    let cat = ((child as AnyObject).key) as String
                    self.expenses[cat] = 0.0
                    let childUrl = self.rootUrl+child.key+"/"
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
        childRef = FIRDatabase.database().reference(fromURL: url)
        childRef.observeSingleEvent(of: .value, with: {snapshot in
            if let result = snapshot.children.allObjects as? [FIRDataSnapshot]{
                for child in result {
                    let item1 = ((child as AnyObject).key) as String
                    let expenseUrl = url+child.key+"/"
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
        
        expenseRef = FIRDatabase.database().reference(fromURL: expenseUrl)
        expenseRef.observeSingleEvent(of:.value, with: {snapshot in
            if let dict = snapshot.value as? NSDictionary{
                let price = dict["price"] as? Float
                let quantity = dict["quantity"] as? Float
                let cost = price! * quantity!
                self.totalExpense = self.totalExpense + cost
                self.expenses[cat] = self.expenses[cat]!+cost
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let itemPopup = segue.destination as! GraphPopUpViewController
        itemPopup.expenses = expenses
    }
}
