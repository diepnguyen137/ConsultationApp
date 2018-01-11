//
//  NewMessageController.swift
//  ConsultationApp
//
//  Created by Thien Ho on 1/6/18.
//  Copyright © 2018 cosc2659. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class NewMessageController: UITableViewController {
    let celId = "cellId"
    
    // Create User array
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("NewMessageController: DidLoad")

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
            
            // Add all user to dictionary for Swift 4
            if let dictionary = snapshot.value as? NSDictionary {
                let user = User()
                user.id = snapshot.key
                user.name = dictionary["name"] as? String ?? ""
                user.email = dictionary["email"] as? String ?? ""
                user.avatar = dictionary["avatar"] as? String ?? ""
                
                print("Firebase: User: \(user.id ?? "") \(user.name ?? "") \(user.email ?? "")")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: celId, for: indexPath) as! UserCell
        
        // Fill User in to TableRow
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        
        // Load Image
        if let profileImageUrl = user.avatar {
            let imgStorageRef = Storage.storage().reference(forURL: profileImageUrl)
            //                      Observe method to download the data (4MB)
            imgStorageRef.getData(maxSize: 4 * 1024 * 1024) { (data, error) in
                if let error = error {
                    print("Download Iamge: Error !!! \(error)")
                } else {
                    if let imageData = data {
                        DispatchQueue.main.async {
                            //put Image to imageView in cell
                            let image = UIImage(data: imageData)
                            cell.profileImageView.image = image
                        }
                        
                    }
                }
            }
        }

        return cell
    }
    
    var messagesController: MessagesController?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) {
            print("NewMessagesController: Dismiss Completed")
            
            // Get selected user
            let user = self.users[indexPath.row]
            
            // Show ChatLogController
            self.messagesController?.showChatControllerForUser(user: user)
        }
    }
    
    // MARK: - Navigation

     // Return to MessagesController
     @objc func handleCancel(){
        dismiss(animated: true, completion: nil)
     }
  
}


