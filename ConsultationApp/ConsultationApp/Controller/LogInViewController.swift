/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2017C
 Assignment: 3
 Author: Ho Phu Thien- Tran Trong Tri- Nguyen Tran Ngoc Diep
 ID: s3574966-s3533437- s3519039
 Created date: 26/12/2017
 Acknowledgement:
 -Thien
 Client-side fan-out for data consistency
 https://firebase.googleblog.com/2015/10/client-side-fan-out-for-data-consistency_73.html
 Programmatically creating UITabBarController in Swift
 https://medium.com/ios-os-x-development/programmatically-creating-uitabbarcontroller-in-swift-e957cd35cfc4
 Programmatically Creating Constraints
 https://developer.apple.com/library/content/documentation/UserExperience/Conceptual/AutolayoutPG/ProgrammaticallyCreatingConstraints.html
 iOS Notes 19 : How to push and present to ViewController programmatically ? [ How to switch VC ]
 https://freakycoder.com/ios-notes-19-how-to-push-and-present-to-viewcontroller-programmatically-how-to-switch-vc-8f8f65b55c7b
 Create UITabBarController programmatically
 http://swiftdeveloperblog.com/code-examples/create-uitabbarcontroller-programmatically/
 UINavigationController And UITabBarController Programmatically (Swift 3)
 https://medium.com/@ITZDERR/uinavigationcontroller-and-uitabbarcontroller-programmatically-swift-3-d85a885a5fd0
 -Diep
 Delegate Protocol for custom cell
 https://www.youtube.com/watch?v=3Rrzm9ZXdds
 DLRadioButton
 https://github.com/DavydLiu/DLRadioButton
 Pass Data Between View Controllers
 https://www.youtube.com/watch?v=7fbTHFH3tl4
 -Tri
 https://developer.apple.com/library/content/referencelibrary/GettingStarted/DevelopiOSAppsSwift/index.html#//apple_ref/doc/uid/TP40015214-CH2-SW1
 */

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
                    let customTabBarController = CustomTabBarController()
                    self.present(customTabBarController, animated: true, completion: nil)
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
