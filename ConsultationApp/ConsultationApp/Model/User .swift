//
//  User .swift
//  ConsultationApp
//
//  Created by admin on 1/8/18.
//  Copyright © 2018 cosc2659. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class User: NSObject {
    //Properties
    var id : String?
    var email: String?
    var name : String?
    var password: String?
    var role: String?
    var avatar: String?
    
//    init?(email: String, name: String, password:String, role: String, avatar: String) {
//        if email.isEmpty || password.isEmpty || name.isEmpty {
//            return nil
//        }
//        self.email = email
//        self.name = name
//        self.password = password
//        self.role = role
//        self.avatar = avatar
//    }
//    
//    init?(snapshot: DataSnapshot){
//        guard let dict =  snapshot.value as? [String:Any] else { return nil }
//        guard let email = dict["email"] as? String else { return nil }
//        guard let name = dict["name"] as? String else { return nil }
//        guard let password = dict["password"] as? String else { return nil }
//        guard let role = dict["role"] as? String else { return nil }
//        guard let avatar = dict["avatar"] as? String else { return nil }
//        
//        self.email = email
//        self.name = name
//        self.password = password
//        self.role = role
//        self.avatar = avatar
//    }
//    
//    convenience override init() {
//        self.init(email:"", name: "", password: "",role: "",avatar: "")!
//    }
    
    //convert into Dictionary
    func toAnyObject () ->[ String : Any] {
        return ["email": email ?? "", "name": name ?? "", "password": password ?? "", "role":role ?? "", "avatar": avatar ?? "" ]
    }
}
