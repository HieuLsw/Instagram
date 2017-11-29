//
//  followersCell.swift
//  Instagram
//
//  Created by Bobby Negoat on 11/22/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import Parse

class followersCell: UITableViewCell {

    @IBOutlet weak var avaImg: UIImageView!
    
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var followBtn: UIButton!
    
    @IBOutlet weak var imagUIView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
       //round img
        setImgLayer()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func followBtn_click(_ sender: Any) {
       
      let title = followBtn.title(for: .normal)
        
      //to follow
        if title == "FOLLOW"{
            
        let object = PFObject(className: "follow")
        object["follower"] = PFUser.current()?.username
        object["following"] = username.text
            object.saveInBackground(block: { (success, error) in
if success {
    
self.followBtn.setTitle("FOLLOWING", for: .normal)
self.followBtn.backgroundColor = UIColor.green
    
}else{print(error!.localizedDescription)}
    })
        } else{

         //un follow
let query = PFQuery(className: "follow")
   query.whereKey("follower", equalTo: (PFUser.current()?.username)!)
   query.whereKey("following", equalTo: (username.text)!)
query.findObjectsInBackground(block: { (objects, error) in
    if error == nil{
        for object in objects!{
        
object.deleteInBackground(block: { (success, error) in
    if success {
     self.followBtn.setTitle("FOLLOW", for: .normal)
    self.followBtn.backgroundColor = UIColor.purple
    }else{
        print(error!.localizedDescription)
    }
            })
            
        }
    }else{
        print(error!.localizedDescription)
    }
            })
            
        }
 }
}// followersCell class over line

extension followersCell{
    
    fileprivate func setImgLayer(){
 avaImg.layer.cornerRadius = avaImg.bounds.size.width / 2
 avaImg.layer.borderWidth = 2
 avaImg.layer.borderColor = UIColor.white.cgColor
 avaImg.clipsToBounds = true
        
    imagUIView.layer.cornerRadius = self.imagUIView.bounds.size.width / 2
    imagUIView.layer.borderWidth = 2
    imagUIView.layer.borderColor = UIColor.black.cgColor
    imagUIView.clipsToBounds = true
    }
    
}
