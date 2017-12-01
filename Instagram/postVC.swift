//
//  postVC.swift
//  Instagram
//
//  Created by Bobby Negoat on 12/1/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import Parse

var postuuid = [String]()

class postVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var customTableView: UITableView!
    {didSet
    {self.customTableView.delegate = self
     self.customTableView.dataSource = self}
    }
    
    // arrays to hold information from server
    var avaArray = [PFFile]()
    var usernameArray = [String]()
    var dateArray = [Date?]()
    var picArray = [PFFile]()
    var uuidArray = [String]()
    var titleArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    //configue navigation bar
       setNavigationBar()
        
        // dynamic cell heigth
      tableViewCellHeight()
        
          //find post
        findPost()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}//postVC class over line


extension postVC{
  
    //configue navigation bar
    fileprivate func setNavigationBar(){
        
        self.navigationItem.title = "PHOTO"
        
        // new back button
        self.navigationItem.hidesBackButton = true
        let backBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(back(_:)))
        self.navigationItem.leftBarButtonItem = backBtn
        
        // swipe to go back
        let backSwipe = UISwipeGestureRecognizer(target: self, action: #selector(back(_:)))
        backSwipe.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(backSwipe)
    }
    
    // go back function
   @objc fileprivate func back(_ sender: UIBarButtonItem) {
        
        // push back
    self.navigationController?.popViewController(animated: true)
        
      // clean post uuid from last hold
        if !postuuid.isEmpty {
            postuuid.removeLast()
        }
    }
    
     // dynamic cell heigth
    fileprivate func tableViewCellHeight(){
        
        customTableView.rowHeight = UITableViewAutomaticDimension
        customTableView.estimatedRowHeight = 582
    }
    
    //find post
    fileprivate func findPost(){
        
    let postQuery = PFQuery(className: "posts")
        postQuery.whereKey("uuid", equalTo: postuuid.last!)
        
postQuery.findObjectsInBackground{ (objects, error) in
            if error == nil {
                
    // clean up
    self.avaArray.removeAll(keepingCapacity: false)
    self.usernameArray.removeAll(keepingCapacity: false)
    self.dateArray.removeAll(keepingCapacity: false)
    self.picArray.removeAll(keepingCapacity: false)
    self.uuidArray.removeAll(keepingCapacity: false)
    self.titleArray.removeAll(keepingCapacity: false)
                
    // find related objects
    for object in objects! {
    
    self.avaArray.append(object.value(forKey: "ava") as! PFFile)
    self.usernameArray.append(object.value(forKey: "username") as! String)
    
    self.dateArray.append(object.createdAt)
    self.picArray.append(object.value(forKey: "pic") as! PFFile)
    self.uuidArray.append(object.value(forKey: "uuid") as! String)
    self.titleArray.append(object.value(forKey: "title") as! String)
                }
                
    self.customTableView.reloadData()
            }
        }
    }
    
}

// table view --data source
extension postVC{
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! postCell
  
//connect objects with our information from arrays
  cell.usernameBtn.setTitle(usernameArray[indexPath.row], for: .normal)
  cell.uuidLbl.text = uuidArray[indexPath.row]
  cell.titleLbl.text = titleArray[indexPath.row]
 
// place post picture
  avaArray[indexPath.row].getDataInBackground { (data, error) in
            cell.avaImg.image = UIImage(data: data!) }

  picArray[indexPath.row].getDataInBackground { (data, error) in
            cell.picImg.image = UIImage(data: data!)}
    
    // calculate post date
    let from = dateArray[indexPath.row]
    let now = Date()
    let components : NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfMonth]
    let difference = (Calendar.current as NSCalendar).components(components, from: from!, to: now, options: [])
     
   // logic what to show: seconds, minuts, hours, days or weeks
if difference.second! <= 0 {cell.dateLbl.text = "now"}
if (difference.second! > 0) && (difference.minute! == 0) {
cell.dateLbl.text = "\(difference.second!)s."}
if (difference.minute! > 0) && (difference.hour! == 0) {
cell.dateLbl.text = "\(difference.minute!)m."}
if (difference.hour! > 0) && (difference.day! == 0) {
cell.dateLbl.text = "\(difference.hour!)h."}
if (difference.day! > 0) && (difference.weekOfMonth! == 0) {cell.dateLbl.text = "\(difference.day!)d."}
if difference.weekOfMonth! > 0 {
cell.dateLbl.text = "\(difference.weekOfMonth!)w."}
        
   return cell
    }
}

// table view --delegate
extension postVC{
    
    
    
}
