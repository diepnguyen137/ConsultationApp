/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2017C
 Assignment: 3
 Author: Ho Phu Thien- Tran Trong Tri- Nguyen Tran Ngoc Diep
 ID: s3574966-s3533437- s3519039
 Created date: 26/12/2017
 Acknowledgement:
 -Thien
 Client-side fan-out for data consistency
 https://firebase.googleblog.com/2015/10/client-side-fan-out-for-data-consistency_73.html
 Programmatically creating UITabBarController in Swift
 https://medium.com/ios-os-x-development/programmatically-creating-uitabbarcontroller-in-swift-e957cd35cfc4
 Programmatically Creating Constraints
 https://developer.apple.com/library/content/documentation/UserExperience/Conceptual/AutolayoutPG/ProgrammaticallyCreatingConstraints.html
 iOS Notes 19 : How to push and present to ViewController programmatically ? [ How to switch VC ]
 https://freakycoder.com/ios-notes-19-how-to-push-and-present-to-viewcontroller-programmatically-how-to-switch-vc-8f8f65b55c7b
 Create UITabBarController programmatically
 http://swiftdeveloperblog.com/code-examples/create-uitabbarcontroller-programmatically/
 UINavigationController And UITabBarController Programmatically (Swift 3)
 https://medium.com/@ITZDERR/uinavigationcontroller-and-uitabbarcontroller-programmatically-swift-3-d85a885a5fd0
 -Diep
 Delegate Protocol for custom cell
 https://www.youtube.com/watch?v=3Rrzm9ZXdds
 DLRadioButton
 https://github.com/DavydLiu/DLRadioButton
 Pass Data Between View Controllers
 https://www.youtube.com/watch?v=7fbTHFH3tl4
 -Tri
 https://developer.apple.com/library/content/referencelibrary/GettingStarted/DevelopiOSAppsSwift/index.html#//apple_ref/doc/uid/TP40015214-CH2-SW1
 */

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

// Setup a custome UserCell
class UserCell: UITableViewCell {
    
    var message: Message? {
        didSet{
            
            // Setup Name and ProfileImage
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
        
        // Getting User Name by toId in message
        if let id = message?.chatPartnerId() {
            let refUser = Database.database().reference().child("users").child(id)
            refUser.observeSingleEvent(of: .value, with: { (snapshot) in
                print("MessagesController: UserCell: Firebase: TOID: \(snapshot.key) ")
                
                if let dictionary = snapshot.value as? NSDictionary {
                    self.textLabel?.text = dictionary["name"] as? String
                    let consultantRole = dictionary["consultantRole"] as? String
                    // Change color role
                    switch consultantRole {
                    case "Love"?:
                        self.roleLabel.textColor = UIColor.magenta
                    case "Depress"?:
                        self.roleLabel.textColor = UIColor.red
                    case "Stress"?:
                        self.roleLabel.textColor = UIColor.blue
                    case "General"?:
                        self.roleLabel.textColor = UIColor.green
                    case .none:
                        print("NONE")
                    case .some(_):
                        print("SOME")
                    }
                    self.roleLabel.text = consultantRole
                    
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
    // ReDesign LayoutSubviews
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

    // Get roleConsultant
    let roleLabel: UILabel = {
        let label = UILabel()
        label.text = "LOVE"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.magenta
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        addSubview(roleLabel)
        
        // Constraint anchor for profileImageView
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        // Constraint anchor for RoleLabel
        roleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 200).isActive = true
        roleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        roleLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        roleLabel.heightAnchor.constraint(equalTo: (textLabel?.heightAnchor)!).isActive = true
        
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
