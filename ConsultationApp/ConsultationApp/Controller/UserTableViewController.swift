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

class UserTableViewController: UITableViewController {
    
    //Properties
    var users = [User]()

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
        cell.userName.text = user.name
        cell.userEmail.text = user.email
        if user.role == "User" {
            cell.switchRole.setOn(false, animated: false)
            
        }
        else if user.role == "Consultant" {
            cell.switchRole.setOn(true, animated: false)
        }
//        URLSession.shared.dataTask(with: NSURL(string: user.avatar!) as! URL) { (data, response, error) in
//            if error != nil {
//                print ("Error")
//            }
//            DispatchQueue.main.async(execute: {
//                let image = UIImage(data : data!)
//                cell.userAvarta.image = image
//            })
//            
//            
//        }
        return cell
    }

    
    // MARK: - Navigation
    // Go back to Log in View
    @objc func handleLogout() {
        print("UserTableViewController: Logout navigation: Pressed")
        let loginController = LogInViewController()
        self.present(loginController, animated: true, completion: nil)
    }
    
}
