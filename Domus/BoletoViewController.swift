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

    lazy var webView : UIWebView = {
        let v = UIWebView()
        v.delegate = self
        return v
    }()
    
    @IBOutlet weak var collectionComunicado: UICollectionView!
    
    var comunicados: [Comunicado] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareWebView()
//        self.criarComunicado()
//        self.carregarComunicados()
    }
    
    var userLogged: User?
    
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
