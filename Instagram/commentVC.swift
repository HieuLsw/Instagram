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
    {didSet{self.tableView.delegate = self
        self.tableView.dataSource = self}}
    
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
        
       //call load comments function
        loadComments()
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
 
    @IBAction func close_keyboard(_ sender: Any) {
        
        hideKeyboard()
    }
    
    @IBAction func usernameBtn_click(_ sender: Any) {
        
    // call index of current button
    let i = (sender as AnyObject).layer.value(forKey: "index") as! IndexPath
        
    // call cell to call further cell data
    let cell = tableView.cellForRow(at: i) as! commentCell
        
    // if user tapped on his username go home, else go guest
if cell.usernameBtn.titleLabel?.text == PFUser.current()?.username {

let home = self.storyboard?.instantiateViewController(withIdentifier: "homeVC") as! homeVC

self.navigationController?.show(home, sender: nil)
        } else {

guestName.append(cell.usernameBtn.titleLabel!.text!)

let guest = self.storyboard?.instantiateViewController(withIdentifier: "guestVC") as! guestVC

self.navigationController?.show(guest, sender: sender)
        }
    }
        
    @IBAction func sendBtn_click(_ sender: Any) {
    
// STEP 1. Add row in tableView
usernameArray.append(PFUser.current()!.username!)
avaArray.append(PFUser.current()?.object(forKey: "ava") as! PFFile)
dateArray.append(Date())
commentArray.append(commentTxt.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
    tableView.reloadData()
        
        // STEP 2. Send comment to server
let commentObj = PFObject(className: "comments")
commentObj["to"] = commentuuid.last
commentObj["username"] = PFUser.current()?.username
commentObj["ava"] = PFUser.current()?.value(forKey: "ava")
commentObj["comment"] = commentTxt.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    commentObj.saveEventually()
        
// STEP 3. Send #hashtag to server
let words:[String] = commentTxt.text!.components(separatedBy: CharacterSet.whitespacesAndNewlines)
        
    // define taged word
for var word in words {
            
// save #hasthag in server
if word.hasPrefix("#") {
                
        // cut symbold
word = word.trimmingCharacters(in: CharacterSet.punctuationCharacters)
word = word.trimmingCharacters(in: CharacterSet.symbols)
                
let hashtagObj = PFObject(className: "hashtags")
hashtagObj["to"] = commentuuid.last
hashtagObj["by"] = PFUser.current()?.username
hashtagObj["hashtag"] = word.lowercased()
 hashtagObj["comment"] = commentTxt.text
        hashtagObj.saveInBackground(block: { (success, error) in
if success {print("hashtag \(word) is created")
    } else {print(error!.localizedDescription)}
    })
    }
}
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
    
    // func to hide keyboard
    fileprivate func hideKeyboard() {
        self.view.endEditing(true)
    }
    
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
    
    // load comments function
   fileprivate func loadComments() {
        
// STEP 1. Count total comments in order to skip all except (page size = 15)
let countQuery = PFQuery(className: "comments")
countQuery.whereKey("to", equalTo: commentuuid.last!)
countQuery.countObjectsInBackground (block: { (count, error) in
            
// if comments on the server for current post are more than (page size 15), implement pull to refresh func
if self.page < count {
    self.refresh.addTarget(self, action: #selector(self.loadMore), for: UIControlEvents.valueChanged)
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
} else {print(error?.localizedDescription ?? String())
    }
            })
        })
    }
}

//custom funcitons selectors
extension commentVC{
    
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
    
    // alert action
   fileprivate func alert(_ title: String, message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
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
        bottomConstaints.constant = UIScreen.main.bounds.height - endFrame.origin.y - 20
        self.view.layoutIfNeeded()
    }
    
   @objc fileprivate func keyboardWillHide(_ notification : Notification) {
        
        // move UI down
        UIView.animate(withDuration: 0.4)
        {self.tableView.frame.size.height = self.tableViewHeight
            self.commentTxt.frame.origin.y = self.commentY
            self.sendBtn.frame.origin.y = self.commentY
            self.bottomConstaints.constant += 20
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentArray.count
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
        
        // @mention is tapped
cell.commentLbl.userHandleLinkTapHandler = { label, handle, rang in
    var mention = handle
    mention = String(mention.dropFirst())
            
   // if tapped on @currentUser go home, else go guest
if mention.lowercased() == PFUser.current()?.username {
let home = self.storyboard?.instantiateViewController(withIdentifier: "homeVC") as! homeVC
self.navigationController?.show(home, sender: nil)
} else {guestName.append(mention.lowercased())
let guest = self.storyboard?.instantiateViewController(withIdentifier: "guestVC") as! guestVC
self.navigationController?.show(guest, sender: nil)
            }
        }
        
        // #hashtag is tapped
cell.commentLbl.hashtagLinkTapHandler = { label, handle, range in
    var mention = handle
mention = String(mention.dropFirst())
hashtag.append(mention.lowercased())
let hashvc = self.storyboard?.instantiateViewController(withIdentifier: "hashtagsVC") as! hashtagsVC
self.navigationController?.show(hashvc, sender: nil)
        }
        
        // assign indexes of buttons
        cell.usernameBtn.layer.setValue(indexPath, forKey: "index")
        
        return cell
    }
}

//UITableViewDelegate
extension commentVC{
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // call cell for calling further cell data
        let leadingCell = tableView.cellForRow(at: indexPath) as! commentCell
       
