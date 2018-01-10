//
//  LogInViewController.swift
//  ConsultationApp
//
//  Created by admin on 1/5/18.
//  Copyright © 2018 cosc2659. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class LogInViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var logInBtn: UIButton!
    @IBOutlet weak var userTxtField: UITextField!
    @IBOutlet weak var passwdTxtField: UITextField!
    
    var adminUsername:String = "admin"
    var adminPass:String = "admin"
    
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        logInBtn.layer.borderWidth = 2.0
        logInBtn.layer.borderColor = UIColor.white.cgColor
        
        userTxtField.delegate = self
        passwdTxtField.delegate = self
        
        fetchUser()
        
        userTxtField.text = "admin"
        passwdTxtField.text = "admin"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchUser() {
        // Read user information from Database
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
//
//            print("Firebase: User found")
//            print("Firebase: \(snapshot)")
            
            // Add all user to dictionary for Swift 4
            if let dictionary = snapshot.value as? NSDictionary {
                let user = User ()
                user.email = dictionary["email"] as? String ?? ""
                user.password = dictionary["password"] as? String ?? ""
                user.role = dictionary["role"] as? String ?? ""
                print("Firebase: User: \(user.id ?? "") \(user.name ?? "") \(user.role ?? "") \(user.email ?? "")")
                // Add user to users arraylist
                self.users.append(user)
            }
        }, withCancel: nil)
        
    }
    
    @IBAction func logInBtnTapped(_ sender: Any) {
        if userTxtField.text != nil && passwdTxtField.text != nil {
            //Log in as User/Consultant
            for user in users {
                if (userTxtField.text == user.email && passwdTxtField.text == user.password) {
                    if (user.role == "Consultant") {
                        print("Log in: as Consultant")
                    }
                    else {
                        print("Log in: as User")
                    }
                }
            }
            //Log in as Admin
            if userTxtField.text == adminUsername && passwdTxtField.text == adminPass {
                //create main storyboard instance
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                //from main storyboard instantiate navigation controller
                let naviVC = storyboard.instantiateViewController(withIdentifier: "userListVC") as! UINavigationController
                //Get the app delegate
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                //Set navigation controller as root view controller
                appDelegate.window?.rootViewController = naviVC
            }
            else {
                print("Not Admin")
            }
            
        }
    }
    
    @IBAction func registerBtnTapped(_ sender: Any) {
        
        //switch view by setting navigation view as root view controller
        
        //create main storyboard instance
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        //from main storyboard instantiate navigation controller
        let naviVC = storyboard.instantiateViewController(withIdentifier: "navigationVC") as! UINavigationController
        //Get the app delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //Set navigation controller as root view controller
        appDelegate.window?.rootViewController = naviVC
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userTxtField {
            userTxtField.resignFirstResponder()
            passwdTxtField.becomeFirstResponder()
        } else {
            passwdTxtField.resignFirstResponder()
        }
        
        return true
    }

}
