//
//  Line View Mode.swift
//  Instagram
//
//  Created by Shao Kahn on 10/12/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

@IBDesignable
class Line_View_Mode: UIView {

    
    override func draw(_ rect: CGRect) {
        
        //returns a current CGContext
        let cgContext = UIGraphicsGetCurrentContext()
        //set line width, it is euqal to line view height
        cgContext?.setLineWidth(1.0)
        //set dash line color
        cgContext?.setStrokeColor(UIColor.red.cgColor)
        
        //the dash line - red line width is 10 , the between two red lines distance is 3
        let dashArr:[CGFloat] = [10,3]
        //phase determine dash line start in head of 10
        cgContext?.setLineDash(phase: 0.0, lengths: dashArr)
        
        //dash line begin point
        cgContext?.move(to: CGPoint(x: self.bounds.origin.x , y: self.bounds.origin.y ))
        //dash line end point
        cgContext?.addLine(to: CGPoint(x: self.bounds.size.width, y: self.bounds.origin.y ))
        
        //put dash line to line view
        cgContext?.strokePath()
        
    }
    
    
    

}
