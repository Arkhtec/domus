//
//  StoreError.swift
//  Condominus
//
//  Created by Thiago Vinhote on 14/01/17.
//  Copyright © 2017 Arkhtec. All rights reserved.
//

import Foundation

struct StoreError: Error {
    
    enum TypeError {
        case value
        case callback
        case call
    }
    
    var typeError: TypeError
    var reason: String
}
