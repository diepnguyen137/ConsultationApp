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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("MessagesController: DidLoad")
        // Compose new message
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(handleNewMessage))
        
        // Logout Button
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        // Update Messages
        observeMessages()
    }
    
    // MARK: Handle Events
    @objc func observeMessages(){
        let refMessages = Database.database().reference().child("messages")
        refMessages.observe(.childAdded, with: { (snapshot) in
            print("Firebase: Messages: \(snapshot) ")
            
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
        
        // TODO: For login controller
//        let loginController = LoginController()
//        present(loginController, animated: true, completion: nil)
    }


}

