//
//  UserTableViewCell.swift
//  ConsultationApp
//
//  Created by admin on 1/6/18.
//  Copyright © 2018 cosc2659. All rights reserved.
//

import UIKit
import FirebaseDatabase

protocol UserCellDelegate {
    func switchRoleChanged(sender : UserTableViewCell, check : Bool)
}

class UserTableViewCell: UITableViewCell {

    var delegate: UserCellDelegate?
    @IBOutlet weak var userAvarta: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var userEmail: UILabel!
    
    @IBOutlet weak var switchRole: UISwitch!
    var refUser : DatabaseReference!
    
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

    @IBAction func switchRoleChanged(_ sender: UISwitch) {
        if let delegate = self.delegate {
            delegate.switchRoleChanged(sender: self, check: sender.isOn)
        }
    }
}
