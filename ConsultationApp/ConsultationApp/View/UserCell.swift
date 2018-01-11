//
//  UserCell.swift
//  ConsultationApp
//
//  Created by Thien Ho on 1/9/18.
//  Copyright © 2018 cosc2659. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

// Setup a custome UserCell
class UserCell: UITableViewCell {
    
    var message: Message? {
        didSet{
            
            setupNameAndProfileImage()
            
            // Set detail table by message
            self.detailTextLabel?.text = message?.text
            
            // Set timestamp to timelabel
            if let seconds = message?.timestamp?.doubleValue {
                let timestampDate = NSDate(timeIntervalSince1970: seconds)
                
                // Formatting to HH:MM:SS AM/PM
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm:ss a"
                timeLabel.text = dateFormatter.string(from: timestampDate as Date)
            }
        }
    }
    @objc private func setupNameAndProfileImage(){
        let chatPartnerId: String?
        
        if message?.fromId == "ME" {       // TODO: replace with firebase auth current Id
            chatPartnerId = message?.toId
        } else {
            chatPartnerId = message?.fromId
        }
        
        // Getting User Name by toId in message
        if let id = chatPartnerId {
            let refUser = Database.database().reference().child("users").child(id)
            refUser.observeSingleEvent(of: .value, with: { (snapshot) in
                print("MessagesController: UserCell: Firebase: TOID: \(snapshot.key) ")
                
                if let dictionary = snapshot.value as? NSDictionary {
                    self.textLabel?.text = dictionary["name"] as? String
                    
                    // TODO: Set Image URL
                    
                    if let profileImageUrl = dictionary["avatar"] as? String {
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
                                        self.profileImageView.image = image
                                    }
    
                                }
                            }
                        }
                    }
                }
                
            })
        }
    }
    // TODO: Design LayoutSubviews
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        
        detailTextLabel?.frame = CGRect(x: 64, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    // Time Label
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)          // Set Font Size
        label.textColor = UIColor.darkGray                 // Set color to dark gray color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        // Add to subview
        addSubview(timeLabel)
        addSubview(profileImageView)
        
        // Constraint anchor for profileImageView
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        // Constraint anchor for timelabel
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 18).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: (textLabel?.heightAnchor)!).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
