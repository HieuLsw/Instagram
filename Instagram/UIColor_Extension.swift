//
//  UIColor_Extension.swift
//  Instagram
//
//  Created by Bobby Negoat on 11/30/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

extension UIColor {
    
    //Returns: the lighter color
     func lightColor() -> UIColor {
        return self.withAlphaComponent(0.5)
    }
    
    //Returns: the darker color
     func darker() -> UIColor {
        
        var r:CGFloat = 0, g:CGFloat = 0, b:CGFloat = 0, a:CGFloat = 0
        
        if self.getRed(&r, green: &g, blue: &b, alpha: &a){
            return UIColor(red: max(r - 0.2, 0.0), green: max(g - 0.2, 0.0), blue: max(b - 0.2, 0.0), alpha: a)
        }
        
        return UIColor()
    }
    
    //color: the color to create an image from
    //size: the size of the image
    //Returns: the image with the color specified
    class func imageWithColor(_ color: UIColor, size: CGSize = CGSize(width: 60, height: 60)) -> UIImage {
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        return image
    }
    
   //size: the size of the image
    //Returns: the image with the color specified
     func imageWithColor(size: CGSize = CGSize(width: 60, height: 60)) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context!.setFillColor(self.cgColor)
        context!.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        return image
    }
}

