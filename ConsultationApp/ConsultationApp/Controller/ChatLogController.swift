//
//  ChatLogController.swift
//  ConsultationApp
//
//  Created by Thien Ho on 1/6/18.
//  Copyright © 2018 cosc2659. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ChatLogController: UICollectionViewController, UITextFieldDelegate {
    var user: User? {
        didSet {
            // set NavigationTile to Selected User
            navigationItem.title = user?.name
            print("ChatLogController: NavigationItem: Title: \(user?.name ?? "Not selected user.")")
        }
    }
    
    lazy var inputTextField: UITextField = {
        // Create Textfield
        let textField = UITextField()
        textField.placeholder = "Enter messages...."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ChatLogController: DidLoad")
        
        collectionView?.backgroundColor = UIColor.white     // Set background to white
        
        // Setup a chat field
        setupInputComponents()
    }
    
    func setupInputComponents(){
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        
        // Constraint anchors x,y,w,h for container
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // Create Send button
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        
        containerView.addSubview(sendButton)
        
        // Constraint anchors x,y,w,h for Send Button
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        // Create Textfield
        containerView.addSubview(inputTextField)
        
        // Constraint anchors x,y,w,h for Input TextField
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextField.widthAnchor.constraint(equalToConstant: 300).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        // Create Seperator
        let seperatorLineView = UIView()
        seperatorLineView.backgroundColor = UIColor.black
        seperatorLineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(seperatorLineView)
        
        // Constraint anchors x,y,w,h for SeperatorLine
        seperatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        seperatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        seperatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        seperatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    // MARK: Handle Events
    @objc func handleSend(){
        print("ChatLogController: SendButton: Pressed")
        
        print("ChatLogController: inputTextField: \(inputTextField.text ?? "") ")
        
        // Write to Firebase
        let refMessages = Database.database().reference().child("messages")
        let childRef = refMessages.childByAutoId()
        
        let fromId = "ME" // Firebase Auth currentUser?.uid
        let toId = user!.id!
        let timestamp = Int(NSDate().timeIntervalSince1970 )
        let values = ["text": inputTextField.text!, "fromId": fromId, "toId": toId, "timestamp": timestamp] as [String : Any]
        childRef.updateChildValues(values)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Send the messages to firebase
        handleSend()
        return true
    }
}
