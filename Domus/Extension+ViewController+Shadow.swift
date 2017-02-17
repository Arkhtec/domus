//
//  Extension+ViewController+Shadow.swift
//  Condominus
//
//  Created by Anderson Oliveira on 16/01/17.
//  Copyright © 2017 Arkhtec. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func shadow(to layer: CALayer) {
        
        layer.shadowOpacity = 1.0
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowRadius = 5
        layer.shadowColor = UIColor(red: 21.0/255.0, green: 21.0/255.0, blue: 23.0/255.0, alpha: 1.0).cgColor
    }
}

public func shadow(to layer: CALayer) {
    
    layer.shadowOpacity = 1.0
    layer.shadowOffset = CGSize(width: 0, height: 3)
    layer.shadowRadius = 5
    layer.shadowColor = UIColor(red: 21.0/255.0, green: 21.0/255.0, blue: 23.0/255.0, alpha: 1.0).cgColor
}
