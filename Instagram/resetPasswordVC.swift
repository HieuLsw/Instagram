//
//  resetPasswordVC.swift
//  Instagram
//
//  Created by Shao Kahn on 9/13/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import Parse

class resetPasswordVC: UIViewController,UITextFieldDelegate {
    
//Textfield
    @IBOutlet weak var emailTxt: UITextField!{didSet{emailTxt.delegate = self}}

//Buttons
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!

//layout
    @IBOutlet weak var distanceOfBtnAndTxtF: NSLayoutConstraint!
    @IBOutlet weak var resetBtnHeight: NSLayoutConstraint!
    
    var currentTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
 
        
//initalize button
        initInputFirst()
 
  //initalize reset btn
 initResetBtn()
    }

    
    
    //when users open this VC, the keyboard will appear at once
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
  //convert emailTxt to first responder
         createFirstResponder()
        
        //create observers
        setUpObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(true)
        
        //deallocate observers
        deallocateObservers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func resetBtn_click(_ sender: Any) {
   
//request for reseting password
PFUser.requestPasswordResetForEmail(inBackground: emailTxt.text!) { (success:Bool, error:Error?) in
            
    if success{
            
    //show alert message
let alert = UIAlertController(title: "Email for reseting password", message: "has been sent to texted Email", preferredStyle: .alert)
                
    //if press OK call self.dismiss... function
   let ok = UIAlertAction(title: "OK", style: .default, handler: { (action:UIAlertAction) in
                    
     self.dismiss(animated: true, completion: nil)
})
           alert.addAction(ok)
           self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    //click cancel button
    @IBAction func cancelBtn_click(_ sender: Any) {
    
 }
   
    @IBAction func emailTextFieldTap(_ sender: UITextField) {

        resetBtn.isHidden = (emailTxt.text?.isEmpty)!
        
        if resetBtn.isHidden{
        NotificationCenter.default.post(name: NSNotification.Name.init("didHidden"), object: nil)
        }else {
            NotificationCenter.default.post(name: NSNotification.Name.init("disHidden"), object: nil)
        }
    }
}//class over line

//custom functions
extension resetPasswordVC {

    //convert emailTxt to first responder
    fileprivate func createFirstResponder(){
         emailTxt.becomeFirstResponder()
    }
    
    //initalize reset button
    fileprivate func initResetBtn(){
        resetBtn.isHidden = true
        resetBtnHeight.constant = 0.0
        distanceOfBtnAndTxtF.constant = 0.0
    }

    //initialize text fields false isEnable input
    fileprivate  func initInputFirst(){
       
        self.resetBtn.applyGradient(colours: [UIColor(hex: "FDFC47"), UIColor(hex: "24FE41")], locations: [0.0, 1.0], stP: CGPoint(x:0.0, y:0.0), edP: CGPoint(x:1.0, y:0.0))
        
        self.cancelBtn.applyGradient(colours: [UIColor(hex: "004FF9"), UIColor(hex: "833AB4")], locations: [0.0, 1.0], stP: CGPoint(x:0.0, y:0.0), edP: CGPoint(x:1.0, y:0.0))
    }
}

//observers
extension resetPasswordVC{
    
    fileprivate func setUpObservers(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(didResetBtnHidden(argu:)), name: NSNotification.Name.init("didHidden"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(disResetBtnHidden(argu:)), name: NSNotification.Name.init("disHidden"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(argu:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(argu:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    fileprivate func deallocateObservers(){
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init("didHidden"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init("disHidden"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
}

//observers selectors
extension resetPasswordVC{
    
    @objc fileprivate func didResetBtnHidden(argu:Notification){
        self.distanceOfBtnAndTxtF.constant = 0.0
        self.resetBtnHeight.constant = 0.0
    }
    
    @objc fileprivate func disResetBtnHidden(argu:Notification){
        self.distanceOfBtnAndTxtF.constant = 58.0
        self.resetBtnHeight.constant = self.cancelBtn.bounds.size.height
    }
    
    @objc fileprivate func keyboardDidShow(argu:Notification){
        
        let info = argu.userInfo! as NSDictionary
        
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let keyboardY = self.view.frame.size.height - keyboardSize.height
        
        guard let editingTextField = currentTextField?.frame.origin.y else
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
    
    @objc fileprivate func keyboardWillHide(argu:Notification){
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: {
            self.view.frame = CGRect(x: 0.0, y: 0.0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
        }, completion: nil)
    }
}

//UITextFieldDelegate
extension resetPasswordVC{
    
    //get current textfield context
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        currentTextField = textField
    }
    
    //the delegate or datasource function
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        emailTxt.resignFirstResponder()
        return true
    }
}









