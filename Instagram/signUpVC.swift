//
//  signUpVC.swift
//  Instagram
//
//  Created by Shao Kahn on 9/13/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class signUpVC: UIViewController {
    
//ImageView
    @IBOutlet weak var avaImg: UIImageView!
    
//TextFields
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var repeat_passwordTxt: UITextField!

    @IBOutlet weak var fullnameTxt: UITextField!
    @IBOutlet weak var bioTxt: UITextField!
    @IBOutlet weak var webTxt: UITextField!
 
//ScrollView
    @IBOutlet weak var scrollView: UIScrollView!

//Buttons
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    //resert deault size
    var scrollViewHeight:CGFloat = 0

    //keyboard frame size
    var keyboard = CGRect()
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    //click sign up
    @IBAction func signUpBtn_click(_ sender: Any) {
   
    }
   
    //click cancel
    @IBAction func cancelBtn_click(_ sender: Any) {
   self.dismiss(animated: true, completion: nil)
    }

    
    
}
