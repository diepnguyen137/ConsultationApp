//
//  User.swift
//  ConsultationApp
//
//  Created by Thien Ho on 1/7/18.
//  Copyright © 2018 cosc2659. All rights reserved.
//

import UIKit
import FirebaseDatabase

class User: NSObject {
     var name: String
     var email: String
    
    init(name: String, email: String) {
        self.name = name
        self.email = email
    }
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String:Any] else { return nil }
        guard let name = dict["name"] as? String else { return nil }
        guard let email = dict["email"] as? String else { return nil }
        
        self.name = name
        self.email = email
    }
    convenience override init() {
        self.init(name: "", email: "")
    }
}
