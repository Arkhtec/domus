//
//  Comunicado.swift
//  Condominus
//
//  Created by Thiago Vinhote on 13/01/17.
//  Copyright © 2017 Arkhtec. All rights reserved.
//

import UIKit

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

class Comunicado: BaseModel {
    
    var mensagem: String?
    var imagemUrl: String?
    var dataEnvio: NSNumber?
    
    override var description: String {
        return "\(mensagem) \(dataEnvio) [\(idBM)]"
    }

}
