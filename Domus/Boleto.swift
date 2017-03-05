//
//  Boleto.swift
//  Condominus
//
//  Created by Thiago Vinhote on 04/03/17.
//  Copyright © 2017 Arkhtec. All rights reserved.
//

import Foundation
import JavaScriptCore

@objc protocol BoletoExportProcol: JSExport {
    
    
    var unidade: String {get set}
    var nome: String {get set}
    var calculo: String {get set}
    var mes: String {get set}
    var vencimento: String {get set}
    var codBarra: String {get set}
    
    static func boletoWith(unidade: String, nome: String, calculo: String, mes: String, vencimento: String, codBarra: String) -> Boleto
    
}

class Boleto: BaseModel, BoletoExportProcol {
    
    dynamic var unidade: String = ""
    dynamic var nome: String = ""
    dynamic var calculo: String = ""
    dynamic var mes: String = ""
    dynamic var vencimento: String = ""
    dynamic var codBarra: String = ""
    
    override var description: String {
        return "(\(unidade) | \(mes))"
    }
    
    override init() {
        super.init()
    }
    
    init(unidade: String, nome: String, calculo: String, mes: String, vencimento: String, codBarra: String) {
        super.init()
        self.unidade = unidade
        self.nome = nome
        self.calculo = calculo
        self.mes = mes
        self.vencimento = vencimento
        let b = codBarra.components(separatedBy: "quot")[1].components(separatedBy: ";")[1].components(separatedBy: "&").first ?? ""
        self.codBarra = b
        
    }
    
    convenience init(dic: [String: Any]) {
        self.init()
        self.setValuesForKeys(dic)
    }
    
    class func boletoWith(unidade: String, nome: String, calculo: String, mes: String, vencimento: String, codBarra: String) -> Boleto {
        return Boleto(unidade: unidade, nome: nome, calculo: calculo, mes: mes, vencimento: vencimento, codBarra: codBarra)
    }
    
}
