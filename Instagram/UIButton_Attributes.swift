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
    
    
 
    func setGraidentBackground(color1: UIColor, color2: UIColor,stP:CGPoint, edP:CGPoint){
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [color1.cgColor, color2.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = stP
        gradientLayer.endPoint = edP
        
        layer.insertSublayer(gradientLayer, at: 0)
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

