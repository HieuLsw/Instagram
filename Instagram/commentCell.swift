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

    @IBOutlet weak var commentLbl: KILabel!
    
    @IBOutlet weak var dateLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //configue cell views layout
        configueCellLayout()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}//commentVC class over lineanimated

//custom functions
extension commentCell{
    
    fileprivate func configueCellLayout(){
        
avaImg.layer.cornerRadius = avaImg.bounds.size.width / 2
avaImg.layer.borderWidth = 0
avaImg.clipsToBounds = true
       }
}



