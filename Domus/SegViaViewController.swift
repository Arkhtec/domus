//
//  SegViaViewController.swift
//  Condominus
//
//  Created by Anderson Oliveira on 29/12/16.
//  Copyright © 2016 Arkhtec. All rights reserved.
//

import UIKit

class SegViaViewController: UIViewController {

    @IBOutlet weak var viewTopo: UIView!
    @IBOutlet weak var cvSegVia: UICollectionView!
    @IBOutlet weak var btFechar: UIButton!
    
    let data = [("Jan/2017", "10 de jan de 2017", "34191090080924677068067888940003770300000063000"), ("Fev/2017", "10 de Fev de 2017", "34191090080924677068067888940003770300000063000"), ("Mar/2017", "10 de mar de 2017", "34191090080924677068067888940003770300000063000")]
    var selectedItem : Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewTopo.transform = CGAffineTransform(translationX: 0, y: -self.viewTopo.frame.height)
        self.shadow(to: self.viewTopo.layer)
        
        self.cvSegVia.backgroundColor = .clear
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        self.viewTopo.isHidden = false
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.view.backgroundColor = UIColor(red: 28.0/255.0, green: 29.0/255.0, blue: 31.0/255.0, alpha: 1.0)
            self.viewTopo.transform = CGAffineTransform(translationX: 0, y: 0)
        }) { (finish) in
            
            self.cvSegVia.isHidden = false
            self.btFechar.isHidden = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func voltar() {
        
        self.cvSegVia.isHidden = true
        self.btFechar.isHidden = true
        
        UIView.animate(withDuration: 0.2, animations: {
            
            self.view.backgroundColor = UIColor(red: 84.0/255.0, green: 165.0/255.0, blue: 146.0/255.0, alpha: 1.0)
        }) { (finished) in
            
            _ = self.navigationController?.popViewController(animated: true)
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

extension SegViaViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //Ir para a tela de detalhes
        self.performSegue(withIdentifier: "segViaDetalhes", sender: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SegViaCollectionViewCell
        
        cell.lblTitulo.text = self.data[indexPath.item].0
        
        return cell
    }
}
