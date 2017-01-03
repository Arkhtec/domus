//
//  LoginViewController.swift
//  Domus
//
//  Created by Anderson Oliveira on 30/12/16.
//  Copyright © 2016 Arkhtec. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var viewId: UIView!
    @IBOutlet var viewSenha: UIView!
    @IBOutlet var tfId: UITextField!
    @IBOutlet var tfSenha: UITextField!
    @IBOutlet var viewLogin: UIView!
    @IBOutlet var viewLoginH: NSLayoutConstraint!
    @IBOutlet var viewLoginW: NSLayoutConstraint!
    
    
    @IBAction func ligarAJM() {
        
        if let url = NSURL(string: "tel://9232344567"), UIApplication.shared.canOpenURL(url as URL) {
            UIApplication.shared.open(url as URL)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ajusteViewLogin()
        
        self.animationIn(self.viewId, tf: self.tfId)
        self.animationIn(self.viewSenha, tf: self.tfSenha)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        
        self.view.endEditing(true)
    }
    
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
    }
    
    func animationOut(_ view: UIView, tf: UITextField) {
        
        UIView.animate(withDuration: 0.5) {

            view.frame.size.width = 50
            print(self.viewLogin.center.x)
            view.center.x = self.viewLogin.center.x
            tf.isHidden = true
        }
    }
    
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
