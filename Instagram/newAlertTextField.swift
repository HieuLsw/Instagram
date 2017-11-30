//
//  newAlertTextField.swift
//  Instagram
//
//  Created by Bobby Negoat on 11/30/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

// A textfield that provides an inset for the text
 class newTextField: UITextField {
    let inset: CGFloat = 10
    
    //placeholder position
    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: inset , dy: 0)
    }
    
    //text position
    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: inset , dy: 0)
    }
    
    // the placeholder rect
    override public func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: inset, dy: 0)
    }
}

