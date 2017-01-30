//
//  SegViaViewController.swift
//  Condominus
//
//  Created by Anderson Oliveira on 29/12/16.
//  Copyright © 2016 Arkhtec. All rights reserved.
//

import UIKit

class SegViaViewController: UIViewController {

    @IBOutlet var viewDetail: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func voltar() {
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.viewDetail.transform = CGAffineTransform(translationX: 0, y: 867)
        }) { (finished) in
            
            self.viewDetail.isHidden = true
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        
        self.viewDetail.isHidden = false
        UIView.animate(withDuration: 0.3) { 
            self.viewDetail.transform = CGAffineTransform(translationX: 0, y: -500)
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
