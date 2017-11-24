//
//  editVC.swift
//  Instagram
//
//  Created by Bobby Negoat on 11/24/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class editVC: UIViewController {

    @IBOutlet weak var fullnameTxt: UITextField_Attributes!
    
    @IBOutlet weak var usernameTxt: UITextField_Attributes!
    
    @IBOutlet weak var avaImg: UIImageView!
    
    @IBOutlet weak var webTxt: UITextField_Attributes!
    
    @IBOutlet weak var bioTxt: UITextView!
    
    @IBOutlet weak var emailTxt: UITextField_Attributes!
    
    @IBOutlet weak var telTxt: UITextField_Attributes!
    
    @IBOutlet weak var genderTxt: UITextField_Attributes!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //set Img view layer
        setImgLayer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    
// clicked save button
    @IBAction func save_clicked(_ sender: Any) {
    
    }
    
// clicked cancel button
    @IBAction func cancel_clicked(_ sender: Any) {
       
        //close the keyboard
        self.view.endEditing(true)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    

}// editVC class over line

//custom functions
extension editVC{
    
    //set img view layer
    fileprivate func setImgLayer(){
        avaImg.layer.cornerRadius = avaImg.bounds.size.width / 2
        avaImg.layer.borderColor = UIColor.red.cgColor
        avaImg.layer.borderWidth = 2
    }
    
}

