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
    
    typealias handlerUser = (_ user: User?) -> Void
    typealias handlerError = (_ error: Error?) -> Void
    
    func userLogged(_ completion: @escaping handlerUser) {
        if let uid = FIRAuth.auth()?.currentUser?.uid {
            self.user(withId: uid, completion)
        }
    }
    
    func user(withId id: String, _ completion: @escaping handlerUser) {
        self.referenceUser.child(id).observeSingleEvent(of: .value, with: { (snapshot: FIRDataSnapshot) in
            if let dic = snapshot.value as? [String: Any] {
                let user = User(dic: dic)
                user.uid = snapshot.key
                completion(user)
                return
            }
            completion(nil)
        }, withCancel: nil)
    }
    
    func isLogged(_ completion: @escaping (_ bool: Bool) -> Void) {
        FIRAuth.auth()?.addStateDidChangeListener({ (auth: FIRAuth, user: FIRUser?) in
            if user != nil {
                completion(true)
                return
            }
            completion(false)
        })
    }
    
    func logIn(_ email: String, senha: String, completion: @escaping (_ idUsuario: String?, _ error: Error?) -> Void) {
        FIRAuth.auth()?.signIn(withEmail: email, password: senha, completion: { (user: FIRUser?, error: Error?) in
            if user == nil {
                FIRAuth.auth()?.createUser(withEmail: email, password: senha, completion: { (user: FIRUser?, error: Error?) in
                    if let e = error {
                        print(e)
                        completion(nil, e)
                        return
                    }
                    completion(user?.uid, nil)
                })
            } else {
                completion(user?.uid, nil)
            }
        })
    }
    
    func logOut(_ completion: @escaping handlerError) {
        do {
            try FIRAuth.auth()?.signOut()
            completion(nil)
        } catch let error {
            print(error)
            completion(error)
        }
    }
    
    func createUser(_ user: User, _ completion: @escaping handlerError ) {
        guard let uid = user.uid else {
            fatalError("Error! uid do usuário está vazio")
        }
        let dicValues : [String: Any] = ["nome": user.nome, "email": user.email, "bloco": user.bloco, "apto": user.apto, "vencimento": user.vencimento, "login": user.login]
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
