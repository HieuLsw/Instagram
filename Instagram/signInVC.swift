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
    
    @IBOutlet weak var signInBtnHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var assisView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
 
  
        
  //initialize text fields false isEnable input
        initInputFirst()
        
   //observe sign In button is or not hidden
        createObserver()
    
   //check text fields is or not written all
            setupAddTargetIsNotEmptyTextFields()
        
     
    }


   /* deinit {
        NotificationCenter.removeObserver(Notification.Name.init("isHidden"))
        NotificationCenter.removeObserver(Notification.Name.init("NotHidden"))
 }
 */
    

    //clicked sign in button
    @IBAction func signInBtn_click(_ sender: Any) {

        
        //login funcitons
        PFUser.logInWithUsername(inBackground: usernameTxt.text!, password: passwordTxt.text!) { (user:PFUser?, error:Error?) in
            
            if error == nil{
               
//remeber user or save in App memory did the user login or not
                UserDefaults.standard.set(user?.username, forKey: "username")
                UserDefaults.standard.synchronize()
                
   //call login function from AppDelegate.swift class
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.login()
            }else{
                //another case
            let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
}//class over line

//textfield - delegate
extension signInVC{
    
   fileprivate func setupAddTargetIsNotEmptyTextFields() {
        
        //hidden sign In Button
        signInBtn.isHidden = true
        
        usernameTxt.addTarget(self, action: #selector(textFieldsIsNotEmpty),
                                    for: .editingChanged)
        passwordTxt.addTarget(self, action: #selector(textFieldsIsNotEmpty),
                                     for: .editingChanged)
    
    }
    
    //click keyboard return to close keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        usernameTxt.resignFirstResponder()
        passwordTxt.resignFirstResponder()
        return true
    }
    
 

    
}

//custom functions
extension signInVC{
    
    //observe the sign In button is or not hidden
    func createObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(signInVC.btnHiddenStackLocation(argu:)), name: NSNotification.Name.init("isHidden"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(signInVC.btnNotHiddenStackLocation(argu:)), name: NSNotification.Name.init("NotHidden"), object:nil)
    }
    
    //if the sign In button is or not hidden, change the stack location
    func btnHiddenStackLocation(argu: Notification){
signInBtnHeight.constant = 0
        
        
    }
    
    func btnNotHiddenStackLocation(argu: Notification){
 signInBtnHeight.constant = 60
     
    }
    
 //if all text fields has not been written anything, the sign In button will be hidden
    @objc fileprivate func textFieldsIsNotEmpty(sender: UITextField) {
    sender.text = sender.text?.trimmingCharacters(in: .whitespaces)
    
    guard
        let username = usernameTxt.text, !username.isEmpty ,
        let password = passwordTxt.text, !password.isEmpty
        else
    {
        self.signInBtn.isHidden = true
        NotificationCenter.default.post(name: NSNotification.Name.init("isHidden"), object: nil)
        return
    }
    // enable okButton if all conditions are met

    self.signInBtn.isHidden = false
 NotificationCenter.default.post(name: NSNotification.Name.init("NotHidden"), object: nil)
 
    }
    
    //initialize signInt button layout and background
  fileprivate  func initInputFirst(){
    
   signInBtnHeight.constant = 0
 
  signInBtn.applyGradient(colours:[UIColor(hex:"00C3FF"), UIColor(hex:"FFFF1C")], locations:[0.0, 1.0], stP:CGPoint(x:0.0, y:0.0), edP:CGPoint(x:1.0, y:0.0))
    
    
    }
}
