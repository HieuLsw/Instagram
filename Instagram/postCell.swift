//
//  postCell.swift
//  Instagram
//
//  Created by Bobby Negoat on 12/1/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class postCell: UITableViewCell {

    @IBOutlet weak var avaImg: UIImageView!
    
    @IBOutlet weak var usernameBtn: UIButton!
    
    @IBOutlet weak var dateLbl: UILabel!

    @IBOutlet weak var picImg: UIImageView!

    @IBOutlet weak var likeBtn: UIButton!
 
    @IBOutlet weak var commentBtn: UIButton!
    
    @IBOutlet weak var moreBtn: UIButton!
    
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var likeLbl: UILabel!
 
    @IBOutlet weak var uuidLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
        //set ava image layer
        setAvaImgLayer()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//custom functions
extension postCell{
  
    fileprivate func setAvaImgLayer(){
        self.avaImg.layer.cornerRadius = self.avaImg.bounds.size.width / 2
        self.avaImg.layer.borderWidth = 0
        self.avaImg.clipsToBounds = true
    }
}
