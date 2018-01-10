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

class UserTableViewController: UITableViewController {
    
    //Properties
    var users = [User]()
    var selectIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(handleLogout))
        self.navigationItem.title = "Admin"
        
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
                
                
                print("Firebase: User: \(user.id ?? "") \(user.name ?? "") \(user.role ?? "") \(user.email ?? "")")
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
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Deque Reuseable Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserTableViewCell
        
        //Fill User into Table view
        let user = users[indexPath.row]
        selectIndex = indexPath.row
        
        cell.userName.text = user.name
        cell.userEmail.text = user.email
        if user.role == "User" {
            cell.switchRole.setOn(false, animated: true)
            
        }
        else if user.role == "Consultant" {
            cell.switchRole.setOn(true, animated: true)
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

        return cell
    }
    
    // MARK: - Navigation
    // Go back to Log in View
    @objc func handleLogout() {
        print("UserTableViewController: Logout navigation: Pressed")
        // For login controller Swift 4: Connect to ViewController In MainStoryboard programmatically
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "logInCV")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
