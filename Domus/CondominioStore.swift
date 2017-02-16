//
//  CondominioStore.swift
//  Condominus
//
//  Created by Anderson Oliveira on 29/01/17.
//  Copyright © 2017 Arkhtec. All rights reserved.
//

import Foundation

class CondominioStore: NSObject {
    
    static let singleton : CondominioStore = CondominioStore()
    
    let condominos = [("Alphaville", "logoAlpha"), ("Fórum", "logoForum"), ("Diamond", "logoDiamond")]
    
    
    typealias handlerCondominio = (_ condominios: [Condominio?], _ error: StoreError?) -> Void
    
    func fetchCondominios(_ completion: @escaping handlerCondominio) {
        
        var condominos: [Condominio?] = []
        
        self.condominos.forEach { (condo) in
            
            let condominio = Condominio()
            
            condominio.nome = condo.0
            condominio.imagemUrl = condo.1
            
            condominos.append(condominio)
        }
        
        completion(condominos, nil)
    }
}
