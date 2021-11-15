//
//  OnlineViewController.swift
//  grocery App
//
//  Created by Wa ibra. on 05/04/1443 AH.
//

import UIKit
import Firebase

class OnlineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //Variables
    @IBOutlet weak var onlineTableView: UITableView!
    let onlineCell = "onlineCell"
    
    var currentUsers: [String] = []
    let OnlineUsersRef = Database.database().reference(withPath: "online")
    var onlineUserRefObserve: [DatabaseHandle] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.onlineTableView.delegate = self
        self.onlineTableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
   override func viewWillAppear(_ animated: Bool) {
       
       //show online user
      super.viewWillAppear(true)
      let childAdded = OnlineUsersRef
        .observe(.childAdded) { [weak self] snap in
          guard
            let email = snap.value as? String,
            let self = self
          else { return }
          self.currentUsers.append(email)
          let row = self.currentUsers.count - 1
          let indexPath = IndexPath(row: row, section: 0)
          self.onlineTableView.insertRows(at: [indexPath], with: .top)
        }
      onlineUserRefObserve.append(childAdded)

       
      let childRemoved = OnlineUsersRef
        .observe(.childRemoved) {[weak self] snap in
          guard
            let emailToFind = snap.value as? String,
            let self = self
          else { return }
            //remove online user
          for (index, email) in self.currentUsers.enumerated()
            where email == emailToFind {
              let indexPath = IndexPath(row: index, section: 0)
              self.currentUsers.remove(at: index)
              self.onlineTableView.deleteRows(at: [indexPath], with: .fade)
          }
        }
      onlineUserRefObserve.append(childRemoved)
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
      super.viewDidDisappear(true)
      onlineUserRefObserve.forEach(OnlineUsersRef.removeObserver(withHandle:))
      onlineUserRefObserve = []
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return currentUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: onlineCell, for: indexPath)
      let onlineUserEmail = currentUsers[indexPath.row]
        //show online user email in table view
      cell.textLabel?.text = onlineUserEmail
      return cell
    }
    
    
    
    @IBAction func logoutButton(_ sender: UIButton) {
            //LogOut alert
            let alert = UIAlertController(title: "do you want to logout?", message: "", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { [weak self] _ in
                guard let strongSelf = self else {
                    return
                }
                guard let user = Auth.auth().currentUser else { return }
                
                
                //update log out from Database
                let onlineRef = Database.database().reference(withPath: "online/\(user.uid)")
                onlineRef.removeValue { error, _ in
                    if let error = error {
                        print("Removing online failed: \(error)")
                        return
                    }
                    do {
                        try Auth.auth().signOut()
                        
                        // set homeVC as root VC
                        let vc = strongSelf.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                        let nav = UINavigationController(rootViewController: vc)
                        nav.modalPresentationStyle = .fullScreen
                        strongSelf.present(nav, animated: false)
                    } catch let error {
                        print("Auth sign out failed: \(error)")
                    }
                }
                
            }))
        //cancel action
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true)
        
      }
    
    //go back to GroceryVC
    @IBAction func backButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

}
