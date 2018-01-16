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
    var topic:String!
    var post:Post?
    
    @IBOutlet weak var saveBttn: UIBarButtonItem!
    @IBAction func saveBtn(_ sender: Any) {
        
        let key  = postRef.childByAutoId().key
        postRef.child(key).setValue(self.post?.toAnyObject())
        
        print("New PC: Save Btn ", self.post?.question! as Any)
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
        print(topic)
        // Enable the Save button only if the text field has a valid question.
        questionText.delegate = self
        solutionText.delegate = self
        
        // Set up views if editing an existing Post.
        if let post = post {
            navigationItem.title = "Edit Case"
            questionText.text = post.question
            solutionText.text = post.solution
        }
        
        updateSaveButtonState()
        
        postRef = Database.database().reference().child("posts")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        let post = Post()
        post.question = self.questionText.text! as String
        post.solution = self.solutionText.text! as String
        post.topic = self.topic
        post.userID = Auth.auth().currentUser?.uid
        
        print("NewPostController: Save Btn ", self.post?.question! as Any)

    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        
//        switch(segue.identifier ?? "") {
//        case "savedPost":
//        guard let PostDetailViewController = segue.destination as? DetailController else {
//            fatalError("Unexpected destination: \(segue.destination)")
//        }
//        PostDetailViewController.post = self.post
//        
//        default:
//        fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
//        }

    }
    

    //MARK: Private Methods
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text1 = questionText.text ?? ""
        let text2 = solutionText.text ?? ""
        saveBttn.isEnabled = (!text1.isEmpty && !text2.isEmpty)
        
    }
}
