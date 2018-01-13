//
//  QuestionCell.swift
//  Sth2Delete
//
//  Created by Tony Tom on 1/12/18.
//  Copyright © 2018 Tran Trong Tri. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var consultantRole: UILabel!
    @IBOutlet weak var questionTView: UITextView!
    @IBOutlet weak var solutionTView: UITextView!
    @IBOutlet weak var show: UIButton!
    @IBOutlet weak var chat: UIButton!
    
    @IBAction func showDetail(_ sender: Any) {
    }
    @IBAction func chatBtn(_ sender: Any) {
    }
    
    //MARK: Properties
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
