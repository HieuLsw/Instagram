//
//  commentCell.swift
//  Instagram
//
//  Created by Bobby Negoat on 12/1/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class commentCell: UITableViewCell {

    @IBOutlet weak var avaImg: UIImageView!
    
    @IBOutlet weak var usernameBtn: UIButton!

    @IBOutlet weak var commentLbl: UILabel!
    
    @IBOutlet weak var dateLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
