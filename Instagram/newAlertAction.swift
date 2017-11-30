//
//  newAlertAction.swift
//  Instagram
//
//  Created by Bobby Negoat on 11/30/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

 class newAlertAction: NSObject, NSCopying {
    
    var title: String
    var style: newAlertActionStyle
    var handler: ((newAlertAction) -> Void)!
    var bgColor: UIColor?
    var isEnabled = true

    //title: the title of the action
    //style: the action style
    //bgColor: the background color of the action
    //handler: the handler to fire when interacted with
    required public init(title: String, style: newAlertActionStyle, bgColor: UIColor? = nil, handler: ((newAlertAction) -> Void)!) {
        self.title = title
        self.style = style
        self.bgColor = bgColor
        self.handler = handler
    }

    //zone: the zone
    //Returns: returns a copy of JHTAlertAction
    func copy(with zone: NSZone? = nil) -> Any {
        
        let copy = type(of: self).init(title: title, style: style, bgColor: bgColor, handler: handler)
        copy.isEnabled = self.isEnabled
        return copy
    }
    
}
