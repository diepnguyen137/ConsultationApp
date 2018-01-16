//
//  Problem.swift
//  Sth2Delete
//
//  Created by Tony Tom on 1/12/18.
//  Copyright © 2018 Tran Trong Tri. All rights reserved.
//

import UIKit

class Post:NSObject {
    
    //MARK: Properties
    
    var question: String?
    var solution: String?
    var userID : String?
    var topic: String?
    var key: String?
    
    
    //MARK: Initialization
    
    //convert into Dictionary
    func toAnyObject () ->[ String : Any] {
        return ["question": question ?? "", "answer": solution ?? "", "topic": topic ?? "", "userID": userID ?? ""]
    }
}
