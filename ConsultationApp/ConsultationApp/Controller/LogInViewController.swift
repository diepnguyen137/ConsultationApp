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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        logInBtn.layer.borderWidth = 2.0
        logInBtn.layer.borderColor = UIColor.white.cgColor
        
        userTxtField.delegate = self
        passwdTxtField.delegate = self
  
        
        // FIXME: For testing
        userTxtField.text = adminUsername
        passwdTxtField.text = adminPass
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logInBtnTapped(_ sender: Any) {
        if userTxtField.text != nil && passwdTxtField.text != nil {
            Auth.auth().signIn(withEmail: self.userTxtField.text!, password: self.passwdTxtField.text!){
                (user, error) in
                if error == nil {
                    print("Log in successfully")
                    
                    // TODO: Show MessagesController
                    let messagesController = UINavigationController(rootViewController: MessagesController())
                    self.present(messagesController, animated: true, completion: nil)
                }
                else {
                    print("Account isn't available")
                }
            }
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
