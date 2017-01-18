//
//  ComunicadosViewController.swift
//  Condominus
//
//  Created by Anderson Oliveira on 28/12/16.
//  Copyright © 2016 Arkhtec. All rights reserved.
//

import UIKit

class ComunicadosViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet var viewTopo: UIView!
    @IBOutlet weak var cvComunicados: UICollectionView!
    @IBOutlet weak var imageTopo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewTopo.transform = CGAffineTransform(translationX: 0, y: -self.viewTopo.frame.height)
        self.cvComunicados.backgroundColor = .clear
        
        self.cvComunicados.bounds.intersection(CGRect(x: 10, y: 10, width: 10, height: 10))
        self.shadow(to: self.imageTopo.layer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)

        self.viewTopo.isHidden = false
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.view.backgroundColor = UIColor(red: 28.0/255.0, green: 29.0/255.0, blue: 31.0/255.0, alpha: 1.0)
            self.viewTopo.transform = CGAffineTransform(translationX: 0, y: 0)
        }) { (finish) in
                
            UIView.animate(withDuration: 0.5, animations: {
                
                self.cvComunicados.isHidden = false
            })
        }
    }
    
    // Collection View Data Source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        return cell
    }
    
    // Collection View Delegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.view.frame.width - 32, height: self.view.frame.height * 0.0967)
    }
    
    @IBAction func buttonMenu(_ sender: UIButton) {
        
        _ = self.navigationController?.popViewController(animated: true)
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
