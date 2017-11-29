//
//  guestVC.swift
//  Instagram
//
//  Created by Bobby Negoat on 11/23/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import Parse

var guestName = [String]()


class guestVC: UICollectionViewController {

    //UI objects
    var refresher:UIRefreshControl!
    var page = 10
    
    //arrays to hold data from server
    var uuidArray = [String]()
    var picArray = [PFFile]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

// hold scroll direction
         holdScrollDirection()

// set refresher
    setRefresher()
        
// set navigationBar
  topSetting()
 
        // call load posts function
        loadPosts()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   
}// gusetVC class over line

//custom functions
extension guestVC{
    
    fileprivate func holdScrollDirection(){
        
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = .white
    }
    
    fileprivate func topSetting(){
        
        //top title
        navigationItem.title = guestName.last
        
        navigationItem.hidesBackButton = true
        
        //new back button
        let backBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(back(sender:)))
        navigationItem.leftBarButtonItem = backBtn
        
        //swipe to go back
        let backSwipe = UISwipeGestureRecognizer(target: self, action: #selector(back(sender:)))
        backSwipe.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(backSwipe)
       
    
    }
  
    //add refresh control
    fileprivate func setRefresher(){
        
       refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(afterRefresher), for: .valueChanged)
        collectionView?.addSubview(refresher)
        
    }
    
    //back function
     @objc fileprivate func back(sender: UIBarButtonItem){
     
//push back
    self.navigationController?.popViewController(animated: true)
    
  //clean guest username or detect the last guest username from guestName array
        if !guestName.isEmpty{
        
       guestName.removeLast()
        
        }
}
  
  // refresh functions
 @objc fileprivate func afterRefresher(){
    
    refresher.endRefreshing()
    loadPosts()
    }
    
    // post loading function
    fileprivate func loadPosts(){
        // load posts
        let query = PFQuery(className: "posts")
        query.whereKey("username", equalTo: (guestName.last)!)
query.limit = page
query.findObjectsInBackground (block: { (objects, error)  in
    if error == nil {
                
    // clean up
self.uuidArray.removeAll(keepingCapacity: false)
    self.picArray.removeAll(keepingCapacity: false)
                
    // find related objects
for object in objects! {
                    
    // hold found information in arrays
    self.uuidArray.append(object.value(forKey: "uuid") as! String)
self.picArray.append(object.value(forKey: "pic") as! PFFile)
    }
                
self.collectionView?.reloadData()
 } else {print(error!.localizedDescription)}
    })
   }
    
  
    // tapped posts label
   @objc func _postsTap() {
        
        if !picArray.isEmpty {
            let index = IndexPath(item: 0, section: 0)
            self.collectionView?.scrollToItem(at: index, at: UICollectionViewScrollPosition.top, animated: true)
        }
    }
    
    // tapped followers label
    @objc func _followersTap() {
        varUser = (guestName.last)!
        varShow = "followers"
        
        // defind followersVC
        let followers = self.storyboard?.instantiateViewController(withIdentifier: "followersVC") as! followersVC
        
        // navigate to it
self.navigationController?.pushViewController(followers, animated: true)
    }
    
    // tapped followings label
    @objc func _followingsTap() {
        varUser = (guestName.last)!
        varShow = "followings"
        
        // define followersVC
        let followings = self.storyboard?.instantiateViewController(withIdentifier: "followersVC") as! followersVC
        
        // navigate to it
self.navigationController?.pushViewController(followings, animated: true)
    }
    
    fileprivate func loadMore(){
        
        // if there is more objects
        if self.page <= picArray.count{
            
            // increase page size
            page = page + 12
            // load more posts
            let query = PFQuery(className: "posts")
            query.whereKey("username", equalTo: (guestName.last)!)
            query.limit = page
            query.findObjectsInBackground(block: { (objects, error) in
                if error == nil {
                    
  // clean up
self.uuidArray.removeAll(keepingCapacity: false)
self.picArray.removeAll(keepingCapacity: false)
                    
        // find related objects
    for object in objects! {
    
    self.uuidArray.append(object.value(forKey: "uuid") as! String)
    self.picArray.append(object.value(forKey: "pic") as! PFFile)
        }
    self.collectionView?.reloadData()
  } else {print(error?.localizedDescription ?? String())}
            })
        }
    }
}

//collection --data source
extension guestVC{
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
   
   //dequeue
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! pictureCell

