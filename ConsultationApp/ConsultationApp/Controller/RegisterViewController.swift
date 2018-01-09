//
//  RegisterViewController.swift
//  ConsultationApp
//
//  Created by admin on 1/5/18.
//  Copyright © 2018 cosc2659. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class RegisterViewController: UIViewController {
    @IBOutlet weak var registerBtn: UIButton!
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var usernameTxtField: UITextField!
    
    @IBOutlet weak var emailTxtField: UITextField!
    
    @IBOutlet weak var passTxtField: UITextField!
    var refUser : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        refUser = Database.database().reference().child("users")
        
        registerBtn.layer.borderWidth = 2.0
        registerBtn.layer.borderColor = UIColor.white.cgColor
    }
    
    @IBAction func registerBtnTapped(_ sender: Any) {
        if self.emailTxtField.text != nil && self.passTxtField.text != nil {
            //Generate automatic key
            let key = refUser.childByAutoId().key
            
            //Register with email 
            Auth.auth().createUser(withEmail: self.emailTxtField.text!, password: self.passTxtField.text!) { (user, error) in
                if error == nil {
                    print("RegisterViewController: Register button: Pressed")
                    let user = User()
                    user.name = self.usernameTxtField.text! as String
                    user.email = self.emailTxtField.text! as String
                    user.password = self.passTxtField.text! as String
                    user.role = "User"
                    user.avatar = " "
        
                    //Store in Firebase
                    self.refUser.child(key).setValue(user.toAnyObject())
                    print("RegisterViewController: Register Successfully")
                }
                else {
                    print("RegisterViewController: Register Fail")
                }
            }
        }
    }
    @IBAction func cancelTapped(_ sender: Any) {
        //create main storyboard instance
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        //from main storyboard instantiate View controller
        let naviVC = storyboard.instantiateViewController(withIdentifier: "logInCV") as! LogInViewController
        //Get the app delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //Set navigation controller as root view controller
        appDelegate.window?.rootViewController = naviVC
        
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
