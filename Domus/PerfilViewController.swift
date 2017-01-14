//
//  PerfilViewController.swift
//  Condominus
//
//  Created by Anderson Oliveira on 09/01/17.
//  Copyright © 2017 Arkhtec. All rights reserved.
//

import UIKit

class PerfilViewController: UIViewController {

    @IBOutlet var viewTopo: UIView!
    @IBOutlet var bFotoPerfil: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // aplicando layers no botao de foto de perfil
        
        self.bFotoPerfil.layer.cornerRadius = self.bFotoPerfil.frame.width / 2.0
        self.bFotoPerfil.layer.borderWidth = 1.0
        self.bFotoPerfil.layer.borderColor = UIColor(red: 207.0/255.0, green: 175.0/255.0, blue: 84.0/255.0, alpha: 1.0).cgColor
        
        self.viewTopo.transform = CGAffineTransform(translationX: 0, y: -self.viewTopo.frame.height)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        self.viewTopo.isHidden = false
        UIView.animate(withDuration: 0.3, animations: {
            
            self.viewTopo.transform = CGAffineTransform(translationX: 0, y: 0)
        }) { (finish) in
            
            UIView.animate(withDuration: 0.5, animations: {

                self.bFotoPerfil.isHidden = false
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
