//
//  headerView.swift
//  Instagram
//
//  Created by Shao Kahn on 10/25/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class headerView: UICollectionReusableView {
    
    @IBOutlet weak var avaImg: UIImageView!
 
    
    @IBOutlet weak var fullnameLbl: UILabel!
    
    @IBOutlet weak var webTxt: UITextView!
    
    @IBOutlet weak var bioLbl: UITextView!
  

    @IBOutlet weak var posts: UILabel!
    
    @IBOutlet weak var followers: UILabel!
    
    @IBOutlet weak var followings: UILabel!
    
    @IBOutlet weak var postsTitle: UILabel!
    @IBOutlet weak var followersTitle: UILabel!
    @IBOutlet weak var followingsTitle: UILabel!
    
    @IBOutlet weak var button: UIButton!
 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //round img layer
        setImgLayer()
    }
    
    
}// headerView class over line

extension headerView{
    
    //set image layer
    fileprivate func setImgLayer(){
       avaImg.layer.cornerRadius = self.avaImg.bounds.size.width / 2
        avaImg.layer.borderWidth = 0.01
        avaImg.layer.borderColor = UIColor.white.cgColor
        avaImg.clipsToBounds = true
    }
}


