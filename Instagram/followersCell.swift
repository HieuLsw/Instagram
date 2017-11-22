//
//  followersCell.swift
//  Instagram
//
//  Created by Bobby Negoat on 11/22/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class followersCell: UITableViewCell {

    @IBOutlet weak var avaImg: UIImageView!
    
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var followBtn: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}// followersCell class over line

extension followersCell{
    
    fileprivate func setImgLayer(){
avaImg.layer.cornerRadius = avaImg.frame.size.width / 2
 avaImg.clipsToBounds = true
    }
    
}
