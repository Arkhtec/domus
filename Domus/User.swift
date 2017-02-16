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
    var login: String {get set}
    
    static func userWith(nome: String, email: String, bloco: String, apto: String, vencimento: String) -> User
}

class User: BaseModel, UserExportsProtocol {
    
    dynamic var nome: String = ""
    dynamic var email: String = ""
    dynamic var bloco: String = ""
    dynamic var apto: String = ""
    dynamic var vencimento: String = ""
    dynamic var id: String = ""
    dynamic var login: String = ""
    dynamic var senha: String = ""
    
    var condominioUid: String?
    
    init(nome: String, email: String, bloco: String, apto: String, vencimento: String) {
        self.nome = nome
        self.email = email
        self.bloco = bloco
        self.apto = apto
        self.vencimento = vencimento
    }
    
    override init() {
        super.init()
    }
    
    convenience init(dic: [String: Any]) {
        self.init()
        self.setValuesForKeys(dic)
    }
    
    class func userWith(nome: String, email: String, bloco: String, apto: String, vencimento: String) -> User {
        return User(nome: nome, email: email, bloco: bloco, apto: apto, vencimento: vencimento)
    }
    
    override var description: String {
        return "\(nome), \(email), \(bloco), \(apto), \(vencimento)"
    }
}

@objc protocol BoletoExportProcol: JSExport {
    
    
    var unidade: String {get set}
    var nome: String {get set}
    var calculo: String {get set}
    var mes: String {get set}
    var vencimento: String {get set}
    
    static func boletoWith(unidade: String, nome: String, calculo: String, mes: String, vencimento: String) -> Boleto

}

class Boleto: BaseModel, BoletoExportProcol {
    
    dynamic var unidade: String = ""
    dynamic var nome: String = ""
    dynamic var calculo: String = ""
    dynamic var mes: String = ""
    dynamic var vencimento: String = ""
    
    override var description: String {
        return "(\(unidade) | \(mes))"
    }
    
    override init() {
        super.init()
    }
    
    init(unidade: String, nome: String, calculo: String, mes: String, vencimento: String) {
        super.init()
        self.unidade = unidade
        self.nome = nome
        self.calculo = calculo
        self.mes = mes
        self.vencimento = vencimento
        
    }
    
    convenience init(dic: [String: Any]) {
        self.init()
        self.setValuesForKeys(dic)
    }
    
    class func boletoWith(unidade: String, nome: String, calculo: String, mes: String, vencimento: String) -> Boleto {
        return Boleto(unidade: unidade, nome: nome, calculo: calculo, mes: mes, vencimento: vencimento)
    }
    
}

