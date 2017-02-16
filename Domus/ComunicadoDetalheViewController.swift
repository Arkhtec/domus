//
//  ComunicadoDetalheViewController.swift
//  Condominus
//
//  Created by Thiago Vinhote on 16/01/17.
//  Copyright © 2017 Arkhtec. All rights reserved.
//

import UIKit

class ComunicadoDetalheViewController: UIViewController {

    
    @IBOutlet weak var viewTopo: UIView!
    @IBOutlet weak var labelTitulo: UILabel!
    @IBOutlet weak var imagemBanner: UIImageView!
    @IBOutlet weak var textViewMensagem: UITextView!
    @IBOutlet weak var btFechar: UIButton!
    
    var comunicado : Comunicado?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewTopo.transform = CGAffineTransform(translationX: 0, y: -self.viewTopo.frame.height)
        
        self.shadow(to: self.viewTopo.layer)
        
        self.setupComunicado()
    }
    
    private func setupComunicado () {
        if let titulo = self.comunicado?.titulo {
            self.labelTitulo.text = titulo
        }
        if let menagem = self.comunicado?.mensagem {
            self.textViewMensagem.text = menagem
        }
        if let imagemUrl = self.comunicado?.imagemUrl {
            self.imagemBanner.loadImageUsingCache(withUrlString: imagemUrl)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        self.viewTopo.isHidden = false
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.view.backgroundColor = UIColor(red: 28.0/255.0, green: 29.0/255.0, blue: 31.0/255.0, alpha: 1.0)
            self.viewTopo.transform = CGAffineTransform(translationX: 0, y: 0)
        }) { (finish) in
            
            UIView.animate(withDuration: 0.5, animations: {
                
                // Mostrar o conteudo da tela
                self.labelTitulo.isHidden = false
                self.imagemBanner.isHidden = false
                self.textViewMensagem.isHidden = false
                self.btFechar.isHidden = false
            })
        }
    }

    @IBAction func fechar() {
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.viewTopo.transform = CGAffineTransform(translationX: 0, y: -self.viewTopo.frame.height)
        }) { (finish) in
            
            self.viewTopo.isHidden = true
            self.dismiss(animated: true, completion: nil)
        }
    }


}
