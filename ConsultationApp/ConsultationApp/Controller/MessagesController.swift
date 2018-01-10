//
//  ViewController.swift
//  ConsultationApp
//
//  Created by admin on 12/26/17.
//  Copyright © 2017 cosc2659. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class MessagesController: UITableViewController {

    let cellId = "cellId"
    var messages = [Message]()
    var messagesDictionary = [String:Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("MessagesController: DidLoad")
        // Compose new message
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(handleNewMessage))
        
        // Logout Button
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        // Register Custom UserCell
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
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
    @objc func observeUserMessages(){
        guard let uid = "ME" as Optional else { return }        // TODO: Replace with CurrentUser ID
        let ref = Database.database().reference().child("user-messages").child(uid)
        
        ref.observe(.childAdded) { (snapshot) in
            print("MessagesController: UserMessages: \(snapshot.key) ")
            
            let messageId = snapshot.key
            let messageReference = Database.database().reference().child("messages").child(messageId)
            
            messageReference.observeSingleEvent(of: .value, with: { (snapshot) in
                print("MessagesController: Messages: \(snapshot) ")
                
                if let dictionary = snapshot.value as? NSDictionary {
                    let message = Message()
                    message.fromId = dictionary["fromId"] as? String ?? ""
                    message.text = dictionary["text"] as? String ?? ""
                    message.timestamp = dictionary["timestamp"] as? NSNumber
                    message.toId = dictionary["toId"] as? String ?? ""
                    
                    print("MessagesController: Messages: \(message.text ?? "")")
                    
                    // Get the last message of user
                    if let toId = message.toId {
                        self.messagesDictionary[toId] = message
                        
                        // Add message to messages arry
                        self.messages = Array(self.messagesDictionary.values)
                        
                        // Sort the messages
                        self.messages.sort(by: { (mes1, mes2) -> Bool in
                            guard let time1 = mes1.timestamp?.intValue else {return true}
                            guard let time2 = mes2.timestamp?.intValue else {return true}
                            return time1 > time2
                            
                        })
                    }
                    
                    // Reload data
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
                
            }, withCancel: nil)
            
        }
    }
    
    // Retreive database from firebase
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
                
                // Get the last message of user
                if let toId = message.toId {
                    self.messagesDictionary[toId] = message
                    
                    // Add message to messages arry
                    self.messages = Array(self.messagesDictionary.values)
                    
                    // Sort the messages
                    self.messages.sort(by: { (mes1, mes2) -> Bool in
                        guard let time1 = mes1.timestamp?.intValue else {return true}
                        guard let time2 = mes2.timestamp?.intValue else {return true}
                        return time1 > time2
                        
                    })
                }
                
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
    
    @objc func fetchUserAndSetupBarTitle(){
        guard let uid = "ME" as Optional else { return }      //TODO: Replace with Firebase CurrentUserID
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? NSDictionary {
                let user = User()
                user.id = snapshot.key
                user.name = dictionary["name"] as? String ?? ""
                user.email = dictionary["email"] as? String ?? ""
                
                self.setupNavBarWithUser(user: user)
            }
        }, withCancel: nil)
    }
    
    @objc func setupNavBarWithUser(user: User) {
        messages.removeAll()
        messagesDictionary.removeAll()
        tableView.reloadData()
        
        // Update User Messages
        observeUserMessages()
        
        let titleView = UIView()
    
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(containerView)
        
        // TODO: Add User ImageView
        let profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
//        if let profileImageUrl = user.profileImageUrl {
//            profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
//        }
        // TODO: Set Image to ImageView
        containerView.addSubview(profileImageView)
        
        //ios 9 constraint anchors
        //need x,y,width,height anchors
        profileImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let nameLabel = UILabel()
        
        containerView.addSubview(nameLabel)
        nameLabel.text = user.name
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        //need x,y,width,height anchors
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        
        self.navigationItem.titleView = titleView
    }


}

