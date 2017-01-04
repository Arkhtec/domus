//
//  User.swift
//  Condominus
//
//  Created by Thiago Vinhote on 04/01/17.
//  Copyright © 2017 Arkhtec. All rights reserved.
//

import Foundation
import JavaScriptCore

@objc protocol UserExportsProtocol: JSExport {
    
    var nome: String { get set }
    var email: String { get set }
    var bloco: String {get set}
    var apto: String {get set}
    var vencimento: String {get set}
    
    static func userWith(nome: String, email: String, bloco: String, apto: String, vencimento: String) -> User
}

class User: NSObject, UserExportsProtocol {
    
    dynamic var nome: String
    dynamic var email: String
    dynamic var bloco: String
    dynamic var apto: String
    dynamic var vencimento: String
    
    var uid: String?
    
    init(nome: String, email: String, bloco: String, apto: String, vencimento: String) {
        self.nome = nome
        self.email = email
        self.bloco = bloco
        self.apto = apto
        self.vencimento = vencimento
    }
    
    class func userWith(nome: String, email: String, bloco: String, apto: String, vencimento: String) -> User {
        return User(nome: nome, email: email, bloco: bloco, apto: apto, vencimento: vencimento)
    }
    
    override var description: String {
        return "\(nome), \(email), \(bloco), \(apto), \(vencimento)"
    }
}
