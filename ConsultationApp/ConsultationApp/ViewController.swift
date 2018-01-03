//
//  ViewController.swift
//  ConsultationApp
//
//  Created by admin on 12/26/17.
//  Copyright © 2017 cosc2659. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ViewController: UIViewController {
 
    @IBOutlet weak var label: UILabel!
    
    
    var ref : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        ref = Database.database().reference()
        
        // Write into Firebase
//        self.ref.child("Thien").setValue(["Test": "OK"])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Read from Firebase
        ref.child("Thien").observe(DataEventType.value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let data = value?["Test"] as? String ?? ""
            print("Firebase: Output: " + data)
            self.label.text = data
        }) { (error: Error) in
            debugPrint("Firebase: Error: " + error.localizedDescription)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

