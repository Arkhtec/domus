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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareWebView()
    }
    
    private func prepareWebView() {
        UserStore.singleton.userLogged({ (user: User?) in
            guard let userId = user?.login else {
                return
            }
            if var request = Request.boleto2Via(userId) {
                self.webView.loadRequest(request)
                request.addValue("ASPSESSIONIDCAQQDCTS=CIEPIGAAEGOJAANMLPJACMKJ; ASP.NET_SessionId=2ejehqfom31dvf2noc3q5ss1; ASPSESSIONIDAATRCCTS=HIFLHCNACCGBODPNLJCIPDBO; ASPSESSIONIDQATSACAC=NAPPECECMOHFJPNGNOECMDLK", forHTTPHeaderField: "Cookie")
//                request.addValue("gzip, deflate, lzma, sdch", forHTTPHeaderField: "Accept-Encoding")
//                request.addValue("keep-alive", forHTTPHeaderField: "Connection")
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
