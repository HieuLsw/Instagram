//
//  followersVC.swift
//  Instagram
//
//  Created by Bobby Negoat on 11/22/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import Parse

var varShow = ""
var varUser = ""

class followersVC: UITableViewController {

   //arrays to hold data received from servers
    var usernameArray = [String]()
    var avaArray = [PFFile]()
  
 //arrays for showing who do we follow or who following us
  var followArray = [String]()
  

    override func viewDidLoad() {
        super.viewDidLoad()

        
      //navigaiton bar information
      setBarInfo()
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}// followersVC class over line


//custom functions
extension followersVC{
    
    
    fileprivate func setBarInfo(){
    navigationItem.title = varShow.uppercased()
     
        if varShow == "followers"{
        
      fetchFollowers()
        } else if varShow == "followings"{
            fetchFollowings()
        }
        
    }
    
    
    fileprivate func fetchFollowers(){
       
      //STEP 1.Find in follow class people following user
       //find follwers of user
  let followQuery = PFQuery(className: "follow")
 followQuery.whereKey("following", equalTo: varUser)
        followQuery.findObjectsInBackground { (objects, error) in
            
//STEP 2. Hold received data
if error == nil{
    
    //clean up
    self.followArray.removeAll(keepingCapacity: false)

    
  //find related objects depending on query settings
self.followArray = objects!.map{$0.value(forKey: "follower") as! String}
  
 //STEP 3. Find in user class data of users following varuser
  //find users following user
let query = PFUser.query()
query?.whereKey("username", containedIn: self.followArray)
query?.addDescendingOrder("createdAt")
query?.findObjectsInBackground(block: { (objects, error) in
    
    if error == nil{
    
   // clear up
     self.usernameArray.removeAll(keepingCapacity: false)
      self.avaArray.removeAll(keepingCapacity: false)
  
  // find related objects in User class of Parse
    for object in objects!{
        self.usernameArray.append(object.object(forKey: "username") as! String)
        self.avaArray.append(object.object(forKey: "ava") as! PFFile)
        self.tableView.reloadData()
        }
 
    } else{
        print(error!.localizedDescription)
    }
})
    }
else{print(error!.localizedDescription)}
    }
}
    
    fileprivate func fetchFollowings(){

//STEP 1. Find in follow class people following user
// find followers of user
let followingQuery = PFQuery(className: "follow")
followingQuery.whereKey("follower", equalTo: varUser)
        followingQuery.findObjectsInBackground { (objects, error) in
            if error == nil {
   
  //STEP 2. Hold received data
   // clean up
self.followArray.removeAll(keepingCapacity: false)
   
   // find related objects in "follow" class of Parse
self.followArray = objects!.map{$0.value(forKey: "following") as! String}
 
 //STEP 3. Find in user class data of users following _user
 //find users follow by user
    let query = PFQuery(className: "_User")
     query.addDescendingOrder("createdAt")
query.findObjectsInBackground(block: { (objects, error) in
    if error == nil{
        
     //clean up
    self.usernameArray.removeAll(keepingCapacity: false)
self.avaArray.removeAll(keepingCapacity: false)
        
//find related objects in "User" class of Parse
        for object in objects!{
   self.usernameArray.append(object.object(forKey: "username") as! String)
    self.avaArray.append(object.object(forKey: "ava") as! PFFile)
      self.tableView.reloadData()
        }
        
    }else {print(error!.localizedDescription)}
})
    }else{print(error!.localizedDescription)}
}
}

}

//table view -- datasource
extension followersVC{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usernameArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! followersCell
        
       //STEP 1. Connect data from server to objects
        cell.username.text = usernameArray[indexPath.row]
        
        avaArray[indexPath.row].getDataInBackground { (data, error) in
            if error == nil {
                cell.avaImg.image = UIImage(data: data!)
                
            }else{
                print(error!.localizedDescription)
            }
        }
      
     //STEP 2. Show do user following or do not
        let query = PFQuery(className: "follow")
        query.whereKey("follower", equalTo: (PFUser.current()?.username)!)
        query.whereKey("following", equalTo: (cell.username.text)!)
        query.countObjectsInBackground { (count, error) in
    if error == nil{
    if count == 0{
    cell.followBtn.setTitle("FOLLOW", for: .normal)
cell.followBtn.backgroundColor = UIColor.purple
    }else{
cell.followBtn.setTitle("FOLLOWING", for: .normal)
 cell.followBtn.backgroundColor = UIColor.green
    }
        
 }
}
   
   //hide follow button for current user
    if cell.username.text == PFUser.current()?.username{
    cell.followBtn.isHidden = true
        
    }
        
        return cell
    }
}
