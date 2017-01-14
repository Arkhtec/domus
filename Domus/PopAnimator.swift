//
//  PopAnimator.swift
//  kid
//
//  Created by Anderson Oliveira on 08/07/16.
//  Copyright © 2016 Thiago Vinhote. All rights reserved.
//

import UIKit

class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    
    enum PopTransitionMode: Int {
        case present, dismiss
    }
    
    var circle : UIView?
    var circleColor : UIColor?
    var origin = CGPoint.zero
    
    var transitionMode: PopTransitionMode = .present
    
    let presentDuration = 0.3 
    let dismissDuration = 0.4
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        if self.transitionMode == .present {
            return self.presentDuration
        }else {
            return self.dismissDuration
        }
    }
    
    func frameForCircle(_ center: CGPoint, size: CGSize, start: CGPoint) ->CGRect {
        
        let lengthX = fmax(start.x, size.width - start.x)
        let lengthy = fmax(start.y, size.height - start.y)
        let offset = sqrt(lengthX * lengthX + lengthy * lengthy)
        let size = CGSize(width: offset, height: offset)
        
        return CGRect(origin: origin, size: size)
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    
        let containerView = transitionContext.containerView
        let presentView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        let returnView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        
        if self.transitionMode == .present {
            
            
            let originalCenter = presentView.center
            let originalSize = presentView.frame.size
            
            self.circle = UIView(frame: self.frameForCircle(originalCenter, size: originalSize, start: self.origin))
            self.circle!.layer.cornerRadius = self.circle!.frame.size.height/2
            self.circle!.center = origin
            
            self.circle!.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            self.circle!.backgroundColor = circleColor
            containerView.addSubview(circle!)
            
            presentView.center = origin
            presentView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            presentView.backgroundColor = circleColor
            containerView.addSubview(presentView)
            
            UIView.animate(withDuration: presentDuration, animations: {
                
                self.circle!.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
                presentView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                presentView.center = originalCenter
                }, completion: { (_) in
                    self.circle!.removeFromSuperview()
                    transitionContext.completeTransition(true)
            }) 
        }else {
            
            let originalCenter = returnView.center
            let originalSize = returnView.frame.size
            
            self.circle = UIView(frame: self.frameForCircle(originalCenter, size: originalSize, start: self.origin))
            self.circle!.layer.cornerRadius = self.circle!.frame.size.height/2
            self.circle!.center = origin
            
            self.circle!.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
            self.circle!.backgroundColor = circleColor
            
            containerView.addSubview(presentView)
            containerView.addSubview(circle!)
            containerView.addSubview(returnView)
            
            returnView.alpha = 0
            
            UIView.animate(withDuration: dismissDuration, animations: {
                
                self.circle!.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                self.circle!.alpha = 0
                returnView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                
                returnView.center = self.origin

                }, completion: { (_) in
                    returnView.removeFromSuperview()
                    self.circle!.removeFromSuperview()
                    transitionContext.completeTransition(true)
            }) 
        }
    }
}
