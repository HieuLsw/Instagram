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
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  

   

    
}//homeVC class over line


extension homeVC{

    //title of the top
    func setTopTitle(){
    navigationItem.title = PFUser.current()?.username?.uppercased()
    }
    
}


//colleciton view data source
extension homeVC {
  
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        // Configure the cell
        
        return cell
    }

    
    
}


//collection view delegate
extension homeVC{
    
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
