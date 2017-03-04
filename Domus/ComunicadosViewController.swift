//
//  ComunicadosViewController.swift
//  Condominus
//
//  Created by Anderson Oliveira on 28/12/16.
//  Copyright © 2016 Arkhtec. All rights reserved.
//

import UIKit
import JavaScriptCore

class ComunicadosViewController: UIViewController {

    private lazy var webView : UIWebView = {
        let v = UIWebView()
        v.delegate = self
        return v
    }()
        
    var comunicados: [Comunicado] = []
    
    @IBOutlet var viewTopo: UIView!
    @IBOutlet weak var cvComunicados: UICollectionView!
    @IBOutlet weak var imageTopo: UIImageView!
    @IBOutlet weak var btFechar: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewTopo.transform = CGAffineTransform(translationX: 0, y: -self.viewTopo.frame.height)
        self.shadow(to: self.viewTopo.layer)
        self.cvComunicados.backgroundColor = .clear
        
        self.carregarComunicados()
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
                self.btFechar.isHidden = false
            })
        }
    }
    
    @IBAction func buttonMenu(_ sender: UIButton) {
        
        self.cvComunicados.isHidden = true
        self.btFechar.isHidden = true
        
        UIView.animate(withDuration: 0.2, animations: {
            
            self.view.backgroundColor = UIColor(red: 36.0/255.0, green: 38.0/255.0, blue: 41.0/255.0, alpha: 1.0)
        }) { (finished) in
            
            _ = self.navigationController?.popViewController(animated: true)
        }
    }

    private func prepareWebView() {
        
        UserStore.singleton.userLogged({ (user: User?) in
            guard let userId = user?.login else {
                return
            }
            var request = Request.boleto2Via(userId)
            self.webView.loadRequest(request)
            request.addValue("ASPSESSIONIDQATQCDAC=NDGLMDKAOLLFBOFGONAEKLAP; ASP.NET_SessionId=0nj2rdbdun1ngdfliaxt5pqa", forHTTPHeaderField: "Cookie")
            //                request.addValue("gzip, deflate, lzma, sdch", forHTTPHeaderField: "Accept-Encoding")
            request.addValue("keep-alive", forHTTPHeaderField: "Connection")
            //                request.addValue("t-BR,pt;q=0.8,en-US;q=0.6,en;q=0.4", forHTTPHeaderField: "Accept-Language")
            URLSession.shared.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
                print(response, error)
                if let data = data {
                    print(String(data: data, encoding: String.Encoding.utf8))
                }
            }).resume()
        })
    }
    
    private func carregarComunicados() {
        
        func handler(_ comunicado: Comunicado?, _ storeError: StoreError?) {
            if let e = storeError {
                print(e.reason)
                return
            }
            self.comunicados.append(comunicado!)
            self.cvComunicados.reloadData()
        }
        
        ComunicadoStore.singleton.fetchAddChild { (comunicado: Comunicado?, storeError: StoreError?) in
            handler(comunicado, storeError)
        }
        ComunicadoStore.singleton.fetchAddChild("Arkhtec") { (comunicado: Comunicado?, storeError: StoreError?) in
            handler(comunicado, storeError)
        }
        ComunicadoStore.singleton.fetchAddChild("AJM") { (comunicado: Comunicado?, storeError: StoreError?) in
            handler(comunicado, storeError)
        }
    }
    
    private func criarComunicado() {
        
        let comunicado = Comunicado()
        comunicado.titulo = "Titulo"
        comunicado.mensagem = "Mensagem de teste"
        comunicado.imagemUrl = ""
        comunicado.dataEnvio = Int(Date().timeIntervalSince1970) as NSNumber?
        ComunicadoStore.singleton.criarComunicado(comunicado) { (comunicado: Comunicado?, storeError: StoreError?) in
            if let e = storeError {
                print(e.reason)
                return
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "modalComunicado" {
            let destino = segue.destination as! ComunicadoDetalheViewController
            if let index = self.cvComunicados.indexPathsForSelectedItems?.first {
                destino.comunicado = self.comunicados[index.item]
            }
        }
    }
}

extension ComunicadosViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.comunicados.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "modalComunicado", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ComunicadoCell
        
        cell.layer.cornerRadius = cell.frame.height / 2.0
        
        weak var comunicado = self.comunicados[indexPath.row]
        cell.comunicado = comunicado
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.view.frame.width - 40, height: self.view.frame.height * 0.0967)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let topBot = self.viewTopo.frame.height + 20
        
        collectionViewLayout.invalidateLayout()
        
        return UIEdgeInsets(top: topBot, left: 20, bottom: topBot, right: 20)
    }
}

extension ComunicadosViewController: UIWebViewDelegate {
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        print(request)
        return true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        guard let b = webView.request?.url else {
            return
        }
        
        if b.absoluteString.contains("OM_2via.aspx") {
            if let context = webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as? JSContext {
                guard let additionsJSPath = Bundle.main.path(forResource: "additions", ofType: "js") else {
                    print("Unable to read resource files.")
                    return
                }
                do {
                    let additions = try String(contentsOfFile: additionsJSPath, encoding: String.Encoding.utf8)
                    _ = context.evaluateScript(additions)
                    let toValores = context.objectForKeyedSubscript("valores")
                    if let toValoresResult = toValores?.call(withArguments: []).toString() {
                        print(toValoresResult)
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
