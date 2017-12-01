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
    
_ = [avaImg,usernameBtn,commentLbl,dateLbl].map{$0.translatesAutoresizingMaskIntoConstraints = false
        }
        
     //ava image layout
    NSLayoutConstraint.init(item: avaImg, attribute: .height, relatedBy: .equal, toItem: avaImg, attribute: .notAnAttribute, multiplier: 1.0, constant: 60).isActive = true
    NSLayoutConstraint.init(item: avaImg, attribute: .height, relatedBy: .equal, toItem: avaImg, attribute: .width, multiplier: 1/1, constant: 0.0).isActive = true
     NSLayoutConstraint.init(item: avaImg, attribute: .left, relatedBy: .equal, toItem: commentCell().contentView, attribute: .leftMargin, multiplier: 1.0, constant: 0.0).isActive = true
     NSLayoutConstraint.init(item: avaImg, attribute: .centerX, relatedBy: .equal, toItem: commentCell().contentView, attribute: .centerX, multiplier: 1.0, constant: 0.0).isActive = true
      
    //date label layout
  dateLbl.heightAnchor.constraint(equalToConstant: 21).isActive = true
  dateLbl.widthAnchor.constraint(equalToConstant: 30).isActive = true
  NSLayoutConstraint(item: dateLbl, attribute: .top, relatedBy: .equal, toItem: avaImg, attribute: .top, multiplier: 1.0, constant: 0.0).isActive = true
  
   // username button layout
  NSLayoutConstraint(item: usernameBtn, attribute: .height, relatedBy: .equal, toItem: commentLbl, attribute: .height, multiplier: 1.0, constant: 0.0).isActive = true
   NSLayoutConstraint(item: usernameBtn, attribute: .left, relatedBy: .equal, toItem: avaImg, attribute: .right, multiplier: 1.0, constant: 25.0).isActive = true
    NSLayoutConstraint(item: usernameBtn, attribute: .top, relatedBy: .equal, toItem: avaImg, attribute: .top, multiplier: 1.0, constant: 0.0).isActive = true
    NSLayoutConstraint.init(item: usernameBtn, attribute: .right, relatedBy: .lessThanOrEqual, toItem: dateLbl, attribute: .left, multiplier: 1.0, constant: 53.0).isActive = true
        
   //comment label layout
    commentLbl.heightAnchor.constraint(equalToConstant: 21.0).isActive = true
    NSLayoutConstraint(item: commentLbl, attribute: .right, relatedBy: .equal, toItem: commentCell().contentView, attribute: .rightMargin, multiplier: 1.0, constant: 0.0).isActive = true
    NSLayoutConstraint.init(item: commentLbl, attribute: .bottom, relatedBy: .equal, toItem: avaImg, attribute: .bottom, multiplier: 1.0, constant: 0.0).isActive = true
    NSLayoutConstraint(item: commentLbl, attribute: .left, relatedBy: .equal, toItem: avaImg, attribute: .right, multiplier: 1.0, constant: 25.0).isActive = true
}
}



