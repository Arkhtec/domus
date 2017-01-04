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
    
}
