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

class commentVC: UIViewController,UITextViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var commentTxt: UITextView!
{didSet{self.commentTxt.delegate = self}}
    
    @IBOutlet weak var sendBtn: UIButton!
 
    @IBOutlet weak var textViewLocation: NSLayoutConstraint!
    
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
        
        // set text view placehold
setTextViewPlacehold()
        
        // add done button above keyboard
addDoneButton()
}

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //create observers
        createObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //release observers
        deleteObservers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    // set text view placehold
    fileprivate func setTextViewPlacehold(){
        
        commentTxt.placeholder = "Writing something..."
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
        
        // catch notification if the keyboard is shown or hidden
        NotificationCenter.default.addObserver(self, selector: #selector(commentVC.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(commentVC.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    fileprivate func deleteObservers(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
}

//observers selectors
extension commentVC{
    
    // func loading when keyboard is shown
   @objc fileprivate func keyboardWillShow(_ notification : Notification) {
        
        // defnine keyboard frame size
       keyboard = ((notification.userInfo?[UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue)!
    
   // move UI up
      UIView.animate(withDuration: 0.4)
        { [unowned self] in
        self.tableView.frame.size.height = self.tableViewHeight - self.keyboard.height + 30
        self.commentTxt.frame.origin.y = self.commentY - self.keyboard.height + 30
        self.sendBtn.frame.origin.y = self.commentTxt.frame.origin.y
            }
    }
    
    // func loading when keyboard is hidden
   @objc fileprivate func keyboardWillHide(_ notification : Notification) {
    
       // move UI down
    UIView.animate(withDuration: 0.4)
            {[unowned self]  in
                self.tableView.frame.size.height = self.tableViewHeight
                self.commentTxt.frame.origin.y = self.commentY
                self.sendBtn.frame.origin.y = self.commentY
            }
   }
}

//UITextViewDelegate
extension commentVC{
    
    // while writing something
    func textViewDidChange(_ textView: UITextView) {
       
    }
}
