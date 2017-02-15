//
//  Request.swift
//  Condominus
//
//  Created by Thiago Vinhote on 04/01/17.
//  Copyright © 2017 Arkhtec. All rights reserved.
//

import Foundation

class Request: NSObject {

    static let baseUrl: String = "http://www.omeupredio.com.br/"
    
    static func autenticar(_ login: String, _ senha: String) -> URLRequest? {
        guard let url = URL(string: Request.baseUrl + "redireciona.asp?action=logar&cod=845&login=\(login)&senha=\(senha)&button=Entrar") else {
            return nil
        }
        let r = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: TimeInterval.init(5))
        
        return r
    }
    
    static func meusDados(_ idUsuario: String) -> URLRequest? {
        //window.location.href= 'default.aspx?processo=' + (hoje.getFullYear() + (hoje.getMonth() + 1) + hoje.getDate() + hoje.getHours() + hoje.getMinutes() + hoje.getSeconds()) * id + '' + '&strAdmin=' + adm + '&acessoDireto=1&id_usuario=' + id;
        //                    http://www.omeupredio.com.br/meusDados/OM_meusDados.aspx?processo=1482946215356

        let dataComponents = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute, .second], from: Date())
        guard let dia = dataComponents.day, let mes = dataComponents.month, let ano = dataComponents.year, let hora = dataComponents.hour, let minuto = dataComponents.minute, let segundo = dataComponents.second else {
            return nil
        }
        guard let id = Int(idUsuario) else {
            return nil
        }
        let processo = (ano + (mes + 1) + dia + hora + minuto + segundo) * id
        guard let url = URL(string: Request.baseUrl + "meusDados/OM_meusDados.aspx?processo=\(processo)") else {
            return nil
        }
        return URLRequest(url: url)
    }
    
    static func login(_ idUsuario: String) -> URLRequest? {
        let dataComponents = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute, .second], from: Date())
        guard let dia = dataComponents.day, let mes = dataComponents.month, let ano = dataComponents.year, let hora = dataComponents.hour, let minuto = dataComponents.minute, let segundo = dataComponents.second else {
            return nil
        }
        guard let id = Int(idUsuario) else {
            return nil
        }
        let processo = (ano + (mes + 1) + dia + hora + minuto + segundo) * id
        guard let url = URL(string: Request.baseUrl + "Login.aspx?processo=\(processo)") else {
            return nil
        }
        return URLRequest(url: url)
    }
    
    static func boleto2Via(_ idUsuario: String) -> URLRequest? {
        let dataComponents = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute, .second], from: Date())
        guard let dia = dataComponents.day, let mes = dataComponents.month, let ano = dataComponents.year, let hora = dataComponents.hour, let minuto = dataComponents.minute, let segundo = dataComponents.second else {
            return nil
        }
        guard let id = Int(idUsuario) else {
            return nil
        }
//        let processo = (ano + (mes + 1) + dia + hora + minuto + segundo) * id
        let processo = Int(Date().timeIntervalSince1970)
        guard let url = URL(string: Request.baseUrl + "Boleto/OM_2via.aspx?processo=\(processo)") else {
            return nil
        }
        return URLRequest(url: url)
    }
    
}
