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
    
    var activeTextField: UITextField?
 
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
        
   //check text fields is or not written all
            setupAddTargetIsNotEmptyTextFields()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        
        //observe sign In button is or not hidden
        createObserver()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(true)
        
        //release the observers
      releaseObservers()
    }
    

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
  
    @IBAction func setUnwind(sender: UIStoryboardSegue){
    }
    
}//signInVC class over line

//textfield - delegate
extension signInVC{
    
   fileprivate func setupAddTargetIsNotEmptyTextFields() {
        
        //hidden sign In Button
        signInBtn.isHidden = true
        
        usernameTxt.addTarget(self, action: #selector(textFieldsIsOrNotEmpty),
                                    for: .editingChanged)
        passwordTxt.addTarget(self, action: #selector(textFieldsIsOrNotEmpty),
                                     for: .editingChanged)
    
    }
    
  //get the currrent textfield whenever
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
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
  fileprivate  func createObserver(){
    
        NotificationCenter.default.addObserver(self, selector: #selector(signInVC.btnHiddenStackLocation(argu:)), name: NSNotification.Name.init("isHidden"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(signInVC.btnNotHiddenStackLocation(argu:)), name: NSNotification.Name.init("NotHidden"), object:nil)
    
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(argu:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
    
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(argu:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    
    }
    
    
    //if the sign In button is or not hidden, change the stack location
    @objc fileprivate func btnHiddenStackLocation(argu: Notification){
signInBtnHeight.constant = 0
        
        
    }
    @objc fileprivate func btnNotHiddenStackLocation(argu: Notification){
 signInBtnHeight.constant = 60
     
    }
   
    @objc fileprivate func keyboardDidShow(argu: Notification){
        
        let info = argu.userInfo! as NSDictionary
        
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let keyboardY = self.view.frame.size.height - keyboardSize.height
        
        guard let editingTextField = activeTextField?.frame.origin.y else
        {return}
       
        if self.view.frame.origin.y >= 0{
      //Checking if the textfield is really hidden behind the keyboard
        if editingTextField > keyboardY - 60{
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: {
                self.view.frame = CGRect(x: 0.0, y: self.view.frame.origin.y - (editingTextField - (keyboardY - 60)), width: self.view.bounds.size.width, height: self.view.bounds.size.height)
            }, completion: nil)
        }
    }
        
}
    @objc fileprivate func keyboardWillHide(argu: Notification){
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: {
            self.view.frame = CGRect(x: 0.0, y: 0.0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
        }, completion: nil)
    }
    
    
    
 //if all text fields has not been written anything, the sign In button will be hidden
    @objc fileprivate func textFieldsIsOrNotEmpty(sender: UITextField) {
    sender.text = sender.text?.trimmingCharacters(in: .whitespaces)
   

    self.signInBtn.isHidden = (usernameTxt.text?.isEmpty)! || (passwordTxt.text?.isEmpty)!
      
        if self.signInBtn.isHidden{
          NotificationCenter.default.post(name: NSNotification.Name.init("isHidden"), object: nil)
        }else{
 NotificationCenter.default.post(name: NSNotification.Name.init("NotHidden"), object: nil)
        }
        
    }
    
    //release the observers
    fileprivate func releaseObservers(){
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "isHidden"), object: nil)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "NotHidden"), object: nil)
    }
    
    
    //initialize signInt button layout and background
  fileprivate  func initInputFirst(){
    
   signInBtnHeight.constant = 0
 
  signInBtn.applyGradient(colours:[UIColor(hex:"00C3FF"), UIColor(hex:"FFFF1C")], locations:[0.0, 1.0], stP:CGPoint(x:0.0, y:0.0), edP:CGPoint(x:1.0, y:0.0))
    
    
    }
}
