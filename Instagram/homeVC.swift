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
    
//set the title in the top
        setTopTitle()
        
 //load posts func
   loadPosts()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}//homeVC class over line

//custom functions
extension homeVC{

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
        collectionView?.reloadData()
        
        // stop refresher animating
        refresher.endRefreshing()
    }
   
    //load post func
    fileprivate func loadPosts(){
    
        let query = PFQuery(className: "posts")
        
        guard let currentUsername = PFUser.current()?.username else{return}
        
        query.whereKey("username", equalTo: currentUsername)
        query.limit = page
        
        //clean up
        self.uuidArrary.removeAll(keepingCapacity: false)
        self.picArray.removeAll(keepingCapacity: false)
        
        //find objects related to my request
        query.findObjectsInBackground { (objects, error) in
            if error == nil{
                for object in objects!{
          self.uuidArrary.append(object.value(forKey: "uuid") as! String)
        self.picArray.append(object.value(forKey: "pic") as! PFFile)
                }
            self.collectionView?.reloadData()
            }else{
                print(error!.localizedDescription)
            }
        }
        
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
        
        return header
    }
    
    
    
    
}
