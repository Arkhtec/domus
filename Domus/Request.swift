//
//  Request.swift
//  Condominus
//
//  Created by Thiago Vinhote on 04/01/17.
//  Copyright © 2017 Arkhtec. All rights reserved.
//

import Foundation

class Request {
    
    static let baseUrl: String = "http://www.omeupredio.com.br/"
    
    fileprivate class func createRequest(withEndPoint endpoint: String) -> URLRequest {
        guard let url = URL(string: Request.baseUrl + endpoint) else {
            return URLRequest(url: URL(string: "")!)
        }
        let r = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: TimeInterval.init(5))
        return r
    }
    fileprivate class func crateProcesso(withIdUser id: Int) -> Int {
        //window.location.href= 'default.aspx?processo=' + (hoje.getFullYear() + (hoje.getMonth() + 1) + hoje.getDate() + hoje.getHours() + hoje.getMinutes() + hoje.getSeconds()) * id + '' + '&strAdmin=' + adm + '&acessoDireto=1&id_usuario=' + id;
        //                    http://www.omeupredio.com.br/meusDados/OM_meusDados.aspx?processo=1482946215356
        
        let dataComponents = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute, .second], from: Date())
        guard let dia = dataComponents.day, let mes = dataComponents.month, let ano = dataComponents.year, let hora = dataComponents.hour, let minuto = dataComponents.minute, let segundo = dataComponents.second else {
            return 0
        }
        
        let processo = (ano + (mes + 1) + dia + hora + minuto + segundo) * id
        return processo
    }
    
}

extension Request {

    static func dataTask(wiht urlRequest: URLRequest, completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: urlRequest, completionHandler: completion).resume()
    }
    
    /// Função que retorna uma request para autenticação no site
    /// Necessário o login e senha do usuário
    ///
    static func autenticar(_ login: String, _ senha: String) -> URLRequest {
        return self.createRequest(withEndPoint: "redireciona.asp?action=logar&cod=845&login=\(login)&senha=\(senha)&button=Entrar")
    }
    
    /// Função que retorna uma request para acesso aos dados do usuário
    /// Necessário o id do usuário previamente logado
    ///
    static func meusDados(_ idUsuario: String) -> URLRequest {
        let processo = self.crateProcesso(withIdUser: Int(idUsuario)!)
        return self.createRequest(withEndPoint: "meusDados/OM_meusDados.aspx?processo=\(processo)")
    }
    
    /// Função que retorna uma request para acessar o endPoint de login
    /// Necessário o id do usuário em processo de autenticação
    ///
    static func login(_ idUsuario: String) -> URLRequest {
        let processo = self.crateProcesso(withIdUser: Int(idUsuario)!)
        return self.createRequest(withEndPoint: "Login.aspx?processo=\(processo)")
    }
    
    /// Função que retorna uma request para acessar os boletos do usuário
    /// Necessário o id do usuário previamente logado
    ///
    static func boleto2Via(_ idUsuario: String) -> URLRequest {
        let processo = Int(Date().timeIntervalSince1970)
        //        let processo = self.crateProcesso(withIdUser: Int(idUsuario)!)
        return self.createRequest(withEndPoint: "Boleto/OM_2via.aspx?processo=\(processo)")
    }
    
}
