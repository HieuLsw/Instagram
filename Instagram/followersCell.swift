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
  
    @IBOutlet weak var imageInset: UIView!
    
    let shape = CAShapeLayer()
    
    let gradient = CAGradientLayer()
    
    
    var gradientColor1 = UIColor.init(hex: "833AB4").cgColor
    var gradientColor2 = UIColor.init(hex: "FCB045").cgColor
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
       //round img
       // setImgLayer()
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

//custom functions
extension followersCell{
   
func setImgLayer(){
        
 avaImg.layer.cornerRadius = avaImg.bounds.size.width / 2
 avaImg.layer.borderWidth = 1
 avaImg.layer.borderColor = UIColor.black.cgColor
 avaImg.clipsToBounds = true
      
gradient.frame =  CGRect(origin: CGPoint.init(x: 0, y: 0), size: self.imageInset.frame.size)
gradient.colors = [gradientColor1, gradientColor2]
        
shape.lineWidth = 3
    shape.path = UIBezierPath(arcCenter: self.avaImg.center, radius: self.imageInset.bounds.size.width / 2 - 1, startAngle: CGFloat(-80 * Double.pi / 180), endAngle: CGFloat(440 * Double.pi / 180), clockwise: true).cgPath
        
      shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape
        
    self.imageInset.layer.addSublayer(gradient)
  }
}


