//
//  LoginViewController.swift
//  Condominus
//
//  Created by Anderson Oliveira on 30/12/16.
//  Copyright © 2016 Arkhtec. All rights reserved.
//

import UIKit
import JavaScriptCore

class LoginViewController: UIViewController {

    @IBOutlet var viewId: UIView!
    @IBOutlet var viewSenha: UIView!
    @IBOutlet var tfId: UITextField!
    @IBOutlet var tfSenha: UITextField!
    @IBOutlet var viewLogin: UIView!
    @IBOutlet var viewLoginH: NSLayoutConstraint!
    @IBOutlet var viewLoginW: NSLayoutConstraint!
    @IBOutlet var lblErroLogin: UILabel!
    @IBOutlet var wait: UIActivityIndicatorView!
    @IBOutlet var bEntrar: UIButton!
    
    let task = DispatchWorkItem {
        
        print("do something")
    }
    
    
    var isErro : Bool = true
    var dictionaryDefaultResult = Dictionary<AnyHashable, Any>()
    
    internal lazy var webRequest: UIWebView = {
        let webView = UIWebView()
        webView.delegate = self
        return webView
    }()
    
    @IBAction func ligarAJM() {
        
        if let url = NSURL(string: "tel://9232344567"), UIApplication.shared.canOpenURL(url as URL) {
            UIApplication.shared.open(url as URL)
            
        }else {
            
            print("Errooou")
        }
    }
    
