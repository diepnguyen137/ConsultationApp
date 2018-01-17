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
                user.consultantRole = dictionary["consultantRole"] as? String ?? ""
                
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
        
        // Change color role
        switch user.consultantRole {
        case "Love"?:
            cell.roleLabel.textColor = UIColor.magenta
        case "Depress"?:
            cell.roleLabel.textColor = UIColor.red
        case "Stress"?:
            cell.roleLabel.textColor = UIColor.blue
        case "General"?:
            cell.roleLabel.textColor = UIColor.green
        case .none:
            print("NONE")
        case .some(_):
            print("SOME")
        }
        cell.roleLabel.text = user.consultantRole
        
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


