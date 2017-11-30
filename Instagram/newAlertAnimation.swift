//
//  newAlertAnimation.swift
//  Instagram
//
//  Created by Bobby Negoat on 11/30/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

 class newAlertAnimation : NSObject, UIViewControllerAnimatedTransitioning {
    
    //Lets the animation transition know if the alert is presenting or dismissing
    let isPresenting: Bool

    //Parameter isPresenting: a Bool that determines if the alert is presenting or dismissing
    init(isPresenting: Bool) {
        self.isPresenting = isPresenting
    }
    
 
    //transitionContext: the context of the animation
    //Returns: a time interval that differes if the alert is presenting or dismissing
     func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return isPresenting ? 0.2 : 0.2
    }
    
    //transitionContext: the context of the animation
func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresenting {
            self.presentAnimateTransition(transitionContext)
        } else {
            self.dismissAnimateTransition(transitionContext)
        }
    }
    
    //transitionContext: the context for the animation
    func presentAnimateTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        
        guard let alertController = transitionContext.viewController(forKey: .to) as? newAlertVC else {
            return
        }
        
        let containerView = transitionContext.containerView
        containerView.addSubview(alertController.view)
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        containerView.alpha = 0
        
        alertController.view.alpha = 0.0
        alertController.view.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        
        UIView.animate(withDuration:self.transitionDuration(using: transitionContext), animations: {
            alertController.view.alpha = 1.0
            containerView.alpha = 1.0
            alertController.view.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        }, completion: { _ in
            UIView.animate(withDuration: 0.2, animations: {
                alertController.view.transform = CGAffineTransform.identity
            }, completion: { _ in
                
                transitionContext.completeTransition(true)
                
            })
        })
    }
    
    //transitionContext: the context for the animation
    func dismissAnimateTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        let alertController = transitionContext.viewController(forKey: .from) as! newAlertVC
        let containerView = transitionContext.containerView
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            alertController.view.alpha = 0.0
            containerView.alpha = 0.0
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
        
    }
    
    
}

