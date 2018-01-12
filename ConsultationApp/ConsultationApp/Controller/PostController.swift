//
//  QuestionTableViewController.swift
//  Sth2Delete
//
//  Created by Tony Tom on 1/12/18.
//  Copyright © 2018 Tran Trong Tri. All rights reserved.
//

import UIKit
import FirebaseDatabase

class PostController: UITableViewController {

    //MARK: Properties
    
    var problems = [Problem]()
    var refPost:DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refPost = Database.database().reference().child("posts")
        
        // Load the sample data.
        //loadSampleProblems()
        fetchData()
        

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
        return problems.count
    }

    //Firebase fetch data
    func fetchData(){
        refPost.observe(.childAdded, with: { (snapshot) in
            
            print("Firebase: Post found")
            print("Firebase: \(snapshot)")
            
            // Add all user to dictionary for Swift 4
            if let dictionary = snapshot.value as? NSDictionary {
                let problem = Problem()
                problem.question = dictionary["question"] as? String ?? ""
                problem.solution = dictionary["answer"] as? String ?? ""
                problem.userID = dictionary["userID"] as? String ?? ""
                
                
                print("Firebase: post: \(problem.question ?? "") \(problem.solution ?? "") \(problem.userID ?? "")")
                // Add user to users arraylist
                self.problems.append(problem)
                
                // Reload data and avoid crashing
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }, withCancel: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? QuestionCell  else {
            fatalError("The dequeued cell is not an instance of QuestionCell.")
        }
        
        // Fetches the appropriate problem for the data source layout.
        let problem = problems[indexPath.row]
        
        cell.nameLabel.text = "Question"
        cell.sample.text = problem.question
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    //MARK: Private Methods
    
//    private func loadSampleProblems() {
//
//        let problem1 = Problem(question: "How can I ...", solution: "You can either do this or that to ...")
//        let problem2 = Problem(question: "What is the best way to ...", solution: "You need to ...")
//
//        problems += [problem1, problem2]
//    }
    
}
