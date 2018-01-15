//
//  TopicController.swift
//  ConsultationApp
//
//  Created by Tony Tom on 1/15/18.
//  Copyright © 2018 cosc2659. All rights reserved.
//

import UIKit
import FirebaseDatabase

class TopicController: UITableViewController {

    var users = ["Love", "Stress", "Depress"]
    var refUser: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        refUser = Database.database().reference().child("users")
//        fetchUserData()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "topicCell", for: indexPath)

        cell.textLabel?.text = users[indexPath.row]
        
        if cell.textLabel?.text == "Love" {
            cell.textLabel?.textColor = UIColor.magenta
        }
        else if cell.textLabel?.text == "General" {
            cell.textLabel?.textColor = UIColor.green
        }
        else if cell.textLabel?.text == "Stress" {
            cell.textLabel?.textColor = UIColor.blue
        }
        else if cell.textLabel?.text == "Depress" {
            cell.textLabel?.textColor = UIColor.red
        }
        return cell
    }
    

//    func fetchUserData(){
//        refUser.observe(.childAdded, with: { (snapshot) in
//            // Add all user to dictionary for Swift 4
//            if let dictionary = snapshot.value as? NSDictionary {
//                let user = User()
//
//                user.name = dictionary["name"] as? String ?? ""
//                user.consultantRole = dictionary["consultantRole"] as? String ?? ""
//                user.role = dictionary["role"] as? String ?? ""
//                user.id = snapshot.key
//
//                print("Firebase: User: \(user.consultantRole ?? "") \(user.name ?? "") \(user.role ?? "") \(user.id ?? "")")
//                // Add user to users arraylist
//                if user.role == "Consultant" {
//                    self.users.append(user)
//
//
//                }
//
//                // Reload data and avoid crashing
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
//            }
//        }, withCancel: nil)
//
//    }
    
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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
        case "choosedTopic":
            guard let postViewController = segue.destination as? PostController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedTopicCell = sender as? UITableViewCell  else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedTopicCell ) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedTopic = users[indexPath.row]
            postViewController.topic = selectedTopic
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
    }
        
    }
    

}