    @IBAction func autenticar() {
        
//        print(#function)
        guard let login = self.tfId.text, let senha = self.tfSenha.text else {
            
            return
        }
        
        if (self.tfId.text?.isEmpty)! || (self.tfSenha.text?.isEmpty)!{
            
            if (self.tfId.text?.isEmpty)! {
                
                self.animationTF(self.tfId, view: self.viewId)
            }

            if (self.tfSenha.text?.isEmpty)! {
                
                self.animationTF(self.tfSenha, view: self.viewSenha)
            }
            return
        }
        
        if !self.verificarConexao() {
            
            self.setupLabelError(hidden: false, withText: "Verifique a conexão com a internet!")
            self.waitingLogin(false)
            return
        }
        
        if let request = Request.autenticar(login, senha) {
            
            self.waitingLogin(true)
            self.webRequest.loadRequest(request)
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 10, execute: self.task)
        }
    }
    
    func animationTF(_ tf: UITextField, view: UIView) {
        
        tf.transform = CGAffineTransform(translationX: -10, y: 0)
        view.backgroundColor = UIColor(red: 208/255.0, green: 64.0/255.0, blue: 70.0/255.0, alpha: 1.0)
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 5, animations: {
            tf.transform = CGAffineTransform(translationX: 0, y: 0)
        }) { (finish) in
        
            view.backgroundColor = UIColor(red: 84.0/255.0, green: 165.0/255.0, blue: 146.0/255.0, alpha: 1.0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ajusteViewLogin()
        
        self.animationIn(self.viewId, tf: self.tfId)
        self.animationIn(self.viewSenha, tf: self.tfSenha)
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)

        let tap = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    func setupLabelError (hidden: Bool = true, withText text: String = "") {
        
        self.lblErroLogin.isHidden = hidden
        if hidden {
            return
        }
        self.lblErroLogin.alpha = 1
        self.lblErroLogin.text = text
        UIView.animate(withDuration: 0.5, delay: 5, animations: {
            self.lblErroLogin.alpha = 0
        })
    }
    
    func verificarConexao() -> Bool {
        
        let networkStatus = Reachability().connectionStatus()
        
        switch networkStatus {
        case .Unknown, .Offline:
        
            print("Desconected")
            return false
        case .Online(.WWAN):
            
            print("Connected via WWAN")
            return true
        case .Online(.WiFi):
            
            print("Connected via WiFi")
            return true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Bla bla bla de sempre de teclado
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func keyboardWillShow(_ notification: Notification) {
        
        self.view.transform = CGAffineTransform(translationX: 0, y: -100)
    }
    
    func keyboardWillHide(_ notification: Notification) {
        
        self.view.transform = CGAffineTransform(translationX: 0, y: 0)
    }
    
    //Autolayout da view de login
    
    func ajusteViewLogin() {
        
        let sizeFont = self.view.frame.width * 0.035
        
        self.viewLoginH.constant = self.view.frame.width * 0.824
        self.viewLoginW.constant = self.view.frame.width * 0.824
        self.viewLogin.frame.size = CGSize(width: self.view.frame.width * 0.824, height: self.view.frame.width * 0.824)
        self.viewLogin.center = self.view.center
        self.viewLogin.layer.cornerRadius = self.viewLogin.frame.height / 2.0
        self.viewLogin.layer.shadowOpacity = 0.8
        self.viewLogin.layer.shadowRadius = 8
        self.viewLogin.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.viewId.center.y = (self.viewLogin.frame.height / 2.0) - (self.viewLogin.frame.height * 0.1197)
        self.viewSenha.center.y = (self.viewLogin.frame.height / 2.0) + (self.viewLogin.frame.height * 0.1197)
        self.viewId.center.x = self.viewLogin.center.x - ((self.view.frame.width - self.viewLogin.frame.width) / 2.0)
        self.viewSenha.center.x = self.viewLogin.center.x - ((self.view.frame.width - self.viewLogin.frame.width) / 2.0)
        
        self.lblErroLogin.font = UIFont(name: self.lblErroLogin.font.familyName, size: sizeFont)
        self.lblErroLogin.center.x = self.viewId.center.x
        self.lblErroLogin.center.y = self.viewId.center.y - (self.viewId.frame.height / 2.0) - (self.lblErroLogin.frame.height / 2.0) - 8
    }
    
    //Animação de fechar os text field
    
    func animationOut(_ view: UIView, tf: UITextField) {
        UIView.animate(withDuration: 0.5) {
            view.frame.size.width = 50
            view.center.x = self.viewLogin.center.x
            tf.isHidden = true
        }
    }
    
//    Animação de abrir os text field
    
    func animationIn(_ view: UIView, tf: UITextField) {
        view.frame.size.height = 50
        view.layer.cornerRadius = view.frame.width / 2.0
        UIView.animate(withDuration: 0.5, delay: 0.4, animations: {
            view.frame.size.width = self.view.frame.width * 0.6
            view.center.x = self.viewLogin.center.x - ((self.view.frame.width - self.viewLogin.frame.width) / 2.0)
        }) { (finished) in
            tf.isHidden = false
        }
    }
    
    //Animação de conectando
    
    func waitingLogin(_ wait: Bool) {
        
        if wait {
            self.wait.startAnimating()
            self.tfId.alpha = 0.5
            self.tfSenha.alpha = 0.5
        }else {
            self.wait.stopAnimating()
            self.tfId.alpha = 1.0
            self.tfSenha.alpha = 1.0
        }
        self.bEntrar.isEnabled = !wait
        self.tfSenha.isEnabled = !wait
        self.tfId.isEnabled = !wait
    }
}

extension LoginViewController: UIWebViewDelegate {
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
       
        //print(#function, request)
        if let urlAbsolute = request.url?.absoluteString {
            
            if urlAbsolute.contains("default.aspx") {
                if let context = self.webRequest.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as? JSContext {
                    guard let additionsJSPath = Bundle.main.path(forResource: "additions", ofType: "js") else {
                        return false
                    }
                    do {
                        let additions = try String(contentsOfFile: additionsJSPath, encoding: String.Encoding.utf8)
                        _ = context.evaluateScript(additions)
                    } catch (let error) {
                        //print("Error while processing script file: \(error)")
                    }
                    
                    let toDictionaryDefault = context.objectForKeyedSubscript("toDictionaryDefault")
                    let toDictionaryDefaultResult = toDictionaryDefault?.call(withArguments: []).toDictionary()
                    if toDictionaryDefaultResult != nil {
                        
                        self.dictionaryDefaultResult = toDictionaryDefaultResult!
                        if let idUsuario = self.dictionaryDefaultResult["id_usuario"] as? String, let
                            req = Request.login(idUsuario) {
                            
                            webView.loadRequest(req)
                        } else {
                            
                            self.setupLabelError(hidden: false, withText: "Login e/ou senha incorretas!")
                            self.waitingLogin(false)
                        }
                    } else {
                        
                        self.setupLabelError(hidden: false, withText: "Login e/ou senha incorretas!")
                        self.waitingLogin(false)
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
                        if let idUsuario = self.dictionaryDefaultResult["id_usuario"] as? String, let req = Request.meusDados(idUsuario) {
                            
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
                        let senha = self.tfSenha.text!
                        UserStore.singleton.logIn(toUsuarioResult.email, senha: senha, completion: { (uid: String?, error: Error?) in
                            
                            if let e = error {
                                
                                self.setupLabelError(hidden: false, withText: "Login e/ou senha incorretas!")
                                self.waitingLogin(false)
                                return
                            }
                            
                            toUsuarioResult.idBM = uid
                            toUsuarioResult.login = self.dictionaryDefaultResult["id_usuario"] as! String
                            toUsuarioResult.condominioUid = (self.dictionaryDefaultResult["empresa"] as? String)?.replacingOccurrences(of: " ", with: "_")
                            UserStore.singleton.createUser(toUsuarioResult, { (error: Error?) in
                                
                                if error == nil {

                                    self.task.cancel()
                                    self.dismiss(animated: true, completion: nil)
                                } else {
                                    // Nao foi possivel completar sua operacao, tente novamente!
                                    print("Nao foi possivel completar sua operacao, tente novamente!")
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
            
            self.task.cancel()
            self.setupLabelError(hidden: false, withText: "Login e/ou senha incorretos!")
            self.waitingLogin(false)
        }
    }
    
}
