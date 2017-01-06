//
//  ViewController.swift
//  Condominus
//
//  Created by Anderson Oliveira on 28/12/16.
//  Copyright © 2016 Arkhtec. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var raio: CGFloat!
    var botaoSelecionado : UIButton!
    let viewTransparente = UIView()

    
    @IBOutlet var image: UIImageView!
    @IBOutlet var b1: UIButton!
    @IBOutlet var lbl1: UILabel!
    @IBOutlet var b2: UIButton!
    @IBOutlet var lbl2: UILabel!
    @IBOutlet var b3: UIButton!
    @IBOutlet var b4: UIButton!
    @IBOutlet var b5: UIButton!
    @IBOutlet var bPerfil: UIButton!
    @IBOutlet var bComunicados: UIButton!
    @IBOutlet var viewPerfil: UIView!
    @IBOutlet var bAddFoto: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.delegate = self
        self.navigationController?.navigationBar.isHidden = true
        
        self.bPerfil.layer.cornerRadius = self.bPerfil.frame.width / 2.0
        self.shadow(to: self.image.layer)
        self.shadow(to: self.bComunicados.layer)
        
        self.raio = self.view.frame.width * 0.7
        self.ajustarBotoes(x: self.view.frame.width - self.raio)
        
        self.ajustePopoverPerfil()
        
        self.logged()
    }
    
    private func logged() {
        UserStore.singleton.isLogged { (bool: Bool) in
            if bool == false {
                if let viewControllerPresent = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
                    self.present(viewControllerPresent, animated: true, completion: nil)
                }
            } else {
                UserStore.singleton.userLogged({ (user: User?) in
                    print(user)
                })
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonTop(_ sender: UIButton) {
        
        self.animateInPopover(popover: self.viewPerfil, viewTransparente: self.viewTransparente)
    }
    
    @IBAction func buttonBot(_ sender: UIButton) {
    
        print("bot")
    }
    
    @IBAction func handleButton(_ sender: UIButton?) {
        self.botaoSelecionado = sender
    }
    
    @IBAction func fecharPopoverPerfil() {
        
        self.animateOutPopover(popover: self.viewPerfil, viewTransparente: self.viewTransparente)
    }
    
    func shadow(to layer: CALayer) {
        
        layer.shadowOpacity = 1.0
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowRadius = 5
        layer.shadowColor = UIColor(red: 21.0/255.0, green: 21.0/255.0, blue: 23.0/255.0, alpha: 1.0).cgColor
    }
    
    func ajustePopoverPerfil() {
        
        self.viewPerfil.frame.size = CGSize(width: self.view.frame.width * 0.75, height: self.view.frame.height * 0.75)
        self.bAddFoto.layer.masksToBounds = true
        self.bAddFoto.layer.borderWidth = 1.0
        self.bAddFoto.layer.borderColor = UIColor(red: 207.0/255.0, green: 175.0/255.0, blue: 84.0/255.0, alpha: 1.0).cgColor
        self.bAddFoto.layer.cornerRadius = self.bAddFoto.frame.width / 2.0
    }
    
    func ajustarBotoes(x: CGFloat) {
        
        let x1 : CGFloat = x
        let x2 = x1 + (x1 * 0.45)
        let x3 = x2 + (x2 * 0.80)
        
        self.alinharBotoes(to: self.b2, label: self.lbl1, x: x2, cima: true)
        self.alinharBotoes(to: self.b3, label: self.lbl2, x: x2)
        self.alinharBotoes(to: self.b4, label: self.lbl1, x: x3, cima: true)
        self.alinharBotoes(to: self.b5, label: self.lbl1, x: x3)
        self.alinharBotoes(to: self.b1, label: self.lbl1, x: x1)

    }
    
    func alinharBotoes(to botao: UIButton, label: UILabel, x: CGFloat, cima: Bool = false) {
        
        let y = self.yNew(x, cimaBaixo: cima)
        let x2 = (botao.frame.width / 2.0) + (label.frame.width / 2.0) + 10
        
        
        botao.frame.size = CGSize(width: self.view.frame.width * 0.16, height: self.view.frame.width * 0.16)
        botao.center = CGPoint(x: x, y: y)
        botao.layer.cornerRadius = botao.frame.width / 2
        botao.layer.zPosition = 1
        label.center = CGPoint(x: x - x2, y: y)
    }
    
    func yNew(_ x: CGFloat, cimaBaixo: Bool) -> CGFloat {
        
        var y : CGFloat!
        
        let raio2 = pow(self.raio, 2)
        let xg = (x - self.view.frame.width)
        let xg2 = pow(xg, 2)
        let raiz = sqrt(raio2 - xg2)
        let r = cimaBaixo ? raiz : -raiz
        
        y = r + (self.view.center.y + 10)
        
        return y
    }
}

extension ViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if self.botaoSelecionado == self.bComunicados{
            return nil
        }
        
        let animation = PopAnimator()
        animation.origin = botaoSelecionado.center
        animation.circleColor = botaoSelecionado.backgroundColor
        
        if fromVC is ViewController {
            animation.transitionMode = .present
        } else {
            animation.transitionMode = .dismiss
        }
        
        return animation
    }
}
