//
//  BaseModel.swift
//  Condominus
//
//  Created by Thiago Vinhote on 04/03/17.
//  Copyright © 2017 Arkhtec. All rights reserved.
//

import Foundation

class BaseModel: NSObject {
    
    var idBM: String?
    
    override init() {
        super.init()
    }
    
    convenience init(dic: [String: Any]) {
        self.init()
        self.setValuesForKeys(dic)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        if self.responds(to: NSSelectorFromString(key)) {
            super.setValue(value, forKey: key)
        }
    }
    
}
