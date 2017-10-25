//
//  signUpVC.swift
//  Instagram
//
//  Created by Shao Kahn on 9/13/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import Parse

class signUpVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate {
    
//Auto layout height
    @IBOutlet weak var scrollArea: NSLayoutConstraint!
    
//ImageView
    @IBOutlet weak var avaImg: UIImageView!
    
//TextFields
    @IBOutlet weak var emailTxt: UITextField!
        {didSet{emailTxt.delegate = self }}
    
    @IBOutlet weak var usernameTxt: UITextField!
        {didSet{ usernameTxt.delegate = self}}
    
    @IBOutlet weak var passwordTxt: UITextField!
        {didSet{passwordTxt.delegate = self }}
    
    @IBOutlet weak var repeat_passwordTxt: UITextField!
        { didSet{repeat_passwordTxt.delegate = self }}
    
    @IBOutlet weak var fullnameTxt: UITextField!
        {didSet{fullnameTxt.delegate = self }}
    
    @IBOutlet weak var bioTxt: UITextField!
        {didSet{bioTxt.delegate = self}}
    
    @IBOutlet weak var webTxt: UITextField!
        {didSet{webTxt.delegate = self}}
    
//ScrollView
    @IBOutlet weak var scrollView: UIScrollView!

//Buttons
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!

//textfields array

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        
//scrollview scroll area
setScrollArea()
  
//ava image layer
setAvaImgLayer()
        
//declare select image
 declareSelectedImage()
 
//initialize text fields false isEnable input
initInputFirst()
        
}
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    //click sign up
    @IBAction func signUpBtn_click(_ sender: UIButton) {
 
        
        //dismiss keyboard
   self.view.endEditing(true)
  /*
        //if fields are empty
        if (usernameTxt.text?.isEmpty)! || (passwordTxt.text?.isEmpty)! || (repeat_passwordTxt.text?.isEmpty)! || (emailTxt.text?.isEmpty)! || (fullnameTxt.text?.isEmpty)! || (bioTxt.text?.isEmpty)! || (webTxt.text?.isEmpty)!{
     
   let alert = UIAlertController(title: "Hey Hey ~", message: "fill all fields", preferredStyle: .alert)
   let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
  alert.addAction(ok)
present(alert, animated: true, completion: nil)
        
        }*/
    
        //if different passwords
        if passwordTxt.text != repeat_passwordTxt.text{
            
            let alert = UIAlertController(title: "Passwords !!", message: "do not match", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
            
        }

        //send data to server to relative columns
        let user = PFUser()
        user.username = usernameTxt.text?.lowercased()
        user.email = emailTxt.text?.lowercased()
        user.password = passwordTxt.text
        user["fullname"] = fullnameTxt.text?.lowercased()
        user["bio"] = bioTxt.text
        user["web"] = webTxt.text?.lowercased()
        
        //in Edited Profile it's gonna be assigned
        user["tel"] = ""
        user["gender"] = ""
        
        //convert our image for sending to server
       let avaData = UIImageJPEGRepresentation(avaImg.image!, 0.5)
     let avaFile = PFFile(name: "ava.jpg", data: avaData!)
     user["ava"] = avaFile
      
        //save data in server
        user.signUpInBackground { (success:Bool, error:Error?) in
            if success{
                
                //remember logged user 
                UserDefaults.standard.set(user.username, forKey: "username")
                UserDefaults.standard.synchronize()
               
                //call login func from AppleDelegate.swift class
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.login() 
                
            }else{
                
                print(error ?? "")
                
            }
        }
        
    }
   
    //click cancel
    @IBAction func cancelBtn_click(_ sender: Any) {
   self.dismiss(animated: true, completion: nil)
    }

    
    
}//class over line


//textfield - delegate
extension signUpVC{
    
    
   //if all textfields are be inputed the button is enable
    func textFieldDidEndEditing(_ textField: UITextField) {
        
      signUpBtn.isEnabled = (usernameTxt.text?.isEmpty)! && (passwordTxt.text?.isEmpty)! && (repeat_passwordTxt.text?.isEmpty)! && (emailTxt.text?.isEmpty)! && (fullnameTxt.text?.isEmpty)! && (bioTxt.text?.isEmpty)! && (webTxt.text?.isEmpty)!
        
        if signUpBtn.isEnabled {
            signUpBtn.alpha = AlphaValue.enableClickAlpha.rawValue}
        else {
            signUpBtn.alpha = AlphaValue.disableClickAlpha.rawValue
        }
    }
    
    //the delegate or datasource function
 func textFieldShouldReturn(_ textField: UITextField) -> Bool {
_ = [usernameTxt,passwordTxt,repeat_passwordTxt,fullnameTxt,bioTxt,webTxt,emailTxt].map{ $0.resignFirstResponder()}
  
        return true
    }//func make that user clicks return can tab keyboard true
    
}

//imagepick - delegate
extension signUpVC{
    
    
    
    //func connect selected image to our ImageView
   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        avaImg.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
}


//Layout
extension signUpVC{
    
 fileprivate func setScrollArea(){
        //scrollview scroll area
        scrollArea.constant = 900
        
    }
    
  fileprivate  func setAvaImgLayer(){
        //round ava
        avaImg.layer.cornerRadius = avaImg.frame.size.width / 2
        //clip image
        avaImg.clipsToBounds = true
    
      avaImg.layer.borderWidth = 3
    avaImg.layer.borderColor = UIColor.black.cgColor
    }
}

//custom functions
extension signUpVC {
    
    //initialize text fields false isEnable input
 fileprivate   func initInputFirst(){
    
    signUpBtn.setGraidentBacground(color1: .black, color2: UIColor(hex: "004080"),stP: CGPoint(x: 0.0, y: 1.0),edP: CGPoint(x: 0.0, y: 0.0))
    
    signUpBtn.isEnabled = (usernameTxt.text?.isEmpty)! && (passwordTxt.text?.isEmpty)! && (repeat_passwordTxt.text?.isEmpty)! && (emailTxt.text?.isEmpty)! && (fullnameTxt.text?.isEmpty)! && (bioTxt.text?.isEmpty)! && (webTxt.text?.isEmpty)!
    
        signUpBtn.alpha = AlphaValue.disableClickAlpha.rawValue
    
    }
    
    //declare select image
 fileprivate   func declareSelectedImage(){
        let avaTap = UITapGestureRecognizer(target: self, action: #selector(self.loadImg(recognizer:)))
        avaTap.numberOfTapsRequired = 1
        avaImg.isUserInteractionEnabled = true //user can click image
        avaImg.addGestureRecognizer(avaTap)
    }
    
    
    //choose the photo from the phone library
  @objc fileprivate func loadImg(recognizer:UITapGestureRecognizer){
   
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        
    }
}


