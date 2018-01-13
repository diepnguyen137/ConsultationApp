//
//  UserTableViewController.swift
//  ConsultationApp
//
//  Created by admin on 1/9/18.
//  Copyright © 2018 cosc2659. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class UserTableViewController: UITableViewController, UserCellDelegate {
    
    //Properties
    var users = [User]()
    var refUser : DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        refUser = Database.database().reference().child("users")
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(handleLogout))
        self.navigationItem.title = "Admin"
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.green
        
        //Fetch user
        fetchUser()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                user.role = dictionary["role"] as? String ?? ""
                user.consultantRole = dictionary["consultantRole"] as? String ?? ""
                print("Firebase: User: \(user.id ?? "") \(user.name ?? "") \(user.role ?? "") \(user.email ?? "") \(user.consultantRole ?? "")")
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
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Deque Reuseable Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserTableViewCell
        
        //Fill User into Table view
        let user = users[indexPath.row]
        
        cell.userName.text = user.name
        cell.userEmail.text = user.email
        
        //Switch on if it is the Consultant and off otherwise
        if user.role == "User" {
            cell.switchRole.setOn(false, animated: true)
            cell.generalBtn.isEnabled = false
            cell.loveBtn.isEnabled = false
            cell.stressBtn.isEnabled = false
            cell.depressBtn.isEnabled = false
            
        }
        else if user.role == "Consultant" {
            cell.switchRole.setOn(true, animated: true)
            cell.generalBtn.isEnabled = true
            cell.loveBtn.isEnabled = true
            cell.stressBtn.isEnabled = true
            cell.depressBtn.isEnabled = true
        }
        
        if user.consultantRole == "General" {
            cell.generalBtn.isSelected = true
        }
        else if user.consultantRole == "Love" {
            cell.loveBtn.isSelected = true
        }
        else if user.consultantRole == "Stress" {
            cell.stressBtn.isSelected = true
        }
        else if user.consultantRole == "Depress" {
            cell.depressBtn.isSelected = true
        }
        else {
            cell.generalBtn.isSelected = false
            cell.loveBtn.isSelected = false
            cell.stressBtn.isSelected = false
            cell.depressBtn.isSelected = false
        }
        
        //Create storage reference
        let imgStorageRef = Storage.storage().reference(forURL: user.avatar!)
        //Observe method to download the data (4MB)
        imgStorageRef.getData(maxSize: 4 * 1024 * 1024) { (data, error) in
            if let error = error {
                print("UserTableViewController: Download Iamge: Error !!! \(error)")
            } else {
                if let imageData = data {
                    DispatchQueue.main.async {
                        //put Image to imageView in cell
                        let image = UIImage(data: imageData)
                        cell.userAvarta.image = image
                        cell.userAvarta.layer.cornerRadius = cell.userAvarta.frame.size.width / 2
                        cell.userAvarta.clipsToBounds = true
                    }
                    
                }
            }
        }
        cell.delegate = self
        return cell
    }
    
    //Switch Role function
    func switchRoleChanged(sender: UserTableViewCell, check: Bool) {
        if let indexPath = tableView.indexPath(for: sender) {
            //If the switch is on so the person will be the consultant
            if check {
                refUser.child(users[indexPath.row].id!).child("role").setValue("Consultant")
                sender.depressBtn.isEnabled = true
                sender.stressBtn.isEnabled = true
                sender.loveBtn.isEnabled = true
                sender.generalBtn.isEnabled = true
                if users[indexPath.row].consultantRole == "" {
                    sender.generalBtn.isSelected = false
                    sender.loveBtn.isSelected = false
                    sender.stressBtn.isSelected = false
                    sender.depressBtn.isSelected = false
                }
            }
                //If the switch is off so the person will be the user
            else {
                refUser.child(users[indexPath.row].id!).child("role").setValue("User")
                refUser.child(users[indexPath.row].id!).child("consultantRole").setValue("")
                sender.depressBtn.isEnabled = false
                sender.stressBtn.isEnabled = false
                sender.loveBtn.isEnabled = false
                sender.generalBtn.isEnabled = false

            }
            
        }
        
    }
    // Consultant Role change
    func consultantRoleChanged(sender: UserTableViewCell, tag: Int) {
        if let indexPath = tableView.indexPath(for: sender) {
            if tag == 1 {
                refUser.child(users[indexPath.row].id!).child("consultantRole").setValue("General")
            }
            else if tag == 2 {
                refUser.child(users[indexPath.row].id!).child("consultantRole").setValue("Love")
            }
            else if tag == 3 {
                refUser.child(users[indexPath.row].id!).child("consultantRole").setValue("Stress")
            }
            else if tag == 4 {
                refUser.child(users[indexPath.row].id!).child("consultantRole").setValue("Depress")
            }
        }
    }

    // MARK: - Navigation
    // Go back to Log in View
    @objc func handleLogout() {
        print("UserTableViewController: Logout navigation: Pressed")
        //create main storyboard instance
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        //from main storyboard instantiate navigation controller
        let naviVC = storyboard.instantiateViewController(withIdentifier: "logInCV")
        present(naviVC, animated: true, completion: nil)
    }
    
}
