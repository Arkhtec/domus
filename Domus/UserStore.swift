//
//  UserStore.swift
//  Condominus
//
//  Created by Thiago Vinhote on 04/01/17.
//  Copyright © 2017 Arkhtec. All rights reserved.
//

import Foundation
import Firebase

class UserStore: NSObject {

    static let singleton: UserStore = UserStore()
    var referenceUser : FIRDatabaseReference {
        return FIRDatabase.database().reference().child("users")
    }
    
    
    private override init() {
        super.init()
    }
    
    func isLogged(_ completion: @escaping (_ bool: Bool) -> Void) {
        FIRAuth.auth()?.addStateDidChangeListener({ (auth: FIRAuth, user: FIRUser?) in
            if user != nil {
                completion(true)
            } else {
                completion(false)
            }
        })
    }
    
    func logIn(_ email: String, senha: String, completion: @escaping (_ error: Error?, _ idUsuario: String?) -> Void) {
        FIRAuth.auth()?.signIn(withEmail: email, password: senha, completion: { (user: FIRUser?, error: Error?) in
            if let e = error {
                print(e)
                completion(e, nil)
                return
            }
            completion(nil, user?.uid)
        })
    }
    
    func createUser(_ user: User, _ completion: @escaping (_ error: Error?) -> Void) {
        guard let uid = user.uid else {
            fatalError("Error! uid do usuário está vazio")
        }
        let dicValues : [String: Any] = ["nome": user.nome, "email": user.email, "bloco": user.bloco, "apto": user.apto, "vencimento": user.vencimento]
        self.referenceUser.child(uid).updateChildValues(dicValues) { (error: Error?, ref: FIRDatabaseReference) in
            if let e = error {
                print(e)
                completion(e)
                return
            }
            completion(nil)
        }
    }
}
