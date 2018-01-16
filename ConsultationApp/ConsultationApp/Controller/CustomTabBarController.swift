//
//  CustomTabBarController.swift
//  ConsultationApp
//
//  Created by Thien Ho on 1/12/18.
//  Copyright © 2018 cosc2659. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Connect MessagesController
        let messagesController = MessagesController()
        let recentMessagesController = UINavigationController(rootViewController: messagesController)
//        messagesController.tabBarItem = UITabBarItem.init(tabBarSystemItem: .bookmarks, tag: 0)
        recentMessagesController.tabBarItem.title = "Chat"
        recentMessagesController.tabBarItem.image = UIImage(named: "Chat")
        
        // Connect PostStoryboard
        let postStoryboard = UIStoryboard(name: "Post", bundle: nil)
        let postController = postStoryboard.instantiateViewController(withIdentifier: "topicNavi")
//        postController.tabBarItem = UITabBarItem.init(tabBarSystemItem: .contacts, tag: 1)
        postController.tabBarItem.title = "Post"
        postController.tabBarItem.image = UIImage(named: "Post")
        
        // Build TabBar
        viewControllers = [recentMessagesController, postController]
        
    }
}
