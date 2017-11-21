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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
 //self - delegate
       
//initalize button
        initInputFirst()
 
  //initalize reset btn
 initResetBtn()
    
    }

    
    //when users open this VC, the keyboard will appear at once
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        emailTxt.becomeFirstResponder()
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    @IBAction func resetBtn_click(_ sender: Any) {
  /*
 //if emailfield is empty
        if (emailTxt.text?.isEmpty)!{
            
 let alert = UIAlertController(title: "You ~", message: "fogot wirte email?", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
alert.addAction(ok)
present(alert, animated: true, completion: nil)

        }*/
   
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

 sender.text = sender.text?.trimmingCharacters(in: .whitespaces)
        
        resetBtn.isHidden = (emailTxt.text?.isEmpty)!
    }

}//class over line


//textfield - delegate
extension  resetPasswordVC{

    
   
    
    //the delegate or datasource function
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        emailTxt.resignFirstResponder()
        
        return true
        
    }
    
    
}

//custom functions
extension resetPasswordVC {

    //initalize reset button
    fileprivate func initResetBtn(){
        resetBtn.isHidden = true
    }
    
    //initialize text fields false isEnable input
    fileprivate  func initInputFirst(){
       
        self.resetBtn.applyGradient(colours: [UIColor(hex: "FDFC47"), UIColor(hex: "24FE41")], locations: [0.0, 1.0], stP: CGPoint(x:0.0, y:0.0), edP: CGPoint(x:1.0, y:0.0))
        
        self.cancelBtn.applyGradient(colours: [UIColor(hex: "004FF9"), UIColor(hex: "833AB4")], locations: [0.0, 1.0], stP: CGPoint(x:0.0, y:0.0), edP: CGPoint(x:1.0, y:0.0))
        
    }
    
    
}















