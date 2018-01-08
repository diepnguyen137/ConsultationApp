//
//  User .swift
//  ConsultationApp
//
//  Created by admin on 1/8/18.
//  Copyright © 2018 cosc2659. All rights reserved.
//

import Foundation
class User {
    //Properties
    var email:String
    var name : String
    var password:String
    var role:String
    var avatar:String
    
    init?(email: String, name: String, password:String, role: String, avatar: String) {
        if email.isEmpty || password.isEmpty || name.isEmpty {
            return nil
        }
        self.email = email
        self.name = name
        self.password = password
        self.role = role
        self.avatar = avatar
    }
}