 //connect data from array to picImg object from pictureCell class
picArray[indexPath.row].getDataInBackground { (data, error) in
    if error == nil{
        cell.picImg.image = UIImage(data: data!)
    } else{print(error!.localizedDescription)}
        }
        
        return cell
    }
    
}

//collection view --delegate
extension guestVC{
    
    // cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: self.view.frame.size.width / 3, height: self.view.frame.size.width / 3)
        return size
    }

   //header config
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath) as! headerView
        
        //STEP 1. Load data of guest
        let infoQuery = PFQuery(className: "_User")
        infoQuery.whereKey("username", equalTo: (guestName.last)!)
        infoQuery.findObjectsInBackground { (objects, error) in
            
    if error == nil{
        
           //shown wrong user
        if objects!.isEmpty{
            print("wrong user")
        }
        
        // find related to user infomation
        _ = objects!.map{
            header.fullnameLbl.text = ($0.object(forKey: "fullname") as? String)?.uppercased()
            header.bioLbl.text = $0.object(forKey: "bio") as? String
            header.bioLbl.sizeToFit()
            header.webTxt.text = $0.object(forKey: "web") as? String
             header.webTxt.sizeToFit()
            let avaFile = ($0.object(forKey: "ava") as? PFFile)!
            avaFile.getDataInBackground(block: { (data, error) -> Void in
                header.avaImg.image = UIImage(data: data!)
            })
        }
            }
    else{print(error!.localizedDescription)}
       }
        
    // STEP 2. Show do current user follow guest or do not
        let followQuery = PFQuery(className: "follow")
        followQuery.whereKey("follower", equalTo: (PFUser.current()!.username)!)
        followQuery.whereKey("following", equalTo: (guestName.last)!)
        followQuery.countObjectsInBackground { (count, error) in
            if error == nil{
                if count == 0 {
                    header.button.setTitle("FOLLOW", for: UIControlState())
                    header.button.backgroundColor = .lightGray
                } else {
                    header.button.setTitle("FOLLOWING", for: UIControlState())
                    header.button.backgroundColor = .green
                }
            }else {
                print(error!.localizedDescription)
            }

        }
        
        // STEP 3. Count statistics
        // count posts
        let posts = PFQuery(className: "posts")
        posts.whereKey("username", equalTo: (guestName.last)!)
        posts.countObjectsInBackground { (count, error) in
            if error == nil {
                header.posts.text = "\(count)"
            } else {
                print(error!.localizedDescription)
            }
        }
        
        
        // count followers
        let followers = PFQuery(className: "follow")
        followers.whereKey("following", equalTo: (guestName.last)!)
        followers.countObjectsInBackground
            { (count, error)  in
            if error == nil {
                header.followers.text = "\(count)"
            } else {
                print(error!.localizedDescription)
            }
        }

        // count followings
        let followings = PFQuery(className: "follow")
        followings.whereKey("follower", equalTo: (guestName.last)!)
        followings.countObjectsInBackground
            { (count, error) in
            if error == nil {
                header.followings.text = "\(count)"
            } else {
                print(error!.localizedDescription)
            }
        }
        
        // STEP 4. Implement tap gestures
        // tap to posts label
        let postsTap = UITapGestureRecognizer(target: self, action: #selector(_postsTap))
        postsTap.numberOfTapsRequired = 1
        header.posts.isUserInteractionEnabled = true
        header.posts.addGestureRecognizer(postsTap)
        
        // tap to followers label
        let followersTap = UITapGestureRecognizer(target: self, action: #selector(_followersTap))
        followersTap.numberOfTapsRequired = 1
        header.followers.isUserInteractionEnabled = true
        header.followers.addGestureRecognizer(followersTap)
        
        // tap to followings label
        let followingsTap = UITapGestureRecognizer(target: self, action: #selector(_followingsTap))
       followingsTap.numberOfTapsRequired = 1
header.followings.isUserInteractionEnabled = true
header.followings.addGestureRecognizer(followingsTap)
        
return header
    }
    
}

// scroll view --delegate
extension guestVC{
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let verticalIndicator: UIImageView = (scrollView.subviews[(scrollView.subviews.count - 1)] as! UIImageView)
        verticalIndicator.backgroundColor = UIColor.red
        
        if scrollView.contentOffset.y >= scrollView.contentSize.height - self.view.frame.size.height {
            loadMore()
        }
    }
}