        // ACTION. Delete
        let deleteAction = UIContextualAction.init(style: .normal, title: "") { (_, _, _) in
            
            // STEP 1. Delete comment from server
            let commentQuery = PFQuery(className: "comments")
            commentQuery.whereKey("to", equalTo: commentuuid.last!)
            commentQuery.whereKey("comment", equalTo: leadingCell.commentLbl.text!)
            commentQuery.findObjectsInBackground (block: { (objects, error) in
                if error == nil {
                    // find related objects
                    for object in objects! {
                        object.deleteEventually()
                    }
                } else {print(error!.localizedDescription)
                }
            })
            
            // STEP 2. Delete #hashtag from server
            let hashtagQuery = PFQuery(className: "hashtags")
            hashtagQuery.whereKey("to", equalTo: commentuuid.last!)
            hashtagQuery.whereKey("by", equalTo: leadingCell.usernameBtn.titleLabel!.text!)
            hashtagQuery.whereKey("comment", equalTo: leadingCell.commentLbl.text!)
            hashtagQuery.findObjectsInBackground(block: { (objects, error) in
                for object in objects! {
                    object.deleteEventually()
                }
            })
            
            // STEP 3. Delete notification: mention comment
let newsQuery = PFQuery(className: "news")
newsQuery.whereKey("by", equalTo: leadingCell.usernameBtn.titleLabel!.text!)
            newsQuery.whereKey("to", equalTo: commentowner.last!)
            newsQuery.whereKey("uuid", equalTo: commentuuid.last!)
            newsQuery.whereKey("type", containedIn: ["comment", "mention"])
            newsQuery.findObjectsInBackground(block: { (objects, error) in
                if error == nil {
                    for object in objects! {
                        object.deleteEventually()
                    }
                }
            })
            
  // close cell
tableView.setEditing(false, animated: true)
            
  // STEP 4. Delete comment row from tableView
self.commentArray.remove(at: indexPath.row)
self.dateArray.remove(at: indexPath.row)
self.usernameArray.remove(at: indexPath.row)
self.avaArray.remove(at: indexPath.row)
            
tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        deleteAction.image = #imageLiteral(resourceName: "delete")
deleteAction.backgroundColor = .red
        
         // post whether belongs to user
        if (leadingCell.usernameBtn.titleLabel?.text == PFUser.current()?.username) || (commentowner.last == PFUser.current()?.username){
        let config = UISwipeActionsConfiguration.init(actions: [deleteAction])
    return config
            
        // post whether belongs to others
        }else {return nil}
}
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // call cell for calling further cell data
        let trailingCell = tableView.cellForRow(at: indexPath) as! commentCell
        
       // ACTION. Mention or address message to someone
        let mentionAction = UIContextualAction.init(style: .normal, title: "") { (_, _, _) in
           
            // include username in textView
            self.commentTxt.text = "\(self.commentTxt.text + "@" + self.usernameArray[indexPath.row] + " ")"
            
            // enable button
            self.sendBtn.isEnabled = true
            
            // close cell
            tableView.setEditing(false, animated: true)
        }
       
        //Action.Complain
 let complainAction = UIContextualAction(style: .normal, title: "") { (_, _, _) in
            
// send complain to server regarding selected comment
let complainObj = PFObject(className: "complain")
complainObj["by"] = PFUser.current()?.username
complainObj["to"] = trailingCell.commentLbl.text
complainObj["owner"] = trailingCell.usernameBtn.titleLabel?.text
complainObj.saveInBackground(block: { (success, error) in
    if success {
self.alert("Complain has been made successfully", message: "Thank You! We will consider your complain")
} else {self.alert("ERROR", message: error!.localizedDescription)}
            })
            
    // close cell
    tableView.setEditing(false, animated: true)
}
        
        // buttons background
       mentionAction.image = #imageLiteral(resourceName: "address")
        complainAction.image = #imageLiteral(resourceName: "complain")
        mentionAction.backgroundColor = .green
        complainAction.backgroundColor = .purple
        
        // comment belogs to user
        if trailingCell.usernameBtn.titleLabel?.text == PFUser.current()?.username {
let config = UISwipeActionsConfiguration(actions: [mentionAction])
config.performsFirstActionWithFullSwipe = false
        return config
        }
       
     // post belongs to user or others
        else  {
let config = UISwipeActionsConfiguration.init(actions: [mentionAction,complainAction])
config.performsFirstActionWithFullSwipe = false
    return config
        }
    }

}
