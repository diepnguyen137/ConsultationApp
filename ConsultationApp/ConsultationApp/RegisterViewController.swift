//
//  RegisterViewController.swift
//  ConsultationApp
//
//  Created by admin on 1/5/18.
//  Copyright © 2018 cosc2659. All rights reserved.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var emailTxtField: UITextField!
    
    @IBOutlet weak var passTxtField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        registerBtn.layer.borderWidth = 2.0
        registerBtn.layer.borderColor = UIColor.white.cgColor
    }
    
    @IBAction func registerBtnTapped(_ sender: Any) {
        if self.emailTxtField.text != nil && self.passTxtField.text != nil {
            Auth.auth().createUser(withEmail: self.emailTxtField.text!, password: self.passTxtField.text!) { (user, error) in
                if error == nil {
                    print("You have successfully signed up")
                }
                else {
                    print("Signed up error")
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
