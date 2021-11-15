//
//  allGroceryViewController.swift
//  grocery App
//
//  Created by Wa ibra. on 05/04/1443 AH.
//


import UIKit
import FirebaseAuth
import Firebase

class allGroceryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    //variables
    @IBOutlet weak var groceryTableView: UITableView!
    @IBOutlet weak var onlineButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    //Constants
    let ref = Database.database().reference(withPath: "grocery-items")
    var refObservers: [DatabaseHandle] = []
    
    let usersRef = Database.database().reference(withPath: "online")
    var usersRefObservers: [DatabaseHandle] = []
    
    // Properties
    var items: [GroceryItem] = []
    var user: User?
    var handle: AuthStateDidChangeListenerHandle?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groceryTableView.delegate = self
        groceryTableView.dataSource = self
        
        groceryTableView.allowsMultipleSelectionDuringEditing = false
        
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let completed = ref
        
            .queryOrdered(byChild: "completed")
        
        //observing
            .observe(.value) { snapshot in
                var newItems: [GroceryItem] = []
                for child in snapshot.children {
                    if
                        let snapshot = child as? DataSnapshot,
                        let groceryItem = GroceryItem(snapshot: snapshot) {
                        newItems.append(groceryItem)
                    }
                }
                self.items = newItems
                self.groceryTableView.reloadData()
            }
        refObservers.append(completed)
        
        
        //update firebase and app with online user
        handle = Auth.auth().addStateDidChangeListener { _, user in
            guard let user = user else { return }
            self.user = User(authData: user)
            
            let onlineUserRef = self.usersRef.child(user.uid)
            onlineUserRef.setValue(user.email)
            onlineUserRef.onDisconnectRemoveValue()
        }
        
    }
    
    

    
    
    
    @IBAction func addItam(_ sender: Any) {
        
        //alert action to add to table view
        let alert = UIAlertController(
            title: "Grocery Item",
            message: "Add an Item",
            preferredStyle: .alert)
        
        //save button
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard
                let textField = alert.textFields?.first,
                let text = textField.text,
                let user = self.user
            else { return }
            
            //add item details to database
            let groceryItem = GroceryItem(
                name: text,
                addedByUser: user.email,
                completed: false)
            
            let groceryItemRef = self.ref.child(text.lowercased())
            groceryItemRef.setValue(groceryItem.toAnyObject())
            
        }
        //cancel button
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .cancel)
        
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
        
        
    }
    
    
    //editing
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = UIContextualAction(style: .normal, title: "Edit") { (contextualAction, view, actionPerformed: (Bool) -> ()) in
            
            //alert action to Edit to table view
            let Editalert = UIAlertController(
                title: "Grocery Item",
                message: "Edit Item",
                preferredStyle: .alert)
            
            //save button
            let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
                guard
                    let textField = Editalert.textFields?.first,
                    let text = textField.text,
                    let user = self.user
                else { return }
                
                //deleting the before editing name
                let oldGroceryItem = self.items[indexPath.row]
                oldGroceryItem.ref?.removeValue()
                
                //Edit item details to database
                let groceryItem = GroceryItem(
                    name: text,
                    addedByUser: user.email,
                    completed: false)
                
                
                let groceryItemRef = self.ref.child(text.lowercased())
                groceryItemRef.setValue(groceryItem.toAnyObject())
                
                
            }
            //cancel button
            let cancelAction = UIAlertAction(
                title: "Cancel",
                style: .cancel)
            
            Editalert.addTextField()
            Editalert.addAction(saveAction)
            Editalert.addAction(cancelAction)
            
            self.present(Editalert, animated: true, completion: nil)
            
        }
        
        //edit button color
        edit.backgroundColor = .systemMint
        
        return UISwipeActionsConfiguration(actions: [edit])
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groceryCell",for: indexPath)
        let groceryItem = items[indexPath.row]
        
        
        //get data from firebase and present it
        cell.textLabel?.text = groceryItem.name
        cell.detailTextLabel?.text = groceryItem.addedByUser
        
        //ckeck box
        Checkbox(cell, isCompleted: groceryItem.completed)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        //deleting from tableView and firebase
        if editingStyle == .delete {
            let groceryItem = items[indexPath.row]
            groceryItem.ref?.removeValue()
            
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        let groceryItem = items[indexPath.row]
        
        let completedItem = !groceryItem.completed
        Checkbox(cell, isCompleted: completedItem)
        groceryItem.ref?.updateChildValues(["completed": completedItem])
    }
    
    
    //styling checkbox
    func Checkbox(_ cell: UITableViewCell, isCompleted: Bool) {
        if !isCompleted {
            cell.accessoryType = .none
            cell.textLabel?.textColor = .black
            cell.detailTextLabel?.textColor = .black
        } else {
            //changing cell color after adding checkbox
            cell.accessoryType = .checkmark
            cell.textLabel?.textColor = .systemMint
            cell.detailTextLabel?.textColor = .systemMint
        }
    }
    
}


