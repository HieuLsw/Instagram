//
//  commentVC.swift
//  Instagram
//
//  Created by Bobby Negoat on 12/1/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class commentVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var commentTxt: UITextView!
    
    @IBOutlet weak var sendBtn: UIButton!
 
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

      //set views layout
     configueVCAlignment()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func sendBtn_click(_ sender: Any) {
    
    
    }
    
}//commentVC class over line

//custom functions
extension commentVC{
    
    //set views layout
    fileprivate func configueVCAlignment(){
  
     //avoid the issue to auto layout
_ = [tableView,sendBtn,commentTxt,contentView].map{$0.translatesAutoresizingMaskIntoConstraints = false}
 
//table view layout
  tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
   tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
   tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
    
  //content view layout
   contentView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 105 / 812).isActive = true
    contentView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
     contentView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
      contentView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
     contentView.topAnchor.constraint(equalTo: self.tableView.bottomAnchor).isActive = true
  
   //comment text view layout
 commentTxt.leftAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leftAnchor).isActive = true
 commentTxt.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5).isActive = true
  commentTxt.centerXAnchor.constraint(equalTo: self.sendBtn.centerXAnchor).isActive = true
  commentTxt.heightAnchor.constraint(equalToConstant: 43).isActive = true

   //send button layout
  sendBtn.rightAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.rightAnchor).isActive = true
sendBtn.heightAnchor.constraint(equalTo: commentTxt.heightAnchor).isActive = true
sendBtn.widthAnchor.constraint(equalToConstant: 46).isActive = true
sendBtn.leftAnchor.constraint(equalTo: commentTxt.rightAnchor, constant: 10).isActive = true
        
    }
    
    
}
