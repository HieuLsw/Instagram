//
//  navVC.swift
//  Instagram
//
//  Created by Bobby Negoat on 11/24/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class navVC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

      //set navigation bar attributes
        setNavBarAtrributes()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
}// navVC class over line

//custom functions
extension navVC{

    //set navigation bar attributes
    fileprivate func setNavBarAtrributes(){
        
        // color of title at the top in nav controller
        self.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        
        // color of buttons in nav controller
        self.navigationBar.tintColor = UIColor.white
        
        // color of background of nav controller
        self.navigationBar.barTintColor = #colorLiteral(red: 0.1920000017, green: 0.275000006, blue: 0.5059999824, alpha: 1)
        
        // disable translucent
        self.navigationBar.isTranslucent = false
    }

}
