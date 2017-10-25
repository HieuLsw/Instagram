//
//  signInVC.swift
//  Instagram
//
//  Created by Shao Kahn on 9/13/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import Parse

class signInVC: UIViewController,UITextFieldDelegate{
    
    //TextFields
    @IBOutlet weak var usernameTxt: UITextField!
    {didSet{usernameTxt.delegate = self}}
    
    @IBOutlet weak var passwordTxt: UITextField!
{didSet{passwordTxt.delegate = self}}
 
    //Buttons
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var signUpbtn: UIButton!

    @IBOutlet weak var forgotBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
  //initialize text fields false isEnable input
        initInputFirst()
    }



    //clicked sign in button
    @IBAction func signInBtn_click(_ sender: Any) {
   
/*
        //if textfileds are empty
        if (usernameTxt.text?.isEmpty)! || (passwordTxt.text?.isEmpty)!{
         
            let alert = UIAlertController(title: "Wow ~", message: "fill in fields", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
            
        }*/
        
        //login funcitons
        PFUser.logInWithUsername(inBackground: usernameTxt.text!, password: passwordTxt.text!) { (user:PFUser?, error:Error?) in
            
            if error == nil{
               
//remeber user or save in App memory did the user login or not
                UserDefaults.standard.set(user?.username, forKey: "username")
                UserDefaults.standard.synchronize()
                
   //call login function from AppDelegate.swift class
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.login()
                }
            }
        }

}//class over line

//textfield - delegate
extension signInVC{
    
    //click keyboard return to close keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        usernameTxt.resignFirstResponder()
        passwordTxt.resignFirstResponder()
        return true
    }
    
    //if usernameTxt or passwordTxt has not been inputed, the sign In button can't be clicked
     func textFieldDidEndEditing(_ textField: UITextField)  {
        
        
        signInBtn.isEnabled = ((usernameTxt.text! as NSString).length > 0) && ((passwordTxt.text! as NSString).length > 0)
        if signInBtn.isEnabled {
            signInBtn.alpha = AlphaValue.enableClickAlpha.rawValue
            
        }
        else {
            signInBtn.alpha = AlphaValue.disableClickAlpha.rawValue
        }
    }

    
}

//custom functions
extension signInVC{
    

    
    //initialize text fields false isEnable input
  fileprivate  func initInputFirst(){
        
signInBtn.setGraidentBacground(color1: .white, color2: UIColor(hex: "531B93"),stP: CGPoint(x: 0.0, y: 1.0),edP: CGPoint(x: 0.0, y: 0.0))
        
        signInBtn.isEnabled = (usernameTxt.text?.isEmpty)! && (passwordTxt.text?.isEmpty)!
    signInBtn.alpha = AlphaValue.disableClickAlpha.rawValue
    }
}
