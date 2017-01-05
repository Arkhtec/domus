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
    
    @IBOutlet var image: UIImageView!
    @IBOutlet var b1: UIButton!
    @IBOutlet var b2: UIButton!
    @IBOutlet var b3: UIButton!
    @IBOutlet var b4: UIButton!
    @IBOutlet var b5: UIButton!
    @IBOutlet var bPerfil: UIButton!
    @IBOutlet var bComunicados: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.delegate = self
        self.navigationController?.navigationBar.isHidden = true
        
        self.bPerfil.layer.cornerRadius = self.bPerfil.frame.width / 2.0
        self.image.layer.shadowOpacity = 1
        self.image.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.image.layer.shadowRadius = 3
        self.image.layer.shadowColor = UIColor(red: 30.0/255.0, green: 31.0/255.0, blue: 33.0/255.0, alpha: 0.9).cgColor
        
        self.raio = self.view.frame.width * 0.75
        self.ajustarBotoes(x: self.view.frame.width - self.raio)

//        let circlePath = UIBezierPath(arcCenter: CGPoint(x: self.view.frame.width,y: self.view.center.y), radius: CGFloat(self.view.frame.width * 0.75), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
//        
//        let shapeLayer = CAShapeLayer()
//        shapeLayer.path = circlePath.cgPath
//        
//        shapeLayer.zPosition = 0
//        //change the fill color
//        shapeLayer.fillColor = UIColor.clear.cgColor
//        //you can change the stroke color
//        shapeLayer.strokeColor = UIColor(red: 207.0/255.0, green: 175.0/255.0, blue: 84.0/255.0, alpha: 1).cgColor
//        //you can change the line width
//        shapeLayer.lineWidth = 1.0
//        
//        self.view.layer.addSublayer(shapeLayer)
        
        // Do any additional setup after loading the view, typically from a nib.
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
        
        print("top")
    }
    
    @IBAction func buttonBot(_ sender: UIButton) {
    
        print("bot")
    }
    
    @IBAction func handleButton(_ sender: UIButton?) {
        self.botaoSelecionado = sender
    }
    
    func yNew(_ x: CGFloat, cimaBaixo: Bool) -> CGFloat {
        
        var y : CGFloat!
        
        let raio2 = pow(self.raio, 2)
        let xg = (x - self.view.frame.width)
        let xg2 = pow(xg, 2)
        let raiz = sqrt(raio2 - xg2)
        let r = cimaBaixo ? raiz : -raiz
        
        y = r + self.view.center.y
        
        return y
    }
    
    func ajustarBotoes(x: CGFloat) {
        
        let x1 : CGFloat = x
        let x2 = x1 + (x1 * 0.45)
        let x3 = x2 + (x2 * 0.80)
        
        self.b1.center = CGPoint(x: x1, y: self.yNew(x1, cimaBaixo: false))
        self.b1.layer.cornerRadius = self.b1.frame.width / 2
        self.b1.layer.zPosition = 1
        
        self.b2.center = CGPoint(x: x2, y: self.yNew(x2, cimaBaixo: true))
        self.b2.layer.cornerRadius = self.b2.frame.width / 2
        self.b2.layer.zPosition = 1
        
        self.b3.center = CGPoint(x: x2, y: self.yNew(x2, cimaBaixo: false))
        self.b3.layer.cornerRadius = self.b3.frame.width / 2
        self.b3.layer.zPosition = 1
        
        self.b4.center = CGPoint(x: x3, y: self.yNew(x3, cimaBaixo: true))
        self.b4.layer.cornerRadius = self.b4.frame.width / 2
        self.b4.layer.zPosition = 1
        
        self.b5.center = CGPoint(x: x3, y: self.yNew(x3, cimaBaixo: false))
        self.b5.layer.cornerRadius = self.b5.frame.width / 2
        self.b5.layer.zPosition = 1
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
