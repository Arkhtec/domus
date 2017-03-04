//
//  PerfilViewController.swift
//  Condominus
//
//  Created by Anderson Oliveira on 09/01/17.
//  Copyright © 2017 Arkhtec. All rights reserved.
//

import UIKit

class PerfilViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var viewTopo: UIView!
    @IBOutlet weak var lblNome: UILabel!
    @IBOutlet weak var lblInfos: UILabel!
    @IBOutlet weak var viewInfo: UIView!
    @IBOutlet weak var lblDiaVencimento: UILabel!
    @IBOutlet weak var btFechar: UIButton!
    @IBOutlet weak var btDeslogar: UIButton!
    @IBOutlet var viewPopoverSair: UIView!
    
    var nome: String?
    var bloco: String?
    var apto: String?
    var vencimento: String?
    
    let picker = UIImagePickerController()
    var fontPerfil: CGFloat!
    let user = UserDefaults.standard
    let viewTransparente = UIVisualEffectView()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(PerfilViewController.voltar))
        self.viewTransparente.addGestureRecognizer(tap)
        
        self.picker.delegate = self
        
        self.shadow(to: self.viewTopo.layer)
        self.shadow(to: self.viewPopoverSair.layer)
        self.shadow(to: self.viewInfo.layer)
        
        self.ajustesIniciais()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        self.viewTopo.isHidden = false
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.viewTopo.transform = CGAffineTransform(translationX: 0, y: 0)
        }) { (finish) in
            
            self.viewInfo.isHidden = false
            self.lblDiaVencimento.isHidden = false
            self.btFechar.isHidden = false
            self.btDeslogar.isHidden = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func fechar() {
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.viewTopo.transform = CGAffineTransform(translationX: 0, y: -self.viewTopo.frame.height)
        }) { (finish) in
            
            self.viewTopo.isHidden = true
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func voltar() {
        
        self.animateOut(popover: self.viewPopoverSair, viewTransparente: self.viewTransparente)
    }
    
    @IBAction func deslogar() {
        
        self.animateIn(popover: self.viewPopoverSair, viewTransparente: self.viewTransparente)
    }
    
    @IBAction func popoverNao() {
     
        self.voltar()
    }
    
    @IBAction func popoverSim() {
        
        self.animateOut(popover: self.viewPopoverSair, viewTransparente: self.viewTransparente)
        UserStore.singleton.logOut { (error: Error?) in
        
            print(error as Any)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func ajustesIniciais() {
        
        //Aplicando borda no view de info
        self.viewInfo.layer.cornerRadius = 20
        
        //Aplicando borda no popover de sair
        self.viewPopoverSair.layer.cornerRadius = 15
        
        //Ajuste do tamanho da fonte em relação ao iPhone
        self.fontPerfil = self.view.frame.width * 0.043
        
        //preparando a animacao do topo
        self.viewTopo.transform = CGAffineTransform(translationX: 0, y: -self.viewTopo.frame.height)
        
        //preparando as info do perfil
        let htmlNome = "<font color=\"white\">Olá, <font/><font color=\"#54A592\">\(self.nome!)</font></font>"
        let encodedDataNome = htmlNome.data(using: String.Encoding.utf16)!
        let attributedOptionsNome = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
        
        do {
            
            let attributedString = try NSAttributedString(data: encodedDataNome, options: attributedOptionsNome, documentAttributes: nil)
            self.lblNome.attributedText = attributedString
            self.lblNome.font = UIFont(name: "HelveticaNeue-Bold", size: self.fontPerfil + 2)
            
            self.lblNome.textAlignment = .center
        } catch  {
            
            print("error")
        }
        
        //preparando as info do perfil
        let htmlInfo = "<font color=\"white\">Condomínio <font/><font color=\"#54A592\">Alphaville Manaus 4</font></br></br>Bloco <font color=\"#54A592\">\(self.bloco!)</font></br></br>Apto <font color=\"#54A592\">\(self.apto!)</font>"
        let encodedDataInfo = htmlInfo.data(using: String.Encoding.utf16)!
        let attributedOptionsInfo = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
        
        do {
            
            let attributedString = try NSAttributedString(data: encodedDataInfo, options: attributedOptionsInfo, documentAttributes: nil)
            self.lblInfos.attributedText = attributedString
            self.lblInfos.font = UIFont(name: "Helvetica Neue", size: self.fontPerfil + 1)
            
        } catch  {
            
            print("error")
        }
        
        //preparando as info do dia de vencimento
        let htmlVenc = "<font color=\"white\">Seu boleto vence sempre no <font/><font color=\"#54A592\"> dia \(self.vencimento!)</font> de cada mês</font>"
        let encodedDataVenc = htmlVenc.data(using: String.Encoding.utf16)!
        let attributedOptionsVenc = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
        
        do {
            
            let attributedString = try NSAttributedString(data: encodedDataVenc, options: attributedOptionsVenc, documentAttributes: nil)
            self.lblDiaVencimento.attributedText = attributedString
            self.lblDiaVencimento.font = UIFont(name: "Helvetica Neue", size: self.fontPerfil)
            self.lblDiaVencimento.textAlignment = .center
            
        } catch  {
            
            print("error")
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
