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
        
    }
    
}

//UICollectionViewDelegate
extension hashtagsVC{
    
    
}

//UICollectionViewDatasource
extension hashtagsVC{
   
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
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
