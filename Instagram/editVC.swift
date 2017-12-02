//
//  editVC.swift
//  Instagram
//
//  Created by Bobby Negoat on 11/24/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import Parse

class editVC: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UIScrollViewDelegate{

    @IBOutlet weak var scrollView: UIScrollView!
        
    @IBOutlet weak var fullnameTxt: UITextField_Attributes!
    {didSet{self.fullnameTxt.delegate = self}}
    
    @IBOutlet weak var usernameTxt: UITextField_Attributes!
        {didSet{self.usernameTxt.delegate = self}}
    
    @IBOutlet weak var avaImg: UIImageView!
    
    @IBOutlet weak var webTxt: UITextField_Attributes!
    {didSet{self.webTxt.delegate = self}}
    
    @IBOutlet weak var bioTxt: UITextView!
    
    @IBOutlet weak var emailTxt: UITextField_Attributes!
    {didSet{self.emailTxt.delegate = self}}
    
    @IBOutlet weak var telTxt: UITextField_Attributes!
    {didSet{self.telTxt.delegate = self}}
    
    @IBOutlet weak var genderTxt: UITextField_Attributes!

    // pickerView & pickerData
var genderPicker : UIPickerView!
{didSet{
    self.genderPicker.dataSource = self
    self.genderPicker.delegate = self
    }
}
    
    var genders = [""]
    
    // value to hold keyboard frame size
    var keyboard:CGRect!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.genders = ["male","female"]
        self.keyboard = CGRect()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    //set views layer
    setLayer()
        
    //declare UIPickerView instance and properities
    setPickInstance()
        
    //some taps
    setTapGestures()
        
    // call information function
    information()
        
    // add done button above keyboard
    addDoneButton()
        
    // set text view placehold
    setTextViewPlacehold()
    }

    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
        
        //set up observers
        createObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //release observers
