//
//  followersVC.swift
//  Instagram
//
//  Created by Bobby Negoat on 11/22/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

var varShow = ""
var varUser = ""

class followersVC: UITableViewController {

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
        
    }
    
    
}
