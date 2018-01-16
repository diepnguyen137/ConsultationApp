//
//  DetailController.swift
//  ConsultationApp
//
//  Created by Tony Tom on 1/13/18.
//  Copyright © 2018 cosc2659. All rights reserved.
//

import UIKit

class DetailController: UIViewController {

    @IBOutlet weak var questionTV: UITextView!
    @IBOutlet weak var solutionTV: UITextView!
    var post:Post?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //print("DetailView:", post?.question ?? "")
        //let postController = PostController()
        //let post = postController.posts
        //print(post)
        //let question = post?.question as! String?
//        print("DetailView: Question: ", question)
        questionTV.text = post?.question
        solutionTV.text = post?.solution
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        
    }
    

}
