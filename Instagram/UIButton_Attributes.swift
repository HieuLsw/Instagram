//
//  ss.swift
//  Instagram
//
//  Created by Shao Kahn on 9/14/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit



@IBDesignable
class UIButton_Attributes: UIButton {
    
 
 
   
    
    
}


//UIButton
extension UIButton {
    
//can get gradient color in default loaction or actual loacation
    func applyGradient(colours: [UIColor], locations: [NSNumber]? = nil, stP:CGPoint, edP:CGPoint){
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        gradient.startPoint = stP
        gradient.endPoint = edP
        self.layer.insertSublayer(gradient, at: 0)
    }
 
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }

}

