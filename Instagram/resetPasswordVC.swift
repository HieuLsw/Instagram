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
    @IBOutlet weak var emailTxt: UITextField!
 
//Buttons
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        emailTxt.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //the delegate or datasource function
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        emailTxt.resignFirstResponder()
        
        return true
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    //click reset button
    @IBAction func resetBtn_click(_ sender: Any) {
  
 //if emailfield is empty
        if (emailTxt.text?.isEmpty)!{
            
 let alert = UIAlertController(title: "You ~", message: "fogot wirte email?", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
alert.addAction(ok)
present(alert, animated: true, completion: nil)

        }
   
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
           present(alert, animated: ture, completion: nil)
                
            }
        }
        
    }
    
    //click cancel button
    @IBAction func cancelBtn_click(_ sender: Any) {
    
    
    
    
    
    }
    
    
    
}
