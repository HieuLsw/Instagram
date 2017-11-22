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
        let backBtn = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(back(sender:)))
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
    
    
}

//collection --data source
extension guestVC{
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! pictureCell
        
picArray[indexPath.row].getDataInBackground { (data, error) in
    if error == nil{
        cell.picImg.image = UIImage(data: data!)
    } else{print(error!.localizedDescription)}
        }
        
        return cell
    }
    
}

