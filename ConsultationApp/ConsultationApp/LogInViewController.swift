//
//  LogInViewController.swift
//  ConsultationApp
//
//  Created by admin on 1/5/18.
//  Copyright © 2018 cosc2659. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {

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
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logInBtnTapped(_ sender: Any) {
        
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
            print("Not admin")
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

}
