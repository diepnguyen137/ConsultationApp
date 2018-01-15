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

class NewPostController: UIViewController ,UITextFieldDelegate{

    @IBOutlet weak var questionText: UITextField!
    @IBOutlet weak var solutionText: UITextField!
    var postRef : DatabaseReference!
    var topic:String!
    var post:Post?
    
    @IBOutlet weak var saveBttn: UIBarButtonItem!
    @IBAction func saveBtn(_ sender: Any) {
        let post = Post()
        post.question = self.questionText.text! as String
        post.solution = self.solutionText.text! as String
        post.topic = self.topic
        post.userID = Auth.auth().currentUser?.uid
        
        let key  = postRef.childByAutoId().key
        postRef.child(key).setValue(self.post?.toAnyObject())
        
        print("New PC: Save Btn ", self.post?.question)
        performSegue(withIdentifier: "savedPost", sender: self)
    }
    
    @IBAction func cancelBtn(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postRef = Database.database().reference().child("posts")
        
        // Enable the Save button only if the text field has a valid question.
        updateSaveButtonState()
        questionText.delegate = self
        solutionText.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITextFieldDelegate
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
        
        switch(segue.identifier ?? "") {
        case "savedPost":
        guard let PostDetailViewController = segue.destination as? DetailController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
        
        PostDetailViewController.post = self.post
        
        default:
        fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
    }

    }
    

    //MARK: Private Methods
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        if questionText.text != "" && solutionText.text != "" {
            saveBttn.isEnabled = true
        }
        
    }
}
