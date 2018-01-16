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
