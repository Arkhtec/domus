//
//  ComunicadoStore.swift
//  Condominus
//
//  Created by Thiago Vinhote on 13/01/17.
//  Copyright © 2017 Arkhtec. All rights reserved.
//

import Foundation
import Firebase

struct StoreError: Error {
    
    enum TypeError {
        case value
        case callback
    }
    
    var typeError: TypeError
    var reason: String
}

class ComunicadoStore: NSObject {

    static let singleton : ComunicadoStore = ComunicadoStore()
    
    private var refComunicado : FIRDatabaseReference {
        return FIRDatabase.database().reference().child("comunicados")
    }
    
    typealias handlerComunicado = (_ comunicado: Comunicado?, _ error: StoreError?) -> Void
    
    private override init() {
        super.init()
    }
    
    func criarComunicado(_ comunicado: Comunicado, _ completion: @escaping handlerComunicado) -> Void {
        guard let mensagem = comunicado.mensagem, let imageUrl = comunicado.imagemUrl, let dataEnvio = comunicado.dataEnvio else {
            completion(nil, StoreError(typeError: .value, reason: "Alguns campos do comunicado estão vazios."))
            return
        }
        let dic: [String: Any] = ["mensagem": mensagem, "imageUrl": imageUrl, "dataEnvio": dataEnvio]
        self.refComunicado.childByAutoId().updateChildValues(dic) { (error: Error?, ref: FIRDatabaseReference) in
            if let e = error {
                print(e)
                completion(nil, StoreError(typeError: .callback, reason: e.localizedDescription))
                return
            }
            comunicado.idBM = ref.key
            completion(comunicado, nil)
        }
    }
    
    func fetchAddChild (_ completion: @escaping handlerComunicado) -> UInt {
        return self.refComunicado.observe(.childAdded, with: { (snapshot: FIRDataSnapshot) in
            if let dic = snapshot.value as? [String: Any] {
                let comunicado = Comunicado(dic: dic)
                completion(comunicado, nil)
                return
            }
            completion(nil, StoreError(typeError: .value, reason: "Alguns dos campos estão vazios."))
        }) { (error: Error) in
            completion(nil, StoreError(typeError: .callback, reason: error.localizedDescription))
        }
    }
}
