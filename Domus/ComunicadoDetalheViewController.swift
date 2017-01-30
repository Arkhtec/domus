//
//  ComunicadoDetalheViewController.swift
//  Condominus
//
//  Created by Thiago Vinhote on 16/01/17.
//  Copyright © 2017 Arkhtec. All rights reserved.
//

import UIKit

class ComunicadoDetalheViewController: UIViewController {

    
    @IBOutlet weak var labelTitulo: UILabel!
    @IBOutlet weak var imagemBanner: UIImageView!
    @IBOutlet weak var textViewMensagem: UITextView!
    
    var comunicado : Comunicado?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

    @IBAction func fechar() {
        self.dismiss(animated: true, completion: nil)
    }


}
