//
//  hashtagsVC.swift
//  Instagram
//
//  Created by Bobby Negoat on 12/6/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import Parse

var hashtag = [String]()

class hashtagsVC: UICollectionViewController{

    //UI objects
    var refresher:UIRefreshControl!
    var page = 24
    
    // arrays to hold data from server
    var picArray = [PFFile]()
    var uuidArray = [String]()
    var filterArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set collection attribute
    setCollectionAttribute()
        
        //configue navigation bar
configueNavigationBar()
        
        // pull to refresh
createRefresh()
        
        //back button
createBackButton()
        
        // load hashtags function
loadHashtags()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   
}// hashtagsVC class over line

//custom functions
extension hashtagsVC{
 
    //set collection attribute
    fileprivate func setCollectionAttribute(){
        // be able to pull down even if few post
        self.collectionView?.alwaysBounceVertical = true
    }
    
    //configue navigation bar
    fileprivate func configueNavigationBar(){
        // title at the top
        self.navigationItem.title = "#" + "\(hashtag.last!.uppercased())"
    }
    
    //back button
    fileprivate func createBackButton(){
        
        // new back button
        self.navigationItem.hidesBackButton = true
        let backBtn = UIBarButtonItem(image: UIImage(named: "back.png"), style: .plain, target: self, action: #selector(hashtagsVC.back(_:)))
        self.navigationItem.leftBarButtonItem = backBtn
        
        // swipe to go back
        let backSwipe = UISwipeGestureRecognizer(target: self, action: #selector(hashtagsVC.back(_:)))
        backSwipe.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(backSwipe)
    }
    
     // pull to refresh
    fileprivate func createRefresh(){
    
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(hashtagsVC.refresh), for: UIControlEvents.valueChanged)
        collectionView?.addSubview(refresher)
    }
    
    // load hashtags function
    fileprivate  func loadHashtags() {
    
    // STEP 1. Find poss related to hashtags
let hashtagQuery = PFQuery(className: "hashtags")
    hashtagQuery.whereKey("hashtag", equalTo: hashtag.last!)
    hashtagQuery.findObjectsInBackground (block: { (objects, error) in
            if error == nil {
                
    // clean up
self.filterArray.removeAll(keepingCapacity: false)
                
// store related posts in filterArray
    for object in objects! {
    self.filterArray.append(object.value(forKey: "to") as! String)
}
                
//STEP 2. Find posts that have uuid appended to filterArray
let query = PFQuery(className: "posts")
query.whereKey("uuid", containedIn: self.filterArray)
query.limit = self.page
query.addDescendingOrder("createdAt")
query.findObjectsInBackground(block: { (objects, error) in
    if error == nil {
                        
// clean up
    self.picArray.removeAll(keepingCapacity: false)
    self.uuidArray.removeAll(keepingCapacity: false)
                        
// find related objects
    for object in objects! {
                            
    self.picArray.append(object.value(forKey: "pic") as! PFFile)
    self.uuidArray.append(object.value(forKey: "uuid") as! String)
 }
                        
    // reload
self.collectionView?.reloadData()
self.refresher.endRefreshing()
} else {print(error?.localizedDescription ?? String())
                    }
                })
} else {print(error?.localizedDescription ?? String())
            }
        })
    }
    
    // pagination
   fileprivate func loadMore() {
        
 // if posts on the server are more than shown
    if page <= uuidArray.count {
            
    // increase page size
    page = page + 15
            
    // STEP 1. Find poss related to hashtags
let hashtagQuery = PFQuery(className: "hashtags")
hashtagQuery.whereKey("hashtag", equalTo: hashtag.last!)
    hashtagQuery.findObjectsInBackground (block: { (objects, error) in
        if error == nil {
                    
    // clean up
self.filterArray.removeAll(keepingCapacity: false)
                    
// store related posts in filterArray
    for object in objects! {
self.filterArray.append(object.value(forKey: "to") as! String)
}
                    
//STEP 2. Find posts that have uuid appended to filterArray
    let query = PFQuery(className: "posts")
    query.whereKey("uuid", containedIn: self.filterArray)
    query.limit = self.page
    query.addDescendingOrder("createdAt")
    query.findObjectsInBackground(block: { (objects, error) in
        if error == nil {
                            
            // clean up
        self.picArray.removeAll(keepingCapacity: false)
        self.uuidArray.removeAll(keepingCapacity: false)
                            
    // find related objects
      for object in objects! {
    self.picArray.append(object.value(forKey: "pic") as! PFFile)
    self.uuidArray.append(object.value(forKey: "uuid") as! String)
                            }
                            
// reload
    self.collectionView?.reloadData()
                            
} else {print(error?.localizedDescription ?? String())}})
} else {print(error?.localizedDescription ?? String())
                }
            })
        }
    }
    
    // cell size
   fileprivate func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: self.view.frame.size.width / 3, height: self.view.frame.size.width / 3)
        return size
    }
}

//custom functions selectors
extension hashtagsVC{
    
   @objc fileprivate func back(_ sender : UIBarButtonItem) {
        
        // pop effect back
_ = self.navigationController?.popViewController(animated: true)
        
        // clean hashtag or deduct the last guest userame from guestname = Array
        if !hashtag.isEmpty {
            hashtag.removeLast()
        }
    }
    
    // refreshing func
    @objc fileprivate func refresh() {
        
        loadHashtags()
    }
    
}

//UICollectionViewDelegate
extension hashtagsVC{
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // send post uuid to "postuuid" variable
        postuuid.append(uuidArray[indexPath.row])
        
        // navigate to post view controller
let post = self.storyboard?.instantiateViewController(withIdentifier: "postVC") as! postVC
self.navigationController?.show(post, sender: nil)
    }
}

//UICollectionViewDatasource
extension hashtagsVC{
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // define cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! pictureCell
        
        // get picture from the picArray
        picArray[indexPath.row].getDataInBackground { (data, error) in
            if error == nil {
                cell.picImg.image = UIImage(data: data!)
            }
        }
        
        return cell
    }
}

//UIScrollViewDelegate
extension hashtagsVC{
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= scrollView.contentSize.height / 3 {
            loadMore()
        }
    }
}
