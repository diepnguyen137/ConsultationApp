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
import FirebaseStorage

class MessagesController: UITableViewController {

    let cellId = "cellId"
    var messages = [Message]()
    var messagesDictionary = [String:Message]()
    
    // For LOGGING
    let printVC = "MessagesController:"
    let printFirebase = "Firebase:"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("MessagesController: DidLoad")
        // Compose new message
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(handleNewMessage))
        
        // Logout Button
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        // Check User
        checkUser()
        
        // Register Custom UserCell
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
    }
    
    @objc func checkUser(){
        let currentUser = Auth.auth().currentUser?.uid
        print(printVC, printFirebase, "CurrentUser: \(currentUser ?? "NIL") ")
        if currentUser == nil {
            perform(#selector(handleLogout))
        } else {
            fetchUserAndSetupBarTitle()
        }
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        
        guard let chatPartnerId = message.chatPartnerId() else { return }
        
        let refUser = Database.database().reference().child("users").child(chatPartnerId)
        refUser.observeSingleEvent(of: .value) { (snapshot) in
            print(self.printVC, self.printFirebase, "SelectRow: \(snapshot.key)")
            
            guard let dictionary = snapshot.value as? NSDictionary else { return }
            
            // Fill to User from Firebase
            let user = User()
            user.id = chatPartnerId
            user.name = dictionary["name"] as? String ?? ""
            user.email = dictionary["email"] as? String ?? ""
            user.avatar = dictionary["avatar"] as? String ?? ""
            
            self.showChatControllerForUser(user: user)
        }
        
    }
    
    // Setup Cell Height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    // MARK: Handle Events
    // Retreive database from firebase
    @objc func observeUserMessages(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("user-messages").child(uid)
        
        // Listener Messages
        ref.observe(.childAdded) { (snapshot) in
            print("MessagesController: UserMessages: \(snapshot.key) ")
            
            let messageId = snapshot.key
            let messageReference = Database.database().reference().child("messages").child(messageId)
            
            messageReference.observeSingleEvent(of: .value, with: { (snapshot) in
                print("MessagesController: Messages: \(snapshot) ")
                
                // Get all messges from firebase
                if let dictionary = snapshot.value as? NSDictionary {
                    let message = Message()
                    message.fromId = dictionary["fromId"] as? String ?? ""
                    message.text = dictionary["text"] as? String ?? ""
                    message.timestamp = dictionary["timestamp"] as? NSNumber
                    message.toId = dictionary["toId"] as? String ?? ""
                    
                    print("MessagesController: Messages: \(message.text ?? "")")
                    
                    // Get the last message of user
                    if let chatPartnerId = message.chatPartnerId() {
                        self.messagesDictionary[chatPartnerId] = message
                        
                        // Add message to messages arry
                        self.messages = Array(self.messagesDictionary.values)
                        
                        // Sort the messages
                        self.messages.sort(by: { (mes1, mes2) -> Bool in
                            guard let time1 = mes1.timestamp?.intValue else {return true}
                            guard let time2 = mes2.timestamp?.intValue else {return true}
                            return time1 > time2
                            
                        })
                    }
                    
                    
                    self.timer?.invalidate()
                    // Reload table in 0.1s
                    self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
                }
                
            }, withCancel: nil)
            
        }
    }
    
    
    
    var timer: Timer?
    
    @objc func handleReloadTable(){
        
        // Reload data
        DispatchQueue.main.async {
            self.tableView.reloadData()
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
        print(printVC, printFirebase, "Logout: Pressed")
        
        do {
            // Logout
            try Auth.auth().signOut()
            print(printVC, printFirebase, "Logout Completed")
        } catch let logoutError {
            print(printVC, printFirebase, logoutError)
        }
        
        
        // For login controller Swift 4: Connect to ViewController In MainStoryboard programmatically
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "logInCV")
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func fetchUserAndSetupBarTitle(){
        print(printVC, printFirebase, "Fetching User: ....")
        guard let uid = Auth.auth().currentUser?.uid else { return }
        print(printVC, printFirebase, "Fetching User: \(uid)")
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? NSDictionary {
                let user = User()
                user.id = snapshot.key
                user.name = dictionary["name"] as? String ?? ""
                user.email = dictionary["email"] as? String ?? ""
                user.avatar = dictionary["avatar"] as? String ?? ""
                
                self.setupNavBarWithUser(user: user)
            }
        }, withCancel: nil)
    }
    
    @objc func setupNavBarWithUser(user: User) {
        
        // Clear Old Messages
        messages.removeAll()
        messagesDictionary.removeAll()
        tableView.reloadData()
        
        // Update User Messages
        observeUserMessages()
        
        let titleView = UIView()
    
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(containerView)
        
        let profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        
        // FIXME: Update Image Load Performance
        //Create storage reference
        let imgStorageRef = Storage.storage().reference(forURL: user.avatar!)
        //Observe method to download the data (4MB)
        imgStorageRef.getData(maxSize: 4 * 1024 * 1024) { (data, error) in
            if let error = error {
                print(self.printVC, "Download Iamge: Error !!! \(error)")
            } else {
                if let imageData = data {
                    DispatchQueue.main.async {
                        //put Image to imageView in cell
                        let image = UIImage(data: imageData)
                        profileImageView.image = image
                    }
                    
                }
            }
        }
        
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

