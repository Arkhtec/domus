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
        
        UIView.animate(withDuration: 0.2, animations: {
            
            self.view.backgroundColor = UIColor(red: 207.0/255.0, green: 175.0/255.0, blue: 84.0/255.0, alpha: 1.0)
        }) { (finished) in
            
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3) {
            self.view.backgroundColor = UIColor(red: 28.0/255.0, green: 29.0/255.0, blue: 31.0/255.0, alpha: 1.0)
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
