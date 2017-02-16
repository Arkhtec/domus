//
//  SegViaDetalhesViewController.swift
//  Condominus
//
//  Created by Anderson Oliveira on 04/02/17.
//  Copyright © 2017 Arkhtec. All rights reserved.
//

import UIKit

class SegViaDetalhesViewController: UIViewController {

    @IBOutlet weak var viewTopo: UIView!
    
    weak var boleto: Boleto?
    
    @IBOutlet weak var labelDataVencimento: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewTopo.transform = CGAffineTransform(translationX: 0, y: -self.viewTopo.frame.height)
        self.shadow(to: self.viewTopo.layer)
        self.labelDataVencimento.text = self.boleto?.vencimento
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
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func voltar() {
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.viewTopo.transform = CGAffineTransform(translationX: 0, y: -self.viewTopo.frame.height)
        }) { (finish) in
            
            self.viewTopo.isHidden = true
            self.dismiss(animated: true, completion: nil)
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
