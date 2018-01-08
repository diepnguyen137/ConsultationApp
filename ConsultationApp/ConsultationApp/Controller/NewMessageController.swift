//
//  NewMessageController.swift
//  ConsultationApp
//
//  Created by Thien Ho on 1/6/18.
//  Copyright © 2018 cosc2659. All rights reserved.
//

import UIKit
import FirebaseDatabase

class NewMessageController: UITableViewController {
    let celId = "cellId"
    
    // Create User array
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Create Cancel Navigation Button
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        // Register Custom UserCell
        tableView.register(UserCell.self, forCellReuseIdentifier: celId)
        
        // Fetching List of User from Firebase
        fetchUser()
    }
    
    // MARK: Firebase
    func fetchUser(){
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            print("Firebase: User found")
            print("Firebase: \(snapshot)")
            
            // Get name
//            let dictionary = snapshot.value as? [String: Any]
//            print(dictionary!["name"] as! String)
            
            // Add all user to dictionary for Swift 4
            if let dictionary = snapshot.value as? NSDictionary {
                let name = dictionary["name"] as? String ?? ""
                let email = dictionary["email"] as? String ?? ""
                let user = User(name: name, email: email)
                
                print("Firebase: User: \(user.name) \(user.email)")
                
                // Add user to users arraylist
                self.users.append(user)
                
                // Reload data and avoid crashing
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
            
            
            
            
        }, withCancel: nil)
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Deque Reuseable Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: celId, for: indexPath)
        
        // Fill User in to TableRow
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email

        return cell
    }
    
    // MARK: - Navigation

     // Return to MessagesController
     @objc func handleCancel(){
     dismiss(animated: true, completion: nil)
     }
  
}

// Setup a custome UserCell
class UserCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
