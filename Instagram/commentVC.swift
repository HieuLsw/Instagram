//
//  commentVC.swift
//  Instagram
//
//  Created by Bobby Negoat on 12/1/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import Parse

var commentuuid = [String]()
var commentowner = [String]()

class commentVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var commentTxt: UITextView!
    
    @IBOutlet weak var sendBtn: UIButton!
    
    var refresh = UIRefreshControl()
    
    // values for reseting UI to default
    var tableViewHeight : CGFloat = 0
    var commentY : CGFloat = 0
    var commentHeight : CGFloat = 0
    
    // arrays to hold server data
    var usernameArray = [String]()
    var avaArray = [PFFile]()
    var commentArray = [String]()
    var dateArray = [Date?]()
    
    // variable to hold keybarod frame
    var keyboard = CGRect()
    
    // page size
    var page:Int32 = 15
    
    override func viewDidLoad() {
        super.viewDidLoad()

      //set views layout
     configueVCAlignment()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
// convert commentTxt to first responder
     //createFirstResponder()
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
    
    // convert commentTxt to first responder
    fileprivate func createFirstResponder(){
      
     commentTxt.becomeFirstResponder()
    }

    //set views layout
    fileprivate func configueVCAlignment(){
  
     //avoid the issue to auto layout
_ = [tableView,sendBtn,commentTxt].map{$0.translatesAutoresizingMaskIntoConstraints = false}
 
        
        
//table view layout
  tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
   tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
   tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
  tableView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 700/812).isActive = true
 
  commentTxt.leftAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leftAnchor).isActive = true
  commentTxt.heightAnchor.constraint(equalToConstant: 50).isActive = true
  commentTxt.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 3).isActive = true
  commentTxt.rightAnchor.constraint(equalTo: self.view.layoutMarginsGuide.rightAnchor).isActive = true

sendBtn.rightAnchor.constraint(equalTo: commentTxt.rightAnchor).isActive = true
sendBtn.topAnchor.constraint(equalTo: commentTxt.topAnchor).isActive = true
sendBtn.bottomAnchor.constraint(equalTo: commentTxt.bottomAnchor).isActive = true
  sendBtn.widthAnchor.constraint(equalToConstant: 46).isActive = true
  sendBtn.heightAnchor.constraint(equalToConstant: 46).isActive = true
        
 sendBtn.layer.cornerRadius = sendBtn.bounds.size.width / 2
  sendBtn.layer.borderWidth = 1
sendBtn.backgroundColor = #colorLiteral(red: 0.1920000017, green: 0.275000006, blue: 0.5059999824, alpha: 1)
    
 commentTxt.backgroundColor = UIColor.red
 commentTxt.layer.cornerRadius = sendBtn.bounds.size.width / 2
commentTxt.layer.borderColor = UIColor.blue.cgColor
commentTxt.layer.borderWidth = 2
}
   
    
}
