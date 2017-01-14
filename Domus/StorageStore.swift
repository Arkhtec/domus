
//
//  StorageStore.swift
//  Condominus
//
//  Created by Thiago Vinhote on 13/01/17.
//  Copyright © 2017 Arkhtec. All rights reserved.
//

import Foundation
import Firebase

class StorageStore: NSObject {

    static let singleton: StorageStore = StorageStore()
    
    var pathStorageImage : FIRStorageReference {
        return FIRStorage().reference().child("comunicado_imagens")
    }
    
    typealias handlerStorage = (_ stringUrl: String?, _ error: StoreError? ) -> Void
    
    private override init() {
        super.init()
    }
    
    func uploadToFirebaseStorage(using image: UIImage, _ completion: @escaping handlerStorage) -> Void {
        let nameImage = NSUUID().uuidString
        weak var pathImage = self.pathStorageImage.child(nameImage)
        
        if pathImage == nil {
            completion(nil, StoreError(typeError: .call, reason: "Erro ao criar child no storage do Firebase"))
        }
        
        if let dataImage = UIImageJPEGRepresentation(image, 0.1) {
            pathImage?.put(dataImage, metadata: nil, completion: { (metadata: FIRStorageMetadata?, error: Error?) in
                
                if let e = error {
                    completion(nil, StoreError(typeError: .callback, reason: e.localizedDescription))
                    return
                }
                
                if let stringUrl = metadata?.downloadURL()?.absoluteString {
                    completion(stringUrl, nil)
                } else {
                    completion(nil, StoreError(typeError: .value, reason: "Erro ao identificar url"))
                }

            })
        } else {
            completion(nil, StoreError(typeError: .value, reason: "Erro ao converter imagem em dados"))
        }
    }
    
}
