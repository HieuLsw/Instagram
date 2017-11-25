//
//  editVC.swift
//  Instagram
//
//  Created by Bobby Negoat on 11/24/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import Parse

class editVC: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
        
    @IBOutlet weak var fullnameTxt: UITextField_Attributes!
    
    @IBOutlet weak var usernameTxt: UITextField_Attributes!
    
    @IBOutlet weak var avaImg: UIImageView!
    
    @IBOutlet weak var webTxt: UITextField_Attributes!
    
    @IBOutlet weak var bioTxt: UITextView!
    
    @IBOutlet weak var emailTxt: UITextField_Attributes!
    
    @IBOutlet weak var telTxt: UITextField_Attributes!
    
    @IBOutlet weak var genderTxt: UITextField_Attributes!

    // pickerView & pickerData
var genderPicker : UIPickerView!
{didSet{
    self.genderPicker.dataSource = self
    self.genderPicker.delegate = self
    }
}
    
let genders = ["male","female"]
    
    // value to hold keyboard frame size
var keyboard = CGRect()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //set views layer
        setLayer()
        
        //declare UIPickerView instance and properities
        setPickInstance()
        
        //set up observers
        createObservers()
        
        //some taps
        setTapGestures()
        
        // call information function
        information()
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
    
    // set up observers
    fileprivate func createObservers(){
        
    // check notifications of keyboard - shown or not
 NotificationCenter.default.addObserver(self, selector: #selector(editVC.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
 NotificationCenter.default.addObserver(self, selector: #selector(editVC.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    // func when keyboard is shown
 @objc fileprivate func keyboardWillShow(_ notification: Notification) {
        
        // define keyboard frame size
        keyboard = ((notification.userInfo?[UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue)!
        
        // move up with animation
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.scrollView.contentSize.height = self.view.frame.size.height + self.keyboard.height / 2
        })
    }
    
    
    // func when keyboard is hidden
 @objc fileprivate func keyboardWillHide(_ notification: Notification) {
        
        // move down with animation
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.scrollView.contentSize.height = 0
        })
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
}

//pick view --data source
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

//pick view --delegate
extension editVC{
    
    // picker did selected some value from it
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderTxt.text = genders[row]
        self.view.endEditing(true)
    }
    
}

//image picker -- delegate
extension editVC{
    
    // method to finilize our actions with UIImagePickerController
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        avaImg.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
}
