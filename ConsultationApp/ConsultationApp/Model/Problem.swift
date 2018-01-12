//
//  Problem.swift
//  Sth2Delete
//
//  Created by Tony Tom on 1/12/18.
//  Copyright © 2018 Tran Trong Tri. All rights reserved.
//

import UIKit

class Problem:NSObject {
    
    //MARK: Properties
    
    var question: String?
    var solution: String?
    var userID : String?
    
    
    //MARK: Initialization
    
//    init(question: String, solution: String) {
//        
//        // Initialize stored properties.
//        self.question = question
//        self.solution = solution
//    }
    //convert into Dictionary
    func toAnyObject () ->[ String : Any] {
        return ["question": question ?? "", "answer": solution ?? "", "userID": userID ?? ""]
    }
}
