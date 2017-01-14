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
    
    @IBOutlet weak var tableView: UITableView!
    
    var comunicados: [Comunicado] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareWebView()
//        self.criarComunicado()
//        self.carregarComunicados()
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
        ComunicadoStore.singleton.fetchAddChild { (comunicado: Comunicado?, storeError: StoreError?) in
            if let e = storeError {
                print(e.reason)
                return
            }
            self.comunicados.append(comunicado!)
            self.tableView.reloadData()
        }
    }
    
    private func criarComunicado() {
        let comunicado = Comunicado()
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
}

extension BoletoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.comunicados.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        weak var comunicado = self.comunicados[indexPath.row]
        cell.textLabel?.text = comunicado?.mensagem
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .long
        cell.detailTextLabel?.text = dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval((comunicado?.dataEnvio)!)))
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
