//
//  UserCell.swift
//  ConsultationApp
//
//  Created by Thien Ho on 1/9/18.
//  Copyright © 2018 cosc2659. All rights reserved.
//

import UIKit
import FirebaseDatabase

// Setup a custome UserCell
class UserCell: UITableViewCell {
    
    var message: Message? {
        didSet{
            
            // Getting User Name by toId in message
            if let toId = message?.toId {
                let refUser = Database.database().reference().child("users").child(toId)
                refUser.observeSingleEvent(of: .value, with: { (snapshot) in
                    print("MessagesController: UserCell: Firebase: TOID: \(snapshot.key) ")
                    
                    if let dictionary = snapshot.value as? NSDictionary {
                        self.textLabel?.text = dictionary["name"] as? String
                        
                        // TODO: Set Image URL
                    }
                    
                })
            }
            
            // Set detail table by message
            self.detailTextLabel?.text = message?.text
            
            // Set timestamp to timelabel
            if let seconds = message?.timestamp?.doubleValue {
                let timestampDate = NSDate(timeIntervalSince1970: seconds)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm:ss a"
                timeLabel.text = dateFormatter.string(from: timestampDate as Date)
            }
        }
    }
    // TODO: Design LayoutSubviews
    // TODO: Design ImageView for each cell
    
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
        // TODO: add ImageView
        
        // TODO: constraint anchors for ImageView
        
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
