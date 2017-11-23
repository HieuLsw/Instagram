//
//  headerView.swift
//  Instagram
//
//  Created by Shao Kahn on 10/25/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import Parse

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
  
    
  // clicked follow button from GuestVC
    @IBAction func followBtn_clicked(_ sender: Any) {
    
    
    let title = button.title(for: .normal)
    
    //to follow
if title == "FOLLOW" {
    let object = PFObject(className: "follow")
    object["follower"] = PFUser.current()?.username
    object["following"] = (guestName.last)!
    object.saveInBackground(block: { (success, error) in
        
        if success {
            
            self.button.setTitle("FOLLOWING", for: .normal)
            self.button.backgroundColor = .green
            
            // send follow notification
            let newsObj = PFObject(className: "news")
            newsObj["by"] = PFUser.current()?.username
            newsObj["ava"] = PFUser.current()?.object(forKey: "ava") as! PFFile
            newsObj["to"] = (guestName.last)!
            newsObj["owner"] = ""
            newsObj["uuid"] = ""
            newsObj["type"] = "follow"
            newsObj["checked"] = "no"
            newsObj.saveEventually()
            
            
        } else {
            print(error!.localizedDescription)
        }

    })
}else{
    
 // unfollow
    let query = PFQuery(className: "follow")
    query.whereKey("follower", equalTo: (PFUser.current()!.username)!)
    query.whereKey("following", equalTo: (guestName.last)!)
    
    query.findObjectsInBackground(block: { (objects, error)  in
        if error == nil {
            
            for object in objects! {
                object.deleteInBackground(block: { (success, error)  in
    if success {
    self.button.setTitle("FOLLOW", for: .normal)
        self.button.backgroundColor = .lightGray
                        
// delete follow notification
let newsQuery = PFQuery(className: "news")
newsQuery.whereKey("by", equalTo: (PFUser.current()!.username)!)
newsQuery.whereKey("to", equalTo: (guestName.last)!)
                        newsQuery.whereKey("type", equalTo: "follow")
    
newsQuery.findObjectsInBackground(block: { (objects, error)  in

if error == nil {
    
for object in objects! {object.deleteEventually()}
     }
  })
} else {print(error!.localizedDescription)}
    })
}
} else {
            print(error!.localizedDescription)
        }
    })
    
        }
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


