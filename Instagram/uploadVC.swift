//
//  uploadVC.swift
//  Instagram
//
//  Created by Bobby Negoat on 11/27/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class uploadVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var picImg: UIImageView!
    
    @IBOutlet weak var titleTxt: UITextView!

    @IBOutlet weak var publishBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // init publichBtn
        initPublishBtn()
        
        // hide kyeboard tap
        tapToHideKyeboard()
        
         // select image tap
        tapToSelectImg()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}// uploadVC class over line

// custom functions
extension uploadVC{

   // init publichBtn
fileprivate func initPublishBtn(){
    self.publishBtn.isEnabled = false
    self.publishBtn.backgroundColor = UIColor.red
}
    
    // hide kyeboard tap
fileprivate func tapToHideKyeboard(){
    let hideTap = UITapGestureRecognizer(target: self, action: #selector(uploadVC.hideKeyboardTap))
    hideTap.numberOfTapsRequired = 1
    self.view.isUserInteractionEnabled = true
    self.view.addGestureRecognizer(hideTap)
}
   
     // select image tap
    fileprivate func tapToSelectImg(){
        let picTap = UITapGestureRecognizer(target: self, action: #selector(uploadVC.selectImg))
        picTap.numberOfTapsRequired = 1
        picImg.isUserInteractionEnabled = true
        picImg.addGestureRecognizer(picTap)
    }
    
    // hide kyeboard function
@objc fileprivate func hideKeyboardTap() {
        self.view.endEditing(true)
    }
    
    // func to call pickerViewController
 @objc fileprivate func selectImg() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    // zooming in / out function
  @objc fileprivate func zoomImg() {
    
    // define frame of zoomed image
    let zoomed = CGRect(x: 0, y: self.view.center.y - self.view.center.x - self.tabBarController!.tabBar.frame.size.height * 1.5, width: self.view.frame.size.width, height: self.view.frame.size.width)
    
    // frame of unzoomed (small) image
    let unzoomed = CGRect(x: 15, y: 15, width: self.view.frame.size.width / 4.5, height: self.view.frame.size.width / 4.5)
    
    // if picture is unzoomed, zoom it
    if picImg.frame == unzoomed {
    
        UIView.animate(withDuration: 0.3, animations: {
            // resize image frame
            self.picImg.frame = zoomed
            
            // hide objects from background
            self.view.backgroundColor = .black
            self.titleTxt.alpha = 0
            self.publishBtn.alpha = 0
        })
        
    }else{
        
        UIView.animate(withDuration: 0.3, animations: {
            // resize image frame
            self.picImg.frame = unzoomed
            
            // unhide objects from background
            self.view.backgroundColor = .white
            self.titleTxt.alpha = 1
            self.publishBtn.alpha = 1
        })
    }
 
    }
}

//image picker --delegate
extension uploadVC{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        picImg.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
    // enable publish btn
       publishBtn.isEnabled = true
        publishBtn.backgroundColor = UIColor(red: 52.0/255.0, green: 169.0/255.0, blue: 255.0/255.0, alpha: 1)
        
    // implement second tap for zooming image
        let zoomTap = UITapGestureRecognizer(target: self, action: #selector(uploadVC.zoomImg))
        zoomTap.numberOfTapsRequired = 1
        picImg.isUserInteractionEnabled = true
        picImg.addGestureRecognizer(zoomTap)
    }
    
}












