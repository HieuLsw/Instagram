//
//  tabbarVC.swift
//  Instagram
//
//  Created by Bobby Negoat on 12/1/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import Parse

class tabbarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set tab bar attributes
    setBarAttributes()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}// tabbarVC class over line

extension tabbarVC{
    
    //set tab bar attributes
    fileprivate func setBarAttributes(){
        
      self.tabBar.isTranslucent = false
    }
}
