//
//  BoletoViewController.swift
//  Condominus
//
//  Created by Thiago Vinhote on 06/01/17.
//  Copyright © 2017 Arkhtec. All rights reserved.
//

import UIKit
import JavaScriptCore

class BoletoViewController: UIViewController {

    private lazy var webView : UIWebView = {
        let v = UIWebView()
        v.delegate = self
        return v
    }()
    
    @IBOutlet weak var collectionComunicado: UICollectionView!
    
    var comunicados: [Comunicado] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.prepareWebView()
//        self.criarComunicado()
        self.carregarComunicados()
    }
    
    private func prepareWebView() {
        UserStore.singleton.userLogged({ (user: User?) in
            guard let userId = user?.login else {
                return
            }
            if var request = Request.boleto2Via(userId) {
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
            }
        })
    }
    
    private func carregarComunicados() {
        
        func handler(_ comunicado: Comunicado?, _ storeError: StoreError?) {
            if let e = storeError {
                print(e.reason)
                return
            }
            self.comunicados.append(comunicado!)
            self.collectionComunicado.reloadData()
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
            print(comunicado)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "modalComunicado" {
            let destino = segue.destination as! ComunicadoDetalheViewController
            if let index = self.collectionComunicado.indexPathsForSelectedItems?.first {
                destino.comunicado = self.comunicados[index.item]
            }
        }
    }
}

extension BoletoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.comunicados.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "modalComunicado", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ComunicadoCell
        weak var comunicado = self.comunicados[indexPath.row]
        cell.comunicado = comunicado
        return cell
    }
    
}

extension BoletoViewController: UIWebViewDelegate {
    
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
