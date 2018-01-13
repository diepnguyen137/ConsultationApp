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
    func consultantRoleChanged(sender : UserTableViewCell, tag : Int)
}

class UserTableViewCell: UITableViewCell {

    var delegate: UserCellDelegate?
    @IBOutlet weak var userAvarta: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var userEmail: UILabel!
    
    @IBOutlet weak var switchRole: UISwitch!
    
    @IBOutlet weak var generalBtn: DLRadioButton!
    @IBOutlet weak var loveBtn: DLRadioButton!
    @IBOutlet weak var stressBtn: DLRadioButton!
    @IBOutlet weak var depressBtn: DLRadioButton!
    
    var refUser : DatabaseReference!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        

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
    
    @IBAction func btnTapped(_ sender: DLRadioButton) {
        if let delegate = self.delegate {
            delegate.consultantRoleChanged(sender: self, tag: sender.tag)
        }
    }
    
}
