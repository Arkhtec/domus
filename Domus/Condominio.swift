//
//  Condominio.swift
//  Condominus
//
//  Created by Anderson Oliveira on 29/01/17.
//  Copyright © 2017 Arkhtec. All rights reserved.
//

import Foundation

class Condominio: BaseModel {
    
    var nome: String?
    var imagemUrl: String?
    
    override var description: String {
        return "\(nome)"
    }
    
}
