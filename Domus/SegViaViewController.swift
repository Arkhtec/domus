//
//  SegViaViewController.swift
//  Condominus
//
//  Created by Anderson Oliveira on 29/12/16.
//  Copyright © 2016 Arkhtec. All rights reserved.
//

import UIKit
import JavaScriptCore

class SegViaViewController: UIViewController {
    
    lazy var webView : UIWebView = {
        let v = UIWebView()
        v.delegate = self
        return v
    }()
    
    fileprivate var userLogged: User?

    @IBOutlet weak var viewTopo: UIView!
    @IBOutlet weak var cvSegVia: UICollectionView!
    @IBOutlet weak var btFechar: UIButton!
    
    let data = [("Jan/2017", "10 de jan de 2017", "34191090080924677068067888940003770300000063000"), ("Fev/2017", "10 de Fev de 2017", "34191090080924677068067888940003770300000063000"), ("Mar/2017", "10 de mar de 2017", "34191090080924677068067888940003770300000063000")]
    var selectedItem : Int = -1
    
    fileprivate var vias: [Boleto] = []
    
    private func prepareWebView() {
        UserStore.singleton.userLogged({ (user: User?) in
            guard let login = user?.login, let senha = user?.senha else {
                return
            }
            self.userLogged = user
            if let request = Request.autenticar(login, senha) {
                self.webView.loadRequest(request)
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewTopo.transform = CGAffineTransform(translationX: 0, y: -self.viewTopo.frame.height)
        self.shadow(to: self.viewTopo.layer)
        
        self.cvSegVia.backgroundColor = .clear
        
        self.prepareWebView()
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
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let v = segue.destination as? SegViaDetalhesViewController
        if let indexPath = self.cvSegVia.indexPathsForSelectedItems?.first {
            v?.boleto = self.vias[indexPath.item]
        }
    }

}

extension SegViaViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.vias.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Ir para a tela de detalhes
        self.performSegue(withIdentifier: "segViaDetalhes", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SegViaCollectionViewCell
        
        cell.lblTitulo.text = self.vias[indexPath.item].mes
        
        return cell
    }
}

extension SegViaViewController: UIWebViewDelegate {
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        print(request)
        guard let urlString = request.url else {
            return true
        }
        
        if urlString.absoluteString.contains("Login.aspx") {
            var c : String = ""
            if let cookies = HTTPCookieStorage.shared.cookies {
                c = cookies.map({ (cookie: HTTPCookie) -> String in
                    return "\(cookie.name)=\(cookie.value)"
                }).joined(separator: ";")
                print(c)
            }
            
            if let userId = self.userLogged?.id, var request = Request.boleto2Via(userId) {
                request.addValue(c, forHTTPHeaderField: "Cookie")
                self.webView.loadRequest(request)
                URLSession.shared.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
                    print(response, error)
                    if let data = data {
                        print(String(data: data, encoding: String.Encoding.utf8))
                    }
                }).resume()
            }
        }
        return true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        guard let b = webView.request?.url else {
            return
        }
        
        if b.absoluteString.contains("OM_2via.aspx") {
            if let context = webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as? JSContext {
                guard let additionsJSPath = Bundle.main.path(forResource: "additions", ofType: "js") else {
                    print("Unable to read resource  files.")
                    return
                }
                do {
                    let additions = try String(contentsOfFile: additionsJSPath, encoding: String.Encoding.utf8)
                    _ = context.evaluateScript(additions)
                    context.setObject(Boleto.self, forKeyedSubscript: "Boleto" as (NSCopying & NSObjectProtocol)!)
                    let toValores = context.objectForKeyedSubscript("valores")
                    if let toValoresResult = toValores?.call(withArguments: []).toArray() as? [Boleto] {
                        print(toValoresResult)
                        self.vias = toValoresResult
                        self.cvSegVia.reloadData()
                        //Retorna as vias
                    } else {
                        print("Error call")
                    }
                } catch (let error) {
                    print("Error while processing script file: \(error)")
                }
            }
        }
        
    }
    
}
