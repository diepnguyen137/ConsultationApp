//
//  UserTableViewCell.swift
//  ConsultationApp
//
//  Created by admin on 1/6/18.
//  Copyright © 2018 cosc2659. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var userAvarta: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var userEmail: UILabel!
    
    @IBOutlet weak var switchRole: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        print("awakeFromNib: Start")
//        userAvarta.layer.cornerRadius = userAvarta.frame.size.width / 2
//        userAvarta.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
