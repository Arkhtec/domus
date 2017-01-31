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
    @IBOutlet var bFotoPerfil: UIButton!
    @IBOutlet weak var lblNome: UILabel!
    @IBOutlet weak var lblInfos: UILabel!
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
    let viewTransparente = UIView()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.picker.delegate = self
        
        self.shadow(to: self.viewTopo.layer)
        self.shadow(to: self.viewPopoverSair.layer)
        
        self.ajustesIniciais()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        self.viewTopo.isHidden = false
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.viewTopo.transform = CGAffineTransform(translationX: 0, y: 0)
        }) { (finish) in
            
            self.bFotoPerfil.imageView?.layer.cornerRadius = self.bFotoPerfil.frame.width / 2.0
            self.bFotoPerfil.layer.cornerRadius = self.bFotoPerfil.frame.height / 2.0
            self.bFotoPerfil.layer.borderWidth = 2.0
            self.bFotoPerfil.layer.borderColor = UIColor(red: 84.0/255.0, green: 165.0/255.0, blue: 146.0/255.0, alpha: 1.0).cgColor
                
            self.bFotoPerfil.isHidden = false
            self.lblInfos.isHidden = false
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
    
    @IBAction func deslogar() {
        
        self.animateIn(popover: self.viewPopoverSair, viewTransparente: self.viewTransparente)
    }
    
    @IBAction func popoverNao() {
        
        self.animateOut(popover: self.viewPopoverSair, viewTransparente: self.viewTransparente)
    }
    
    @IBAction func popoverSim() {
        
        UserStore.singleton.logOut { (error: Error?) in
            print(error as Any)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func tirarFoto() {
        
        let cameraSettingsAlert = UIAlertController(title: "Escolha uma opção:", message: NSLocalizedString("", comment: ""), preferredStyle: .actionSheet)
        cameraSettingsAlert.modalPresentationStyle = .popover
        
        let tirarfoto = UIAlertAction(title: "Câmera", style: .default) { (action) in
            
            self.picker.sourceType = .camera
            self.picker.allowsEditing = true
            self.present(self.picker, animated: true, completion: nil)
        }
        
        let galeria = UIAlertAction(title: "Galeria de Fotos", style: .default) { (action) in
            
            self.picker.allowsEditing = false
            self.picker.sourceType = .photoLibrary
            self.present(self.picker, animated: true, completion: nil)
        }
        
        let limpar = UIAlertAction(title: "Limpar", style: .destructive) { (action) in
            
            let data : Data? = nil
            self.user.set(data, forKey: "foto")
            self.bFotoPerfil.setImage(#imageLiteral(resourceName: "addFoto"), for: .normal)
        }
        
        
        let cancelar = UIAlertAction(title: "Cancelar", style: .cancel) { action in
            
        }
        
        cameraSettingsAlert.addAction(limpar)
        cameraSettingsAlert.addAction(tirarfoto)
        cameraSettingsAlert.addAction(galeria)
        cameraSettingsAlert.addAction(cancelar)
        
        if let presenter = cameraSettingsAlert.popoverPresentationController {
            presenter.sourceView = self.bFotoPerfil;
            presenter.sourceRect = self.bFotoPerfil.bounds;
            
        }
        present(cameraSettingsAlert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var foto : UIImage?
        
        if self.picker.allowsEditing {
            
            foto = info[UIImagePickerControllerEditedImage] as? UIImage
        }else {
            
            foto = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
        
        if foto == nil {
            
            //TODO: Colocar um alerta de erro que nao veio nenhuma foto
        }else {
            
            let fotoData = UIImageJPEGRepresentation(foto!, 1.0)
            self.user.set(fotoData, forKey: "foto")
            self.bFotoPerfil.setImage(foto, for: .normal)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func ajustesIniciais() {
        
        //Aplicando borda no popover de sair
        self.viewPopoverSair.layer.cornerRadius = 15
        
        //Ajuste do tamanho da fonte em relação ao iPhone
        self.fontPerfil = self.view.frame.width * 0.043
        
        //TODO: Colocar a foto do perfil como um atributo do usuario, e persisti-lo no firebase. Temporariamente, estamos salvando num user default
        if let fotoData = self.user.data(forKey: "foto") {
            
            let foto = UIImage(data: fotoData)! as UIImage
            self.bFotoPerfil.setImage(foto, for: .normal)
        }else {
            
            self.bFotoPerfil.setImage(#imageLiteral(resourceName: "addFoto"), for: .normal)
        }
        
        //preparando a animacao do topo
        self.viewTopo.transform = CGAffineTransform(translationX: 0, y: -self.viewTopo.frame.height)
        
        //preparando as info do perfil
        let htmlNome = "<font color=\"white\">Olá, <font/><font color=\"#54A592\">NOME</font></font>"
        let encodedDataNome = htmlNome.data(using: String.Encoding.utf16)!
        let attributedOptionsNome = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
        
        do {
            
            let attributedString = try NSAttributedString(data: encodedDataNome, options: attributedOptionsNome, documentAttributes: nil)
            self.lblNome.attributedText = attributedString
            self.lblNome.font = UIFont(name: "HelveticaNeue-Bold", size: self.fontPerfil + 1)
            
            self.lblNome.textAlignment = .center
        } catch  {
            
            print("error")
        }
        
        //preparando as info do perfil
        let htmlInfo = "<font color=\"white\">Condomínio <font/><font color=\"#54A592\">Alphaville Manaus 4</font></br></br>Bloco <font color=\"#54A592\">BLOCO</font></br></br>Apto <font color=\"#54A592\">APTO</font>"
        let encodedDataInfo = htmlInfo.data(using: String.Encoding.utf16)!
        let attributedOptionsInfo = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
        
        do {
            
            let attributedString = try NSAttributedString(data: encodedDataInfo, options: attributedOptionsInfo, documentAttributes: nil)
            self.lblInfos.attributedText = attributedString
            self.lblInfos.font = UIFont(name: "Helvetica Neue", size: self.fontPerfil)
            
        } catch  {
            
            print("error")
        }
        
        //preparando as info do dia de vencimento
        let htmlVenc = "<font color=\"white\">Seu boleto vence sempre no <font/><font color=\"#54A592\"> dia VENCIMENTO</font> de cada mês</font>"
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
