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
    
    var task: DispatchWorkItem?
    var isErro : Bool = true
    
    @IBAction func ligarAJM() {
        if let url = NSURL(string: "tel://9232344567"), UIApplication.shared.canOpenURL(url as URL) {
            UIApplication.shared.open(url as URL)
        }else {
            print("Errooou")
        }
    }
    @IBAction func autenticar() {
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
        
        if !verificarConexao() {
            self.setupLabelError(hidden: false, withText: "Verifique a conexão com a internet!")
            self.waitingLogin(false)
            return
        }
        
        self.task = DispatchWorkItem(block: {
            self.setupLabelError(hidden: false, withText: "Tempo limite expirou. Tente novamente!")
            self.waitingLogin(false)
        })
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 10, execute: self.task!)

        self.waitingLogin(true)
        Auth.singleton.autenticarUsuario(withLogin: login, andSenha: senha) { (error: StoreError?, finish: Bool) in
            self.task?.cancel()
            
            if finish {
                self.dismiss(animated: true, completion: nil)
            } else if let m = error?.reason {
                self.setupLabelError(hidden: false, withText: m)
                self.waitingLogin(false)
            }
            
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
        
        self.tfId.text = "0001a1l1p"
        self.tfSenha.text = "2808324"
        
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
