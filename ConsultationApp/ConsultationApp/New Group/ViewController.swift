//
//  ViewController.swift
//  ConsultationApp
//
//  Created by admin on 12/26/17.
//  Copyright © 2017 cosc2659. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
    }

    // MARK: Login
    @objc func handleLogout(){
        print("Logout: Pressed")
        
        // TODO: For login controller
//        let loginController = LoginController()
//        present(loginController, animated: true, completion: nil)
    }


}

