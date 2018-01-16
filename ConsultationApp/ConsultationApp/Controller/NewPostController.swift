//
//  NewPostController.swift
//  ConsultationApp
//
//  Created by Tony Tom on 1/12/18.
//  Copyright © 2018 cosc2659. All rights reserved.
//

import UIKit
import os.log
import FirebaseDatabase
import FirebaseAuth

class NewPostController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var questionText: UITextField!
    @IBOutlet weak var solutionText: UITextField!
    var postRef : DatabaseReference!
    var userRef: DatabaseReference!
    var post:Post?
    var uid: String?
    var topic:String?
    
    @IBOutlet weak var saveBttn: UIBarButtonItem!
    @IBAction func saveBtn(_ sender: Any) {
        //performSegue(withIdentifier: "savedPost", sender: self)
    }
    
    @IBAction func cancelBtn(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddPostMode = presentingViewController is UINavigationController
        
        if isPresentingInAddPostMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The PostViewController is not inside a navigation controller.")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Enable the Save button only if the text field has a valid question.
        questionText.delegate = self
        solutionText.delegate = self
        
        // Set up views if editing an existing Post.
        if let post = post {
            navigationItem.title = "Edit Case"
            questionText.text = post.question
            solutionText.text = post.solution
            print(post.key)
        }
        
        updateSaveButtonState()
        uid = Auth.auth().currentUser?.uid
        print("New Post Controller: Curren UID", uid)

        
        postRef = Database.database().reference().child("posts")
        userRef = Database.database().reference().child("users")
        fetchUser()
        
        // Do any additional setup after loading the view.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func fetchUser(){
        userRef.child(self.uid!).observeSingleEvent(of: .value) { (snapshot) in
            print("New Post Controller: Snapshot value: ", snapshot)
            if let dictionary = snapshot.value as? NSDictionary  {
                let user = User()
                user.consultantRole = dictionary["consultantRole"] as? String ?? ""
                self.topic = user.consultantRole
                
                print("New Post controller: User Consultant Role ", user.consultantRole)
                print("New Post controller: Topic ", self.topic)
                
               
            }
        }
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveBttn.isEnabled = false
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button == saveBttn
            else{
                os_log("The button is not pressed, cancelling", log: OSLog.default, type: .debug)
                return
                
        }
        print("New PC: Save btn pressed")
        //fetchUser()
        if post == nil {
            let key  = postRef.childByAutoId().key
            let post = Post()
            post.question = questionText.text
            post.solution = solutionText.text
            post.topic = self.topic
            print("New Post controller: Topic ", self.topic)
            
            post.userID = Auth.auth().currentUser?.uid
            post.key = postRef.childByAutoId().key
            
            postRef.child(key).setValue(post.toAnyObject())
        }
        else {
            let key  = self.post?.key
            let post = Post()
            post.question = questionText.text
            post.solution = solutionText.text
            post.topic = self.topic
            print("Update Edit Post controller: Topic ", self.topic)
            
            post.userID = Auth.auth().currentUser?.uid
            
            postRef.child(key!).setValue(post.toAnyObject())
        }
        

    }
    

    //MARK: Private Methods
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text1 = questionText.text ?? ""
        let text2 = solutionText.text ?? ""
        saveBttn.isEnabled = (!text1.isEmpty && !text2.isEmpty)
        
    }
}
