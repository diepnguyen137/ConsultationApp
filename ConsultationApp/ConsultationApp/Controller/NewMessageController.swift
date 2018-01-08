//
//  NewMessageController.swift
//  ConsultationApp
//
//  Created by Thien Ho on 1/6/18.
//  Copyright © 2018 cosc2659. All rights reserved.
//

import UIKit
import FirebaseDatabase

class NewMessageController: UITableViewController {
    let celId = "cellId"
    
    // Create User array
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
            
            // Get name
//            let dictionary = snapshot.value as? [String: Any]
//            print(dictionary!["name"] as! String)
            
            // Add all user to dictionary for Swift 4
            if let dictionary = snapshot.value as? NSDictionary {
                let name = dictionary["name"] as? String ?? ""
                let email = dictionary["email"] as? String ?? ""
                let user = User(name: name, email: email)
                
                print("Firebase: User: \(user.name) \(user.email)")
                
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

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Deque Reuseable Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: celId, for: indexPath)
        
        // Fill User in to TableRow
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

     // Return to MessagesController
     @objc func handleCancel(){
     dismiss(animated: true, completion: nil)
     }
     
    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
    

}

class UserCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
