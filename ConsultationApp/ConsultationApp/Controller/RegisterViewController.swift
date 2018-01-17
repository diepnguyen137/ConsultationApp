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
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class RegisterViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate {
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
        
        usernameTxtField.delegate = self
        emailTxtField.delegate = self
        passTxtField.delegate = self
    }
    //Action
    @IBAction func registerBtnTapped(_ sender: Any) {
        if self.emailTxtField.text != nil && self.passTxtField.text != nil {
            //Register with email 
            Auth.auth().createUser(withEmail: self.emailTxtField.text!, password: self.passTxtField.text!) { (newUser, error) in
                if error != nil {
                   print("RegisterViewController: Register Fail")
                }
                else {
                    let user = User()
                    user.name = self.usernameTxtField.text! as String
                    user.email = self.emailTxtField.text! as String
                    user.password = self.passTxtField.text! as String
                    user.role = "User"
                    user.consultantRole = "General"
                    
                    
                    let imageName = UUID().uuidString
                    let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).jpg")
                    
                    if let profileImage = self.avatar.image, let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) {
                        
                        storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                            if error != nil {
                                print(error ?? "")
                                return
                            }
                            if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                                user.avatar = profileImageUrl
                                //Store in Firebase
                                let key = newUser?.uid as String?
                                self.refUser.child(key!).setValue(user.toAnyObject())
                                print("RegisterViewController: Register Successfully")
                            }
                        })
                    }
                }
                
            }
        }
    }

    @IBAction func selectImageFromLibrary(_ sender: UITapGestureRecognizer) {
        // Hide the keyboard.
        usernameTxtField.resignFirstResponder()
        emailTxtField.resignFirstResponder()
        passTxtField.resignFirstResponder()
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        avatar.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTxtField {
            usernameTxtField.resignFirstResponder()
            emailTxtField.becomeFirstResponder()
            
        } else if textField == emailTxtField {
            emailTxtField.resignFirstResponder()
            passTxtField.becomeFirstResponder()
        }
        else if textField == passTxtField {
            passTxtField.resignFirstResponder()
        }
        
        return true
    }


}