deleteObservers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    
// clicked save button
    @IBAction func save_clicked(_ sender: Any) {
    
 guard Validate.email(emailTxt.text!).isRight else{
    alert("Incorrect email", message: "please provide correct email address")
return}
  
    guard Validate.URL(webTxt.text!).isRight else{
    alert("Incorrect web-link", message: "please provide correct website")
return}
        
        // save filled in information
        let user = PFUser.current()!
        user.username = usernameTxt.text?.lowercased()
        user.email = emailTxt.text?.lowercased()
        user["fullname"] = fullnameTxt.text?.lowercased()
        user["web"] = webTxt.text?.lowercased()
        user["bio"] = bioTxt.text
        
        // if "tel" is empty, send empty data, else entered data
        if telTxt.text!.isEmpty {
            user["tel"] = ""
        } else {
            user["tel"] = telTxt.text
        }
        
        // if "gender" is empty, send empty data, else entered data
        if genderTxt.text!.isEmpty {
            user["gender"] = ""
        } else {
            user["gender"] = genderTxt.text
        }
        
        // send profile picture
        let avaData = UIImageJPEGRepresentation(avaImg.image!, 0.5)
        let avaFile = PFFile(name: "ava.jpg", data: avaData!)
        user["ava"] = avaFile
        
        UserDefaults.standard.removeObject(forKey: "username")
        UserDefaults.standard.set(user.username, forKey: "username")
        UserDefaults.standard.synchronize()
        
        // send filled information to server
user.saveInBackground (block: { (success, error) in
            if success{
                
                // hide keyboard
                self.view.endEditing(true)
                
                // dismiss editVC
                self.dismiss(animated: true, completion: nil)
                
                // send notification to homeVC to be reloaded
                NotificationCenter.default.post(name: Notification.Name(rawValue: "reload"), object: nil)
                
            } else {
                print(error!.localizedDescription)
            }
        })
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
    
    //set views layer
    fileprivate func setLayer(){
        
        //img layer
        avaImg.layer.cornerRadius = avaImg.bounds.size.width / 2
        avaImg.layer.borderColor = UIColor.red.cgColor
        avaImg.layer.borderWidth = 2
        
        //text view layer
        bioTxt.backgroundColor = UIColor.white
        bioTxt.layer.borderColor = UIColor.black.cgColor
        bioTxt.layer.borderWidth = 1
        bioTxt.layer.cornerRadius = 0
    }
    
    //declare UIPickerView instance and properities
    fileprivate func setPickInstance(){
        self.genderPicker = UIPickerView()
        self.genderPicker.backgroundColor = UIColor.groupTableViewBackground
        self.genderPicker.showsSelectionIndicator = true
        self.genderTxt.inputView = genderPicker
    }
    
   //some taps
    fileprivate func setTapGestures(){
        
        // tap to hide keyboard
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(editVC.hideKeyboard))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        // tap to choose image
        let avaTap = UITapGestureRecognizer(target: self, action: #selector(editVC.loadImg(_:)))
        avaTap.numberOfTapsRequired = 1
        avaImg.isUserInteractionEnabled = true
        avaImg.addGestureRecognizer(avaTap)
    }
    
    //user information function
    fileprivate func information(){
       
     //receive profile picture
        let ava = PFUser.current()?.object(forKey: "ava") as! PFFile
        ava.getDataInBackground { (data, error) in
            self.avaImg.image = UIImage(data: data!)
        }
      
        // receive text information
        usernameTxt.text = PFUser.current()?.username
        fullnameTxt.text = PFUser.current()?.object(forKey: "fullname") as? String
        bioTxt.text = PFUser.current()?.object(forKey: "bio") as? String
        webTxt.text = PFUser.current()?.object(forKey: "web") as? String
        
        emailTxt.text = PFUser.current()?.email
        telTxt.text = PFUser.current()?.object(forKey: "tel") as? String
        genderTxt.text = PFUser.current()?.object(forKey: "gender") as? String
    }
    
    
    // alert message function
  fileprivate func alert (_ error: String, message : String) {
        let alert = UIAlertController(title: error, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    // add done button above keyboard
    fileprivate func addDoneButton(){
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(hideKeyboard))
        
        toolBar.setItems([flexibleSpace,doneButton], animated: true)
        
        self.bioTxt.inputAccessoryView = toolBar
    }
    
    // set text view placehold
    fileprivate func setTextViewPlacehold(){
        
        bioTxt.placeholder = "Write something..."
    }
}

//custom functions selectors
extension editVC{
    
    // func to hide keyboard
    @objc fileprivate func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    // func to call UIImagePickerController
    @objc fileprivate func loadImg (_ recognizer : UITapGestureRecognizer) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
}

//observers
extension editVC{
    
    // set up observers
    fileprivate func createObservers(){
        
        // check notifications of keyboard - shown or not
        NotificationCenter.default.addObserver(self, selector: #selector(editVC.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(editVC.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    //release observers
    fileprivate func deleteObservers(){
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
}

//observers selectors
extension editVC{
  
    // func when keyboard is shown
    @objc fileprivate func keyboardWillShow(_ notification: Notification) {
        
        // define keyboard frame size
        keyboard = ((notification.userInfo?[UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue)!
        
        // move up with animation
        UIView.animate(withDuration: 0.4, animations: { [unowned self] in
            self.scrollView.contentSize.height = self.view.frame.size.height + self.keyboard.height / 2
        })
    }
    
    
    // func when keyboard is hidden
    @objc fileprivate func keyboardWillHide(_ notification: Notification) {
        
        // move down with animation
        UIView.animate(withDuration: 0.4, animations: {[unowned self] in
            self.scrollView.contentSize.height = 0
        })
    }
}

//UIPickerViewDataSource
extension editVC{
    
    //pick component num
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return genders.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return genders[row]
    }
}

//UIPickerViewDelegate
extension editVC{
    
    // picker did selected some value from it
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderTxt.text = genders[row]
        self.view.endEditing(true)
    }
    
}

//UIImagePickerControllerDelegate
extension editVC{
    
    // method to finilize our actions with UIImagePickerController
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        avaImg.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
}

//UITextFieldDelegate
extension editVC{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
_ = [fullnameTxt,usernameTxt,webTxt,emailTxt,telTxt].map{$0?.resignFirstResponder()
        }
        return true
    }
}

//UIScrollViewDelegate
extension editVC{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let verticalIndicator = (scrollView.subviews[(scrollView.subviews.count - 1)] as! UIImageView)
        verticalIndicator.backgroundColor = UIColor.orange
    }
}
