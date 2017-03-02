//
//  Extension+ViewController+Popover.swift
//  Condominus
//
//  Created by Anderson Oliveira on 05/01/17.
//  Copyright © 2017 Arkhtec. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func animateIn(popover: UIView, viewTransparente: UIVisualEffectView) {
        
        popover.layer.zPosition = 2
        self.addViewTransparente(viewTransparente)
        self.view.addSubview(popover)
        popover.center = self.view.center
        
        popover.transform = CGAffineTransform.identity.scaledBy(x: 1.5, y: 1.5)
        popover.alpha = 0
        
        UIView.animate(withDuration: 0.4, animations: {
            popover.alpha = 1
            popover.transform = CGAffineTransform.identity
        })
        
    }
    
    func animateOut(popover: UIView, viewTransparente: UIVisualEffectView) {
        viewTransparente.removeFromSuperview()
        UIView.animate(withDuration: 0.3, animations: {
            popover.transform = CGAffineTransform.identity.scaledBy(x: 1.5, y: 1.5)
            popover.alpha = 0
            
        }, completion: { (success:Bool) in
            popover.removeFromSuperview()
        })
    }
    
    func addViewTransparente(_ viewTransparente: UIVisualEffectView){
        
        let blurEffect = UIBlurEffect(style: .dark)
        
        viewTransparente.effect = blurEffect
        viewTransparente.frame = self.view.frame
        viewTransparente.layer.zPosition = 2
        self.view.addSubview(viewTransparente)
    }
}
