//
//  ChatLogController.swift
//  ConsultationApp
//
//  Created by Thien Ho on 1/6/18.
//  Copyright © 2018 cosc2659. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class ChatLogController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout {
    var user: User? {
        didSet {
            // set NavigationTile to Selected User
            navigationItem.title = user?.name
            print("ChatLogController: NavigationItem: Title: \(user?.name ?? "Not selected user.")")
            
            observeMessages()
        }
    }
    
    var messages = [Message]()
    
    @objc func observeMessages(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
         let userMessagesRef = Database.database().reference().child("user-messages").child(uid)
        userMessagesRef.observe(.childAdded) { (snapshot) in
            // Get all the messages of user
            let messageId = snapshot.key
            let messagesRef = Database.database().reference().child("messages").child(messageId)
            messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dictionary = snapshot.value as? NSDictionary else { return }
                let message = Message()
                message.fromId = dictionary["fromId"] as? String ?? ""
                message.text = dictionary["text"] as? String ?? ""
                message.toId = dictionary["toId"] as? String ?? ""
                message.timestamp = dictionary["timestamp"] as? NSNumber
                
                // check user
                if message.chatPartnerId() == self.user?.id {
                    print(message.text ?? "")
                    self.messages.append(message)
                    
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                    }
                }
            })
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
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ChatLogController: DidLoad")
        
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0)       // Spacing from top and botom
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        collectionView?.alwaysBounceVertical = true         // Set to vertial scrolling
        collectionView?.backgroundColor = UIColor.white     // Set background to white
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        // Setup a chat field
        setupInputComponents()
        
        // Setup keyboard Observe
        setupKeyboardObservers()
        
    }
    @objc func setupKeyboardObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide , object: nil)
    }
  
    var containerViewBottomAnchor: NSLayoutConstraint?
    
    @objc func handleKeyboardWillShow(_ notification: Notification) {
        // When keyboard show
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        
        containerViewBottomAnchor?.constant = -keyboardFrame!.height
        UIView.animate(withDuration: keyboardDuration!, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    @objc func handleKeyboardWillHide(_ notification: Notification) {
        // When keybaoard hide
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        
        containerViewBottomAnchor?.constant = -50
        UIView.animate(withDuration: keyboardDuration!, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        
        let message = messages[indexPath.row]
        cell.textView.text = message.text
        
        setupCell(cell: cell, message: message)
        
        // Modifiy bubble view
        cell.bubbleWidthAnchor?.constant = estimateFrameForText(text: message.text!).width + 30
        
        return cell
    }
    
    private func setupCell(cell: ChatMessageCell, message: Message){
        // Load Image
        if let profileImageUrl = self.user?.avatar {
            print("Firebase Storage: \(profileImageUrl)")
            let imgStorageRef = Storage.storage().reference(forURL: profileImageUrl)
            //  Observe method to download the data (4MB)
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
        
        // check user
        if message.fromId == Auth.auth().currentUser?.uid {
            cell.bubbleView.backgroundColor = ChatMessageCell.blueColor
            cell.profileImageView.isHidden = true                   // Hide image
            // Move bubble to right
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
        } else {
            // gray message
            cell.bubbleView.backgroundColor = UIColor.lightGray     // Change Color
            cell.profileImageView.isHidden = false                  // UnHide Image
            // Move bubble to left
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()         // Landscape fix
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        
        if let text = messages[indexPath.item].text {
            height = estimateFrameForText(text: text).height + 20
        }
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    private func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes:  [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    func setupInputComponents(){
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        
        // Constraint anchors x,y,w,h for container
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerViewBottomAnchor = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        containerViewBottomAnchor?.isActive = true
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
        
        let fromId = Auth.auth().currentUser?.uid   
        let toId = user!.id!
        let timestamp = Int(NSDate().timeIntervalSince1970 )
        let values = ["text": inputTextField.text!, "fromId": fromId ?? "", "toId": toId, "timestamp": timestamp] as [String : Any]
//        childRef.updateChildValues(values)
        
        childRef.updateChildValues(values) { (error, refMessages) in
            if error != nil {
                print(error ?? "")
                return
            }
            // clear inputtextfield
            self.inputTextField.text = nil
            
            let userMessagesRef = Database.database().reference().child("user-messages").child(fromId!)
            let messageId = childRef.key
            userMessagesRef.updateChildValues([messageId: 1])
            
            let recipientUserMessageRef = Database.database().reference().child("user-messages").child(toId)
            recipientUserMessageRef.updateChildValues([messageId: 1])
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Send the messages to firebase
        handleSend()
        textField.resignFirstResponder()
        return true
    }
}
