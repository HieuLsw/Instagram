//
//  homeVC.swift
//  Instagram
//
//  Created by Shao Kahn on 10/25/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import Parse

class homeVC: UICollectionViewController {

    //declare refresher variable
    var refresher: UIRefreshControl!
    
    //size of page
    var page = 10
    
    var uuidArrary = [String]()
    var picArray = [PFFile]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
//hold scroll direction
    holdCollectionViewDirection()
        
//set the title in the top
   setTopTitle()
        
 //load posts func
loadPosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(true)
        
        //create observer
        createObserver()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        //deallocate observer
        deallocateObserver()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  // clicked log out
    @IBAction func logout(_ sender: Any) {

        // implement log out
        PFUser.logOutInBackground { (error) in
            
    if error == nil {
        
 let signIn = self.storyboard?.instantiateViewController(withIdentifier: "signInVC") as! signInVC
     
    // remove logged in user from App memory
    UserDefaults.standard.removeObject(forKey: "username")
UserDefaults.standard.synchronize()
        
 let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = signIn
            }
      }
   }
}//homeVC class over line

//custom functions
extension homeVC{
    
 //create observer
fileprivate func createObserver(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(reload(_:)), name: NSNotification.Name!.init(NSNotification.Name(rawValue: "reload")), object: nil)
    }
    
    //deallocate observer
    fileprivate func deallocateObserver(){
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "reload"), object: nil)
    }
    
    //title of the top
  fileprivate  func setTopTitle(){
     
      //background color
    collectionView?.backgroundColor = UIColor.white

        //title at the top
    navigationItem.title = PFUser.current()?.username?.uppercased()
    
    //pull to refresh
    refresher = UIRefreshControl()
    refresher.addTarget(self, action: #selector(refresh), for: .valueChanged)
    
    collectionView?.addSubview(refresher)
    }
    
    
    //refreshing func
    @objc fileprivate func refresh(){
        
        //reload data information
        loadPosts()
        
        // stop refresher animating
        refresher.endRefreshing()
    }
   
    //load post func
    fileprivate func loadPosts(){
    
        let query = PFQuery(className: "posts")
        
        query.whereKey("username", equalTo: (PFUser.current()?.username)!)
        query.limit = page
        
        //find objects related to my request
        query.findObjectsInBackground { (objects, error) in
            
            if error == nil{
                
    //clean up
self.uuidArrary.removeAll(keepingCapacity: false)
self.picArray.removeAll(keepingCapacity: false)
                
self.picArray = objects!.map{$0.value(forKey: "pic") as! PFFile}
self.uuidArrary = objects!.map{$0.value(forKey: "uuid") as! String}

    self.collectionView?.reloadData()
            }else{
                print(error!.localizedDescription)
            }
        }
        
    }
    
    // reloading func after received notification
 @objc fileprivate func reload(_ notification:Notification) {
        collectionView?.reloadData()
    }
    
    
}


//colleciton view data source
extension homeVC {
  
    //number of cells
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picArray.count
    }
   
    //cell config
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //define cell
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! pictureCell
        //get picture from the array
        picArray[indexPath.row].getDataInBackground { (data, error) in
            if error == nil{
                cell.picImg.image = UIImage(data: data!)
            }
        }
        return cell
    }
    
}


//collection view delegate
extension homeVC{
    
    //header config
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
       //get header
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as! headerView
        
        
        //STEP 1. Fetch user data
        
        //get users data with connections to collumns of PFUser class
        header.fullnameLbl.text = (PFUser.current()?.object(forKey: "fullname") as? String)?.uppercased()
        
        header.webTxt.text = PFUser.current()?.object(forKey: "web") as? String
        header.webTxt.sizeToFit()
        
        header.bioLbl.text = PFUser.current()?.object(forKey: "bio") as? String
        header.bioLbl.sizeToFit()
        
        
       let avaQuery = PFUser.current()?.object(forKey: "ava") as! PFFile
        avaQuery.getDataInBackground { (data, error) in
            header.avaImg.image = UIImage(data: data!)
        }
        header.button.setTitle("edit profile", for: .normal)
        
        
        //STEP 2. Count statistics
        
        //count total posts
        let posts = PFQuery(className: "posts")
        posts.whereKey("username", equalTo: (PFUser.current()?.username)!)
        posts.countObjectsInBackground { (count, error) in
            if error == nil{
                header.posts.text = "\(count)"
            }
        }
        
        //count total followers
        let followers = PFQuery(className: "followers")
        followers.whereKey("follower", equalTo: (PFUser.current()?.username)!)
        followers.countObjectsInBackground { (count, error) in
            if error == nil{
              header.followers.text = "\(count)"
            }
        }
        
        //count total following
        let followings = PFQuery(className: "followings")
        followings.whereKey("following", equalTo: (PFUser.current()?.username)!)
        followings.countObjectsInBackground { (count, error) in
            if error == nil{
                header.followings.text = "\(count)"
            }
        }
        
        
        //STEP 3. Impelement top gestures
        
        //tap posts
        let postsTap = UITapGestureRecognizer(target: self, action: #selector(postsT))
        postsTap.numberOfTapsRequired = 1
        header.posts.isUserInteractionEnabled = true
        header.posts.addGestureRecognizer(postsTap)
        
        //tap followers
        let followersTap = UITapGestureRecognizer(target: self, action: #selector(followersT))
        followersTap.numberOfTapsRequired = 1
        header.followers.isUserInteractionEnabled = true
        header.followers.addGestureRecognizer(followersTap)
        
        //tap followings
        let followingsTap = UITapGestureRecognizer(target: self, action: #selector(followingsT))
       followingsTap.numberOfTapsRequired = 1
      header.followings.isUserInteractionEnabled = true
     header.followings.addGestureRecognizer(followingsTap)
        
return header
    }
    
}// homeVC class over line

//custom functions
extension homeVC{
    
    //hold scroll direction
    fileprivate func holdCollectionViewDirection(){
        
      collectionView?.alwaysBounceVertical = true
    }
    
    //taped posts label
    @objc fileprivate func postsT() {
        
        if !picArray.isEmpty{
         let indexPath = IndexPath(item: 0, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: .top, animated: true)
            }
    }
 
   //taped followers label
   @objc fileprivate func followersT() {
    
    varUser = (PFUser.current()?.username)!
    varShow = "followers"
    
    //make references to followersVC
let followers = self.storyboard?.instantiateViewController(withIdentifier: "followersVC") as! followersVC
    
//present
 navigationController?.show(followers, sender: nil)
    }
  
    //taped following label
    @objc fileprivate func followingsT() {
        
varUser = (PFUser.current()?.username)!
varShow = "followings"
 
//make references to followersVC
let followers = self.storyboard?.instantiateViewController(withIdentifier: "followersVC") as! followersVC
        
//present
navigationController?.show(followers, sender: nil)
    }
}




