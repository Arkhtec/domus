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
    var user : User?
    
    
    @IBOutlet var bg: UIImageView!
    @IBOutlet var image: UIImageView!
    @IBOutlet var b1: UIButton!
    @IBOutlet var lbl1: UILabel!
    @IBOutlet var b2: UIButton!
    @IBOutlet var lbl2: UILabel!
    @IBOutlet var b3: UIButton!
    @IBOutlet var lbl3: UILabel!
    @IBOutlet var b4: UIButton!
    @IBOutlet var lbl4: UILabel!
    @IBOutlet var b5: UIButton!
    @IBOutlet var lbl5: UILabel!
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
        self.shadow(to: self.bg.layer)
        
        self.raio = self.view.frame.width * 0.7
        self.ajustarBotoes(x: self.view.frame.width - self.raio)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.logged()
    }
    
    private func logged() {
        UserStore.singleton.isLogged { (bool: Bool) in
            if bool == false {
                self.perform(#selector(self.openLogin), with: self, afterDelay: 0)
            } else {
                UserStore.singleton.userLogged({ (user: User?) in
                    print(user)
                    self.user = user
                })
            }
        }
    }

    @objc private func openLogin() {
        if let viewControllerPresent = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
            self.present(viewControllerPresent, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func buttonTop(_ sender: UIButton) {
        
    }
    
    @IBAction func buttonBot(_ sender: UIButton) {
        
    }
    
    @IBAction func handleButton(_ sender: UIButton?) {
        self.botaoSelecionado = sender
    }
    
    @IBAction func fecharPopoverPerfil() {
        
        //self.animateOutPopover(popover: self.viewPerfil, viewTransparente: self.viewTransparente)
    }
    
    func ajustarBotoes(x: CGFloat) {
        
        let x1 : CGFloat = x
        let x2 = x1 + (x1 * 0.45)
        let x3 = x2 + (x2 * 0.80)
        
        self.alinharBotoes(to: self.b1, label: self.lbl1, x: x1)
        self.alinharBotoes(to: self.b2, label: self.lbl2, x: x2, cima: true)
        self.alinharBotoes(to: self.b3, label: self.lbl3, x: x2)
        self.alinharBotoes(to: self.b4, label: self.lbl4, x: x3, cima: true)
        self.alinharBotoes(to: self.b5, label: self.lbl5, x: x3)

    }
    
    func alinharBotoes(to botao: UIButton, label: UILabel, x: CGFloat, cima: Bool = false) {
        
        botao.frame.size = CGSize(width: self.view.frame.width * 0.16, height: self.view.frame.width * 0.16)
        
        let y = self.yNew(x, cimaBaixo: cima)
        let x2 = (botao.frame.width / 2.0) + (label.frame.width / 2.0) + 10

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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "modalPerfil" {
            
            let destino = segue.destination as! PerfilViewController
            
            destino.nome = self.user?.nome
            destino.bloco = self.user?.bloco
            destino.apto = self.user?.apto
            destino.vencimento = self.user?.vencimento
        }
    }
}

extension ViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        let animation = PopAnimator()
        animation.origin = self.botaoSelecionado.center
        animation.circleColor = self.botaoSelecionado.backgroundColor
        
        if self.botaoSelecionado == self.bComunicados{
            
            animation.origin = CGPoint(x: self.view.frame.width, y: self.botaoSelecionado.center.y)
            animation.circleColor = UIColor(red: 36.0/255.0, green: 38.0/255.0, blue: 45.0/255.0, alpha: 1.0)
        }
        
        if fromVC is ViewController {
            animation.transitionMode = .present
        } else {
            animation.transitionMode = .dismiss
        }
        
        return animation
    }
}
