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

class commentVC: UIViewController,GrowingTextViewDelegate,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    {didSet{self.tableView.delegate = self;self.tableView.dataSource = self}}
    
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
     
        self.tableViewHeight = tableView.frame.size.height
        self.commentHeight = commentTxt.frame.size.height
        self.commentY = commentTxt.frame.origin.y
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


    // load comments function
    func loadComments() {
        
// STEP 1. Count total comments in order to skip all except (page size = 15)
let countQuery = PFQuery(className: "comments")
countQuery.whereKey("to", equalTo: commentuuid.last!)
countQuery.countObjectsInBackground (block: { (count, error) in
            
// if comments on the server for current post are more than (page size 15), implement pull to refresh func
if self.page < count {
    self.refresh.addTarget(self, action: #selector(commentVC.loadMore), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(self.refresh)
}
            
// STEP 2. Request last (page size 15) comments
let query = PFQuery(className: "comments")
query.whereKey("to", equalTo: commentuuid.last!)
query.skip = Int(count - self.page)
query.addAscendingOrder("createdAt")
query.findObjectsInBackground(block: { (objects, erro) in
    if error == nil {
                    
    // clean up
    self.usernameArray.removeAll(keepingCapacity: false)
    self.avaArray.removeAll(keepingCapacity: false)
    self.commentArray.removeAll(keepingCapacity: false)
    self.dateArray.removeAll(keepingCapacity: false)
                    
        // find related objects
    for object in objects! {
  self.usernameArray.append(object.object(forKey: "username") as! String)
  self.avaArray.append(object.object(forKey: "ava") as! PFFile)
  self.commentArray.append(object.object(forKey: "comment") as! String)
  self.dateArray.append(object.createdAt)
    self.tableView.reloadData()
                        
            // scroll to bottom
    self.tableView.scrollToRow(at: IndexPath(row: self.commentArray.count - 1, section: 0), at: UITableViewScrollPosition.bottom, animated: false)
                    }
                } else {
                    print(error?.localizedDescription ?? String())
                }
            })
        })
        
    }
    
    
    // pagination
   @objc fileprivate func loadMore() {
        
        // STEP 1. Count total comments in order to skip all except (page size = 15)
        let countQuery = PFQuery(className: "comments")
        countQuery.whereKey("to", equalTo: commentuuid.last!)
        countQuery.countObjectsInBackground (block: { (count, error) in
            
            // self refresher
    self.refresh.endRefreshing()
            
        // remove refresher if loaded all comments
    if self.page >= count {
    self.refresh.removeFromSuperview()
    }
            
        // STEP 2. Load more comments
    if self.page < count {
                
     // increase page to load 30 as first paging
      self.page = self.page + 15
                
    // request existing comments from the server
    let query = PFQuery(className: "comments")
    query.whereKey("to", equalTo: commentuuid.last!)
    query.skip = Int(count - self.page)
    query.addAscendingOrder("createdAt")
    query.findObjectsInBackground(block: { (objects, error) in
    if error == nil {
                        
    // clean up
    self.usernameArray.removeAll(keepingCapacity: false)
    self.avaArray.removeAll(keepingCapacity: false)
    self.commentArray.removeAll(keepingCapacity: false)
    self.dateArray.removeAll(keepingCapacity: false)
                        
        // find related objects
  for object in objects! {
    self.usernameArray.append(object.object(forKey: "username") as! String)
    self.avaArray.append(object.object(forKey: "ava") as! PFFile)
    self.commentArray.append(object.object(forKey: "comment") as! String)
    self.dateArray.append(object.createdAt)
            self.tableView.reloadData()
                        }
    } else {print(error?.localizedDescription ?? String())
        }
    })
}
})}
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

//UITableViewDataSource
extension commentVC{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentArray.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! commentCell
 cell.usernameBtn.setTitle(usernameArray[indexPath.row], for: .normal)
  cell.usernameBtn.sizeToFit()
cell.commentLbl.text = commentArray[indexPath.row]

avaArray[indexPath.row].getDataInBackground { (data, error) in
            cell.avaImg.image = UIImage(data: data!)
    }
        
  let from = dateArray[indexPath.row]
    let now = Date()
    let components : NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfMonth]
    let difference = (Calendar.current as NSCalendar).components(components, from: from!, to: now, options: [])
   
        if difference.second! <= 0 {
            cell.dateLbl.text = "now"
        }
        if difference.second! > 0 && difference.minute! == 0 {
            cell.dateLbl.text = "\(difference.second!)s."
        }
        if difference.minute! > 0 && difference.hour! == 0 {
            cell.dateLbl.text = "\(difference.minute!)m."
        }
        if difference.hour! > 0 && difference.day! == 0 {
            cell.dateLbl.text = "\(difference.hour!)h."
        }
        if difference.day! > 0 && difference.weekOfMonth! == 0 {
            cell.dateLbl.text = "\(difference.day!)d."
        }
        if difference.weekOfMonth! > 0 {
            cell.dateLbl.text = "\(difference.weekOfMonth!)w."
        }
        
        
        
        return cell
    }
}
