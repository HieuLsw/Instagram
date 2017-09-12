//
//  ViewController.swift
//  Instagram
//
//  Created by Shao Kahn on 9/12/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {

    @IBOutlet weak var wusondahuImageView: UIImageView!
 
    @IBOutlet weak var senderLbl: UILabel!
    
    @IBOutlet weak var receiverLbl: UILabel!

    @IBOutlet weak var messagesLbl: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    //Wrap / take image file data from UIImageView
  /*let data = UIImageJPEGRepresentation(wusondahuImageView.image!, 0.5)
  
   //Convert taken image to file
 let file = PFFile(name: "picture.jpb", data: data!)
        
        
     //Create a class / collection / table in Heroku
     //PFObject - to create table or some data in tanble
        let table = PFObject(className: "messages")
        table["sender"] = "Jordan"
        table["receiver"] = "Goat"
        table["picture"] = file
        table.saveInBackground { (success:Bool, error:Error?) in
            if success{
   print("Saved in server")
            }else{
                print(error)
            }
        }*/
   
    //Retreieving data from server
let information = PFQuery(className: "messsages")
        information.findObjectsInBackground { (objects:[PFObject]?, error:Error?) in
if error == nil{
    for object in objects!{
  self.messagesLbl.text = object["message"] as! String
self.receiverLbl.text = object["receiver"] as! String
self.senderLbl.text = object["sender"] as! String
        
        (object["picture"] as! PFFile).getDataInBackground(block: { (data:Data?, error:Error?) in
    if error == nil{
if data != nil{
 self.wusondahuImageView.image = UIImage(data: data!)
}else{
    print(error)
        }
            }
})
    }
}else{
    print(error)
            }
}
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

