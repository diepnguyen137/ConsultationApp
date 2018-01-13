//
//  NewPostController.swift
//  ConsultationApp
//
//  Created by Tony Tom on 1/12/18.
//  Copyright © 2018 cosc2659. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class NewPostController: UIViewController {

    @IBOutlet weak var questionText: UITextField!
    @IBOutlet weak var solutionText: UITextField!
    var postRef : DatabaseReference!
    
    @IBAction func saveBtn(_ sender: Any) {
        
        let post = Post()
        post.question = self.questionText.text! as String
        post.solution = self.solutionText.text! as String
        post.userID = Auth.auth().currentUser?.uid as? String
        
        let key  = postRef.childByAutoId().key
        postRef.child(key).setValue(post.toAnyObject())
        
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postRef = Database.database().reference().child("posts")
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
