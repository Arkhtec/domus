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
    @IBOutlet weak var viewWait: UIView!
    @IBOutlet weak var lblTxtWait: UILabel!
    @IBOutlet weak var cvSegVia: UICollectionView!
    @IBOutlet weak var btFechar: UIButton!
    
    let txtWait = ("", "Caso esteja demorando, verifique a sua conexão com a internet!", "Caso não estaja aparecendo as 2ª vias, entre em contato com a administradora.")
    var selectedItem : Int = -1
    var task: DispatchWorkItem!
    
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
        
        self.task = DispatchWorkItem(block: { 
            
            self.prepararLbl(self.lblTxtWait, txt: self.txtWait.1)
        })
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5, execute: self.task)
        
        self.prepararLbl(self.lblTxtWait, txt: self.txtWait.0)
        
        self.viewTopo.transform = CGAffineTransform(translationX: 0, y: -self.viewTopo.frame.height)
        self.shadow(to: self.viewTopo.layer)
        self.shadow(to: self.viewWait.layer)
        
        self.cvSegVia.backgroundColor = .clear
        
        self.prepareWebView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        self.viewTopo.isHidden = false
        self.viewWait.layer.cornerRadius = self.viewWait.frame.height / 2.0
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.view.backgroundColor = UIColor(red: 28.0/255.0, green: 29.0/255.0, blue: 31.0/255.0, alpha: 1.0)
            self.viewTopo.transform = CGAffineTransform(translationX: 0, y: 0)
        }) { (finish) in
            
            self.cvSegVia.isHidden = false
            self.btFechar.isHidden = false
            self.viewWait.isHidden = false
            self.lblTxtWait.isHidden = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func voltar() {
        
        self.cvSegVia.isHidden = true
        self.btFechar.isHidden = true
        self.viewWait.isHidden = true
        self.lblTxtWait.isHidden = true
        
        UIView.animate(withDuration: 0.2, animations: {
            
            self.view.backgroundColor = UIColor(red: 84.0/255.0, green: 165.0/255.0, blue: 146.0/255.0, alpha: 1.0)
        }) { (finished) in
            
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    func heightForView(text: String, font: UIFont, width: CGFloat) -> CGFloat {
        //let label:UILabel = UILabel(frame: CGRect(0, 0, width, CGFloat.greatestFiniteMagnitude))
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    func prepararLbl(_ lbl: UILabel, txt: String) {
        
        let heightTxt = self.heightForView(text: txt, font: lbl.font, width: lbl.frame.width)
        
        lbl.frame.size.height = heightTxt
        lbl.text = txt
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
        
        let vias = self.vias[indexPath.item].mes
        let data = vias.components(separatedBy: "/")
        
        cell.layer.cornerRadius = cell.frame.height / 2.0
        
        cell.lblMes.text = data[0]
        cell.lblAno.text = ".\(data[1])"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.view.frame.width - 40, height: self.view.frame.height * 0.075)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let topBot = self.viewTopo.frame.height + 20
        
        collectionViewLayout.invalidateLayout()
        
        return UIEdgeInsets(top: topBot, left: 20, bottom: topBot, right: 20)
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
                        self.viewWait.isHidden = true
                        self.lblTxtWait.isHidden = true
                        self.task.cancel()
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
