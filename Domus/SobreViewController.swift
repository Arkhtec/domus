//
//  SobreViewController.swift
//  Condominus
//
//  Created by Anderson Oliveira on 20/01/17.
//  Copyright © 2017 Arkhtec. All rights reserved.
//

import UIKit

class SobreViewController: UIViewController {

    @IBOutlet weak var viewTopo: UIView!
    @IBOutlet weak var btFechar: UIButton!
    @IBOutlet weak var viewArk: UIView!
    @IBOutlet weak var viewAjm: UIView!
    @IBOutlet weak var viewCondo: UIView!
    @IBOutlet weak var cvCondo: UICollectionView!
    
    var condominios: [Condominio] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cvCondo.backgroundColor = .clear
        self.viewTopo.transform = CGAffineTransform(translationX: 0, y: -self.viewTopo.frame.height)
        self.shadow(to: self.viewTopo.layer)
        
        self.carregarCondominios()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        self.viewTopo.isHidden = false
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.viewTopo.transform = CGAffineTransform(translationX: 0, y: 0)
        }) { (finish) in
            
            self.viewArk.isHidden = false
            self.viewAjm.isHidden = false
            self.viewCondo.isHidden = false
            self.btFechar.isHidden = false
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
    
    @IBAction func contatar(_ sender: UIButton) {
        
        if let url = NSURL(string: (sender.titleLabel?.text)!), UIApplication.shared.canOpenURL(url as URL) {
            UIApplication.shared.open(url as URL)
            
        }else {
            
            print("Errooou")
        }
    }
    
    func carregarCondominios() {
        
        let condoStore = CondominioStore.singleton
        
        condoStore.fetchCondominios { (condo, e) in
            
            self.condominios = condo as! [Condominio]
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

extension SobreViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.condominios.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CondominiosCollectionViewCell
        
        let imgURL = self.condominios[indexPath.item].imagemUrl!
        
        cell.imgLogoCondo.image = UIImage(named: imgURL)
        
        return cell
    }
}
