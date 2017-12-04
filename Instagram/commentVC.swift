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

class commentVC: UIViewController,GrowingTextViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var commentTxt: GrowingTextView!
        {didSet{self.commentTxt.delegate = self}}
    
    @IBOutlet weak var sendBtn: UIButton!
 
    @IBOutlet weak var bottomConstaints: NSLayoutConstraint!
    
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
            
        // add done button above keyboard
addDoneButton()
}

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //create observers
        createObservers()
        
        //let text view become firest responder
setFristResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        deleteObservers()
    }
    
    @IBAction func sendBtn_click(_ sender: Any) {
    
    
    }
  
    @IBAction func BACK(_ sender: Any) {
        
        // clean comment uuid from last holding infromation
        if !commentuuid.isEmpty {
            commentuuid.removeLast()
        }
        
        // clean comment owner from last holding infromation
        if !commentowner.isEmpty {
            commentowner.removeLast()
        }
        
        dismiss(animated: true, completion: nil)
    }
}//commentVC class over line

//custom functions
extension commentVC{
    
    //let text view become firest responder
    fileprivate func setFristResponder(){
        
        commentTxt.becomeFirstResponder()
    }
    
    //set views layout
    fileprivate func configueVCAlignment(){
        
sendBtn.layer.cornerRadius = sendBtn.bounds.size.width / 2
  sendBtn.layer.borderWidth = 0.01
    
commentTxt.layer.borderWidth = 0.01
     
        // assign reseting values
        tableViewHeight = tableView.frame.size.height
        commentHeight = commentTxt.frame.size.height
        commentY = commentTxt.frame.origin.y
}
    
    // add done button above keyboard
    fileprivate func addDoneButton(){
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(hideKeyboard))
        
        toolBar.setItems([flexibleSpace,doneButton], animated: true)
        
        self.commentTxt.inputAccessoryView = toolBar
    }
}

//custom functions selectors
extension commentVC{
 
    // func to hide keyboard
    @objc fileprivate func hideKeyboard() {
        self.view.endEditing(true)
    }
}

//observers
extension commentVC{
    
    fileprivate func createObservers(){
        
        // *** Listen for keyboard show ***
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        // *** Listen for keyboard hide ***
        NotificationCenter.default.addObserver(self, selector: #selector(commentVC.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    fileprivate func deleteObservers(){
      NotificationCenter.default.removeObserver(self)
    }
}

//observers selectors
extension commentVC{
    
    @objc fileprivate func keyboardWillChangeFrame(_ notification: Notification) {
        let endFrame = ((notification as NSNotification).userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        bottomConstaints.constant = UIScreen.main.bounds.height - endFrame.origin.y - 35
        self.view.layoutIfNeeded()
    }
    
   @objc fileprivate func keyboardWillHide(_ notification : Notification) {
        
        // move UI down
        UIView.animate(withDuration: 0.4)
        {self.tableView.frame.size.height = self.tableViewHeight
            self.commentTxt.frame.origin.y = self.commentY
            self.sendBtn.frame.origin.y = self.commentY
            self.bottomConstaints.constant += 35
        }
    }
}

//GrowingTextViewDelegate
extension commentVC{
    
    // *** Call layoutIfNeeded on superview for animation when changing height ***
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [.curveLinear], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

