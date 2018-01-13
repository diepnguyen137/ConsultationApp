//
//  QuestionTableViewController.swift
//  Sth2Delete
//
//  Created by Tony Tom on 1/12/18.
//  Copyright © 2018 Tran Trong Tri. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage


class PostController: UITableViewController , PostCellDelegate{
  
    

    //MARK: Properties
    
    var posts = [Post]()
    var role: String!
    var refPost:DatabaseReference!
    var refUser:DatabaseReference!
    
    @IBOutlet weak var addBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refPost = Database.database().reference().child("posts")
        refUser = Database.database().reference().child("users")
        
        fetchPostData()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
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
        return posts.count
    }

    //Firebase fetch data
    func fetchPostData(){
        refPost.observe(.childAdded, with: { (snapshot) in
            
            print("Firebase: Post found")
            print("Firebase: \(snapshot)")
            
            // Add all user to dictionary for Swift 4
            if let dictionary = snapshot.value as? NSDictionary {
                let post = Post()
                post.question = dictionary["question"] as? String ?? ""
                post.solution = dictionary["answer"] as? String ?? ""
                post.userID = dictionary["userID"] as? String ?? ""
                
                
                print("Firebase: post: \(post.question ?? "") \(post.solution ?? "") \(post.userID ?? "")")
                // Add user to users arraylist
                self.posts.append(post)
                
                // Reload data and avoid crashing
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }, withCancel: nil)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PostCell  else {
            fatalError("The dequeued cell is not an instance of PostCell.")
        }
        
        // Fetches the appropriate problem for the data source layout.
        let post = posts[indexPath.row]
        let uid = posts[indexPath.row].userID
    
        cell.questionTView.text = post.question
        cell.solutionTView.text = post.solution
        
        refUser.child(uid!).observe(.value, with: { (snapshot) in
            
            print("PostController: Firebase: User found")
            print("PostController: Firebase: \(snapshot)")
            
//            // Add all user to dictionary for Swift 4
            if let dictionary = snapshot.value as? NSDictionary {
                let user = User()
                
                user.name = dictionary["name"] as? String ?? ""
                user.email = dictionary["email"] as? String ?? ""
                user.avatar = dictionary["avatar"] as? String ?? ""
                user.consultantRole = dictionary["consultantRole"] as? String ?? ""
                user.role = dictionary["role"] as? String ?? ""


//                print("PostController: tableViewCell: ", self.user?.name)
                print("PostController: tableViewCell: user: \(user.name ?? "") \(user.email ?? "") \(user.consultantRole ?? "")")
                cell.username.text = user.name
                cell.userEmail.text = user.email
                cell.consultantRole.text = user.consultantRole
                
                if user.role == "User" {
                    self.addBtn.isEnabled = false
                }
                if user.consultantRole == "Love" {
                    cell.consultantRole.textColor = UIColor.magenta
                }
                else if user.consultantRole == "General" {
                    cell.consultantRole.textColor = UIColor.green
                }
                else if user.consultantRole == "Stress" {
                    cell.consultantRole.textColor = UIColor.blue
                }
                else if user.consultantRole == "Depress" {
                    cell.consultantRole.textColor = UIColor.red
                }
                
                
                let imgStorageRef = Storage.storage().reference(forURL: user.avatar!)
                //Observe method to download the data (4MB)
                imgStorageRef.getData(maxSize: 4 * 1024 * 1024) { (data, error) in
                    if let error = error {
                        print("Download Iamge: Error !!! \(error)")
                    } else {
                        if let imageData = data {
                            DispatchQueue.main.async {
                                //put Image to imageView in cell
                                let image = UIImage(data: imageData)
                                cell.avatar.image = image
                                //Make circle image
                                cell.avatar.layer.cornerRadius = cell.avatar.frame.size.width / 2
                                cell.avatar.clipsToBounds = true

                            }
                            
                        }
                    }
                }
            }
        }, withCancel: nil)
       

        if cell.solutionTView.text.count < 100 {
            cell.show.isEnabled = false
            cell.show.isHidden = true
            
        }
        cell.delegate = self
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

    func showDetail(sender: PostCell) {
        
                guard let indexPath = tableView.indexPath(for: sender) else {
                    fatalError("The selected cell is not being displayed by the table")
                }
        
                let detailController = DetailController()

                let selectedPost = posts[indexPath.row]
                detailController.post = selectedPost
        
                print("Post Controller: show Detail ", selectedPost.question)
        
                //Go to ChatLogController
                //navigationController?.pushViewController(detailController, animated: true)

            }
    
    
    // MARK: - Navigation

//    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
        case "showDetail":
           
            guard let PostDetailViewController = segue.destination as? DetailController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedPostCell = sender as? PostCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedPostCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedPost = posts[indexPath.row]
            PostDetailViewController.post = selectedPost
        
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }



}
}
