//
//  ViewController.swift
//  Instagram
//
//  Created by Shao Kahn on 9/12/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let object = PFObject(className: "testObject")
        object["firstname"] = "Shao"
        object["lastname"] = "Kahn"
        object.saveInBackground { (done:Bool, error:Error?) in
            if done{
                print("Saved in server")
            }else{
                print(error)
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

