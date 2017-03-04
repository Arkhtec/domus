
//
//  Auth.swift
//  Condominus
//
//  Created by Thiago Vinhote on 04/03/17.
//  Copyright © 2017 Arkhtec. All rights reserved.
//

import Foundation
import JavaScriptCore
import UIKit

class Auth: NSObject {

    static let singleton: Auth = Auth()
    
    private override init() {
        super.init()
    }
    
    typealias handlerCompletion = (_ error: StoreError?, _ finish: Bool) -> Void
    
    fileprivate lazy var webRequest: UIWebView = {
        let webView = UIWebView()
        webView.delegate = self
        return webView
    }()
    
    fileprivate var senha: String!
    fileprivate var login: String!
    
    fileprivate var dictionaryDefaultResult = Dictionary<AnyHashable, Any>()
    
    fileprivate var completionHandler: handlerCompletion!
    
}

extension Auth {
    
    func autenticarUsuario(withLogin login: String, andSenha senha: String, _ completion: @escaping handlerCompletion) {
        let r = Request.autenticar(login, senha)
        self.webRequest.loadRequest(r)
        self.senha = senha
        self.login = login
        self.completionHandler = completion
    }
    
}

extension Auth: UIWebViewDelegate {
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if let urlAbsolute = request.url?.absoluteString {
            
            if urlAbsolute.contains("default.aspx") {
                if let context = self.webRequest.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as? JSContext {
                    guard let additionsJSPath = Bundle.main.path(forResource: "additions", ofType: "js") else {
                        return false
                    }
                    do {
                        let additions = try String(contentsOfFile: additionsJSPath, encoding: String.Encoding.utf8)
                        _ = context.evaluateScript(additions)
                    } catch (let _) {
                        //print("Error while processing script file: \(error)")
                    }
                    
                    let toDictionaryDefault = context.objectForKeyedSubscript("toDictionaryDefault")
                    let toDictionaryDefaultResult = toDictionaryDefault?.call(withArguments: []).toDictionary()
                    if toDictionaryDefaultResult != nil {
                        
                        self.dictionaryDefaultResult = toDictionaryDefaultResult!
                        if let idUsuario = self.dictionaryDefaultResult["id_usuario"] as? String {
                            let req = Request.login(idUsuario)
                            webView.loadRequest(req)
                        } else {
                            self.completionHandler(StoreError(typeError: .value, reason: "Login e/ou senha incorretas!"), false)
//                            self.setupLabelError(hidden: false, withText: "Login e/ou senha incorretas!")
//                            self.waitingLogin(false)
                        }
                    } else {
                        self.completionHandler(StoreError(typeError: .value, reason: "Login e/ou senha incorretas!"), false)
//                        self.setupLabelError(hidden: false, withText: "Login e/ou senha incorretas!")
//                        self.waitingLogin(false)
                    }
                }
            }
        }
        return true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        guard let b = webView.request?.url else {
            return
        }
        
        print("WVFL: ", b.absoluteString)
        if b.absoluteString.contains("Login.aspx") {
            
            if let context = webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as? JSContext {
                guard let additionsJSPath = Bundle.main.path(forResource: "additions", ofType: "js") else {
                    return
                }
                do {
                    
                    let additions = try String(contentsOfFile: additionsJSPath, encoding: String.Encoding.utf8)
                    _ = context.evaluateScript(additions)
                    let toEmpresa = context.objectForKeyedSubscript("toEmpresa")
                    
                    if let toEmpresaResult = toEmpresa?.call(withArguments: []).toDictionary() {
                        
                        print(toEmpresaResult)
                        if let idUsuario = self.dictionaryDefaultResult["id_usuario"] as? String {
                            
                            let req = Request.meusDados(idUsuario)
                            self.dictionaryDefaultResult["empresa"] = toEmpresaResult["empresa"]
                            webView.loadRequest(req)
                            
                        }else {
                            
                            // tratamento de erro de login
                        }
                    }
                } catch (let error) {
                    print("Error while processing script file: \(error)")
                }
            }
        } else if b.absoluteString.contains("OM_meusDados.aspx") {
            
            if let context = webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as? JSContext {
                guard let additionsJSPath = Bundle.main.path(forResource: "additions", ofType: "js") else {
                    return
                }
                do {
                    let additions = try String(contentsOfFile: additionsJSPath, encoding: String.Encoding.utf8)
                    _ = context.evaluateScript(additions)
                    context.setObject(User.self, forKeyedSubscript: "User" as (NSCopying & NSObjectProtocol)!)
                    let toUsuario = context.objectForKeyedSubscript("toUsuario")
                    if let toUsuarioResult = toUsuario?.call(withArguments: []).toObject() as? User {
                        print(toUsuarioResult)
                        UserStore.singleton.logIn(toUsuarioResult.email, senha: self.senha, completion: { (uid: String?, error: Error?) in
                            
                            if let e = error {
                                self.completionHandler(StoreError(typeError: .value, reason: "Login e/ou senha incorretas!"), false)
//                                self.setupLabelError(hidden: false, withText: )
//                                self.waitingLogin(false)
                                return
                            }
                            
                            toUsuarioResult.idBM = uid
                            toUsuarioResult.id = self.dictionaryDefaultResult["id_usuario"] as! String
                            toUsuarioResult.login = self.login
                            toUsuarioResult.senha = self.senha
                            toUsuarioResult.condominioUid = (self.dictionaryDefaultResult["empresa"] as? String)?.replacingOccurrences(of: " ", with: "_")
                            UserStore.singleton.createUser(toUsuarioResult, { (error: Error?) in
                                
                                if error == nil {
                                    self.completionHandler(nil, true)
//                                    self.task?.cancel()
//                                    self.dismiss(animated: true, completion: nil)
                                } else {
                                    // Nao foi possivel completar sua operacao, tente novamente!
                                    print("Nao foi possivel completar sua operacao, tente novamente!")
                                    self.completionHandler(StoreError(typeError: .callback, reason: "Tente novamente!"), false)
                                }
                            })
                        })
                        
                    } else {
                        // Ocorreu um problema na operaçao, tente novamente!
                        print("Ocorreu um problema na operaçao, tente novamente!")
                    }
                } catch (let error) {
                    print("Error while processing script file: \(error)")
                }
            }
        } else if b.absoluteString.contains("erro_senha.asp") {
            self.completionHandler(StoreError(typeError: .value, reason: "Login e/ou senha incorretas!"), false)
//            self.task?.cancel()
//            self.setupLabelError(hidden: false, withText: "Login e/ou senha incorretos!")
//            self.waitingLogin(false)
        }
    }
    
}
