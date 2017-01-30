//
//  Extension+UIImageView.swift
//  Condominus
//
//  Created by Thiago Vinhote on 16/01/17.
//  Copyright © 2017 Arkhtec. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    func loadImageUsingCache(withUrlString: String) {
        self.image = nil
        //verificar sem está no cache
        if let cacheImage = imageCache.object(forKey: withUrlString as NSString) {
            self.image = cacheImage
            return
        }
        guard let url = URL(string: withUrlString) else {
            return
        }
        URLSession.shared.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.async {
                if let d = data, let imagem = UIImage(data: d) {
                    imageCache.setObject(imagem, forKey: withUrlString as NSString)
                    self.image = imagem
                }
            }
        }).resume()
    }
}
