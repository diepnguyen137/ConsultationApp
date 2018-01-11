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
    
    //convert into Dictionary
    func toAnyObject () ->[ String : Any] {
        return ["email": email ?? "", "name": name ?? "", "password": password ?? "", "role":role ?? "", "avatar": avatar ?? "" ]
    }
}
