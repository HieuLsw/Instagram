//
//  pictureCell.swift
//  Instagram
//
//  Created by Shao Kahn on 10/25/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class pictureCell: UICollectionViewCell {
  
    @IBOutlet weak var picImg: UIImageView!
    
    // default func
    override func awakeFromNib() {
        super.awakeFromNib()
       
   // alignment
       alignment()
    }
}

//custom functions
extension pictureCell{
    
    fileprivate func alignment(){
        
        // alignment
        let width = UIScreen.main.bounds.width
        picImg.frame = CGRect(x: 0, y: 0, width: width / 3, height: width / 3)
    }
}
