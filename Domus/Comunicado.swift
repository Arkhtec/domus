//
//  Comunicado.swift
//  Condominus
//
//  Created by Thiago Vinhote on 13/01/17.
//  Copyright © 2017 Arkhtec. All rights reserved.
//

import Foundation

class Comunicado: BaseModel {
    
    var titulo: String?
    var mensagem: String?
    var imagemUrl: String?
    var dataEnvio: NSNumber?
    var remetenteImagemUrl: String?
    
    override var description: String {
        return "\(mensagem) \(dataEnvio) [\(idBM)]"
    }

}
