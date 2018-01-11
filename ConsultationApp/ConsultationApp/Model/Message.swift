//
//  Message.swift
//  ConsultationApp
//
//  Created by Thien Ho on 1/9/18.
//  Copyright © 2018 cosc2659. All rights reserved.
//

import UIKit
import FirebaseAuth

class Message: NSObject {
    var fromId: String?
    var text: String?
    var timestamp: NSNumber?
    var toId: String?
    
    // Check User
    func chatPartnerId() -> String? {
        return fromId == Auth.auth().currentUser?.uid ? toId : fromId
    }
}
