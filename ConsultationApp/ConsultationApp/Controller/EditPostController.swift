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
import FirebaseAuth

class EditPostController: UITableViewController {

    var user: User?
    var posts = [Post]()
    var refPost:DatabaseReference!
    var refUser:DatabaseReference!
    

    @IBAction func editBtn(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        refPost = Database.database().reference().child("posts")
        refUser = Database.database().reference().child("users")
        
        fetchPostData()
        tableView.allowsMultipleSelectionDuringEditing = true
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }

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
                post.topic = dictionary["topic"] as? String ?? ""
                post.key = snapshot.key
                
                print("Firebase: post: \(post.question ?? "") \(post.solution ?? "") \(post.userID ?? "") \(post.topic ?? "")")
                // Add user to users arraylist
                if(post.userID == Auth.auth().currentUser?.uid){
                    self.posts.append(post)
                    print("Firebase post: Array Post", post)
                }
              
                
                // Reload data and avoid crashing
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }, withCancel: nil)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "editCell", for: indexPath) as? PostCell  else {
            fatalError("The dequeued cell is not an instance of EditCell.")
        }
        
        // Fetches the appropriate problem for the data source layout.
        let post = posts[indexPath.row]
        //Take UID of the consultant who create the post
        let uid = posts[indexPath.row].userID
        
        cell.questionTView.text = post.question
        cell.solutionTView.text = post.solution
        
        //Fetch user information that create the post
        refUser.child(uid!).observe(.value, with: { (snapshot) in
            
            print("EditPostController: Firebase: User found")
            print("EditPostController: Firebase: \(snapshot)")
            
            // Add all user to dictionary for Swift 4
            if let dictionary = snapshot.value as? NSDictionary {
                let user = User()
                
                user.name = dictionary["name"] as? String ?? ""
                user.email = dictionary["email"] as? String ?? ""
                user.avatar = dictionary["avatar"] as? String ?? ""
                user.consultantRole = dictionary["consultantRole"] as? String ?? ""
                user.role = dictionary["role"] as? String ?? ""
                
                
                print("PostController: tableViewCell: user: \(user.name ?? "") \(user.email ?? "") \(user.consultantRole ?? "")")
                cell.username.text = user.name
                cell.userEmail.text = user.email
                
                //Download avatar image from Firebase Storage
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
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //Delete post from database
        if editingStyle == .delete {
            let key  = posts[indexPath.row].key
            refPost.child(key!).setValue(nil)
            fetchPostData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    
    // MARK: - Navigation
    @IBAction func unwindToCaseList(sender: UIStoryboardSegue) {
        let indexPath = tableView.indexPathForSelectedRow
        //tableView.reloadRows(at: [indexPath!], with: .none)
        //refPost.child(key!).setValue(selectedPost.toAnyObject())        
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "addNewPost":
            print("edit your own posts")
            
        case "editDetail":
            guard let editDetailViewController = segue.destination as? NewPostController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedPostCell = sender as? PostCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedPostCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedPost = posts[indexPath.row]
            editDetailViewController.post = selectedPost
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }

}
