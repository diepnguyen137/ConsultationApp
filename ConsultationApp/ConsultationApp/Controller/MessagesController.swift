//
//  ViewController.swift
//  ConsultationApp
//
//  Created by admin on 12/26/17.
//  Copyright © 2017 cosc2659. All rights reserved.
//

import UIKit
import FirebaseDatabase

class MessagesController: UITableViewController {

    let cellId = "cellId"
    var messages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("MessagesController: DidLoad")
        // Compose new message
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(handleNewMessage))
        
        // Logout Button
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        // Register Custom UserCell
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        // Update Messages
        observeMessages()
    }
    
    
    // MARK: Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        
        // Show new message from User
        let message = messages[indexPath.row]
        cell.message = message
        
        return cell
    }
    
    // Setup Cell Height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    // MARK: Handle Events
    @objc func observeMessages(){
        let refMessages = Database.database().reference().child("messages")
        refMessages.observe(.childAdded, with: { (snapshot) in
            print("Firebase: Messages: \(snapshot) ")
            
            if let dictionary = snapshot.value as? NSDictionary {
                let message = Message()
                message.fromId = dictionary["fromId"] as? String ?? ""
                message.text = dictionary["text"] as? String ?? ""
                message.timestamp = dictionary["timestamp"] as? NSNumber
                message.toId = dictionary["toId"] as? String ?? ""
                
                print("MessagesController: Messages: \(message.text ?? "")")
                
                // Add message to messages array
                self.messages.append(message)
                
                // Reload data
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
        }) { (error) in
            print("Firebase: Messages: Error getting messages")
        }
    }
    
    
    
    @objc func showChatControllerForUser(user: User){
        // Using CollectionViewController
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        
        // Send User to ChatLogController
        chatLogController.user = user
        
        // Go to ChatLogController
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    @objc func handleNewMessage(){
        print("NewMessage: Pressed")
        
        // Show New Message View
        let newMessageController = NewMessageController()
        newMessageController.messagesController = self
        let navController = UINavigationController(rootViewController: newMessageController)
        present(navController, animated: true, completion: nil)
    }

    @objc func handleLogout(){
        print("Logout: Pressed")
        
        // For login controller Swift 4: Connect to ViewController In MainStoryboard programmatically
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "logInCV")
        self.navigationController?.pushViewController(vc, animated: true)
        
    }


}

