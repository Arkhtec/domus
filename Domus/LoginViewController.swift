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
    
    internal lazy var webRequest: UIWebView = {
        let webView = UIWebView()
        webView.delegate = self
        return webView
    }()
    
    @IBAction func ligarAJM() {
        if let url = NSURL(string: "tel://9232344567"), UIApplication.shared.canOpenURL(url as URL) {
            UIApplication.shared.open(url as URL)
        }
    }
    
    @IBAction private func autenticar() {
        print(#function)
        guard let login = self.tfId.text, let senha = self.tfSenha.text else {
            return
        }
        if let request = Request.autenticar(login, senha) {
            self.webRequest.loadRequest(request)
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
    }
    
    //Animação de fechar os text field
    
    func animationOut(_ view: UIView, tf: UITextField) {
        UIView.animate(withDuration: 0.5) {
            view.frame.size.width = 50
            print(self.viewLogin.center.x)
            view.center.x = self.viewLogin.center.x
            tf.isHidden = true
        }
    }
    
    //Animação de abrir os text field
    
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
}

extension LoginViewController: UIWebViewDelegate {
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        print(#function, request)
        if let urlAbsolute = request.url?.absoluteString {
            if urlAbsolute.contains("default.aspx") {
                if let context = self.webRequest.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as? JSContext {
                    guard let additionsJSPath = Bundle.main.path(forResource: "additions", ofType: "js") else {
                        print("Unable to read resource files.")
                        return false
                    }
                    do {
                        let additions = try String(contentsOfFile: additionsJSPath, encoding: String.Encoding.utf8)
                        _ = context.evaluateScript(additions)
                    } catch (let error) {
                        print("Error while processing script file: \(error)")
                    }
                    
                    let toDictionaryDefault = context.objectForKeyedSubscript("toDictionaryDefault")
                    let toDictionaryDefaultResult = toDictionaryDefault?.call(withArguments: []).toDictionary()
                    print(toDictionaryDefaultResult)
                    if let idUsuario = toDictionaryDefaultResult?["id_usuario"] as? String, let req = Request.meusDados(idUsuario) {
                        webView.loadRequest(req)
                    }else {
                        // tratamento de erro de login
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
        if b.absoluteString.contains("OM_meusDados.aspx") {
            if let context = webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as? JSContext {
                guard let additionsJSPath = Bundle.main.path(forResource: "additions", ofType: "js") else {
                    print("Unable to read resource files.")
                    return
                }
                do {
                    let additions = try String(contentsOfFile: additionsJSPath, encoding: String.Encoding.utf8)
                    _ = context.evaluateScript(additions)
                    context.setObject(User.self, forKeyedSubscript: "User" as (NSCopying & NSObjectProtocol)!)
                    let toUsuario = context.objectForKeyedSubscript("toUsuario")
                    let toUsuarioResult = toUsuario?.call(withArguments: []).toObject() as? User
                    print(toUsuarioResult)
                    print(toUsuarioResult?.nome)
                } catch (let error) {
                    print("Error while processing script file: \(error)")
                }
            }
        }
    }
    
}
